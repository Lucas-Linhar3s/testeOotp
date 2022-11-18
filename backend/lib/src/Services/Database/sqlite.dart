import 'package:sqlite3/sqlite3.dart';

class ConfigDB {
  Database Sqlite() {
    final db = sqlite3.open("../lib/src/Services/Database/table_sqlite.db");
    print("Sqlite iniciado com sucesso!");
    return db;
  }
}
