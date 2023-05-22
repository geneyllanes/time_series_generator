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

class BatchedData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BatchedData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xValues', $pb.PbFieldType.KD, protoName: 'xValues')
    ..p<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'yValues', $pb.PbFieldType.KD, protoName: 'yValues')
    ..hasRequiredFields = false
  ;

  BatchedData._() : super();
  factory BatchedData({
    $core.Iterable<$core.double>? xValues,
    $core.Iterable<$core.double>? yValues,
  }) {
    final _result = create();
    if (xValues != null) {
      _result.xValues.addAll(xValues);
    }
    if (yValues != null) {
      _result.yValues.addAll(yValues);
    }
    return _result;
  }
  factory BatchedData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BatchedData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BatchedData clone() => BatchedData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BatchedData copyWith(void Function(BatchedData) updates) => super.copyWith((message) => updates(message as BatchedData)) as BatchedData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BatchedData create() => BatchedData._();
  BatchedData createEmptyInstance() => create();
  static $pb.PbList<BatchedData> createRepeated() => $pb.PbList<BatchedData>();
  @$core.pragma('dart2js:noInline')
  static BatchedData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BatchedData>(create);
  static BatchedData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get xValues => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.double> get yValues => $_getList(1);
}

class TimeSeriesData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimeSeriesData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  TimeSeriesData._() : super();
  factory TimeSeriesData({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
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
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class PublishResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PublishResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  PublishResponse._() : super();
  factory PublishResponse({
    $core.int? id,
    $core.String? message,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory PublishResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishResponse clone() => PublishResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishResponse copyWith(void Function(PublishResponse) updates) => super.copyWith((message) => updates(message as PublishResponse)) as PublishResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublishResponse create() => PublishResponse._();
  PublishResponse createEmptyInstance() => create();
  static $pb.PbList<PublishResponse> createRepeated() => $pb.PbList<PublishResponse>();
  @$core.pragma('dart2js:noInline')
  static PublishResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishResponse>(create);
  static PublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'timeseries'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

