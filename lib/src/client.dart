import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class Client {
  Future<void> main(List<String> args) async {
    final channel = ClientChannel('localhost',
        port: 8080,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()));

    final client = TimeSeriesGeneratorClient(channel);

    // Start the stream
    final request = TimeSeriesConfig()
      ..sampleRate = 10000.0
      ..tones.add(
        ToneConfig()
          ..initialPhase = 0.0
          ..amplitude = 1.0
          ..frequency = 1.0,
      )
      ..tones.add(
        ToneConfig()
          ..initialPhase = 0.0
          ..amplitude = 0.5
          ..frequency = 2.0,
      );

    Stream<TimeSeriesData> stream;
    try {
      stream = client.generateTimeSeries(request);
    } catch (e) {
      print('Error occurred while starting the stream: $e');
      await channel.shutdown();
      return;
    }

    // Listen to the stream response and log the values
    final subscription = stream.listen((timeSeriesData) {
      for (var value in timeSeriesData.data) {
        print('Value: $value');
      }
    }, onError: (error) {
      print('Error occurred: $error');
    }, onDone: () {
      print('Stream completed');
      channel.shutdown();
    });

    // Complete the stream after 5 seconds
    Timer(Duration(seconds: 5), () {
      subscription.cancel();
      channel.shutdown();
    });
  }
}
