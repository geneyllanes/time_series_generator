import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

part 'time_series_generator_event.dart';
part 'time_series_generator_state.dart';

class TimeSeriesGeneratorBloc
    extends Bloc<TimeSeriesGeneratorEvent, TimeSeriesGeneratorState> {
  StreamSubscription?
      dataGenerationSubscription; // Stream subscription to control data generation

  TimeSeriesGeneratorBloc()
      : super(TimeSeriesGeneratorState(
            current: TimeSeriesData(), batchedData: BatchedData())) {
    on<StartDataGeneration>(_onStartDataGeneration);
    on<StopDataGeneration>(_onStopDataGeneration);
    on<OnSubscribe>(_onSubscribe);
    on<OnUnsubscribe>(_onUnsubscribe);
    on<OnPublish>(_onPublish);
  }

  void _onStartDataGeneration(
      StartDataGeneration event, Emitter<TimeSeriesGeneratorState> emit) {
    final toneConfigs = <ToneConfigData>[];
    final intervalMicroseconds = (1000000 / event.sampleRate).round();
    var elapsedTime = 0;

    for (var toneConfig in event.toneConfigs) {
      final constant = 2 * pi * toneConfig.frequency / event.sampleRate;
      toneConfigs.add(ToneConfigData(
          constant, toneConfig.amplitude, toneConfig.initialPhase));
    }

    dataGenerationSubscription?.cancel(); // Cancel any existing subscription

    var xValues = List<double>.generate(state.batchSize!, (_) => 0.0);
    var yValues = List<double>.generate(state.batchSize!, (_) => 0.0);

    Timer.periodic(Duration(microseconds: intervalMicroseconds), (_) {
      elapsedTime += intervalMicroseconds; // Update elapsed time

      final xValue = elapsedTime / 1000; // Convert to milliseconds
      final yValue = generateYValue(elapsedTime, toneConfigs);

      xValues.add(xValue); // Add current x-value to the list
      yValues.add(yValue); // Add current y-value to the list

      if (xValues.length >= state.batchSize!) {
        print('server x:' + xValues.first.toString());
        // If the desired number of data points is reached, update the state
        final output = BatchedData(
          xValues: xValues,
          yValues: yValues,
        );

        emit(state.copyWith(
          batchedData: output, // Send data batches to subscribers
        ));

        xValues.clear(); // Clear the x-values list
        yValues.clear(); // Clear the y-values list
      }
    });
  }

  void _onStopDataGeneration(
      StopDataGeneration event, Emitter<TimeSeriesGeneratorState> emit) {
    dataGenerationSubscription
        ?.cancel(); // Cancel the data generation subscription
  }

  double generateYValue(int currentTime, List<ToneConfigData> toneConfigs) {
    double yValue = 0;

    for (var toneConfig in toneConfigs) {
      final value = toneConfig.amplitude *
          sin(toneConfig.constant * currentTime + toneConfig.initialPhase);
      yValue += value;
    }

    return yValue;
  }

  void _onSubscribe(OnSubscribe event, Emitter<TimeSeriesGeneratorState> emit) {
    final updated = state.subscribers.map((e) => e).toList()..add(event.hash);

    emit(state.copyWith(subscribers: updated));
    print('Subscribed Event: ' + event.hashCode.toString());

    if (updated.length == 1 && state.isGenerating!) {
      add(StartDataGeneration(state.sampleRate!, state.toneConfigs!));
    }
  }

  void _onUnsubscribe(
      OnUnsubscribe event, Emitter<TimeSeriesGeneratorState> emit) {
    final updated = state.subscribers.map((e) => e).toList()
      ..remove(event.hashCode);

    emit(state.copyWith(subscribers: updated));
    print('Unsubscribed Event: ' + event.hashCode.toString());

    if (updated.length == 0) {
      add(StopDataGeneration());
    }
  }

  void _onPublish(OnPublish event, Emitter<TimeSeriesGeneratorState> emit) {
    emit(
      state.copyWith(
        sampleRate: event.sampleRate,
        toneConfigs: event.toneConfigs,
        isGenerating: true,
      ),
    );
    print(state.subscribers.length);

    if (state.subscribers.length > 0) {
      // Start data generation if there are active subscribers
      add(StartDataGeneration(state.sampleRate!, state.toneConfigs!));
    }
  }

  @override
  Future<void> close() {
    print('onClose');
    dataGenerationSubscription
        ?.cancel(); // Cancel the subscription when closing the bloc
    return super.close();
  }
}

class ToneConfigData {
  final double constant;
  final double amplitude;
  final double initialPhase;

  ToneConfigData(this.constant, this.amplitude, this.initialPhase);
}
