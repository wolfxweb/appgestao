import 'package:flutter/material.dart';
import 'package:appgestao/classes/impdosmeses.dart';
import 'package:appgestao/classes/sqlite/importanciameses.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ImportanciaMesesBLoc extends BlocBase {
  final _resultadoController = BehaviorSubject();
  final _mediaController = BehaviorSubject();
  final _valorMesesController = BehaviorSubject<List>();
  final _janController = BehaviorSubject();
  final _fevController = BehaviorSubject();
  final _marController = BehaviorSubject();
  final _abrController = BehaviorSubject();
  final _maiController = BehaviorSubject();
  final _junController = BehaviorSubject();
  final _julController = BehaviorSubject();
  final _agoController = BehaviorSubject();
  final _setController = BehaviorSubject();
  final _outController = BehaviorSubject();
  final _novController = BehaviorSubject();
  final _dezController = BehaviorSubject();
  final _id = 1;

  final _msgInfoMesSelecionado =  BehaviorSubject();

  Stream get outResult => _resultadoController.stream;
  Stream get outMedia => _mediaController.stream;
  Stream<List> get outValorMeses => _valorMesesController.stream;
  Stream get  janOutValor => _janController.stream;
  Stream get  fevOutValor => _fevController.stream;
  Stream get  marOutValor => _marController.stream;
  Stream get  abrOutValor => _abrController.stream;
  Stream get  maiOutValor => _maiController.stream;
  Stream get  junOutValor => _junController.stream;
  Stream get  julOutValor => _julController.stream;
  Stream get  agoOutValor => _agoController.stream;
  Stream get  setOutValor => _setController.stream;
  Stream get  outOutValor => _outController.stream;
  Stream get  novOutValor => _novController.stream;
  Stream get  dezOutValor => _dezController.stream;
  Stream get  outInfoMesSelecionado => _msgInfoMesSelecionado.stream;

  final List _listValores = [];

  ImportanciaMesesBLoc() {
    _resultadoCalculadoListner();
  }
  inicializarBloc(){
    _consultarMeses();
  }
  _msgMesSelecionado(mesAtual, mesSelecionado){
    // if(mesAtual == mesSelecionado){
    //   _msgInfoMesSelecionado.add("Quanto mais próximo o mês selecionado for do atual, mais as suas análises retratarão a realidade.Todos os dados devem se referir ao mesmo mês. Caso você esteja estudando a viabilidade de um novo Negócio, preencha com suas estimativas e metas.Fechar");
    // }else{
    //  // _msgInfoMesSelecionado.add("Quanto mais próximo o mês selecionado for do mês atual, mais útil será para suas análises.");
    //   _msgInfoMesSelecionado.add("Quanto mais próximo o mês selecionado for do atual, mais as suas análises retratarão a realidade.Todos os dados devem se referir ao mesmo mês. Caso você esteja estudando a viabilidade de um novo Negócio, preencha com suas estimativas e metas.Fechar");
    // }
    var texto = """Quanto mais próximo o mês selecionado for do atual, mais as suas análises retratarão a realidade.\nTodos os dados devem se referir ao mesmo mês.\nCaso você esteja estudando a viabilidade de um novo Negócio, preencha os Dados básicos com suas estimativas e metas.
    """;
    _msgInfoMesSelecionado.add(texto);
  }
  msgInfoMesSelecionado(value){
    final mes = DateTime.now().month;

    switch (value){
      case "Janeiro":
        _msgMesSelecionado(mes, 1);
        break;
      case "Fevereiro":
        _msgMesSelecionado(mes, 2);
        break;
      case "Março":
        _msgMesSelecionado(mes, 3);
        break;
      case "Abril":
        _msgMesSelecionado(mes, 4);
        break;
      case "Maio":
        _msgMesSelecionado(mes, 5);
        break;
      case "Junho":
        _msgMesSelecionado(mes, 6);
        break;
      case "Julho":
        _msgMesSelecionado(mes, 7);
        break;
      case "Agosto":
        _msgMesSelecionado(mes, 8);
        break;
      case "Setembro":
        _msgMesSelecionado(mes, 9);
        break;
      case "Outubro":
        _msgMesSelecionado(mes, 10);
        break;
      case "Novembro":
        _msgMesSelecionado(mes, 11);
        break;
      case "Dezembro":
        _msgMesSelecionado(mes, 8);
        break;

    }
  }



_consultarMeses() async {

    var bd = InportanciasMeses();
    await bd.lista().then((data) {
      data.forEach((element) {
       // print("inportancia meses bloc");
      //  print(element);
        _janController.add(element['jan']);
        _fevController.add(element['fev']);
        _marController.add(element['mar']);
        _abrController.add(element['abr']);
        _maiController.add(element['mai']);
        _junController.add(element['jun']);
        _julController.add(element['jul']);
        _agoController.add(element['ago']);
        _setController.add(element['setb']);
        _outController.add(element['out']);
        _novController.add(element['nov']);
        _dezController.add(element['dez']);
      });
      _calc();
    });

  }
  get context => null;
  _resultadoCalculadoListner() {

    _janController.add(5.0);
    _fevController.add(5.0);
    _marController.add(5.0);
    _abrController.add(5.0);
    _maiController.add(5.0);
    _junController.add(5.0);
    _julController.add(5.0);
    _agoController.add(5.0);
    _setController.add(5.0);
    _outController.add(5.0);
    _novController.add(5.0);
    _dezController.add(5.0);
    _consultarMeses();
    _calc();
  }

  _calc() {
    var jan = _janController.valueOrNull ?? 0;
    var fev = _fevController.valueOrNull ?? 0;
    var mar = _marController.valueOrNull ?? 0;
    var abr = _abrController.valueOrNull ?? 0;
    var mai = _maiController.valueOrNull ?? 0;
    var jun = _junController.valueOrNull ?? 0;
    var jul = _julController.valueOrNull ?? 0;
    var ago = _agoController.valueOrNull ?? 0;
    var set = _setController.valueOrNull ?? 0;
    var out = _outController.valueOrNull ?? 0;
    var nov = _novController.valueOrNull ?? 0;
    var dez = _dezController.valueOrNull ?? 0;
    var total = jan + fev + mar + abr + mai + jun + jul + ago + set + out + nov + dez;
    var media = total / 12;
    _mediaController.add(media);
    _resultadoController.add(total);
    _listaDeValores(total);
  }

  jan(value) {
    _janController.add(value);
    _calc();
  }

  fev(value) {
    _fevController.add(value);
    _calc();
  }

  mar(value) {
    _marController.add(value);
    _calc();
  }

  abr(value) {
    _abrController.add(value);
    _calc();
  }

  mai(value) {
    _maiController.add(value);
    _calc();
  }

  jun(value) {
    _junController.add(value);
    _calc();
  }

  jul(value) {
    _julController.add(value);
    _calc();
  }

  ago(value) {
    _agoController.add(value);
    _calc();
  }

  set(value) {
    _setController.add(value);
    _calc();
  }

  out(value) {
    _outController.add(value);
    _calc();
  }

  nov(value) {
    _novController.add(value);
    _calc();
  }

  dez(value) {
    _dezController.add(value);
    _calc();
  }

  _listaDeValores(total) {
    const per = 100;

    _listValores.clear();

    _listValores.add(_id);
    _listValores.add((_janController.valueOrNull / total) * per);
    _listValores.add((_fevController.valueOrNull / total) * per);
    _listValores.add((_marController.valueOrNull / total) * per);
    _listValores.add((_abrController.valueOrNull / total) * per);
    _listValores.add((_maiController.valueOrNull / total) * per);
    _listValores.add((_junController.valueOrNull / total) * per);
    _listValores.add((_julController.valueOrNull / total) * per);
    _listValores.add((_agoController.valueOrNull / total) * per);
    _listValores.add((_setController.valueOrNull / total) * per);
    _listValores.add((_outController.valueOrNull / total) * per);
    _listValores.add((_novController.valueOrNull / total) * per);
    _listValores.add((_dezController.valueOrNull / total) * per);
    _listValores.add(total);
    _valorMesesController.add(_listValores);
  }

  adicionarImportanciaMeses(context) {
    var dados = impdosmeses(
      _valorMesesController.valueOrNull?[0],
      _janController.valueOrNull*1.0,
      _fevController.valueOrNull*1.0,
      _marController.valueOrNull*1.0,
      _abrController.valueOrNull*1.0,
      _maiController.valueOrNull*1.0,
      _junController.valueOrNull*1.0,
      _julController.valueOrNull*1.0,
      _agoController.valueOrNull*1.0,
      _setController.valueOrNull*1.0,
      _outController.valueOrNull*1.0,
      _novController.valueOrNull*1.0,
      _dezController.valueOrNull*1.0,
      _valorMesesController.valueOrNull?[13],
    );

    var bd = InportanciasMeses();
    print("importancia dos meses");
    print(dados.toJson());
    bd.save(dados.toJson()).then((value) {
      var alert = AlertSnackBar();
      alert.alertSnackBar(context, Colors.green, 'Importâcia dos meses atualizada com sucesso');
    });
  }

  @override
  void dispose() {
    _resultadoController.close();
    _janController.close();
    _fevController.close();
    _marController.close();
    _abrController.close();
    _maiController.close();
    _junController.close();
    _julController.close();
    _agoController.close();
    _setController.close();
    _outController.close();
    _novController.close();
    _dezController.close();
  }
}
