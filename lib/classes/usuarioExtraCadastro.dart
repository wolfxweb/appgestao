class usuarioExtraCadastro {
  String? nome;
  String? telefone;
  bool? status;

  usuarioExtraCadastro({this.nome, this.telefone, this.status});

  usuarioExtraCadastro.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    telefone = json['telefone'];
    status = json['status'];
  }

  Map<String, dynamic> toJson(String string) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['status'] = this.status;
    return data;
  }
}