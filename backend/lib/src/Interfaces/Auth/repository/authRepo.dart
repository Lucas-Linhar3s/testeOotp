import 'package:backend/src/Interfaces/Auth/viewModels/modelLogin.dart';
import 'package:backend/src/Services/BCrypt/configBCrypt.dart';
import 'package:backend/src/Services/Database/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

Database _db = ConfigDB().Sqlite();

class AuthRepo {
  ResultSet login(LoginModel login) {
    ResultSet query = _db.select(
        'SELECT id, nome, senha FROM usuario WHERE email=?;', [login.email]);
    return query;
  }

  ResultSet userExiste(LoginModel login) {
    ResultSet query = _db.select(
        'SELECT id, nome, email FROM usuario WHERE email=:email;',
        [login.email]);
    return query;
  }

  int alterarSenha(LoginModel login) {
    PreparedStatement queryAl =
        _db.prepare('UPDATE usuario SET senha=:senha WHERE email=:email');
    queryAl.execute([ConfigBCrypt().generateBCrypt(password: login.senha), login.email]);
    final rowAffected = _db.getUpdatedRows();
    queryAl.dispose();
    return rowAffected;
  }
}
