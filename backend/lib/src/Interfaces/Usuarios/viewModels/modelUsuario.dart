class ModelUsuarios {
  final int? id;
  final String nome;
  final String email;
  final String? senha;
  final String? isAdmin;

  ModelUsuarios({this.id, required this.nome, required this.email, this.senha, this.isAdmin});
}
