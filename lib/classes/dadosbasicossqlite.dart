

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
  String? data_cadastro;
  String? tipo_empresa;
  String? horas_trabalho;
  String? pro_labore;
  String? demais_custos;




  dadosbasicossqlite(this.id,this.qtd,this.faturamento,this.gastos,this.custo_fixo,this.custo_varivel,this.margen,this.mes,this.gastos_insumos, this.capacidade_atendimento
                  , this.data_cadastro,this.tipo_empresa,this.horas_trabalho,this.pro_labore, this.demais_custos);

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
    data_cadastro = json['data_cadastro'];
    tipo_empresa = json['tipo_empresa'];
    horas_trabalho =json['horas_trabalho'];
    pro_labore =json['pro_labore'];
    demais_custos = json['demais_custos'];
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
    data['data_cadastro']= this.data_cadastro;
    data['tipo_empresa']= this.tipo_empresa;
    data['horas_trabalho']= this.horas_trabalho;
    data['pro_labore']= this.pro_labore;
    data['demais_custos']= this.demais_custos;
    return data;
  }
}
