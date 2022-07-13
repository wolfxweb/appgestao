


import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ImportanciaMesesBLoc extends BlocBase{

  final _resultadoController = BehaviorSubject();
  final _mediaController = BehaviorSubject();
  final _valorMesesController =BehaviorSubject<List>();
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




  Stream get outResult => _resultadoController.stream;
  Stream get  outMedia => _mediaController.stream;
  Stream<List> get outValorMeses => _valorMesesController.stream;

  List _listValores =[];


  ImportanciaMesesBLoc(){
    _resultadoCalculadoListner();

  }
   _resultadoCalculadoListner(){
     _janController.add(5);
     _fevController.add(5);
     _marController.add(5);
     _abrController.add(5);
     _maiController.add(5);
     _junController.add(5);
     _julController.add(5);
     _agoController.add(5);
     _setController.add(5);
     _outController.add(5);
     _novController.add(5);
     _dezController.add(5);


     _calc();

   }
   _calc(){
     var jan = _janController.valueOrNull??0;
     var fev = _fevController.valueOrNull??0;
     var mar = _marController.valueOrNull??0;
     var abr = _abrController.valueOrNull??0;
     var mai = _maiController.valueOrNull??0;
     var jun = _junController.valueOrNull??0;
     var jul = _julController.valueOrNull??0;
     var ago = _agoController.valueOrNull??0;
     var set = _setController.valueOrNull??0;
     var out = _outController.valueOrNull??0;
     var nov = _novController.valueOrNull??0;
     var dez = _dezController.valueOrNull??0;
     var total = jan+fev+mar+abr+mai+jun+jul+ago+set+out+nov+dez;
     var media = total/12;
     _mediaController.add(media);
     _resultadoController.add(total);
     _listaDeValores();
   }
   jan(value){
     _janController.add(value);
     _calc();
   }
  fev(value){
    _fevController.add(value);
    _calc();
  }
  mar(value){
    _marController.add(value);
    _calc();
  }
  abr(value){
    _abrController.add(value);
    _calc();
  }
  mai(value){
    _maiController.add(value);
    _calc();
  }
  jun(value){
    _junController.add(value);
    _calc();
  }
  jul(value){
    _julController.add(value);
    _calc();
  }
  ago(value){
    _agoController.add(value);
    _calc();
  }
  set(value){
    _setController.add(value);
    _calc();
  }
  out(value){
    _outController.add(value);
    _calc();
  }
  nov(value){
    _novController.add(value);
    _calc();
  }
  dez(value){
    _dezController.add(value);
    _calc();
  }
  _listaDeValores(){
    _listValores.add(_janController.valueOrNull);
    _listValores.add(_fevController.valueOrNull);
    _listValores.add(_marController.valueOrNull);
    _listValores.add(_abrController.valueOrNull);
    _listValores.add(_maiController.valueOrNull);
    _listValores.add(_junController.valueOrNull);
    _listValores.add(_julController.valueOrNull);
    _listValores.add(_agoController.valueOrNull);
    _listValores.add(_setController.valueOrNull);
    _listValores.add(_outController.valueOrNull);
    _listValores.add(_novController.valueOrNull);
    _listValores.add(_dezController.valueOrNull);
    _valorMesesController.add(_listValores);

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