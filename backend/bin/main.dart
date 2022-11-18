import 'package:backend/src/Services/Router/router.dart';

void main(List<String> args) {
  ConfigRouter().Connection(address: '0.0.0.0', port: 3333).then(
      (value) => print("Servidor conectado com sucesso! port: ${value.port}"));
}
