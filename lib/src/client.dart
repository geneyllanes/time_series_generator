import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class Client {
  Future<void> main(List<String> args) async {
    final channel = grpc.ClientChannel('localhost',
        port: 8080,
        options: grpc.ChannelOptions(
            credentials: grpc.ChannelCredentials.insecure()));

    final client = TimeSeriesGeneratorClient(channel);

    try {
      // Subscribe to the generated time series
      final subscribeRequest = Empty();

      final subscription = client.subscribeToTimeSeries(subscribeRequest);
      await for (final timeSeriesData in subscription) {
        print('Received time series data: ${timeSeriesData.data}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      await channel.shutdown();
    }
  }
}
