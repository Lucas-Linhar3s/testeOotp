import 'package:backend/src/Interfaces/Auth/viewModels/modelLogin.dart';
import 'package:backend/src/Services/Database/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

Database _db = ConfigDB().Sqlite();

class AuthRepo {
  ResultSet login(LoginModel login) {
    ResultSet query = _db.select(
        'SELECT id, nome, senha FROM usuario WHERE email=?;', [login.email]);
    return query;
  }
}
