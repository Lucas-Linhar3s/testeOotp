import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'Routes/routes.dart';

class ConfigRouter {
  Handler _moduleHander() {
    return Modular(
      module: ModuleRoutes(),
      middlewares: [
        corsHeaders(),
        logRequests(),
        jsonResponse(),
      ],
    );
  }

  Middleware jsonResponse() {
    return (handler) {
      return (request) async {
        var response = await handler(request);

        response = response.change(headers: {
          'content-type': 'application/json',
          ...response.headers,
        });

        return response;
      };
    };
  }

  Future<HttpServer> Connection(
      {required String address, required int port}) async {
    return await io.serve(_moduleHander(), address, port);
  }
}
