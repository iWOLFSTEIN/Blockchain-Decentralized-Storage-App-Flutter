import 'package:crypto/crypto.dart';

String calculateFileSha256Hash(List<int> fileBytes) {
  Digest digest = sha256.convert(fileBytes);
  return digest.toString();
}
