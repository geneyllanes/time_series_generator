part of 'time_series_generator_bloc.dart';

class TimeSeriesGeneratorState extends Equatable {
  final List<int> subscribers;
  final int? batchSize;
  final double? sampleRate;
  final List<ToneConfig>? toneConfigs;
  final TimeSeriesData? current;
  final BatchedData? batchedData;
  final bool? isGenerating;

  TimeSeriesGeneratorState({
    this.subscribers = const [],
    this.batchSize = 10000,
    this.sampleRate = 0,
    this.toneConfigs = const [],
    required this.current,
    required this.batchedData,
    this.isGenerating = false,
  });

  TimeSeriesGeneratorState copyWith({
    List<int>? subscribers,
    int? batchSize,
    double? sampleRate,
    List<ToneConfig>? toneConfigs,
    TimeSeriesData? current,
    BatchedData? batchedData,
    bool? isGenerating,
  }) {
    return TimeSeriesGeneratorState(
      subscribers: subscribers ?? this.subscribers,
      batchSize: batchSize ?? this.batchSize,
      sampleRate: sampleRate ?? this.sampleRate,
      toneConfigs: toneConfigs ?? this.toneConfigs,
      current: current ?? this.current,
      batchedData: batchedData ?? this.batchedData,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props {
    return [
      subscribers,
      batchSize,
      sampleRate,
      toneConfigs,
      current,
      batchedData,
      isGenerating,
    ];
  }
}
