import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:password_vault_mobile/functions/database_management.dart';

void addNewItem(Item newItem) {
  // create table if it doesn't exist already
  createItemsTable('items');
  // insert new item
  insertIntoItemsTable(newItem, 'items');
}

Future<Item> getRecentItem() async {
  List<Map<dynamic, dynamic>> temp = await getRowsFromTable('items');
  String username = temp.elementAt(temp.length-1).values.elementAt(0);
  String password = temp.elementAt(temp.length-1).values.elementAt(1);
  return Item(username: username, password: password);
}

Future<List<Item>> getAllItems() async {
  List<Map<dynamic, dynamic>> tempMap = await getRowsFromTable('items');
  List<Item> items = [];
  for (var item in tempMap) {
    items.add(Item(username: item.values.elementAt(0), password: item.values.elementAt(1)));
  }
  return items;
}


class Item {
  final String username;
  final String password;

  Item({
    required this.username,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'Item{username: $username, password: $password}';
  }
}