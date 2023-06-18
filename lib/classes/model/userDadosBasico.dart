class userDadosBasico {
  String? cidade;
  String? estado;

  @override
  String toString() {
    return 'userDadosBasico{cidade: $cidade, estado: $estado, setorAtuacao: $setorAtuacao, email: $email, telefone: $telefone, admin: $admin, status: $status}';
  }

  String? setorAtuacao;
  String? email;
  String? telefone;
  bool? admin;
  bool? status;

  userDadosBasico(
      {this.cidade,
        this.estado,
        this.setorAtuacao,
        this.email,
        this.telefone,
        this.admin,
        this.status});

  userDadosBasico.fromJson(Map<String, dynamic> json) {
    cidade = json['cidade'];
    estado = json['estado'];
    setorAtuacao = json['setor_atuacao'];
    email = json['email'];
    telefone = json['telefone'];
    admin = json['admin'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    data['setor_atuacao'] = this.setorAtuacao;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    data['admin'] = this.admin;
    data['status'] = this.status;
    return data;
  }
}