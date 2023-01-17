///
//  Generated code. Do not modify.
//  source: storage-node.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use getStatsResponseDescriptor instead')
const GetStatsResponse$json = const {
  '1': 'GetStatsResponse',
  '2': const [
    const {'1': 'freeStorage', '3': 1, '4': 1, '5': 5, '10': 'freeStorage'},
  ],
};

/// Descriptor for `GetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsResponseDescriptor = $convert.base64Decode('ChBHZXRTdGF0c1Jlc3BvbnNlEiAKC2ZyZWVTdG9yYWdlGAEgASgFUgtmcmVlU3RvcmFnZQ==');
@$core.Deprecated('Use initTransactionRequestDescriptor instead')
const InitTransactionRequest$json = const {
  '1': 'InitTransactionRequest',
  '2': const [
    const {'1': 'fileSize', '3': 1, '4': 1, '5': 4, '10': 'fileSize'},
    const {'1': 'segmentsCount', '3': 2, '4': 1, '5': 4, '10': 'segmentsCount'},
    const {'1': 'fileHash', '3': 3, '4': 1, '5': 9, '10': 'fileHash'},
    const {'1': 'bid', '3': 4, '4': 1, '5': 9, '10': 'bid'},
    const {'1': 'userAddress', '3': 5, '4': 1, '5': 9, '10': 'userAddress'},
    const {'1': 'timeStart', '3': 6, '4': 1, '5': 4, '10': 'timeStart'},
    const {'1': 'timeEnd', '3': 7, '4': 1, '5': 4, '10': 'timeEnd'},
    const {'1': 'concludeTimeout', '3': 8, '4': 1, '5': 4, '10': 'concludeTimeout'},
    const {'1': 'ProveTimeout', '3': 9, '4': 1, '5': 4, '10': 'ProveTimeout'},
  ],
};

/// Descriptor for `InitTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initTransactionRequestDescriptor = $convert.base64Decode('ChZJbml0VHJhbnNhY3Rpb25SZXF1ZXN0EhoKCGZpbGVTaXplGAEgASgEUghmaWxlU2l6ZRIkCg1zZWdtZW50c0NvdW50GAIgASgEUg1zZWdtZW50c0NvdW50EhoKCGZpbGVIYXNoGAMgASgJUghmaWxlSGFzaBIQCgNiaWQYBCABKAlSA2JpZBIgCgt1c2VyQWRkcmVzcxgFIAEoCVILdXNlckFkZHJlc3MSHAoJdGltZVN0YXJ0GAYgASgEUgl0aW1lU3RhcnQSGAoHdGltZUVuZBgHIAEoBFIHdGltZUVuZBIoCg9jb25jbHVkZVRpbWVvdXQYCCABKARSD2NvbmNsdWRlVGltZW91dBIiCgxQcm92ZVRpbWVvdXQYCSABKARSDFByb3ZlVGltZW91dA==');
@$core.Deprecated('Use initTransactionResponseDescriptor instead')
const InitTransactionResponse$json = const {
  '1': 'InitTransactionResponse',
  '2': const [
    const {'1': 'JWT', '3': 1, '4': 1, '5': 9, '10': 'JWT'},
    const {'1': 'expiresAt', '3': 2, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'httpURL', '3': 3, '4': 1, '5': 9, '10': 'httpURL'},
  ],
};

/// Descriptor for `InitTransactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initTransactionResponseDescriptor = $convert.base64Decode('ChdJbml0VHJhbnNhY3Rpb25SZXNwb25zZRIQCgNKV1QYASABKAlSA0pXVBIcCglleHBpcmVzQXQYAiABKANSCWV4cGlyZXNBdBIYCgdodHRwVVJMGAMgASgJUgdodHRwVVJM');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = const {
  '1': 'PingRequest',
  '2': const [
    const {'1': 'fileSize', '3': 1, '4': 1, '5': 4, '10': 'fileSize'},
    const {'1': 'segmentsCount', '3': 2, '4': 1, '5': 13, '10': 'segmentsCount'},
    const {'1': 'bidPrice', '3': 3, '4': 1, '5': 9, '10': 'bidPrice'},
    const {'1': 'timePeriod', '3': 4, '4': 1, '5': 4, '10': 'timePeriod'},
  ],
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode('CgtQaW5nUmVxdWVzdBIaCghmaWxlU2l6ZRgBIAEoBFIIZmlsZVNpemUSJAoNc2VnbWVudHNDb3VudBgCIAEoDVINc2VnbWVudHNDb3VudBIaCghiaWRQcmljZRgDIAEoCVIIYmlkUHJpY2USHgoKdGltZVBlcmlvZBgEIAEoBFIKdGltZVBlcmlvZA==');
@$core.Deprecated('Use pingResponseDescriptor instead')
const PingResponse$json = const {
  '1': 'PingResponse',
  '2': const [
    const {'1': 'canStore', '3': 1, '4': 1, '5': 8, '10': 'canStore'},
    const {'1': 'bidPrice', '3': 2, '4': 1, '5': 9, '10': 'bidPrice'},
  ],
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor = $convert.base64Decode('CgxQaW5nUmVzcG9uc2USGgoIY2FuU3RvcmUYASABKAhSCGNhblN0b3JlEhoKCGJpZFByaWNlGAIgASgJUghiaWRQcmljZQ==');
