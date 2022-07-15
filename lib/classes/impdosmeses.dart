class impdosmeses {
  int? id;
  double? jan;
  double? fev;
  double? mar;
  double? abr;
  double? mai;
  double? jun;
  double? jul;
  double? ago;
  double? setb;
  double? out;
  double? nov;
  double? dez;
  double? total;

  impdosmeses(this.id,this.jan,this.fev,this.mar,this.abr, this.mai,this.jun,this.jul,this.ago,this.setb,this.out,this.nov,this.dez,this.total);

  impdosmeses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jan = json['jan'];
    fev = json['fev'];
    mar = json['mar'];
    abr = json['abr'];
    mai = json['mai'];
    jun = json['jun'];
    jul = json['jul'];
    ago = json['ago'];
    setb = json['setb'];
    out = json['out'];
    nov = json['nov'];
    dez = json['dez'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jan'] = this.jan;
    data['fev'] = this.fev;
    data['mar'] = this.mar;
    data['abr'] = this.abr;
    data['mai'] = this.mai;
    data['jun'] = this.jun;
    data['jul'] = this.jul;
    data['ago'] = this.ago;
    data['setb'] = this.setb;
    data['out'] = this.out;
    data['nov'] = this.nov;
    data['dez'] = this.dez;
    data['total'] = this.total;
    return data;
  }
}