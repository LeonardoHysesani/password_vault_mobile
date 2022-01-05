import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'items.dart';

late Database database;

Future<void> initDb() async {
  database = await openDatabase(
    path.join(await getDatabasesPath(), 'alias_info.db'),
  );
}

void createByteTable(String table) async {
  await database.execute('CREATE TABLE IF NOT EXISTS $table (bytes INTEGER)');
}

void createItemsTable() async {
  await database.execute('CREATE TABLE IF NOT EXISTS items(id INTEGER PRIMARY KEY, base64iv TEXT, type TEXT, username TEXT, password TEXT, notes TEXT)');
}

void dropTable(String table) async {
  await database.transaction((txn) async {
    txn.execute('DROP TABLE $table');
  });
}

void insertIntoByteTable(List<int> bytes, String table) async {
  for (var byte in bytes) {
    await database.transaction(
            (txn) async {
          await txn.rawInsert('INSERT INTO $table(bytes) VALUES($byte)');
        }
    );
  }
}

void insertIntoItemsTable(Item newItem) async {
  await database.transaction(
          (txn) async {
        await txn.insert('items', newItem.toMap());
      }
  );
}

Future<List<Map>> getRowsFromTable(String table) async {
  return await database.rawQuery('SELECT * FROM $table');
}

void deleteIdInItemsTable(int id) async {
  await database.transaction(
          (txn) async {
        await txn.delete('items', where: 'id = ?', whereArgs: [id]);
      }
  );
}

void deleteAndInsert(Item item) {
  deleteIdInItemsTable(item.id);
  insertIntoItemsTable(item);
}
