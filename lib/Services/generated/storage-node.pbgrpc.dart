///
//  Generated code. Do not modify.
//  source: storage-node.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'storage-node.pb.dart' as $0;
export 'storage-node.pb.dart';

class StorageNodeClient extends $grpc.Client {
  static final _$getStats = $grpc.ClientMethod<$0.Empty, $0.GetStatsResponse>(
      '/proto.StorageNode/GetStats',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GetStatsResponse.fromBuffer(value));
  static final _$initTransaction =
      $grpc.ClientMethod<$0.InitTransactionRequest, $0.InitTransactionResponse>(
          '/proto.StorageNode/InitTransaction',
          ($0.InitTransactionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.InitTransactionResponse.fromBuffer(value));
  static final _$ping = $grpc.ClientMethod<$0.PingRequest, $0.PingResponse>(
      '/proto.StorageNode/Ping',
      ($0.PingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PingResponse.fromBuffer(value));

  StorageNodeClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.GetStatsResponse> getStats($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.InitTransactionResponse> initTransaction(
      $0.InitTransactionRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$initTransaction, request, options: options);
  }

  $grpc.ResponseFuture<$0.PingResponse> ping($0.PingRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ping, request, options: options);
  }
}

abstract class StorageNodeServiceBase extends $grpc.Service {
  $core.String get $name => 'proto.StorageNode';

  StorageNodeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.GetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.GetStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InitTransactionRequest,
            $0.InitTransactionResponse>(
        'InitTransaction',
        initTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InitTransactionRequest.fromBuffer(value),
        ($0.InitTransactionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PingRequest, $0.PingResponse>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PingRequest.fromBuffer(value),
        ($0.PingResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetStatsResponse> getStats_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getStats(call, await request);
  }

  $async.Future<$0.InitTransactionResponse> initTransaction_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.InitTransactionRequest> request) async {
    return initTransaction(call, await request);
  }

  $async.Future<$0.PingResponse> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PingRequest> request) async {
    return ping(call, await request);
  }

  $async.Future<$0.GetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.InitTransactionResponse> initTransaction(
      $grpc.ServiceCall call, $0.InitTransactionRequest request);
  $async.Future<$0.PingResponse> ping(
      $grpc.ServiceCall call, $0.PingRequest request);
}
