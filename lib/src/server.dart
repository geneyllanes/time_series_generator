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

  int _subscriberCount = 0; // Track the number of subscribers

  @override
  Future<PublishResponse> publishTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) async {
    // Generate time series data
    Stream<TimeSeriesData> dataStream =
        generateTimeSeries(request.sampleRate, request.tones);

    // Notify subscribers
    await dataStream.forEach((data) {
      _broadcastController.add(data);
    });

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  @override
  Stream<TimeSeriesData> subscribeToTimeSeries(
      grpc.ServiceCall call, Empty request) {
    _subscriberCount++; // Increment subscriber count
    print('Subscription added');
    return _broadcastController.stream
        .transform(StreamTransformer.fromHandlers(handleDone: (sink) {
      _subscriberCount--; // Decrement subscriber count when subscription is done
      if (_subscriberCount == 0) {
        stopGeneratingData(); // Stop generating data if no subscribers remaining
      }
    }));
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
    _broadcastController.close(); // Close the stream to stop generating data
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
// Handle the shutdown signal
    await _waitForShutdownSignal();

    // Stop the server gracefully
    await server.shutdown();
  }

  static Future<void> _waitForShutdownSignal() async {
    final completer = Completer<void>();

    // Register the signal handler for termination signals
    ProcessSignal.sigint.watch().listen((signal) {
      print('Received signal: ${signal.toString()}. Shutting down...');
      completer.complete();
    });

    // Register the signal handler for termination signals on Windows
    if (Platform.isWindows) {
      ProcessSignal.sigterm.watch().listen((signal) {
        print('Received signal: ${signal.toString()}. Shutting down...');
        completer.complete();
      });
    }

    await completer.future;
  }
}
