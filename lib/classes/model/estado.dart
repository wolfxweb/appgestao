




class estado {
  int? id;
  String? sigla;

  String? nome;

  estado({this.id, this.sigla, this.nome});

  estado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sigla = json['sigla'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sigla'] = this.sigla;
    data['nome'] = this.nome;
    return data;
  }

  @override
  String toString() {
    return 'estado{id: $id, sigla: $sigla, nome: $nome}';
  }



}