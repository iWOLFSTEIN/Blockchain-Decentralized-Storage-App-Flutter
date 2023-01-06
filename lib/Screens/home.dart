import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:blockchain_decentralized_storage_system/Utils/dimensions.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import '../widgets/app_branding.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                  for (var i = 0; i < 10; i++)
                    Padding(
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
                                opacity: 0.3,
                                child: Image.asset(
                                  'images/file.png',
                                  height: 22.5,
                                  width: 22.5,
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
                                          'Wedding Collection',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xFF494949),
                                              fontSize: 17),
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
                                          '20 GB',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              color: Color(0xFF6A6A6A)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '25 Apr, 2022',
                                        style: TextStyle(
                                            fontSize: 12.5,
                                            color: Color(0xFF6A6A6A)),
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
                    )
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
    // FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   String fileP = result.files.single.path as String;
    //   File file = File(fileP);

    //   PlatformFile fileM = result.files.first;

    //   var chunks = await fileMerkleTree(file);
    // } else {}

    List<Uint8List> merkleTree = await fileMerkleTree();
    print("merkle root is ${HEX.encode(merkleTree[merkleTree.length - 1])}");
  }

  // fileMerkleTree(file) async {
  //   List<Uint8List> encryptedChunks = await chunksSha3Encoding(file);
  //   List<Uint8List> tree = merkle(encryptedChunks, chunkSha3Encoding);
  //   print(tree[0].length);
  //   print('[\n\t"${tree.map((x) => HEX.encode(x)).join('",\n\t"')}"\n]');
  // }

  // Uint8List chunkSha3Encoding(Uint8List chunk) {
  //   var k = SHA3(256, KECCAK_PADDING, 256);
  //   k.update(chunk);
  //   var hash = k.digest();
  //   return Uint8List.fromList(hash);
  // }

  // Future<List<Uint8List>> chunksSha3Encoding(file) async {
  //   List<Uint8List> chunks = await fileBytesChunking(file);

  //   chunks = chunks.map((chunk) {
  //     return chunkSha3Encoding(chunk);
  //   }).toList();

  //   return chunks;
  // }

  // Future<List<Uint8List>> fileBytesChunking(file) async {
  //   Uint8List fileBytes = await file.readAsBytes();
  //   List<Uint8List> chunks = [];
  //   int chunkSize = 1024;
  //   for (var i = 0; i < fileBytes.length; i += chunkSize) {
  //     chunks.add(fileBytes.sublist(i,
  //         i + chunkSize > fileBytes.length ? fileBytes.length : i + chunkSize));
  //   }
  //   return chunks;
  // }

  Future<List<Uint8List>> fileMerkleTree() async {
    List<Uint8List> encryptedChunks = await chunksSha3Encoding();
    List<Uint8List> tree = merkle(encryptedChunks, chunkSha3Encoding);
    return tree;
  }

  Uint8List chunkSha3Encoding(Uint8List chunk) {
    var k = SHA3(256, KECCAK_PADDING, 256);
    k.update(chunk);
    var hash = k.digest();
    return Uint8List.fromList(hash);
  }

  Future<List<Uint8List>> chunksSha3Encoding() async {
    List<Uint8List> chunks = await fileBytesChunking();

    chunks = chunks.map((chunk) {
      return chunkSha3Encoding(chunk);
    }).toList();

    return chunks;
  }

  Future<List<Uint8List>> fileBytesChunking() async {
    Uint8List stringBytes = Uint8List.fromList(utf8.encode(
        'This is a dummy text. I am just using it for the testing puposes.'));
    List<Uint8List> chunks = [];
    int chunkSize = 8;
    for (var i = 0; i < stringBytes.length; i += chunkSize) {
      chunks.add(stringBytes.sublist(
          i,
          i + chunkSize > stringBytes.length
              ? stringBytes.length
              : i + chunkSize));
    }
    return chunks;
  }
}
