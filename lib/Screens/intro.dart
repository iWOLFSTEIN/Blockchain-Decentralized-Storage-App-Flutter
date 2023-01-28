import 'dart:io' as io;
import 'dart:io';
import 'dart:math';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/screens/home.dart';
import 'package:blockchain_decentralized_storage_system/widgets/custom_alert_dialogues.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:path/path.dart';
import 'package:web_socket_channel/io.dart';
import '../utils/app_directory.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final privateKeyController = TextEditingController();
  final nameController = TextEditingController();
  final pageController = PageController(initialPage: 0);
  late http.Client httpClient = http.Client();
  late Web3Client ethClient =
      Web3Client(HTTP_URL, httpClient, socketConnector: () {
    return IOWebSocketChannel.connect(HTTP_URL).cast<String>();
  });
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          logoArea(),
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Container(
                    height: 50,
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await importDatabase(context, databaseProvider);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Text(
                              'Import Account',
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF4859A0).withOpacity(0.4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        privateKeyPage(context),
                        namePage(context, databaseProvider),
                      ]),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  importDatabase(context, databaseProvider) async {
    try {
      var newPath = await getAppDirectory();
      List files = io.Directory(newPath).listSync();
      // if (!listEquals(files, [])) {
      print(files);
      // Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // String path = join(documentsDirectory.path, "database.db");
      // files[0].copy(path).then((value) {
      //   databaseProvider.fetchAndSetData();
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => Home()),
      //       (route) => false);
      // });

      var listAlert = CustomListAlertDialogue(
        title: 'Hyperspace Accounts',
        subtitle: 'Select an account below to continue',
        // action: () {},
        // actionTitle: 'None',
        files: files,
      );
      showDialog(context: context, builder: (context) => listAlert);
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget privateKeyPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textFieldPrivateKey(),
          SizedBox(
            height: 30,
          ),
          button(context, action: () {
            if (privateKeyController.text != '') {
              pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            }
          })
        ],
      ),
    );
  }

  Widget namePage(BuildContext context, databaseProvider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          textFieldName(),
          button(context, action: () async {
            if (nameController.text != '') {
              var credentials = await ethClient
                  .credentialsFromPrivateKey(privateKeyController.text);
              final publicKey =
                  bytesToHex(credentials.encodedPublicKey, include0x: true);
              final accountAddress = credentials.address.hex;
              Map<String, dynamic> row = {
                'name': nameController.text,
                'private_key': privateKeyController.text,
                'public_key': publicKey,
                'address': accountAddress,
                'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
              };
              databaseProvider.addAccountTableRow(row);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
            } else {}
          })
        ],
      ),
    );
  }

  Expanded logoArea() {
    return Expanded(
        child: Container(
      color: Color(0xFF4859A0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage('images/cube.png'),
            color: Colors.white,
            size: 70,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'HYPER',
                style: TextStyle(color: Colors.black, fontSize: 22.5),
              ),
              Text(
                'SPACE',
                style: TextStyle(color: Colors.white, fontSize: 22.5),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Container button(BuildContext context, {action}) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFF4859A0),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
        onPressed: action,
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  TextField textFieldPrivateKey() {
    return TextField(
      controller: privateKeyController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: 'Enter private key',
        suffixIcon: GestureDetector(
          onTap: () {
            var rng = Random.secure();
            EthPrivateKey randomKey;
            String privateKey;
            while (true) {
              randomKey = EthPrivateKey.createRandom(rng);
              privateKey = bytesToHex(randomKey.privateKey);
              if (privateKey.length == 64) {
                break;
              }
            }
            print(privateKey);
            print(privateKey.length);
            setState(() {
              privateKeyController.text = privateKey;
            });
          },
          child: Text(
            'Generate',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }

  TextField textFieldName() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: 'Enter your name',
      ),
    );
  }
}
