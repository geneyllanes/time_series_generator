///
//  Generated code. Do not modify.
//  source: time_series_generator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use timeSeriesConfigDescriptor instead')
const TimeSeriesConfig$json = const {
  '1': 'TimeSeriesConfig',
  '2': const [
    const {'1': 'sample_rate', '3': 1, '4': 1, '5': 2, '10': 'sampleRate'},
    const {'1': 'tones', '3': 2, '4': 3, '5': 11, '6': '.timeseries.ToneConfig', '10': 'tones'},
  ],
};

/// Descriptor for `TimeSeriesConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSeriesConfigDescriptor = $convert.base64Decode('ChBUaW1lU2VyaWVzQ29uZmlnEh8KC3NhbXBsZV9yYXRlGAEgASgCUgpzYW1wbGVSYXRlEiwKBXRvbmVzGAIgAygLMhYudGltZXNlcmllcy5Ub25lQ29uZmlnUgV0b25lcw==');
@$core.Deprecated('Use toneConfigDescriptor instead')
const ToneConfig$json = const {
  '1': 'ToneConfig',
  '2': const [
    const {'1': 'initial_phase', '3': 1, '4': 1, '5': 2, '10': 'initialPhase'},
    const {'1': 'amplitude', '3': 2, '4': 1, '5': 2, '10': 'amplitude'},
    const {'1': 'frequency', '3': 3, '4': 1, '5': 2, '10': 'frequency'},
  ],
};

/// Descriptor for `ToneConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toneConfigDescriptor = $convert.base64Decode('CgpUb25lQ29uZmlnEiMKDWluaXRpYWxfcGhhc2UYASABKAJSDGluaXRpYWxQaGFzZRIcCglhbXBsaXR1ZGUYAiABKAJSCWFtcGxpdHVkZRIcCglmcmVxdWVuY3kYAyABKAJSCWZyZXF1ZW5jeQ==');
@$core.Deprecated('Use timeSeriesDataDescriptor instead')
const TimeSeriesData$json = const {
  '1': 'TimeSeriesData',
  '2': const [
    const {'1': 'data', '3': 1, '4': 3, '5': 2, '10': 'data'},
  ],
};

/// Descriptor for `TimeSeriesData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSeriesDataDescriptor = $convert.base64Decode('Cg5UaW1lU2VyaWVzRGF0YRISCgRkYXRhGAEgAygCUgRkYXRh');
