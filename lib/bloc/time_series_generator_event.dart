part of 'time_series_generator_bloc.dart';


abstract class TimeSeriesGeneratorEvent {}

class StartDataGeneration extends TimeSeriesGeneratorEvent {
  final double sampleRate;
  final List<ToneConfig> toneConfigs;

  StartDataGeneration(this.sampleRate, this.toneConfigs);
}

class StopDataGeneration extends TimeSeriesGeneratorEvent {}

class UpdateConfiguration extends TimeSeriesGeneratorEvent {
  final double sampleRate;
  final List<ToneConfig> toneConfigs;

  UpdateConfiguration(this.sampleRate, this.toneConfigs);
}

class OnSubscribe extends TimeSeriesGeneratorEvent {
  final int hash;

  OnSubscribe(this.hash);

}

class OnUnsubscribe extends TimeSeriesGeneratorEvent {
  final int hash;

  OnUnsubscribe(this.hash);

}

class OnPublish extends TimeSeriesGeneratorEvent {
  final double sampleRate;
  final List<ToneConfig> toneConfigs;

  OnPublish(this.sampleRate, this.toneConfigs);
}
