part of 'time_series_generator_bloc.dart';

abstract class TimeSeriesGeneratorEvent {}

class OnSubscribe extends TimeSeriesGeneratorEvent {
  final int hash;

  OnSubscribe(this.hash);
}

class OnPublish extends TimeSeriesGeneratorEvent {
  final double sampleRate;
  final List<ToneConfig> toneConfigs;

  OnPublish(this.sampleRate, this.toneConfigs);
}

class UpdateConfiguration extends TimeSeriesGeneratorEvent {
  final double sampleRate;
  final List<ToneConfig> toneConfigs;

  UpdateConfiguration(this.sampleRate, this.toneConfigs);
}

class StartDataGeneration extends TimeSeriesGeneratorEvent {}

class StopDataGeneration extends TimeSeriesGeneratorEvent {}

class OnUnsubscribe extends TimeSeriesGeneratorEvent {
  final int hash;

  OnUnsubscribe(this.hash);
}
