import 'dart:io';

import 'package:blockchain_decentralized_storage_system/services/generated/storage-node.pb.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

uploadFile(
    {required File file,
    required PlatformFile fileMetaData,
    required InitTransactionResponse initTransactionResponse}) async {
  var dio = Dio();
  FormData formData = new FormData.fromMap({"file": file});
  var response = await dio.post(
    "${initTransactionResponse.httpURL}",
    data: formData,
    options: Options(
      headers: {"Authorization": "Bearer ${initTransactionResponse.jWT}"},
    ),
    onSendProgress: (count, total) {},
  );
}
