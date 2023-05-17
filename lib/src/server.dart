import 'dart:async';
import 'dart:math';
import 'package:grpc/grpc.dart' as grpc;
import 'package:logging/logging.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

final Logger _logger = Logger('TimeSeriesGenerator');

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  late StreamController<TimeSeriesData> _controller;
  bool _hasActiveSubscribers = false;

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
    _controller = StreamController<TimeSeriesData>(
      onCancel: () {
        _logger.info('Stream canceled. Stopping time series generation.');
        _hasActiveSubscribers = false;
        _controller.close();
      },
    );

    _controller.addStream(
      generateTimeSeriesStream(sampleRate, toneConfigs),
    );
  }

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
