import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:blockchain_decentralized_storage_system/provider/data_provider.dart';
import 'package:blockchain_decentralized_storage_system/screens/upload.dart';
import 'package:blockchain_decentralized_storage_system/services/generated/storage-node.pbgrpc.dart';
import 'package:blockchain_decentralized_storage_system/services/rpc_calls.dart';
import 'package:blockchain_decentralized_storage_system/services/smart_contract_helper_methods.dart';
import 'package:blockchain_decentralized_storage_system/structures/node.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:hex/hex.dart';
import 'package:provider/provider.dart';
import 'package:sha3/sha3.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../provider/database_provider.dart';
import '../utils/bytes_calculator.dart';
import '../utils/compute_merkle_tree.dart';
import '../widgets/app_branding.dart';
import 'package:http/http.dart' as http;

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serversAddresses();
    updateAccountDetails();
  }

  updateAccountDetails() {
    Future.delayed(Duration(milliseconds: 2000), () {
      var dataProvider = Provider.of<DataProvider>(this.context, listen: false);
      var databaseProvider =
          Provider.of<DatabaseProvider>(this.context, listen: false);
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
    // if (listEquals(serversUrls, [])) {
    //   return Container(
    //     color: Colors.white,
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                children: [
                  for (Map<String, dynamic> row
                      in databaseProvider.filesTableItems)
                    uploadedFileTile(row: row)
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

  Padding uploadedFileTile({required Map<String, dynamic> row}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7.5,
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
                opacity: 0.5,
                child: Image.asset(
                  (row['is_encrypted'] == 1)
                      ? 'images/encrypted_file.png'
                      : 'images/file.png',
                  height: 25,
                  width: 25,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          row['name'],
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Color(0xFF494949), fontSize: 17),
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
                          // '${(row['file_size'] / 1024).ceil()}kb',
                          '${formatBytes(row['file_size'])}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.5, color: Color(0xFF6A6A6A)),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        row['created_at'].toString().split(' ')[0],
                        style:
                            TextStyle(fontSize: 12.5, color: Color(0xFF6A6A6A)),
                      ),
                    ],
                  ),
                  //   ],
                  // ),
                ],
              ),
              Expanded(
                child: SizedBox(
                    // width: 8,
                    ),
              ),
              Icon(
                Icons.cloud_download,
                color: Color(0xFF4859A0),
                size: 25,
              )
            ],
          ),
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
