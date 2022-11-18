import 'package:backend/src/Services/Jwt/configJWT.dart';
import 'package:test/test.dart';

void main() {
  test('generateToken...', () async {
    final exp = DateTime.now().add(Duration(seconds: 60));
    final iijkn = Duration(milliseconds: exp.millisecondsSinceEpoch).inSeconds;
    final Map claims = {"id": 1, "nome": "Lucas", "exp": iijkn};
    final token = configJwt().generateToken(claims, "accessToken");
    print(token);
  });

  test("verifyToken", () async {
    configJwt().verifyToken(
        token:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibm9tZSI6Ikx1Y2FzIiwiaWF0IjoxNjY4MTA5ODE1LCJhdWQiOiJhY2Nlc3NUb2tlbiJ9.mHRBdNzr_6PIil7r1oyEORoAgiQw9HItXGjPu1C-1c8",
        audiance: "accessToken");
  });
}
