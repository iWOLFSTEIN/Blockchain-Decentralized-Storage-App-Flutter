import 'package:dio/dio.dart';

uploadFile({required file, required fileMetaData, required sender}) async {
  var dio = Dio();
  FormData formData = new FormData.fromMap(
      {"name": "", "${sender}": UploadFileInfo(file, "${fileMetaData.name}")});
  var response = await dio.post("127.0.0.1", data: formData);
  print(response);
}

class UploadFileInfo {
  var file;
  var name;
  UploadFileInfo(this.file, this.name);
}
