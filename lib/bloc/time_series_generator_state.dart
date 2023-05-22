part of 'time_series_generator_bloc.dart';

class TimeSeriesGeneratorState extends Equatable {
  final List<int> subscribers;
  final int? batchSize;
  final double? sampleRate;
  final List<ToneConfig>? toneConfigs;
  final BatchedData? batchedData;
  final bool? isGenerating;
  final StreamSubscription? dataGenerationSubscription;

  TimeSeriesGeneratorState({
    this.subscribers = const [],
    this.batchSize = 10000,
    this.sampleRate = 0,
    this.toneConfigs = const [],
    required this.batchedData,
    this.isGenerating = false,
    this.dataGenerationSubscription,
  });

  TimeSeriesGeneratorState copyWith({
    List<int>? subscribers,
    int? batchSize,
    double? sampleRate,
    List<ToneConfig>? toneConfigs,
    BatchedData? batchedData,
    bool? isGenerating,
    StreamSubscription? dataGenerationSubscription,
  }) {
    return TimeSeriesGeneratorState(
      subscribers: subscribers ?? this.subscribers,
      batchSize: batchSize ?? this.batchSize,
      sampleRate: sampleRate ?? this.sampleRate,
      toneConfigs: toneConfigs ?? this.toneConfigs,
      batchedData: batchedData ?? this.batchedData,
      isGenerating: isGenerating ?? this.isGenerating,
      dataGenerationSubscription:
          dataGenerationSubscription ?? this.dataGenerationSubscription,
    );
  }

  @override
  List<Object?> get props {
    return [
      subscribers,
      batchSize,
      sampleRate,
      toneConfigs,
      batchedData,
      isGenerating,
    ];
  }
}
