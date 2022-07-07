
class dadosbasicossqlite {
  int? id;
  String? qtd;
  String? faturamento;
  String? gastos;
  String? custo_fixo;
  String? custo_varivel;
  String? margen;

  dadosbasicossqlite(this.id,this.qtd,this.faturamento,this.gastos,this.custo_fixo,this.custo_varivel,this.margen);

  dadosbasicossqlite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qtd = json['qtd'];
    faturamento = json['faturamento'];
    gastos = json['gastos'];
    custo_fixo = json['custo_fixo'];
    custo_varivel = json['custo_varivel'];
    margen = json['margen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qtd'] = this.qtd;
    data['faturamento'] = this.faturamento;
    data['gastos'] = this.gastos;
    data['custo_fixo'] = this.custo_fixo;
    data['custo_varivel'] = this.custo_varivel;
    data['margen'] = this.margen;
    return data;
  }
}
