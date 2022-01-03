import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'items_management.dart';

late Database database;

Future<void> initDb() async {
  database = await openDatabase(
    path.join(await getDatabasesPath(), 'alias_info.db'),
  );
}

void createByteTable(String table) async {
  await database.execute('CREATE TABLE $table (bytes INTEGER)');
}

void createItemsTable(String table) async {
  await database.execute('CREATE TABLE IF NOT EXISTS $table(username TEXT, password TEXT)');
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

void insertIntoItemsTable(Item newItem, String table) async {
  String username = newItem.username;
  String password = newItem.password;
  await database.transaction(
          (txn) async {
        await txn.insert(table, newItem.toMap());
      }
  );
}



Future<List<Map>> getRowsFromTable(String table) async {
  return await database.rawQuery('SELECT * FROM $table');
}
