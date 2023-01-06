import 'dart:typed_data';
import 'package:dart_merkle_lib/dart_merkle_lib.dart';
import 'package:sha3/sha3.dart';

Future<List<Uint8List>> fileMerkleTree(file) async {
  List<Uint8List> encryptedChunks = await chunksSha3Encoding(file);
  List<Uint8List> tree = merkle(encryptedChunks, chunkSha3Encoding);
  return tree;
}

Uint8List chunkSha3Encoding(Uint8List chunk) {
  var k = SHA3(256, KECCAK_PADDING, 256);
  k.update(chunk);
  var hash = k.digest();
  return Uint8List.fromList(hash);
}

Future<List<Uint8List>> chunksSha3Encoding(file) async {
  List<Uint8List> chunks = await fileBytesChunking(file);

  chunks = chunks.map((chunk) {
    return chunkSha3Encoding(chunk);
  }).toList();

  return chunks;
}

Future<List<Uint8List>> fileBytesChunking(file) async {
  Uint8List fileBytes = await file.readAsBytes();
  List<Uint8List> chunks = [];
  int chunkSize = 1024;
  for (var i = 0; i < fileBytes.length; i += chunkSize) {
    chunks.add(fileBytes.sublist(i,
        i + chunkSize > fileBytes.length ? fileBytes.length : i + chunkSize));
  }
  return chunks;
}
