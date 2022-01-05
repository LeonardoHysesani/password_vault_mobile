import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:password_vault_mobile/functions/database_management.dart';

import '../main.dart';

Future<List<Item>> getAllItems() async {
  List<Map<dynamic, dynamic>> tempMap = await getRowsFromTable('items');
  List<Item> items = [];
  for (var item in tempMap) {
    items.add(
        Item(
          id: item.values.elementAt(0),
          base64iv: item.values.elementAt(1),
          type: item.values.elementAt(2),
          username: item.values.elementAt(3),
          password: item.values.elementAt(4),
          notes: item.values.elementAt(5),
        ).decrypted()
    );
  }
  return items;
}

String getRandomBase64IVSource() {
  String str = '';
  for (int i = 0; i < 4; i++) {
    str += String.fromCharCode(Random.secure().nextInt(128));
  }
  final bytes = utf8.encode(str);
  final base64Str = base64.encode(bytes);
  return base64Str;
}

String getKeySource() {
  String keysource = "";

  for (int i = 0; i < 32; i++) {
    keysource += plainPassword[i % plainPassword.length];
  }

  return keysource;
}

String encryptString(String plaintext, String base64iv) {
  if (plaintext != '') {
    final key = Key.fromUtf8(getKeySource());
    final iv = IV.fromBase64(base64iv);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return encrypted.base64;
  }
  else {
    return '';
  }
}

String decryptString(String base64str, String base64iv) {
  if (base64str != '') {
    final key = Key.fromUtf8(getKeySource());
    final iv = IV.fromBase64(base64iv);
    final decrypter = Encrypter(AES(key));

    final decrypted = decrypter.decrypt64(base64str, iv: iv);
    return decrypted;
  }
  else {
    return '';
  }
}


class Item {
  final int id;
  final String type;
  final String username;
  final String password;
  final String base64iv;
  final String notes;

  Item({
    required this.id,
    required this.type,
    required this.username,
    required this.password,
    required this.base64iv,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'base64iv': base64iv,
      'type': type,
      'username': username,
      'password': password,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'Item{username: $username, password: $password, notes: $notes}';
  }

  void add() {
    // create table if it doesn't exist already
    createItemsTable();
    // insert current item after encrypting it
    insertIntoItemsTable(encrypt());
  }

  void delete() {
    deleteIdInItemsTable(id);
  }

  void replaceWith(Item updatedItem) {
    deleteAndInsert(updatedItem.encrypt());
  }

  Item encrypt() {
    Item encryptedItem = Item(
      id: id,
      base64iv: base64iv,
      type: encryptString(type, base64iv),
      username: encryptString(username, base64iv),
      password: encryptString(password, base64iv),
      notes: encryptString(notes, base64iv),
    );
    return encryptedItem;
  }

  Item decrypted() {
    Item decryptedItem = Item(
      id: id,
      base64iv: base64iv,
      type: decryptString(type, base64iv),
      username: decryptString(username, base64iv),
      password: decryptString(password, base64iv),
      notes: decryptString(notes, base64iv),
    );
    return decryptedItem;
  }
}