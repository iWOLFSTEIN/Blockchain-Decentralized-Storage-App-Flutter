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
import 'package:blockchain_decentralized_storage_system/utils/alerts.dart';
import 'package:blockchain_decentralized_storage_system/utils/app_directory.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:blockchain_decentralized_storage_system/utils/file_hash.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:dio/dio.dart';
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

  bool _isContainerVisible = false;
  bool _isContentVisible = false;

  Map<String, dynamic>? currentRow;

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
    if (mounted)
      setState(() {
        serversUrls = urls;
      });
  }

  _showContainer() {
    setState(() {
      _isContainerVisible = true;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isContentVisible = true;
      });
    });
  }

  _hideContainer() {
    setState(() {
      _isContainerVisible = false;
      _isContentVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                              GestureDetector(
                                  onTap: () {
                                    _showContainer();
                                    setState(() {
                                      currentRow = row;
                                    });
                                  },
                                  child: UploadedFileTile(row: row))
                          ],
                        ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isContainerVisible
                      ? Expanded(
                          child: GestureDetector(
                          onTap: () {
                            _hideContainer();
                          },
                          child: Container(
                            color: Colors.white.withOpacity(0.0),
                          ),
                        ))
                      : Container(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    height: _isContainerVisible ? 150 : 0,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: _isContentVisible
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                bottomContainerElement(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFF494949),
                                  ),
                                  action: () {},
                                  title: 'delete',
                                  color: Color(0xFF494949),
                                ),
                                bottomContainerElement(
                                  icon: Icon(
                                    Icons.verified_outlined,
                                    color: Color(0xFF494949),
                                  ),
                                  action: () {},
                                  title: 'verify',
                                  color: Color(0xFF494949),
                                ),
                                bottomContainerElement(
                                  icon: Icon(
                                    Icons.link,
                                    color: (currentRow!['is_encrypted'] == 1)
                                        ? Colors.grey
                                        : Color(0xFF494949),
                                  ),
                                  action: (currentRow!['is_encrypted'] == 1)
                                      ? null
                                      : () async {
                                          await Clipboard.setData(ClipboardData(
                                              text:
                                                  currentRow!['download_url']));
                                          _hideContainer();
                                          Alert(
                                                  message:
                                                      'link copied to clipboard')
                                              .show();
                                        },
                                  title: 'link copy',
                                  color: (currentRow!['is_encrypted'] == 1)
                                      ? Colors.grey
                                      : Color(0xFF494949),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _isContainerVisible
          ? null
          : FloatingActionButton(
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

  Column bottomContainerElement(
      {required Widget icon,
      required String title,
      required Color color,
      required action}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(100),
          elevation: 8,
          shadowColor: Colors.white,
          child: GestureDetector(
            onTap: action,
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                border:
                    Border.all(width: 1, color: Colors.black.withOpacity(0.05)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(child: icon),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
            color: color,
          ),
        )
      ],
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
  bool isVerifingSha256Comparison = false;
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
                            isVerifingSha256Comparison
                                ? 'verifying...'
                                : isDecrypting
                                    ? 'decrypting...'
                                    : '',
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
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(100),
                  shadowColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CircularPercentIndicator(
                      radius: 18,
                      lineWidth: 2,
                      percent: downloadProgress,
                      animateFromLastPercent: true,
                      animation: true,
                      center: Text(
                        '${(downloadProgress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: Color(0xFF4859A0), fontSize: 9),
                      ),
                      backgroundColor: Colors.grey.withOpacity(0.05),
                      progressColor: Color(0xFF4859A0),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ),
              if (!isDownlaoding)
                GestureDetector(
                  onTap: (isDecrypting || isVerifingSha256Comparison)
                      ? null
                      : () async {
                          await download(databaseProvider);
                        },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(100),
                    shadowColor: Colors.white,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.05), width: 1.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.file_download_outlined,
                          color: (isDecrypting || isVerifingSha256Comparison)
                              ? Colors.grey.withOpacity(0.2)
                              : Color(0xFF4859A0),
                          size: 16.5,
                        ),
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
      File file = File(savePath);
      setState(() {
        isDownlaoding = false;
        downloadProgress = 0.0;
        isVerifingSha256Comparison = true;
      });
      Uint8List fileBytes = await verifyFileByComparingSha256Hash(
          file: file, storedSha256Hash: widget.row['sha256']);
      setState(() {
        isVerifingSha256Comparison = false;
      });
      if (widget.row['is_encrypted'] == 1) {
        setState(() {
          isDecrypting = true;
        });
        await decryptFile(
            databaseProvider: databaseProvider,
            file: file,
            fileBytes: fileBytes);
        setState(() {
          isDecrypting = false;
        });
      }
      Alert(message: 'Saved in downloads').show();
    } catch (e) {
      setState(() {
        isDownlaoding = false;
        downloadProgress = 0.0;
        isVerifingSha256Comparison = false;
        isDecrypting = false;
      });
      Alert(message: 'An error occurred').show();
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
      required File file,
      required Uint8List fileBytes}) async {
    String privateKey = databaseProvider.accountTableItems[0]['private_key'];
    var bytes = utf8.encode(privateKey);
    var digest = sha256.convert(bytes);

    final key = en.Key.fromUtf8(digest.toString().substring(0, 32));
    final iv = en.IV.fromUtf8(iv_key);
    final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));
    fileBytes = Uint8List.fromList(
        encrypter.decryptBytes(en.Encrypted(fileBytes), iv: iv));

    await file.writeAsBytes(fileBytes);
  }

  Future<Uint8List> verifyFileByComparingSha256Hash(
      {required File file, required String storedSha256Hash}) async {
    Uint8List fileBytes = await file.readAsBytes();
    String calculatedSha256Hash = calculateFileSha256Hash(fileBytes);
    if (!(storedSha256Hash == calculatedSha256Hash)) {
      showErrorAlert(context,
          subtitle: 'The integrity of this file has been compromised.');
    }

    return fileBytes;
  }
}
