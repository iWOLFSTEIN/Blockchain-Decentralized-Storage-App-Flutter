import 'package:grpc/grpc.dart';

import '../src/generated/connection.pbgrpc.dart';

getRPCResponse() async {
  final channel = ClientChannel('192.168.10.2',
      port: 5000,
      options: ChannelOptions(credentials: ChannelCredentials.insecure()));

  final stub = TokenServiceClient(channel);
  var response = await stub.getToken(TokenRequest(nodeNumber: '12C5A3'));
  String message = "server response to this request is \n ${response}";
  return message;
}
