import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend/src/Interfaces/Auth/authResources.dart';
import 'package:backend/src/Interfaces/Produtos/repository/produtoRepository.dart';
import 'package:backend/src/Interfaces/Produtos/viewModels/modelProdutos.dart';
import 'package:backend/src/Interfaces/Produtos/viewModels/queryParams.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

final _repository = IProdutosRepo();

class IProdutoController extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/produtos', _criarProduto, middlewares: [AuthGuard()]),
        Route.get('/produtos', _buscarProdutos, middlewares: [AuthGuard()]),
        Route.put('/produtos/:id', _atualizarProduto,
            middlewares: [AuthGuard()]),
        Route.delete('/produtos/:id', _deleteProduto,
            middlewares: [AuthGuard()]),
      ];

  Future<Response> _criarProduto(ModularArguments req) async {
    ModelProdutos produtos = ModelProdutos(
      nome: req.data['nome'],
      dt_ult_compra: req.data['dt_ult_compra'],
      ult_preco: req.data['ult_preco'],
    );
    int result = _repository.criarProdutos(produtos);
    if (result != 0) {
      final map = {
        'Sucesso': ['Produto criado com sucesso! id: $result']
      };
      return Response(201, body: jsonEncode(map));
    }
    final map = {
      'Error': ['erro ao criar produto!']
    };
    return Response(500, body: jsonEncode(map));
  }

  Future<Response> _buscarProdutos(ModularArguments req, Request r) async {
    Params params = Params(
      int.parse(req.queryParams['pageSize'].toString()),
      int.parse(req.queryParams['offset'].toString()),
    );
    final result = _repository.buscarProdutos(params);
    if (result.isEmpty == false) {
      final map = {'Produtos': result};
      return Response(200, body: jsonEncode(map));
    }
    final map = {
      'Error': ["error ao buscar produtos"]
    };
    return Response(404, body: jsonEncode(map));
  }

  // Future<Response> _getOneProduct(ModularArguments req) async {
  //   int id = int.parse(req.params['id']);
  //   final result = _repository.getOneProduct(id);
  //   final s = result.map((e) => e).first;
  //   print(s);
  //   if (result.isEmpty == false) {
  //     return Response(200, body: jsonEncode(result), headers: _jsonEncode);
  //   }
  //   final map = {'error': 'Erro ao buscar produtos com id: $id!'};
  //   return Response(404, body: jsonEncode(map), headers: _jsonEncode);
  // }

  Future<Response> _atualizarProduto(ModularArguments req) async {
    ModelProdutos produto = ModelProdutos(
      id: int.parse(req.params['id']),
      nome: req.data['nome'],
      dt_ult_compra: req.data['dt_ult_compra'],
      ult_preco: req.data['ult_preco'],
    );
    int result = _repository.atualizarProduto(produto);
    if (result != 0) {
      final map = {
        'Sucesso': ['Produto com id: ${produto.id} foi atualizado com sucesso!']
      };
      return Response(200, body: jsonEncode(map));
    }
    final map = {
      'Error': ['erro ao tentar atualizar produto com id: ${produto.id}!']
    };
    return Response(400, body: jsonEncode(map));
  }

  Future<Response> _deleteProduto(ModularArguments req) async {
    final id = int.parse(req.params['id']);
    final result = _repository.deleteProduto(id);
    if (result != 0) {
      final map = {
        'Sucesso': ['Produto com id: $id foi excluido com sucesso']
      };
      return Response(200, body: jsonEncode(map));
    }
    final map = {
      'Error': ['erro ao tentar excluir produto com id: $id!']
    };
    return Response(404, body: jsonEncode(map));
  }
}
