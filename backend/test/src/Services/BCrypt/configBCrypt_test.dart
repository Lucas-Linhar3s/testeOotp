import 'package:backend/src/Services/BCrypt/configBCrypt.dart';
import 'package:test/test.dart';

void main() {
  test('generateBCrypt ...', () async {
    final senha = ConfigBCrypt().generateBCrypt(password: "password");
    print(senha);
  });

  test('verifySenha', () async {
    final b = ConfigBCrypt().verifyBCrypt(
        password: "password",
        hashed:
            r"$2a$10$5mf93N75/DXlyGzzD/t2JuAu5m0x9r8P1h6rAvdG7mRER2rCA2Ba6");
    expect(b, true);
  });
}
