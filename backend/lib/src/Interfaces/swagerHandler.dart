import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> SwaggerHandler(Request req) {
  final path = '../specs/swagger.yaml';
  final handler = SwaggerUI(
    path,
    title: 'Projeto UGE',
    deepLink: true,
  );
  return handler(req);
}
