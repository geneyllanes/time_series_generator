import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  final _logger = Logger('TimeSeriesGeneratorService');

  StreamGroup<TimeSeriesData> _streamGroup = StreamGroup<TimeSeriesData>();
  Map<int, StreamController<TimeSeriesData>> _subscriberControllers = {};
  int _subscriberId = 0;

  @override
  Future<PublishResponse> publishTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) async {
    // Generate time series data
    Stream<TimeSeriesData> dataStream =
        generateTimeSeries(request.sampleRate, request.tones);

    // Add data stream to the StreamGroup
    _streamGroup.add(dataStream);

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  @override
  Stream<TimeSeriesData> subscribeToTimeSeries(
      grpc.ServiceCall call, Empty request) {
    final subscriberController = StreamController<TimeSeriesData>();
    final subscriberId = _subscriberId++;

    // Add subscriber's StreamController to the map
    _subscriberControllers[subscriberId] = subscriberController;

    // Add subscriber's StreamController to the StreamGroup
    _streamGroup.add(subscriberController.stream);

    // When the subscriber cancels the subscription, remove the StreamController from the map
    subscriberController.onCancel = () {
      _subscriberControllers.remove(subscriberId);
    };

    print('Subscriber $subscriberId added');
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
        _logger.info('Generator value: $value'); // Logging the generated value
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
    _streamGroup.close();
    _subscriberControllers.forEach((_, controller) => controller.close());
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

    final server = grpc.Server([TimeSeriesGeneratorService()]);

    await server.serve(port: 8080);
    print('Server listening on port ${server.port}...');

    // Register the onExit callback to handle program termination
    registerOnExitCallback(server);
  }

  static void registerOnExitCallback(grpc.Server server) {
    ProcessSignal.sigint.watch().listen((signal) async {
      print('Received signal: ${signal.toString()}. Shutting down...');

      // Stop the data generation
      TimeSeriesGeneratorService().stopGeneratingData();

      // Gracefully shutdown the server
      await server.shutdown();

      // Exit the program
      exit(0);
    });
  }
}
