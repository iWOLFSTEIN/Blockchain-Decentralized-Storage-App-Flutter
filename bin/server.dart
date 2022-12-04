import 'package:blockchain_decentralized_storage_system/src/generated/connection.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/src/server/call.dart';

class TokenService extends TokenServiceBase {
  @override
  Future<Token> getToken(ServiceCall call, TokenRequest request) async {
    // TODO: implement getToken
    return Token(token: '234AB23084E23423FA234');
  }
}

void main(List<String> args) async {
  final server = Server([TokenService()]);
  await server.serve(port: 5000);
  print("server listening to the port ${server.port}");
}
