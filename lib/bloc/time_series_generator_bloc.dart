import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_series_generator/src/generated/time_series_generator.dart';

part 'time_series_generator_event.dart';
part 'time_series_generator_state.dart';

class TimeSeriesGeneratorBloc
    extends Bloc<TimeSeriesGeneratorEvent, TimeSeriesGeneratorState> {
  StreamSubscription<BatchedData>? periodicSubscription;

  TimeSeriesGeneratorBloc()
      : super(TimeSeriesGeneratorState(
            batchedData: BatchedData(xValues: [0], yValues: [0]))) {
    on<OnSubscribe>(_onSubscribe);
    on<OnPublish>(_onPublish);
    on<UpdateConfiguration>(_onUpdateConfiguration);
    on<StartDataGeneration>(_onStartDataGeneration);
    on<StopDataGeneration>(_onStopDataGeneration);
    on<OnUnsubscribe>(_onUnsubscribe);
  }

  void _onSubscribe(OnSubscribe event, Emitter<TimeSeriesGeneratorState> emit) {
    final updated = state.subscribers.map((e) => e).toList()..add(event.hash);

    emit(state.copyWith(subscribers: updated));
    print('Subscribed Event: ' + event.hashCode.toString());

    if (updated.length == 1 && state.isGenerating!) {
      add(StartDataGeneration());
    }
  }

  void _onPublish(OnPublish event, Emitter<TimeSeriesGeneratorState> emit) {
    add(UpdateConfiguration(event.sampleRate, event.toneConfigs));

    if (state.subscribers.isNotEmpty) {
      // Start a new data generation process with the updated configurations
      add(StartDataGeneration());
    }
  }

  void _onUpdateConfiguration(
      UpdateConfiguration event, Emitter<TimeSeriesGeneratorState> emit) async {
    await periodicSubscription
        ?.cancel()
        .then((value) => print('stop cancelled periodic Generation'));
    emit(
      state.copyWith(
        sampleRate: event.sampleRate,
        toneConfigs: event.toneConfigs,
      ),
    );
  }

  void _onStartDataGeneration(
      StartDataGeneration event, Emitter<TimeSeriesGeneratorState> emit) async {
    emit(state.copyWith(isGenerating: true));

    final toneConfigs = <ToneConfigData>[];
    final intervalMicroseconds = (1000000 / state.sampleRate!).round();
    var elapsedTime = 0;

    for (var toneConfig in state.toneConfigs!) {
      final constant = 2 * pi * toneConfig.frequency / state.sampleRate!;
      toneConfigs.add(ToneConfigData(
          constant, toneConfig.amplitude, toneConfig.initialPhase));
    }

    var xValues = List<double>.generate(state.batchSize!, (_) => 0.0);
    var yValues = List<double>.generate(state.batchSize!, (_) => 0.0);

    final batchDataTransformer =
        StreamTransformer<int, BatchedData>.fromHandlers(
            handleData: (value, sink) {
      final xValue = (elapsedTime / 1000);
      final yValue = generateYValue(elapsedTime, toneConfigs);

      xValues.add(xValue);
      yValues.add(yValue);

      elapsedTime += intervalMicroseconds;

      if (xValues.length >= state.batchSize!) {
        final output = BatchedData(
          xValues: xValues,
          yValues: yValues,
        );

        print(output.xValues.firstOrNull.toString());

        xValues = [];
        yValues = [];

        sink.add(output);
      }
    });

    final stopwatch = Stopwatch();
    stopwatch.start();

    final intervalStream =
        Stream.periodic(Duration(microseconds: intervalMicroseconds), (value) {
      return stopwatch.elapsedMicroseconds;
    });

    periodicSubscription =
        intervalStream.transform(batchDataTransformer).listen((batchedData) {
      emit(state.copyWith(batchedData: batchedData));
    });
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

  void _onStopDataGeneration(
      StopDataGeneration event, Emitter<TimeSeriesGeneratorState> emit) async {
    await periodicSubscription
        ?.cancel()
        .then((value) => print('stop cancelled periodic Generation'));

    emit(
      state.copyWith(
        batchedData: BatchedData(xValues: [0], yValues: [0]),
        isGenerating: false,
      ),
    );
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

  @override
  Future<void> close() async {
    print('onClose');
    await periodicSubscription
        ?.cancel()
        .then((value) => print('onClose cancelled periodic Generation'));
    return super.close();
  }
}

class ToneConfigData {
  final double constant;
  final double amplitude;
  final double initialPhase;

  ToneConfigData(this.constant, this.amplitude, this.initialPhase);
}
