
class dadosbasicossqlite {
  int? id;
  String? qtd;
  String? faturamento;
  String? gastos ='0.0';
  String? custo_fixo;
  String? custo_varivel;
  String? margen;
  String? mes;
  String? gastos_insumos;
  String? capacidade_atendimento;

  dadosbasicossqlite(this.id,this.qtd,this.faturamento,this.gastos,this.custo_fixo,this.custo_varivel,this.margen,this.mes,this.gastos_insumos, this.capacidade_atendimento);

  dadosbasicossqlite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qtd = json['qtd'];
    faturamento = json['faturamento'];
    gastos = '0.0';
    custo_fixo = json['custo_fixo'];
    custo_varivel = json['custo_varivel'];
    margen = json['margen'];
    mes = json['mes'];
    gastos_insumos = json['gastos_insumos'];
    capacidade_atendimento = json['capacidade_atendimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qtd'] = this.qtd;
    data['faturamento'] = this.faturamento;
    data['gastos'] = "0.0";
    data['custo_fixo'] = this.custo_fixo;
    data['custo_varivel'] = this.custo_varivel;
    data['margen'] = this.margen;
    data['mes'] = this.mes;
    data['gastos_insumos'] = this.gastos_insumos;
    data['capacidade_atendimento'] = this.capacidade_atendimento;
    return data;
  }
}
