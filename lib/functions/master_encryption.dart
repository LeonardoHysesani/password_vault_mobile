import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

import 'database_management.dart';

List<int> getBytesFromMap(List<Map<dynamic, dynamic>> temp) {
  List<int> bytes = [];
  for (var element in temp) {
    bytes.add(element.values.first as int);
  }
  return bytes;
}


Future<List<int>> generateHashBytesOf(String plaintext, List<int> nonce) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 128,
  );

  // Password we want to hash
  final secretKey = SecretKey(utf8.encode(plaintext));

  // Calculate a hash that can be stored in the database
  final newSecretKey = await pbkdf2.deriveKey(
    secretKey: secretKey,
    nonce: nonce,
  );
  final newSecretKeyBytes = await newSecretKey.extractBytes();
  if (kDebugMode) {
    print("Hash bytes for plaintext '" + plaintext + "':" + newSecretKeyBytes.toString());
    print("Salt bytes:" + nonce.toString());
  }

  return newSecretKeyBytes;
}

List<int> generateRandomSalt() {
  // Generates 128 bit salt
  List<int> saltBytes = [];
  for (int i = 0; i < 16; i++) {
    saltBytes.add(Random.secure().nextInt(256));
  }
  return saltBytes;
}



Future<bool> authenticate(String password) async {
  bool hashesMatch = true;

  List<int> salt = getBytesFromMap(await getRowsFromTable('salt'));
  List<int> bytes1 = getBytesFromMap(await getRowsFromTable('hash'));
  List<int> bytes2 = await generateHashBytesOf(password, salt);

  int i = 0;
  while (i < bytes1.length && hashesMatch) {
    if (bytes1[i] != bytes2[i]) {
      hashesMatch = false;
    }
    i++;
  }
  return hashesMatch;
}