import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'generated/storage-node.pbgrpc.dart';

class StorageNode {
  late StorageNodeClient _storageNode;

  StorageNode({required String address}) {
    _storageNode = _storageNodeConnection(address: address);
  }

  StorageNodeClient _storageNodeConnection({required String address}) {
    List serverAddressList;
    String serverAddress;
    int port;

    if (address.contains('http://')) {
      serverAddressList = address.split('//')[1].split(':');
      serverAddress = serverAddressList[0];
      port = int.parse(serverAddressList[1]);
    } else {
      serverAddressList = address.split(':');
      serverAddress = serverAddressList[0];
      port = int.parse(serverAddressList[1]);
    }

    final channel = ClientChannel(serverAddress,
        port: port,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()));
    final storageNodeClient = StorageNodeClient(channel);
    return storageNodeClient;
  }

  Future<GetStatsResponse> stats() async {
    GetStatsResponse getStatsResponse = await _storageNode.getStats(Empty());
    return getStatsResponse;
  }

  Future<PingResponse> ping(
      {Int64? fileSize,
      int? segmentCount,
      String? bidPrice,
      Int64? timePeriod}) async {
    PingRequest pingRequest = PingRequest(
        fileSize: fileSize,
        segmentsCount: segmentCount,
        bidPrice: bidPrice,
        timePeriod: timePeriod);
    PingResponse pingResponse = await _storageNode.ping(pingRequest);
    return pingResponse;
  }

  initTransaction({
    Int64? fileSize,
    Int64? segmentsCount,
    String? fileHash,
    String? bid,
    String? userAddress,
    Int64? timeStart,
    Int64? timeEnd,
    Int64? concludeTimeout,
    Int64? proveTimeout,
  }) async {
    InitTransactionRequest initTransactionRequest = InitTransactionRequest(
        fileSize: fileSize,
        segmentsCount: segmentsCount,
        fileHash: fileHash,
        bid: bid,
        userAddress: userAddress,
        timeStart: timeStart,
        timeEnd: timeEnd,
        concludeTimeout: concludeTimeout,
        proveTimeout: proveTimeout);
    InitTransactionResponse initTransactionResponse =
        await _storageNode.initTransaction(initTransactionRequest);
    return initTransactionResponse;
  }
}
