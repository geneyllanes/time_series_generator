import 'dart:async';
import 'dart:math';
import 'package:grpc/grpc.dart' as grpc;
import 'package:logging/logging.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

final Logger _logger = Logger('TimeSeriesGenerator');

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  late final StreamController<TimeSeriesData> _controller;
  bool _hasActiveSubscribers = false;

  TimeSeriesGeneratorService() {
    _controller = StreamController<TimeSeriesData>(
      onCancel: () {
        _logger.info('Stream canceled. Stopping time series generation.');
        _hasActiveSubscribers = false;
        _controller.close();
      },
    );
  }

  @override
  Stream<TimeSeriesData> generateTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) {
    final sampleRate = request.sampleRate;
    final toneConfigs = request.tones;

    _hasActiveSubscribers = true;
    generateTimeSeriesFromConfig(sampleRate, toneConfigs);

    return _controller.stream;
  }

  void generateTimeSeriesFromConfig(
      double sampleRate, List<ToneConfig> toneConfigs) {
    _controller.addStream(
      generateTimeSeriesStream(sampleRate, toneConfigs),
    );
  }

  /// In this optimization:
  /// Instead of repeatedly accessing the properties of
  /// ToneConfig objects inside the inner loop,
  /// the values of frequency, amplitude, and initialPhase
  /// are pre-extracted into separate lists (constants, amplitudes,
  /// and initialPhases) outside the loop.
  ///
  /// The length of toneConfigs is stored in toneConfigsLength
  /// variable to avoid redundant calculations.
  ///
  /// The lists constants, amplitudes, and initialPhases
  /// are pre-allocated with the required length to avoid
  /// unnecessary allocations within the loop.
  ///
  /// The batchSize variable is introduced to define the number of
  /// data points to batch together before sending them through the
  /// stream. You can adjust this value according to your requirements
  /// and the overhead you want to reduce.
  ///
  /// The intervalMicroseconds variable calculates the desired timer
  /// interval in microseconds based on the desired sampleRate.
  ///
  /// The stopwatch is used to measure the time taken to generate a
  /// batch of data points.
  ///
  /// After generating and yielding a batch of data points, the
  /// elapsed time is checked against the desired interval. If the
  /// elapsed time is less than the interval, the code waits for the
  /// remaining time to achieve the desired interval.
  ///
  /// By batching data points and fine-tuning the timer interval,
  /// you can reduce the overhead and achieve optimal performance
  /// for the time series generation. Adjust the batchSize and
  /// intervalMicroseconds values based on your specific requirements
  /// and performance testing.
  ///
  Stream<TimeSeriesData> generateTimeSeriesStream(
      double sampleRate, List<ToneConfig> toneConfigs) async* {
    _logger.info('Starting time series generation.');

    final batchSize = 100; // Number of data points to batch together
    final timeSeries = List<double>.filled(batchSize, 0.0);
    final int toneConfigsLength = toneConfigs.length;

    final constants = List<double>.filled(toneConfigsLength, 0.0);
    final amplitudes = List<double>.filled(toneConfigsLength, 0.0);
    final initialPhases = List<double>.filled(toneConfigsLength, 0.0);

    for (var i = 0; i < toneConfigsLength; i++) {
      final toneConfig = toneConfigs[i];
      constants[i] = 2 * pi * toneConfig.frequency / sampleRate;
      amplitudes[i] = toneConfig.amplitude;
      initialPhases[i] = toneConfig.initialPhase;
    }

    final intervalMicroseconds = (1000000 / sampleRate).round();

    while (_hasActiveSubscribers) {
      final stopwatch = Stopwatch()..start();

      for (var t = 0; t < batchSize; t++) {
        double value = 0.0;

        for (var i = 0; i < toneConfigsLength; i++) {
          value += amplitudes[i] * sin(constants[i] * t + initialPhases[i]);
        }

        timeSeries[t] = value;
      }

      yield TimeSeriesData()..data.addAll(timeSeries);

      final elapsedMicroseconds = stopwatch.elapsedMicroseconds;
      if (elapsedMicroseconds < intervalMicroseconds) {
        await Future.delayed(
            Duration(microseconds: intervalMicroseconds - elapsedMicroseconds));
      }
    }
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
    _logger.info('Server listening on port ${server.port}...');
  }
}
