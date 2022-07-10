class usuarioExtraCadastro {
  String? nome;
  String? telefone;
  String? email;
  bool? status;
  bool? admin;

  usuarioExtraCadastro({this.nome, this.telefone, this.status ,this.email, this.admin});

  usuarioExtraCadastro.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    telefone = json['telefone'];
    status = json['status'];
    email = json['email'];
    admin = json['admin'];
  }

  Map<String, dynamic> toJson(String string) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['status'] = this.status;
    data['email'] = this.email;
    data['admin'] = this.admin;
    return data;
  }
}