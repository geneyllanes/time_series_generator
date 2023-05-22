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
  static final _$publishTimeSeries =
      $grpc.ClientMethod<$0.TimeSeriesConfig, $0.PublishResponse>(
          '/timeseries.TimeSeriesGenerator/PublishTimeSeries',
          ($0.TimeSeriesConfig value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.PublishResponse.fromBuffer(value));
  static final _$subscribeToTimeSeries =
      $grpc.ClientMethod<$0.Empty, $0.BatchedData>(
          '/timeseries.TimeSeriesGenerator/SubscribeToTimeSeries',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.BatchedData.fromBuffer(value));

  TimeSeriesGeneratorClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.PublishResponse> publishTimeSeries(
      $0.TimeSeriesConfig request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$publishTimeSeries, request, options: options);
  }

  $grpc.ResponseStream<$0.BatchedData> subscribeToTimeSeries($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$subscribeToTimeSeries, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class TimeSeriesGeneratorServiceBase extends $grpc.Service {
  $core.String get $name => 'timeseries.TimeSeriesGenerator';

  TimeSeriesGeneratorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TimeSeriesConfig, $0.PublishResponse>(
        'PublishTimeSeries',
        publishTimeSeries_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TimeSeriesConfig.fromBuffer(value),
        ($0.PublishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.BatchedData>(
        'SubscribeToTimeSeries',
        subscribeToTimeSeries_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.BatchedData value) => value.writeToBuffer()));
  }

  $async.Future<$0.PublishResponse> publishTimeSeries_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.TimeSeriesConfig> request) async {
    return publishTimeSeries(call, await request);
  }

  $async.Stream<$0.BatchedData> subscribeToTimeSeries_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* subscribeToTimeSeries(call, await request);
  }

  $async.Future<$0.PublishResponse> publishTimeSeries(
      $grpc.ServiceCall call, $0.TimeSeriesConfig request);
  $async.Stream<$0.BatchedData> subscribeToTimeSeries(
      $grpc.ServiceCall call, $0.Empty request);
}
