import 'package:backend/src/Interfaces/Usuarios/viewModels/modelUsuario.dart';
import 'package:backend/src/Services/Database/sqlite.dart';
import 'package:backend/src/Services/Jwt/configJWT.dart';
import 'package:sqlite3/sqlite3.dart';

final _db = ConfigDB().Sqlite();
final _jwt = configJwt();

class IUsuariosRepo {
  int criarUsuario(ModelUsuarios usuarios) {
    PreparedStatement query = _db.prepare(
        'INSERT INTO usuario(nome,email,senha,isAdmin) VALUES(?,?,?,?);');
    query.execute(
        [usuarios.nome, usuarios.email, usuarios.senha, usuarios.isAdmin]);
    final lastId = _db.lastInsertRowId;
    query.dispose();
    return lastId;
  }

  int putUsuario(ModelUsuarios usuarios, String token) {
    final payload = _jwt.getPayload(token);
    final idClaim = payload['id'] ?? 0;
    if (idClaim == usuarios.id) {
      PreparedStatement query =
          _db.prepare('UPDATE usuario SET nome=?, email=? WHERE id=?');
      query.execute([
        usuarios.nome,
        usuarios.email,
        usuarios.id,
      ]);
      final result = _db.getUpdatedRows();
      query.dispose();
      return result;
    }
    return 0;
  }

//   int putSenhaUsuario(ModelUsuarios usuarios) {
//     final query = _db.prepare('UPDATE usuario SET senha=? WHERE id=?');
//     query.execute([usuarios.senha, usuarios.id]);
//     final result = _db.getUpdatedRows();
//     query.dispose();
//     return result;
//   }

  int deleteUsuario(int id, String token) {
    final payload = _jwt.getPayload(token);
    final role = payload['id'] ?? 0;
    if (role == id) {
      PreparedStatement delete = _db.prepare('DELETE FROM usuario WHERE id=?');
      delete.execute([id]);
      final query = _db.getUpdatedRows();
      return query;
    }
    return 0;
  }
}
