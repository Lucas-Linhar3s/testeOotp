import 'dart:convert';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:ootp/ootp.dart';

class ConfigTotp {
  String generateOotp({required String id, required String email}) {
    final Uint8List secretToken = Utf8Encoder().convert("Sist${id}${email}UGE");
    final String secretKey = base32.encode(secretToken);
    final totp = TOTP.secret(secretToken);

    final token =
        "otpauth://totp/BRISANET:${email}?secret=${secretKey}&issuer=SistUGE&period=${totp.period}&digits=${totp.digits}";
    final qrCode =
        "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=${token}";
    print(totp.make());
    return qrCode;
  }

  bool verifyOotp({required String id, required String email,  required String token}) {
    final Uint8List encoder = Utf8Encoder().convert("Sist${id}${email}UGE");
    final totp = TOTP.secret(encoder, digits: 6);
    final verify = totp.check(token);
    return verify;
  }
}
