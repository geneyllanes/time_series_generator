import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class Client2 {
  Future<void> main(List<String> args) async {
    final channel = grpc.ClientChannel('localhost',
        port: 8080,
        options: grpc.ChannelOptions(
            credentials: grpc.ChannelCredentials.insecure()));

    final client = TimeSeriesGeneratorClient(channel);

    try {
      // Publish three tones
      final publishRequest = TimeSeriesConfig()
        ..sampleRate = 44100
        ..tones.addAll([
          ToneConfig(initialPhase: 0.0, amplitude: 10.0, frequency: 4440.0),
          ToneConfig(initialPhase: 0.0, amplitude: 0.5, frequency: 880.0),
          ToneConfig(initialPhase: 0.0, amplitude: 0.25, frequency: 1320.0),
        ]);

      final publishResponse = await client.publishTimeSeries(publishRequest);
      print('Publish ID: ${publishResponse.id}');
      print('Publish Message: ${publishResponse.message}');
    } catch (e) {
      print('Error: $e');
    } finally {
      await channel.shutdown();
    }
  }
}
