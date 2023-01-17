import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class NetworkData with ChangeNotifier {
  getAccountBalance({privateKey, ethClient}) async {
    var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    EtherAmount balance = await ethClient.getBalance(credentials.address);
    double ethers = balance.getValueInUnit(EtherUnit.ether);
    return ethers;
  }
}
