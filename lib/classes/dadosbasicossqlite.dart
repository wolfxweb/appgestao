
class dadosbasicos {
  int? id;
  int? qtd;
  String? faturamento;
  String? gastos;
  String? custoFixo;
  String? custoVarivel;
  int? margen;

  dadosbasicos(
      {this.id,
        this.qtd,
        this.faturamento,
        this.gastos,
        this.custoFixo,
        this.custoVarivel,
        this.margen});

  dadosbasicos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qtd = json['qtd'];
    faturamento = json['faturamento'];
    gastos = json['gastos'];
    custoFixo = json['custo_fixo'];
    custoVarivel = json['custo_varivel'];
    margen = json['margen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qtd'] = this.qtd;
    data['faturamento'] = this.faturamento;
    data['gastos'] = this.gastos;
    data['custo_fixo'] = this.custoFixo;
    data['custo_varivel'] = this.custoVarivel;
    data['margen'] = this.margen;
    return data;
  }
}
