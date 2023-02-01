import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../provider/data_provider.dart';
import '../provider/database_provider.dart';

updateAccountBalance(context, ethClient) {
  try {
    _fetchAndUpdate(context, ethClient);
  } catch (e) {
    print(e.toString());
    Future.delayed(Duration(seconds: 2), () {
      _fetchAndUpdate(context, ethClient);
    });
  }
}

_fetchAndUpdate(context, ethClient) {
  var dataProvider = Provider.of<DataProvider>(context, listen: false);
  var databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  var privateKey = databaseProvider.accountTableItems[0]['private_key'];
  dataProvider.fetchAndSyncBalance(
      ethClient: ethClient, privateKey: privateKey);
}
