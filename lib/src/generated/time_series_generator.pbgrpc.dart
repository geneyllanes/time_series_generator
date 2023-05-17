///
//  Generated code. Do not modify.
//  source: time_series_generator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'time_series_generator.pb.dart' as $0;
export 'time_series_generator.pb.dart';

class TimeSeriesGeneratorClient extends $grpc.Client {
  static final _$generateTimeSeries =
      $grpc.ClientMethod<$0.TimeSeriesConfig, $0.TimeSeriesData>(
          '/timeseries.TimeSeriesGenerator/GenerateTimeSeries',
          ($0.TimeSeriesConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.TimeSeriesData.fromBuffer(value));

  TimeSeriesGeneratorClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.TimeSeriesData> generateTimeSeries(
      $0.TimeSeriesConfig request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$generateTimeSeries, request, options: options);
  }
}

abstract class TimeSeriesGeneratorServiceBase extends $grpc.Service {
  $core.String get $name => 'timeseries.TimeSeriesGenerator';

  TimeSeriesGeneratorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TimeSeriesConfig, $0.TimeSeriesData>(
        'GenerateTimeSeries',
        generateTimeSeries_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TimeSeriesConfig.fromBuffer(value),
        ($0.TimeSeriesData value) => value.writeToBuffer()));
  }

  $async.Future<$0.TimeSeriesData> generateTimeSeries_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.TimeSeriesConfig> request) async {
    return generateTimeSeries(call, await request);
  }

  $async.Future<$0.TimeSeriesData> generateTimeSeries(
      $grpc.ServiceCall call, $0.TimeSeriesConfig request);
}
