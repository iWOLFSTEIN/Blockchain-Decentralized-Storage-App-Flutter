import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class NetworkData with ChangeNotifier {
  getAccountBalance(
      {required String privateKey, required Web3Client ethClient}) async {
    var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    EtherAmount balance = await ethClient.getBalance(credentials.address);
    double ethers = balance.getValueInUnit(EtherUnit.ether);
    return ethers;
  }

  // getPublicKey(
  //     {required String privateKey, required Web3Client ethClient}) async {
  //   var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
  //   Uint8List publicKey = credentials.encodedPublicKey;
  //   return bytesToHex(publicKey);
  // }

  // getAddress(
  //     {required String privateKey, required Web3Client ethClient}) async {
  //   var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
  //   return credentials.address.hex;
  // }
}
