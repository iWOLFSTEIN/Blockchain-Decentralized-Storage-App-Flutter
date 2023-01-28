import 'package:flutter/cupertino.dart';
import 'database_helper.dart';

class DatabaseProvider with ChangeNotifier {
  DatabaseProvider(
      this._accountTableItems, this._filesTableItems, this.database) {
    fetchAndSetData();
  }

  DatabaseHelper database;

  List<Map<String, dynamic>> _accountTableItems = [];
  List<Map<String, dynamic>> get accountTableItems => [..._accountTableItems];

  List<Map<String, dynamic>> _filesTableItems = [];
  List<Map<String, dynamic>> get filesTableItems => [..._filesTableItems];

  Future<void> fetchAndSetData() async {
    final allAccountTableRows =
        await database.queryAllChildrenRowsFromAccountTable();
    final allFilesTableRows =
        await database.queryAllChildrenRowsFromFilesTable();

    _accountTableItems = allAccountTableRows;
    _filesTableItems = allFilesTableRows;

    notifyListeners();
  }

  addAccountTableRow(row) async {
    await database.insertChildrenInAccountTable(row);
    fetchAndSetData();
  }

  addFilesTableRow(row) async {
    await database.insertChildrenInFilesTable(row);
    fetchAndSetData();
  }

  deleteAccountTableData() async {
    await database.truncateAccountTable();
  }

  deleteFilesTableData() async {
    await database.truncatefilesTable();
  }
}
