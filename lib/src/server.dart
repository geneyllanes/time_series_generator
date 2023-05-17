import 'dart:io';
import 'package:grpc/grpc.dart' as grpc;
import 'dart:math';
import 'package:grpc/grpc.dart';
import './generated/time_series_generator.dart';

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  @override
  Future<TimeSeriesData> generateTimeSeries(
      ServiceCall call, TimeSeriesConfig request) async {
    // Extract the configuration parameters from the request
    final sampleRate = request.sampleRate;
    final toneConfigs = request.tones;

    // Generate the time series based on the provided configuration
    final timeSeries = generateTimeSeriesFromConfig(sampleRate, toneConfigs);

    // Create the response containing the generated time series
    final response = TimeSeriesData()..data.addAll(timeSeries);

    return response;
  }

  List<double> generateTimeSeriesFromConfig(
      double sampleRate, List<ToneConfig> toneConfigs) {
    // Implement your time series generation logic here
    // Generate the time series based on the provided configuration
    // You can use libraries like 'dart:math' or 'dart:io' for this purpose

    // Example: Generate a time series with sine waves for each tone
    final timeSeries = <double>[];

    for (final toneConfig in toneConfigs) {
      final initialPhase = toneConfig.initialPhase;
      final amplitude = toneConfig.amplitude;
      final frequency = toneConfig.frequency;

      // Generate the time series for the current tone
      // You can adjust this part based on your specific requirements
      for (var t = 0; t < 1000; t++) {
        final value = amplitude *
            (sin(2 * pi * frequency * t / sampleRate + initialPhase));
        timeSeries.add(value);
      }
    }

    return timeSeries;
  }
}

class Server {
  Future<void> main(List<String> args) async {
    final server = grpc.Server([TimeSeriesGeneratorService()]);
    await server.serve(port: 8080);
    print('Server listening on port ${server.port}...');
  }
}
