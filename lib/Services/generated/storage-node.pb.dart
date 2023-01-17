///
//  Generated code. Do not modify.
//  source: storage-node.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class GetStatsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetStatsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'freeStorage', $pb.PbFieldType.O3, protoName: 'freeStorage')
    ..hasRequiredFields = false
  ;

  GetStatsResponse._() : super();
  factory GetStatsResponse({
    $core.int? freeStorage,
  }) {
    final _result = create();
    if (freeStorage != null) {
      _result.freeStorage = freeStorage;
    }
    return _result;
  }
  factory GetStatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStatsResponse clone() => GetStatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStatsResponse copyWith(void Function(GetStatsResponse) updates) => super.copyWith((message) => updates(message as GetStatsResponse)) as GetStatsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetStatsResponse create() => GetStatsResponse._();
  GetStatsResponse createEmptyInstance() => create();
  static $pb.PbList<GetStatsResponse> createRepeated() => $pb.PbList<GetStatsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetStatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatsResponse>(create);
  static GetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get freeStorage => $_getIZ(0);
  @$pb.TagNumber(1)
  set freeStorage($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFreeStorage() => $_has(0);
  @$pb.TagNumber(1)
  void clearFreeStorage() => clearField(1);
}

class InitTransactionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InitTransactionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileSize', $pb.PbFieldType.OU6, protoName: 'fileSize', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'segmentsCount', $pb.PbFieldType.OU6, protoName: 'segmentsCount', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileHash', protoName: 'fileHash')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bid')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userAddress', protoName: 'userAddress')
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeStart', $pb.PbFieldType.OU6, protoName: 'timeStart', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeEnd', $pb.PbFieldType.OU6, protoName: 'timeEnd', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'concludeTimeout', $pb.PbFieldType.OU6, protoName: 'concludeTimeout', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ProveTimeout', $pb.PbFieldType.OU6, protoName: 'ProveTimeout', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  InitTransactionRequest._() : super();
  factory InitTransactionRequest({
    $fixnum.Int64? fileSize,
    $fixnum.Int64? segmentsCount,
    $core.String? fileHash,
    $core.String? bid,
    $core.String? userAddress,
    $fixnum.Int64? timeStart,
    $fixnum.Int64? timeEnd,
    $fixnum.Int64? concludeTimeout,
    $fixnum.Int64? proveTimeout,
  }) {
    final _result = create();
    if (fileSize != null) {
      _result.fileSize = fileSize;
    }
    if (segmentsCount != null) {
      _result.segmentsCount = segmentsCount;
    }
    if (fileHash != null) {
      _result.fileHash = fileHash;
    }
    if (bid != null) {
      _result.bid = bid;
    }
    if (userAddress != null) {
      _result.userAddress = userAddress;
    }
    if (timeStart != null) {
      _result.timeStart = timeStart;
    }
    if (timeEnd != null) {
      _result.timeEnd = timeEnd;
    }
    if (concludeTimeout != null) {
      _result.concludeTimeout = concludeTimeout;
    }
    if (proveTimeout != null) {
      _result.proveTimeout = proveTimeout;
    }
    return _result;
  }
  factory InitTransactionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitTransactionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitTransactionRequest clone() => InitTransactionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitTransactionRequest copyWith(void Function(InitTransactionRequest) updates) => super.copyWith((message) => updates(message as InitTransactionRequest)) as InitTransactionRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InitTransactionRequest create() => InitTransactionRequest._();
  InitTransactionRequest createEmptyInstance() => create();
  static $pb.PbList<InitTransactionRequest> createRepeated() => $pb.PbList<InitTransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static InitTransactionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitTransactionRequest>(create);
  static InitTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fileSize => $_getI64(0);
  @$pb.TagNumber(1)
  set fileSize($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileSize() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get segmentsCount => $_getI64(1);
  @$pb.TagNumber(2)
  set segmentsCount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSegmentsCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSegmentsCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFileHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileHash() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get bid => $_getSZ(3);
  @$pb.TagNumber(4)
  set bid($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBid() => $_has(3);
  @$pb.TagNumber(4)
  void clearBid() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get userAddress => $_getSZ(4);
  @$pb.TagNumber(5)
  set userAddress($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUserAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserAddress() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timeStart => $_getI64(5);
  @$pb.TagNumber(6)
  set timeStart($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTimeStart() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimeStart() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timeEnd => $_getI64(6);
  @$pb.TagNumber(7)
  set timeEnd($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTimeEnd() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeEnd() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get concludeTimeout => $_getI64(7);
  @$pb.TagNumber(8)
  set concludeTimeout($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasConcludeTimeout() => $_has(7);
  @$pb.TagNumber(8)
  void clearConcludeTimeout() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get proveTimeout => $_getI64(8);
  @$pb.TagNumber(9)
  set proveTimeout($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProveTimeout() => $_has(8);
  @$pb.TagNumber(9)
  void clearProveTimeout() => clearField(9);
}

class InitTransactionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'InitTransactionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'JWT', protoName: 'JWT')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt', protoName: 'expiresAt')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'httpURL', protoName: 'httpURL')
    ..hasRequiredFields = false
  ;

  InitTransactionResponse._() : super();
  factory InitTransactionResponse({
    $core.String? jWT,
    $fixnum.Int64? expiresAt,
    $core.String? httpURL,
  }) {
    final _result = create();
    if (jWT != null) {
      _result.jWT = jWT;
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    if (httpURL != null) {
      _result.httpURL = httpURL;
    }
    return _result;
  }
  factory InitTransactionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitTransactionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitTransactionResponse clone() => InitTransactionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitTransactionResponse copyWith(void Function(InitTransactionResponse) updates) => super.copyWith((message) => updates(message as InitTransactionResponse)) as InitTransactionResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InitTransactionResponse create() => InitTransactionResponse._();
  InitTransactionResponse createEmptyInstance() => create();
  static $pb.PbList<InitTransactionResponse> createRepeated() => $pb.PbList<InitTransactionResponse>();
  @$core.pragma('dart2js:noInline')
  static InitTransactionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitTransactionResponse>(create);
  static InitTransactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jWT => $_getSZ(0);
  @$pb.TagNumber(1)
  set jWT($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJWT() => $_has(0);
  @$pb.TagNumber(1)
  void clearJWT() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAt => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAt($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAt() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get httpURL => $_getSZ(2);
  @$pb.TagNumber(3)
  set httpURL($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHttpURL() => $_has(2);
  @$pb.TagNumber(3)
  void clearHttpURL() => clearField(3);
}

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
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

class PingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileSize', $pb.PbFieldType.OU6, protoName: 'fileSize', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'segmentsCount', $pb.PbFieldType.OU3, protoName: 'segmentsCount')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bidPrice', protoName: 'bidPrice')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timePeriod', $pb.PbFieldType.OU6, protoName: 'timePeriod', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  PingRequest._() : super();
  factory PingRequest({
    $fixnum.Int64? fileSize,
    $core.int? segmentsCount,
    $core.String? bidPrice,
    $fixnum.Int64? timePeriod,
  }) {
    final _result = create();
    if (fileSize != null) {
      _result.fileSize = fileSize;
    }
    if (segmentsCount != null) {
      _result.segmentsCount = segmentsCount;
    }
    if (bidPrice != null) {
      _result.bidPrice = bidPrice;
    }
    if (timePeriod != null) {
      _result.timePeriod = timePeriod;
    }
    return _result;
  }
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fileSize => $_getI64(0);
  @$pb.TagNumber(1)
  set fileSize($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileSize() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get segmentsCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set segmentsCount($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSegmentsCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSegmentsCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get bidPrice => $_getSZ(2);
  @$pb.TagNumber(3)
  set bidPrice($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBidPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearBidPrice() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timePeriod => $_getI64(3);
  @$pb.TagNumber(4)
  set timePeriod($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimePeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimePeriod() => clearField(4);
}

class PingResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'proto'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canStore', protoName: 'canStore')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bidPrice', protoName: 'bidPrice')
    ..hasRequiredFields = false
  ;

  PingResponse._() : super();
  factory PingResponse({
    $core.bool? canStore,
    $core.String? bidPrice,
  }) {
    final _result = create();
    if (canStore != null) {
      _result.canStore = canStore;
    }
    if (bidPrice != null) {
      _result.bidPrice = bidPrice;
    }
    return _result;
  }
  factory PingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingResponse clone() => PingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingResponse copyWith(void Function(PingResponse) updates) => super.copyWith((message) => updates(message as PingResponse)) as PingResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingResponse create() => PingResponse._();
  PingResponse createEmptyInstance() => create();
  static $pb.PbList<PingResponse> createRepeated() => $pb.PbList<PingResponse>();
  @$core.pragma('dart2js:noInline')
  static PingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingResponse>(create);
  static PingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get canStore => $_getBF(0);
  @$pb.TagNumber(1)
  set canStore($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCanStore() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanStore() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get bidPrice => $_getSZ(1);
  @$pb.TagNumber(2)
  set bidPrice($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBidPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearBidPrice() => clearField(2);
}

