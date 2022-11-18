import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class configJwt {
  final String key =
      "qMIV#zaWwX}on(v374hvmXXim2K/;o2lz5-_vuF_3fzV;I?D:s>{NM>zh%rh2yB";

  String generateToken(Map claims, String audiance) {
    final jwt = JWT(claims, audience: Audience.one(audiance));
    return jwt.sign(SecretKey(key));
  }

  verifyToken({required String token, required String audiance}) {
    JWT.verify(token, SecretKey(key), audience: Audience.one(audiance));
  }


Map<String, dynamic> acessTokenClaims(Map<String, dynamic> json) {
  final dateIn = DateTime.now().add(Duration(milliseconds: 60000));
  final exp = Duration(milliseconds: dateIn.millisecondsSinceEpoch).inSeconds;
  final claims = {"id": json['id'], "nome": json["nome"], "exp": exp};
  return claims;
}

Map<String, dynamic> refreshTokenClaims(Map<String, dynamic> json) {
  final dateIn = DateTime.now().add(Duration(days: 3));
  final exp = Duration(milliseconds: dateIn.millisecondsSinceEpoch).inSeconds;
  final claims = {"id": json['id'], "nome": json["nome"], "exp": exp};
  return claims;
}

  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(key),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }
}
