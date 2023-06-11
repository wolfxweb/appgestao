
class estados {
  int? id;
  String? nome;
  String? sigla;
  @override
  String toString() {
    return 'estados{id: $id, nome: $nome, sigla: $sigla}';
  }



  estados({this.id, this.nome, this.sigla});

  estados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    sigla = json['sigla'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['sigla'] = this.sigla;
    return data;
  }
}