import 'dart:convert';
import 'dart:developer';

import 'package:backend/src/Interfaces/Auth/repository/authRepo.dart';
import 'package:backend/src/Interfaces/Auth/viewModels/modelLogin.dart';
import 'package:backend/src/Services/BCrypt/configBCrypt.dart';
import 'package:backend/src/Services/Jwt/configJWT.dart';
import 'package:backend/src/Services/Totp/configTotp.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:sqlite3/common.dart';

final _repository = AuthRepo();
ConfigBCrypt _bcrypt = ConfigBCrypt();

class AuthController extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/auth/login', login),
        Route.put('/auth/senha', alterarSenha),
      ];

  Response login(ModularArguments req) {
    LoginModel login = LoginModel.fromRequest(data: req.data);
    ResultSet result = _repository.login(login);
    if (!result.isEmpty) {
      final hashed = result.map((senha) => senha['senha']).first;
      final id = result.map((e) => e["id"]).first;
      final verify = ConfigTotp().verifyOotp(
          id: id.toString(), email: login.email, token: login.token);
      Map accessClaims =
          configJwt().acessTokenClaims(result.map((e) => e).first);
      Map refreshClaims =
          configJwt().refreshTokenClaims(result.map((e) => e).first);
      if (_bcrypt.verifyBCrypt(password: login.senha, hashed: hashed)) {
        if (verify) {
          final accessToken =
              configJwt().generateToken(accessClaims, "accessToken");
          final refreshToken =
              configJwt().generateToken(refreshClaims, "refreshToken");
          final map = {
            "accessToken": [accessToken],
            "refreshToken": [refreshToken],
          };
          return Response(200, body: jsonEncode(map));
        }
      }
    }
    final map = {
      "Error": ["email, senha ou token invalida!"]
    };
    return Response(401, body: jsonEncode(map));
  }

  Future<Response> alterarSenha(ModularArguments req) async {
    final login = LoginModel.fromRequest(data: req.data);
    final result = _repository.userExiste(login);
    final id = result.map((e) => e['id']).first;
    final email = result.map((e) => e['email']).first;
    final nome = result.map((e) => e["nome"]).first;
    if (!result.isEmpty && login.nome == nome) {
      if (login.senha.length >= 8 && login.senha == login.confSenha) {
        if (ConfigTotp()
            .verifyOotp(id: id.toString(), email: email, token: login.token)) {
          final alterarSenha = _repository.alterarSenha(login);
          if (alterarSenha != 0) {
            final map = {
              "Sucesso": ["Sua senha foi alterada com sucesso!"],
            };
            return Response(200, body: jsonEncode(map));
          }
        }
      }
    }
    final map = {
      "Error": ["não foi possivel confirmar que essa conta pertence a você!"],
    };
    return Response(401, body: jsonEncode(map));
  }
}
