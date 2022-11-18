import 'dart:convert';
import 'package:backend/src/Services/Jwt/configJWT.dart';
import 'package:backend/src/Services/request_extractor/configExtractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  AuthGuard({this.roles = const [], this.isRefreshToken = false});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extrator = RequestExtractor();
    final jwt = configJwt();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(jsonEncode({
          'error': ['not authorization header']
        }));
      }

      final token = extrator.getAuthorizationBearer(request);
      try {
        jwt.verifyToken(
            token: token,
            audiance: isRefreshToken ? 'refreshToken' : 'accessToken');
        final payload = jwt.getPayload(token);
        final role = payload['id'] ?? 0;
        print(role);
        if (roles.isEmpty || roles.contains(role)) {
          return handler(request);
        }
        
          return Response.forbidden(jsonEncode({
            'Error': ['você não tem autorização para essa operação']
          }));
      } catch (e) {
        return Response.forbidden(jsonEncode({
          'error': [e.toString()]
        }));
      }
    };
  }
}
