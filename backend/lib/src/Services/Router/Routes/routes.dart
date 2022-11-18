import 'package:backend/src/Interfaces/Auth/controller/authController.dart';
import 'package:backend/src/Interfaces/Produtos/controller/produtoController.dart';
import 'package:backend/src/Interfaces/Usuarios/controller/usuariosController.dart';
import 'package:backend/src/Interfaces/swagerHandler.dart';
import 'package:shelf_modular/shelf_modular.dart';

class ModuleRoutes extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.resource(IProdutoController()),
        Route.resource(IUsuarioController()),
        Route.resource(AuthController()),
        Route.get('/documentation/**', SwaggerHandler),
      ];
}
