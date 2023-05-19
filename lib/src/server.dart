import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  final _logger = Logger('TimeSeriesGeneratorService');

  StreamController<TimeSeriesData> _broadcastController =
      StreamController.broadcast();

  int _subscriberId = 0;
  Map<int, StreamController<TimeSeriesData>> _subscriberControllers = {};

  @override
  Future<PublishResponse> publishTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) async {
    // Generate time series data
    Stream<TimeSeriesData> dataStream =
        generateTimeSeries(request.sampleRate, request.tones);

    _logger.info('publishing data to the broadcast');

    // Add data stream to the broadcast controller
    dataStream.listen((data) {
      _broadcastController.add(data);
    });

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  @override
  Stream<TimeSeriesData> subscribeToTimeSeries(
      grpc.ServiceCall call, Empty request) {
    final subscriberController = StreamController<TimeSeriesData>();

    final subscriberId = _subscriberId++;
    print('Subscriber $subscriberId added');

    subscriberController.onCancel = () {
      print('Subscriber $subscriberId unsubscribed');
      _subscriberControllers
          .remove(subscriberId); // Remove the subscriber's controller
    };

    _subscriberControllers[subscriberId] =
        subscriberController; // Store the subscriber's controller

    _broadcastController.stream.listen(
      (data) {
        subscriberController.add(data);
      },
      onError: subscriberController.addError,
      onDone: subscriberController.close,
    );

    return subscriberController.stream;
  }

  Stream<TimeSeriesData> generateTimeSeries(
      double sampleRate, List<ToneConfig> toneConfigs) async* {
    final batchSize = 100; // Number of data points to batch together
    final timeSeries = List<double>.filled(batchSize, 0.0);
    final int toneConfigsLength = toneConfigs.length;

    final constants = List<double>.filled(toneConfigsLength, 0.0);
    final amplitudes = List<double>.filled(toneConfigsLength, 0.0);
    final initialPhases = List<double>.filled(toneConfigsLength, 0.0);

    for (var i = 0; i < toneConfigsLength; i++) {
      final toneConfig = toneConfigs[i];

      // Check for invalid values
      if (toneConfig.frequency.isNaN ||
          toneConfig.frequency.isInfinite ||
          sampleRate.isNaN ||
          sampleRate.isInfinite ||
          sampleRate <= 0) {
        throw Exception('Invalid frequency or sample rate');
      }

      constants[i] = 2 * pi * toneConfig.frequency / sampleRate;
      amplitudes[i] = toneConfig.amplitude;
      initialPhases[i] = toneConfig.initialPhase;
    }

    final intervalMicroseconds = (1000000 / sampleRate).round();

    while (true) {
      final stopwatch = Stopwatch()..start();

      for (var t = 0; t < batchSize; t++) {
        double value = 0.0;

        for (var i = 0; i < toneConfigsLength; i++) {
          value += amplitudes[i] * sin(constants[i] * t + initialPhases[i]);
        }

        timeSeries[t] = value;
        // _logger.info('Generator value: $value'); // Logging the generated value
      }

      yield TimeSeriesData()..data.addAll(timeSeries);

      final elapsedMicroseconds = stopwatch.elapsedMicroseconds;
      if (elapsedMicroseconds < intervalMicroseconds) {
        await Future.delayed(
            Duration(microseconds: intervalMicroseconds - elapsedMicroseconds));
      }
    }
  }

  void stopGeneratingData() {
    // Close the broadcast stream
    _broadcastController.close();

    // Close the individual subscriber stream controllers and cancel the subscription
    _subscriberControllers.forEach((_, controller) {
      controller.close();
      controller.sink.close();
    });
    _subscriberControllers.clear();
  }
}

class Server {
  static void configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static Future<void> main(List<String> args) async {
    configureLogger();

    final service = TimeSeriesGeneratorService();
    final server = grpc.Server([service]);

    await server.serve(port: 8080);
    print('Server listening on port ${server.port}...');

    // Register the onExit callback to handle program termination
    registerOnExitCallback(server, service);
  }

  static void registerOnExitCallback(
      grpc.Server server, TimeSeriesGeneratorService service) {
    ProcessSignal.sigint.watch().listen((signal) async {
      print('Received signal: ${signal.toString()}. Shutting down...');

      // Stop the data generation
      service.stopGeneratingData();

      // Gracefully shutdown the server
      await server.shutdown();

      // Exit the program
      exit(0);
    });
  }
}
