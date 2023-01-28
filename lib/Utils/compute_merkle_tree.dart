import 'dart:convert';
import 'dart:typed_data';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:encrypt/encrypt.dart';
import 'package:provider/provider.dart';
import 'package:sha3/sha3.dart';

import '../provider/database_provider.dart';

List<Uint8List> fileMerkleTree(Uint8List fileBytes) {
  List<Uint8List> encryptedChunks = chunksSha3Encoding(fileBytes);
  List<Uint8List> tree = merkle(encryptedChunks, chunkSha3Encoding);
  return tree;
}

Uint8List chunkSha3Encoding(Uint8List chunk) {
  var k = SHA3(256, KECCAK_PADDING, 256);
  k.update(chunk);
  var hash = k.digest();
  return Uint8List.fromList(hash);
}

List<Uint8List> chunksSha3Encoding(Uint8List fileBytes) {
  List<Uint8List> chunks = fileBytesChunking(fileBytes);

  chunks = chunks.map((chunk) {
    return chunkSha3Encoding(chunk);
  }).toList();

  return chunks;
}

List<Uint8List> fileBytesChunking(Uint8List fileBytes) {
  // Uint8List fileBytes = await file.readAsBytes();
  List<Uint8List> chunks = [];
  int chunkSize = 1024;
  for (var i = 0; i < fileBytes.length; i += chunkSize) {
    chunks.add(fileBytes.sublist(i,
        i + chunkSize > fileBytes.length ? fileBytes.length : i + chunkSize));
  }
  return chunks;
}
