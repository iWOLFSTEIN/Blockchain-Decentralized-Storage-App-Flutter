import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:alert/alert.dart';
import 'package:blockchain_decentralized_storage_system/provider/data_provider.dart';
import 'package:blockchain_decentralized_storage_system/screens/upload.dart';
import 'package:blockchain_decentralized_storage_system/services/generated/storage-node.pbgrpc.dart';
import 'package:blockchain_decentralized_storage_system/services/rpc_calls.dart';
import 'package:blockchain_decentralized_storage_system/services/smart_contract_helper_methods.dart';
import 'package:blockchain_decentralized_storage_system/structures/node.dart';
import 'package:blockchain_decentralized_storage_system/utils/app_directory.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:dio/dio.dart';
// import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sha3/sha3.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../provider/database_provider.dart';
import '../utils/bytes_calculator.dart';
import '../utils/compute_merkle_tree.dart';
import '../utils/update_account_balance.dart';
import '../widgets/app_branding.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as R;
import 'package:encrypt/encrypt.dart' as en;

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late http.Client httpClient = http.Client();
  late Web3Client ethClient =
      Web3Client(HTTP_URL, httpClient, socketConnector: () {
    return IOWebSocketChannel.connect(HTTP_URL).cast<String>();
  });
  List<Node> serversUrls = [];
  double downloadProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serversAddresses();
    updateAccountBalance();
  }

  updateAccountBalance() {
    Future.delayed(Duration(seconds: 2), () {
      var dataProvider = Provider.of<DataProvider>(context, listen: false);
      var databaseProvider =
          Provider.of<DatabaseProvider>(context, listen: false);
      var privateKey = databaseProvider.accountTableItems[0]['private_key'];
      dataProvider.fetchAndSyncBalance(
          ethClient: ethClient, privateKey: privateKey);
    });
  }

  serversAddresses() async {
    List<Node> urls = await getServersAddresses(ethClient: ethClient);
    setState(() {
      serversUrls = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    AppBranding(profileIconVisibility: 1.0),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Uploaded',
                        style: TextStyle(
                            color: Color(0xFFABACAF),
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              listEquals(databaseProvider.filesTableItems, [])
                  ? Expanded(
                      child: Container(
                        child: Center(
                            child: Text(
                          'No files available',
                          style: TextStyle(color: Colors.grey),
                        )),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                      padding: EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 70),
                      children: [
                        for (Map<String, dynamic> row
                            in databaseProvider.filesTableItems)
                          // uploadedFileTile(row: row)
                          UploadedFileTile(row: row)
                      ],
                    ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4859A0),
        onPressed: () async {
          await pickFile();
        },
        child: Icon(
          Icons.cloud_upload,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path as String;
      File file = File(filePath);
      PlatformFile fileMetaData = result.files.first;

      if (!listEquals(serversUrls, [])) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Upload(
                      file: file,
                      fileMetaData: fileMetaData,
                      serversUrls: serversUrls,
                    )));
      }
    } else {}
  }
}

class UploadedFileTile extends StatefulWidget {
  const UploadedFileTile({super.key, required this.row});
  final Map<String, dynamic> row;
  @override
  State<UploadedFileTile> createState() => _UploadedFileTileState();
}

class _UploadedFileTileState extends State<UploadedFileTile> {
  double downloadProgress = 0.0;
  bool isDownlaoding = false;
  bool isDecrypting = false;
  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 20,
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          height: 80,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Opacity(
                opacity: 0.6,
                child: Image.asset(
                  (widget.row['is_encrypted'] == 1)
                      ? 'images/encrypted_file.png'
                      : 'images/file.png',
                  height: 25,
                  width: 25,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.row['name'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xFF494949), fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              '${formatBytes(widget.row['file_size'])}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.5, color: Color(0xFF6A6A6A)),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            widget.row['created_at'].toString().split(' ')[0],
                            style: TextStyle(
                                fontSize: 12.5, color: Color(0xFF6A6A6A)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            isDecrypting ? 'decrypting...' : '',
                            style: TextStyle(
                                fontSize: 12.5, color: Color(0xFF6A6A6A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              if (isDownlaoding)
                CircularPercentIndicator(
                  radius: 16,
                  lineWidth: 2,
                  percent: downloadProgress,
                  animateFromLastPercent: true,
                  animation: true,
                  center: Text(
                    '${(downloadProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Color(0xFF4859A0), fontSize: 9),
                  ),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  progressColor: Color(0xFF4859A0),
                ),
              if (!isDownlaoding)
                GestureDetector(
                  onTap: isDecrypting
                      ? null
                      : () async {
                          await download(databaseProvider);
                        },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2), width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.file_download_outlined,
                        color: isDecrypting
                            ? Colors.grey.withOpacity(0.2)
                            : Color(0xFF4859A0),
                        size: 17.5,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  download(DatabaseProvider databaseProvider) async {
    try {
      setState(() {
        isDownlaoding = true;
      });
      String? path = await getDownloadPath();
      String savePath = '$path/${widget.row['name']}';
      await downloadFile(url: widget.row['download_url'], savePath: savePath);
      if (widget.row['is_encrypted'] == 1) {
        setState(() {
          isDownlaoding = false;
          downloadProgress = 0.0;
          isDecrypting = true;
        });
        await decryptFile(
            databaseProvider: databaseProvider, filePath: savePath);
        setState(() {
          isDecrypting = false;
        });
      } else {
        setState(() {
          isDownlaoding = false;
          downloadProgress = 0.0;
        });
      }
      Alert(message: 'Saved in downloads').show();
    } catch (e) {
      setState(() {
        isDownlaoding = false;
        downloadProgress = 0.0;
        isDecrypting = false;
      });
      print(e.toString());
    }
  }

  Future<dynamic> downloadFile(
      {required String url, required String savePath}) async {
    Dio dio = Dio();
    R.Response response = await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        setState(() {
          downloadProgress = received / total;
        });
      },
    );
    return response.data;
  }

  Future<void> decryptFile(
      {required DatabaseProvider databaseProvider,
      required String filePath}) async {
    File file = File(filePath);
    Uint8List fileBytes = await file.readAsBytes();
    String privateKey = databaseProvider.accountTableItems[0]['address'];
    var bytes = utf8.encode(privateKey);
    var digest = sha256.convert(bytes);

    final key = en.Key.fromUtf8(digest.toString().substring(0, 32));
    final iv = en.IV.fromUtf8(iv_key);
    final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));
    fileBytes = Uint8List.fromList(
        encrypter.decryptBytes(en.Encrypted(fileBytes), iv: iv));

    await file.writeAsBytes(fileBytes);
  }
}
