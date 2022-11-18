import 'package:backend/src/Services/Totp/configTotp.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('configTotp ...', () async {
    final totp =
        ConfigTotp().generateOotp(id: "256", email: "linhares7748@gmail.com");
    print(totp);
  });

  test("verifyTotp", () async {
    final verify = ConfigTotp().verifyOotp(
        id: "256",
        email: "linhares7748@gmail.com",
        token: "771150");
    print(verify);
    expect(verify, true);
  });
}
