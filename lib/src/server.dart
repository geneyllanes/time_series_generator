import 'dart:async';
import 'package:grpc/grpc.dart' as grpc;
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

final Logger _logger = Logger('TimeSeriesGenerator');

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  StreamController<TimeSeriesData> controller =
      StreamController<TimeSeriesData>();

  @override
  Stream<TimeSeriesData> generateTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) {
    final sampleRate = request.sampleRate;
    final toneConfigs = request.tones;

    generateTimeSeriesFromConfig(sampleRate, toneConfigs, controller);

    return controller.stream;
  }

  void generateTimeSeriesFromConfig(
      double sampleRate,
      List<ToneConfig> toneConfigs,
      StreamController<TimeSeriesData> controller) {
    // Generates a time series with sine waves for each tone
    // and streams the data points to the client based on the provided
    // configuration
    // This implementation generates time series indefinitely

    final completer = Completer<void>();

    // Generate time series until completion is signaled
    Timer.periodic(Duration(milliseconds: (1000 / sampleRate).round()),
        (timer) {
      // checking if the stream has any active listeners
      // if not then cancel and complete
      if (!controller.hasListener) {
        timer.cancel();
        completer.complete();
        return;
      }

      final timeSeries = <double>[];

      // Generate the time series for the current tone
      for (var t = 0; t < 1000; t++) {
        double value = 0.0;
        for (final toneConfig in toneConfigs) {
          final initialPhase = toneConfig.initialPhase;
          final amplitude = toneConfig.amplitude;
          final frequency = toneConfig.frequency;

          // Generate the value for the current time point
          value += amplitude *
              sin(2 * pi * frequency * t / sampleRate + initialPhase);
        }
        timeSeries.add(value);
      }

      // Create a response containing the generated time series
      final response = TimeSeriesData()..data.addAll(timeSeries);

      // Yield the response to the client through the stream controller
      controller.add(response);

      // Log the generated time series
      _logger.fine('Generated time series: $timeSeries');
    });

    // When completion is signaled, close the stream
    completer.future.then((_) {
      controller.close();
      _logger.info('Time series generation completed.');
    });
  }
}

class Server {
  Future<void> main(List<String> args) async {
    // Configure the logger
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    final server = grpc.Server([TimeSeriesGeneratorService()]);
    await server.serve(port: 8080);
    _logger.info('Server listening on port ${server.port}...');
  }
}
