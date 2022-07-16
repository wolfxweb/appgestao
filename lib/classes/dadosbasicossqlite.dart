
class dadosbasicossqlite {
  int? id;
  String? qtd;
  String? faturamento;
  String? gastos;
  String? custo_fixo;
  String? custo_varivel;
  String? margen;
  String? mes;
  String? gastos_insumos;

  dadosbasicossqlite(this.id,this.qtd,this.faturamento,this.gastos,this.custo_fixo,this.custo_varivel,this.margen,this.mes,this.gastos_insumos);

  dadosbasicossqlite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qtd = json['qtd'];
    faturamento = json['faturamento'];
    gastos = json['gastos'];
    custo_fixo = json['custo_fixo'];
    custo_varivel = json['custo_varivel'];
    margen = json['margen'];
    mes = json['mes'];
    gastos_insumos = json['gastos_insumos'];
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
    data['mes'] = this.mes;
    data['gastos_insumos'] = this.gastos_insumos;
    return data;
  }
}
