import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/bloc/time_series_generator_bloc.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  final TimeSeriesGeneratorBloc generatorBloc = TimeSeriesGeneratorBloc();

  @override
  Future<PublishResponse> publishTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) async {
    print('PublishTimeSeries request received');

    // Start data generation by calling the _onStartDataGeneration method of the generatorBloc
    generatorBloc.add(OnPublish(
      request.sampleRate,
      request.tones,
    ));

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  @override
  Stream<BatchedData> subscribeToTimeSeries(
      grpc.ServiceCall call, Empty request) {
    print('New subscriber');

    final subscriberHashCode = call.clientCertificate.hashCode;

    generatorBloc.add(OnSubscribe(subscriberHashCode));

    // Return the stream from the bloc
    final stream = generatorBloc.stream.map((state) => state.batchedData!);

    return stream;
  }
}

/// Server class:
class Server {
  /// main is the entry point of the server application.
  /// It configures the logger, creates an instance of the TimeSeriesGeneratorService, creates a gRPC server,
  /// registers the service with the server, starts the server, and listens on port 8080.
  /// It also registers an onExit callback to gracefully shut down the server and stop data generation when a SIGINT signal (e.g., Ctrl+C) is received.

  static Future<void> main(List<String> args) async {
    final service = TimeSeriesGeneratorService();
    final server = grpc.Server([service]);

    await server.serve(port: 8080);
    print('Server started. Listening on port ${server.port}...');

    // Register the onExit callback to handle program termination
    registerOnExitCallback(server, service);
  }

  /// registerOnExitCallback registers an onExit callback to handle program termination when a SIGINT signal is received.
  /// This function registers an onExit callback to handle program termination when a SIGINT signal is received.
  /// It stops the data generation by calling the stopGeneratingData method of the TimeSeriesGeneratorService.
  /// It then gracefully shuts down the gRPC server and exits the program.
  static void registerOnExitCallback(
      grpc.Server server, TimeSeriesGeneratorService service) {
    ProcessSignal.sigint.watch().listen((signal) async {
      print('Received signal: ${signal.toString()}. Shutting down...');

      // Stop data generation by adding the StopDataGeneration event
      service.generatorBloc.add(StopDataGeneration());

      // Wait for a brief moment to ensure data generation stops
      await Future.delayed(Duration(milliseconds: 100));

      // Gracefully shutdown the server
      await server.shutdown();

      // Close the client channel
      await service.generatorBloc.close();

      // Exit the program
      exit(0);
    });
  }
}
