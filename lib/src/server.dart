import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:time_series_generator/src/generated/time_series_generator.dart';

/// TimeSeriesGeneratorService implements the server-side of the TimeSeriesGenerator service.
class TimeSeriesGeneratorService extends TimeSeriesGeneratorServiceBase {
  final _logger = Logger('TimeSeriesGeneratorService');

  // StreamController for broadcasting time series data to multiple subscribers.
  StreamController<TimeSeriesData> _broadcastController =
      StreamController.broadcast();

  int _subscriberId = 0;
  Map<int, StreamController<TimeSeriesData>> _subscriberControllers = {};

  /// publishTimeSeries handles the PublishTimeSeries RPC method.
  /// This function is called when a client invokes the PublishTimeSeries RPC method.
  /// It takes a gRPC service call object and a TimeSeriesConfig request as input.
  /// It generates time series data based on the provided configuration and publishes it to the broadcast controller.
  /// It returns a PublishResponse object with an ID and a message indicating the status of the publication.
  @override
  Future<PublishResponse> publishTimeSeries(
      grpc.ServiceCall call, TimeSeriesConfig request) async {
    // Generate time series data
    Stream<TimeSeriesData> dataStream =
        generateTimeSeries(request.sampleRate, request.tones);

    _logger.info('publishing data to the broadcast');

    // Add data stream to the broadcast controller
    dataStream.listen((data) {
      _broadcastController.add(data);
    });

    return PublishResponse()
      ..id = 1
      ..message = 'Publishing';
  }

  /// subscribeToTimeSeries handles the SubscribeToTimeSeries RPC method.
  /// This function is called when a client invokes the SubscribeToTimeSeries RPC method.
  /// It takes a gRPC service call object and an Empty request as input.
  /// It creates a new subscriber controller for the client and adds it to the map of subscriber controllers.
  /// It listens to the broadcast controller for time series data and forwards it to the subscriber controller.
  /// It returns the stream of time series data for the client to consume.
  @override
  Stream<TimeSeriesData> subscribeToTimeSeries(
      grpc.ServiceCall call, Empty request) {
    final subscriberController = StreamController<TimeSeriesData>();

    final subscriberId = _subscriberId++;
    print('Subscriber $subscriberId added');

    subscriberController.onCancel = () {
      print('Subscriber $subscriberId unsubscribed');
      _subscriberControllers
          .remove(subscriberId); // Remove the subscriber's controller
    };

    _subscriberControllers[subscriberId] =
        subscriberController; // Store the subscriber's controller

    _broadcastController.stream.listen(
      (data) {
        subscriberController.add(data);
      },
      onError: subscriberController.addError,
      onDone: subscriberController.close,
    );

    return subscriberController.stream;
  }

  /// generateTimeSeries generates time series data based on the sample rate and tone configurations.
  /// This function generates the time series data based on the sample rate and tone configurations provided.
  /// It uses a generator function (async*) to continuously yield batches of time series data.
  /// It calculates the values for each data point in the batch by iterating over the tone configurations and summing the contributions from each tone.
  /// The generated data is added to a list (timeSeries) and then yielded as a TimeSeriesData object.
  /// The generator function also includes a delay to ensure a consistent sample rate.
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

    /// This first implementation with nested loops might be more readable
    /// and easier to understand, especially for developers who are new to
    /// the codebase or not familiar with the specific domain. It explicitly
    /// separates the outer loop for batch iterations and the inner loop for tone
    /// contributions. This can make it easier to follow the logic and make
    /// modifications or enhancements in the future.
    ///
    // while (true) {
    //   for (var i = 0; i < batchSize; i++) {
    //     timeSeries[i] = 0.0;

    //     for (var j = 0; j < toneConfigsLength; j++) {
    //       final constant = constants[j];
    //       final amplitude = amplitudes[j];
    //       final initialPhase = initialPhases[j];

    //       timeSeries[i] += amplitude *
    //           sin(constant * i +
    //               initialPhase); // Calculate the value for the data point
    //     }
    //   }

    /// The second implementation with a single loop may offer better performance
    /// compared to the first implementation with nested loops. This is because
    /// nested loops can result in redundant calculations and slower execution.
    /// If performance is a critical factor, especially when dealing with large
    /// batch sizes or complex calculations, the second implementation may be
    /// more efficient.
    ///
    /// The second implementation includes timing-related logic using a stopwatch
    /// and a delay to maintain a consistent sample rate. If maintaining a precise
    /// and consistent sample rate is important for your application, the second
    /// implementation provides a mechanism to control the timing more accurately.
    while (true) {
      final stopwatch = Stopwatch()..start();
      for (var t = 0; t < batchSize; t++) {
        double value = 0.0;
        for (var i = 0; i < toneConfigsLength; i++) {
          value += amplitudes[i] * sin(constants[i] * t + initialPhases[i]);
        }
        timeSeries[t] = value;
        // _logger.info('Generator value: $value'); // Logging the generated value
      }
      yield TimeSeriesData()..data.addAll(timeSeries);
      final elapsedMicroseconds = stopwatch.elapsedMicroseconds;
      if (elapsedMicroseconds < intervalMicroseconds) {
        await Future.delayed(
            Duration(microseconds: intervalMicroseconds - elapsedMicroseconds));
      }
/////////////////////////////////////////////////////////////////////////////////
      yield TimeSeriesData()..data.addAll(timeSeries);

      await Future.delayed(Duration(
          microseconds:
              intervalMicroseconds)); // Delay for consistent sample rate
    }
  }

  /// stopGeneratingData stops the generation of time series data.
  /// This function stops the generation of time series data.
  /// It closes the broadcast controller stream and cancels the subscription for each individual subscriber.
  void stopGeneratingData() {
    _broadcastController.close();

    // Close the individual subscriber stream controllers and cancel the subscription
    _subscriberControllers.forEach((_, controller) {
      controller.close();
      controller.sink.close();
    });
    _subscriberControllers.clear();
  }
}

/// Server class:
class Server {
  static final _serverPort = 8080;

  /// configureLogger configures the logger to log all levels of log records and prints them to the console.
  static void configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  /// main is the entry point of the server application.
  /// It configures the logger, creates an instance of the TimeSeriesGeneratorService, creates a gRPC server,
  /// registers the service with the server, starts the server, and listens on port 8080.
  /// It also registers an onExit callback to gracefully shut down the server and stop data generation when a SIGINT signal (e.g., Ctrl+C) is received.

  static Future<void> main(List<String> args) async {
    configureLogger();

    final service = TimeSeriesGeneratorService();
    final server = grpc.Server([service]);

    await server.serve(port: 8080);
    print('Server listening on port ${server.port}...');

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

      // Stop the data generation
      service.stopGeneratingData();

      // Gracefully shutdown the server
      await server.shutdown();

      // Exit the program
      exit(0);
    });
  }
}
