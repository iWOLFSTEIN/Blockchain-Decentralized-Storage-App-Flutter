import 'package:flutter/cupertino.dart';
import '../services/database_helper.dart';

class DatabaseProvider with ChangeNotifier {
  DatabaseProvider(this._items, this.database) {
    fetchAndSetData();
  }

  DatabaseHelper database;

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => [..._items];

  Future<void> fetchAndSetData() async {
    final dataList = await database.queryAllChildrenRows();
    _items = dataList;
    notifyListeners();
  }

  addUserTableRow(row) async {
    await database.insertChildren(row);
    fetchAndSetData();
  }

  deleteDatabase() async {
    await database.truncateTable();
  }
}
