import 'package:blockchain_decentralized_storage_system/provider/network_data.dart';
import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  DataProvider(
    this._networkData,
    this._balance,
    //  this._accountAddress, this._publicKey
  );
  NetworkData _networkData;
  double _balance;
  double get balance => _balance;
  // String _publicKey;
  // String get publicKey => _publicKey;
  // String _accountAddress;
  // String get accountAddress => _accountAddress;
  fetchAndSyncBalance({privateKey, ethClient}) async {
    double accountBalance = await _networkData.getAccountBalance(
        privateKey: privateKey, ethClient: ethClient);
    _balance = accountBalance;
    notifyListeners();
  }

  // fetchAndSyncAccountDetails({privateKey, ethClient}) async {
  //   String key = await _networkData.getPublicKey(
  //       privateKey: privateKey, ethClient: ethClient);
  //   String address = await _networkData.getAddress(
  //       privateKey: privateKey, ethClient: ethClient);

  //   _publicKey = key;
  //   _accountAddress = address;

  //   notifyListeners();
  // }
}
