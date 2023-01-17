import 'package:blockchain_decentralized_storage_system/provider/network_data.dart';
import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  DataProvider(this._networkData, this._balance);
  NetworkData _networkData;
  double _balance;
  double get balance => _balance;
  fetchAndSync({privateKey, ethClient}) async {
    double accountBalance = await _networkData.getAccountBalance(
        privateKey: privateKey, ethClient: ethClient);
    _balance = accountBalance;
    notifyListeners();
  }
}
