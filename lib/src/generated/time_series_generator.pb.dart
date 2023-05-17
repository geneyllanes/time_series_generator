///
//  Generated code. Do not modify.
//  source: time_series_generator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TimeSeriesConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimeSeriesConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sampleRate', $pb.PbFieldType.OF)
    ..pc<ToneConfig>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tones', $pb.PbFieldType.PM, subBuilder: ToneConfig.create)
    ..hasRequiredFields = false
  ;

  TimeSeriesConfig._() : super();
  factory TimeSeriesConfig({
    $core.double? sampleRate,
    $core.Iterable<ToneConfig>? tones,
  }) {
    final _result = create();
    if (sampleRate != null) {
      _result.sampleRate = sampleRate;
    }
    if (tones != null) {
      _result.tones.addAll(tones);
    }
    return _result;
  }
  factory TimeSeriesConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeSeriesConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeSeriesConfig clone() => TimeSeriesConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeSeriesConfig copyWith(void Function(TimeSeriesConfig) updates) => super.copyWith((message) => updates(message as TimeSeriesConfig)) as TimeSeriesConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimeSeriesConfig create() => TimeSeriesConfig._();
  TimeSeriesConfig createEmptyInstance() => create();
  static $pb.PbList<TimeSeriesConfig> createRepeated() => $pb.PbList<TimeSeriesConfig>();
  @$core.pragma('dart2js:noInline')
  static TimeSeriesConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeSeriesConfig>(create);
  static TimeSeriesConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get sampleRate => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRate($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSampleRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRate() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<ToneConfig> get tones => $_getList(1);
}

class ToneConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ToneConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'initialPhase', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amplitude', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frequency', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ToneConfig._() : super();
  factory ToneConfig({
    $core.double? initialPhase,
    $core.double? amplitude,
    $core.double? frequency,
  }) {
    final _result = create();
    if (initialPhase != null) {
      _result.initialPhase = initialPhase;
    }
    if (amplitude != null) {
      _result.amplitude = amplitude;
    }
    if (frequency != null) {
      _result.frequency = frequency;
    }
    return _result;
  }
  factory ToneConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToneConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToneConfig clone() => ToneConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToneConfig copyWith(void Function(ToneConfig) updates) => super.copyWith((message) => updates(message as ToneConfig)) as ToneConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToneConfig create() => ToneConfig._();
  ToneConfig createEmptyInstance() => create();
  static $pb.PbList<ToneConfig> createRepeated() => $pb.PbList<ToneConfig>();
  @$core.pragma('dart2js:noInline')
  static ToneConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToneConfig>(create);
  static ToneConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get initialPhase => $_getN(0);
  @$pb.TagNumber(1)
  set initialPhase($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInitialPhase() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialPhase() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amplitude => $_getN(1);
  @$pb.TagNumber(2)
  set amplitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmplitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmplitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get frequency => $_getN(2);
  @$pb.TagNumber(3)
  set frequency($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFrequency() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrequency() => clearField(3);
}

class TimeSeriesData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimeSeriesData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.KF)
    ..hasRequiredFields = false
  ;

  TimeSeriesData._() : super();
  factory TimeSeriesData({
    $core.Iterable<$core.double>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory TimeSeriesData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeSeriesData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeSeriesData clone() => TimeSeriesData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeSeriesData copyWith(void Function(TimeSeriesData) updates) => super.copyWith((message) => updates(message as TimeSeriesData)) as TimeSeriesData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimeSeriesData create() => TimeSeriesData._();
  TimeSeriesData createEmptyInstance() => create();
  static $pb.PbList<TimeSeriesData> createRepeated() => $pb.PbList<TimeSeriesData>();
  @$core.pragma('dart2js:noInline')
  static TimeSeriesData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeSeriesData>(create);
  static TimeSeriesData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get data => $_getList(0);
}

