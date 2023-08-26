class atividadesEmpresa {
  String? especialidade;
  String? setorAtuacao;

  atividadesEmpresa({this.especialidade, this.setorAtuacao});

  atividadesEmpresa.fromJson(Map<String, dynamic> json) {
    especialidade = json['especialidade'];
    setorAtuacao = json['setorAtuacao'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['especialidade'] = this.especialidade;
    data['setorAtuacao'] = this.setorAtuacao;
    return data;
  }
}