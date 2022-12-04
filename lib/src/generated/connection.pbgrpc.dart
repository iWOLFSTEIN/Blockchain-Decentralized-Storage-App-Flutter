///
//  Generated code. Do not modify.
//  source: connection.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'connection.pb.dart' as $0;
export 'connection.pb.dart';

class TokenServiceClient extends $grpc.Client {
  static final _$getToken = $grpc.ClientMethod<$0.TokenRequest, $0.Token>(
      '/TokenService/getToken',
      ($0.TokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Token.fromBuffer(value));

  TokenServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Token> getToken($0.TokenRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getToken, request, options: options);
  }
}

abstract class TokenServiceBase extends $grpc.Service {
  $core.String get $name => 'TokenService';

  TokenServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TokenRequest, $0.Token>(
        'getToken',
        getToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TokenRequest.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
  }

  $async.Future<$0.Token> getToken_Pre(
      $grpc.ServiceCall call, $async.Future<$0.TokenRequest> request) async {
    return getToken(call, await request);
  }

  $async.Future<$0.Token> getToken(
      $grpc.ServiceCall call, $0.TokenRequest request);
}
