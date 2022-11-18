import 'package:bcrypt/bcrypt.dart';

class ConfigBCrypt {
  String generateBCrypt({required String password}) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  bool verifyBCrypt({required String password, required String hashed}) {
    return BCrypt.checkpw(password, hashed);
  }
}
