class calculadoraHistorico {
  int? id;
  String? produto;
  String? data;
  String? precoAtual;
  String? precoSugerido;
  String? margemDesejada;
  String? margemAtual;

  calculadoraHistorico(this.id,this.produto,this.data,this.precoAtual,this.precoSugerido,this.margemDesejada,this.margemAtual);

  calculadoraHistorico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produto = json['produto'];
    data = json['data'];
    precoAtual = json['preco_atual'];
    precoSugerido = json['preco_sugerido'];
    margemDesejada = json['margem_desejada'];
    margemAtual = json['margem_atual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produto'] = this.produto;
    data['data'] = this.data;
    data['preco_atual'] = this.precoAtual;
    data['preco_sugerido'] = this.precoSugerido;
    data['margem_desejada'] = this.margemDesejada;
    data['margem_atual'] = this.margemAtual;
    return data;
  }

  Object? fromJson() {}
}