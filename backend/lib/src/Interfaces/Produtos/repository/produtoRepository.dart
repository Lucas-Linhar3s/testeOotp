import 'package:backend/src/Interfaces/Produtos/viewModels/modelProdutos.dart';
import 'package:backend/src/Interfaces/Produtos/viewModels/queryParams.dart';
import 'package:backend/src/Services/Database/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class IProdutosRepo {
  final _db = ConfigDB().Sqlite();

  int criarProdutos(ModelProdutos produtos) {
    PreparedStatement query = _db.prepare(
        'INSERT INTO produtos(nome,dt_ult_compra,ult_preco) VALUES(?,?,?);');

    query.execute([produtos.nome, produtos.dt_ult_compra, produtos.ult_preco]);
    final lastID = _db.lastInsertRowId;
    query.dispose();
    return lastID;
  }

  // ResultSet getOneProduct(int id) {
  //   final query =
  //       _db.select('SELECT id, nome, senha FROM usuario  WHERE id=?', [id]);
  //   return query;
  // }

  ResultSet buscarProdutos(Params params) {
    ResultSet query = _db.select(
        'SELECT * FROM produtos ORDER BY id LIMIT ? OFFSET ?;',
        [params.limite, params.offset]);
    return query;
  }

  int atualizarProduto(ModelProdutos produtos) {
    PreparedStatement query = _db.prepare(
        'UPDATE produtos SET nome=?, dt_ult_compra=?, ult_preco=? WHERE id=?');
    query.execute([
      produtos.nome,
      produtos.dt_ult_compra,
      produtos.ult_preco,
      produtos.id,
    ]);
    final result = _db.getUpdatedRows();
    query.dispose();
    return result;
  }

  int deleteProduto(int id) {
    PreparedStatement delete = _db.prepare('DELETE FROM produtos WHERE id=?');
    delete.execute([id]);
    final query = _db.getUpdatedRows();
    return query;
  }
}
