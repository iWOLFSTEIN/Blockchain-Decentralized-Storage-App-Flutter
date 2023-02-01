import 'dart:io';
import 'package:blockchain_decentralized_storage_system/utils/permissions_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

getAppDirectory() async {
  var directory;

  if (await requestPermission(Permission.storage)) {
    if (await requestPermission(Permission.manageExternalStorage)) {
      var tempDirectory = Directory(await _getPath());
      if (await tempDirectory.exists()) {
        directory = tempDirectory.path;
      } else {
        directory = tempDirectory.create().then((value) => value.path);
      }
    } else {
      var tempDirectory = Directory(await _getPath());
      if (await tempDirectory.exists()) {
        directory = tempDirectory.path;
      } else {
        directory = tempDirectory.create().then((value) => value.path);
      }
    }
  }

  return directory;
}

_getPath() async {
  var directory = (await getExternalStorageDirectory())!;
  String newPath = "";
  List<String> paths = directory.path.split("/");
  for (int x = 1; x < paths.length; x++) {
    String folder = paths[x];
    if (folder != "Android") {
      newPath += "/$folder";
    } else {
      break;
    }
  }
  newPath = "$newPath/Hyperspace";

  return newPath;
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists())
        directory = await getExternalStorageDirectory();
    }
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
  return directory?.path;
}
