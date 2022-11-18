import 'dart:convert';

import 'package:backend/src/Interfaces/Auth/authResources.dart';
import 'package:backend/src/Interfaces/Usuarios/repository/usuariosRepo.dart';
import 'package:backend/src/Interfaces/Usuarios/viewModels/modelUsuario.dart';
import 'package:backend/src/Services/BCrypt/configBCrypt.dart';
import 'package:backend/src/Services/Database/sqlite.dart';
import 'package:backend/src/Services/Totp/configTotp.dart';
import 'package:backend/src/Services/request_extractor/configExtractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

final _repository = IUsuariosRepo();
final _extractor = RequestExtractor();
final _BCrypt = ConfigBCrypt();

class IUsuarioController extends Resource {
  @override
  List<Route> get routes => [
        // Create new user.
        Route.post('/usuarios', _criarUsuarios),
        Route.delete('/usuarios/:id', _deleteUsuarios,
            middlewares: [AuthGuard()]),
        Route.put('/usuarios/:id', _putUsuarios, middlewares: [AuthGuard()]),
      ];

  Future<Response> _criarUsuarios(ModularArguments req) async {
    final email = req.data['email'];
    final senha = req.data['senha'].toString();
    final bool emailIsValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailIsValid && senha.length >= 8) {
      ModelUsuarios usuarios = ModelUsuarios(
          nome: req.data['nome'],
          email: email,
          senha: _BCrypt.generateBCrypt(password: senha),
          isAdmin: req.data['isAdmin']);
      final result = _repository.criarUsuario(usuarios);
      if (result != 0) {
        final totp =
            ConfigTotp().generateOotp(id: result.toString(), email: email);
        final query = ConfigDB()
            .Sqlite()
            .prepare('INSERT INTO totp (qrCode, id_usuario) VALUES(?,?);');
        query.execute([totp, result]);
        query.dispose();
        final map = {
          'Sucesso': ['Usuario criado com sucesso! id: $result'],
          "Totp": [totp],
        };
        return Response(201, body: jsonEncode(map));
      }
    }
    final map = {
      'Error': ['email não é valido ou senha é muito curta']
    };
    return Response(500, body: jsonEncode(map));
  }

  Future<Response> _putUsuarios(ModularArguments req, Request request) async {
    final token = _extractor.getAuthorizationBearer(request);
    ModelUsuarios usuarios = ModelUsuarios(
        id: int.parse(req.params['id']),
        nome: req.data['nome'],
        email: req.data['email']);
    final result = _repository.putUsuario(usuarios, token);
    if (result != 0) {
      final map = {'Sucesso': 'Dados atualizados com sucesso!'};
      return Response(200, body: jsonEncode(map));
    }
    final map = {'Error': 'Voçê não tem permissão para essa operação!'};
    return Response(500, body: jsonEncode(map));
  }

  Future<Response> _deleteUsuarios(
      ModularArguments req, Request request) async {
    final id = int.parse(req.params['id']);
    final token = _extractor.getAuthorizationBearer(request);
    final result = _repository.deleteUsuario(id, token);
    if (result != 0) {
      final map = {'Sucesso': 'Sua conta foi excluida com sucesso!'};
      return Response(200, body: jsonEncode(map));
    }
    final map = {'Error': 'Voçê não tem permissão para essa operação!'};
    return Response(401, body: jsonEncode(map));
  }
}
