class LoginModel {
  String email;
  String senha;
  String token;

  LoginModel(this.email, this.senha, this.token);

  factory LoginModel.fromRequest({required Map data}) {
    return LoginModel(data["email"], data["senha"], data['token']);
  }
}
