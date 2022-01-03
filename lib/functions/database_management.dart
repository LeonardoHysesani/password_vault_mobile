import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

late Database database;

Future<void> initDb() async {
  database = await openDatabase(
    path.join(await getDatabasesPath(), 'alias_info.db'),
  );
}

void createByteTable(String table) async {
  await database.execute('CREATE TABLE $table (bytes INTEGER)');
}

void dropTable(String table) async {
  await database.transaction((txn) async {
    txn.execute('DROP TABLE $table');
  });
}

Future<void> insertIntoByteTable(List<int> bytes, String table) async {
  for (var byte in bytes) {
    await database.transaction(
            (txn) async {
          await txn.rawInsert('INSERT INTO $table(bytes) VALUES($byte)');
        }
    );
  }
}

Future<List<Map>> getRowsFromTable(String table) async {
  return await database.rawQuery('SELECT * FROM $table');
}
