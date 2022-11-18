class LoginModel {
  String email;
  String senha;
  String confSenha;
  String token;
  String nome;

  LoginModel(this.email, this.senha, this.token, this.nome, this.confSenha);

  factory LoginModel.fromRequest({required Map data}) {
    return LoginModel(
        data["email"], data["senha"], data['token'], data["nome"], data["confSenha"]);
  }
}
