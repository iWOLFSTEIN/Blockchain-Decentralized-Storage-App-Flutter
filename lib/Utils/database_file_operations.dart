import 'dart:io';
import 'package:path/path.dart';
import 'package:blockchain_decentralized_storage_system/utils/app_directory.dart';
import 'package:path_provider/path_provider.dart';

saveDatabase(String databaseFileName) async {
  try {
    var newPath = await getAppDirectory() + "/$databaseFileName.db";
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    File databaseFile = File(path);
    await databaseFile.copy(newPath);
  } catch (e) {
    print(e.toString());
  }
}

deleteDatabase(String databaseFileName) async {
  try {
    var path = await getAppDirectory() + "/$databaseFileName.db";
    File databaseFile = File(path);
    await databaseFile.delete();
  } catch (e) {
    print(e.toString());
  }
}
