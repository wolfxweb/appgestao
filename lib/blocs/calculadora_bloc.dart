import 'package:appgestao/classes/calculadorahistorico.dart';
import 'package:appgestao/classes/sqlite/calculadora_sqlite.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class CalculadoraBloc extends BlocBase {



  var bd = DadosBasicosSqlite();
  final _calculoMargemController = BehaviorSubject();
  final _msgMargemController = BehaviorSubject();
  final _calcluloSugeridoController = BehaviorSubject();
  final _comparativoPrecoController = BehaviorSubject();
  final _msgPrecoSugeridoController = BehaviorSubject();
  final _relacaoPrecoController = BehaviorSubject();
  final _calculoParte1Controller = BehaviorSubject();
  final _precoVendaAtualController = BehaviorSubject();
  final _custoComInsumoslController = BehaviorSubject();
  final _historicolController = BehaviorSubject();

  Stream get outCalculoMargem => _calculoMargemController.stream;
  Stream get outMsgMargem => _msgMargemController.stream;
  Stream get outCaculoPrecoSugerido => _calcluloSugeridoController.stream;
  Stream get outComparativoPreco => _comparativoPrecoController.stream;
  Stream get outMsgPrecoSugerido => _msgPrecoSugeridoController.stream;
  Stream get outCaculoPedido1Controller => _calculoParte1Controller.stream;
  Stream get outRelacaoPrecoController => _relacaoPrecoController.stream;
  Stream get outPrecoVendaAtualController => _precoVendaAtualController.stream;
  Stream get outCustosComInsumosController => _custoComInsumoslController.stream;
  Stream get outHistoricoController => _historicolController.stream;


  var _custoInsumo = 200.0;
  var _margemDesejada = 0.3;
  var caluculoFinal = 1.0;
  var fat;
  var cf;
  var cv;
  var gi;
  var gas;
  var mars;
  var mar;
  var _precoVendaAtual = 1000.00;
  var _margemComPrecoAtual;
  var _calculoPrecoSuregirdo;
  var _relacaoPreco;
  var _nomeUsuario;
  List list= [];
  CalculadoraBloc() {
      Intl.defaultLocale = 'pt_BR';
    _getDadosBasicos();
    _nomeUsuarioLogado();
    //selectHistorico();

  }
  //NumberFormat formatter = NumberFormat.simpleCurrency();
  NumberFormat formatter = NumberFormat("0.00");
  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
    //    print(element);
        var faturamento = (element['faturamento']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var custo_fixo = (element['custo_fixo']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var custo_varivel = (element['custo_varivel']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastos_insumos = (element['gastos_insumos']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastos = (element['gastos']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
         fat = double.parse(faturamento).truncateToDouble();
         cf = double.parse(custo_fixo).truncateToDouble();
         cv = double.parse(custo_varivel).truncateToDouble();
         gi = double.parse(gastos_insumos).truncateToDouble();
         gas = double.parse(gastos).truncateToDouble();
         mars = double.parse(element['margen']);
         mar = mars / 100;

        _precoVendaAtualController.add(formatter.format(fat));
        _custoComInsumoslController.add(formatter.format(_custoInsumo));
        _precoVendaAtual = fat;

        _calculoMargemAtual();
      });
    });
  }
  _primeiroComentario(){
    /*
        =(fat-(cv+cf+gi+gas))/fat
        =(B7-(B8+B9+B10+B11))/B7
        fat = double.parse(faturamento).truncateToDouble();
        cf = double.parse(custo_fixo).truncateToDouble();
        cv = double.parse(custo_varivel).truncateToDouble();
        gi = double.parse(gastos_insumos).truncateToDouble();
        gas = double.parse(gastos).truncateToDouble();
        SE(E(F13>B18;F13<=F15);"Fulano, este produto, com o preço atual, contribui para que o resultado da empresa não seja menor!";
        SE(E(F13>B18;F13>F15);"Fulano, este produto contribui muito positivamente para o resultado da empresa!";
        SE(E(F13>0;F13>B18);"Fulano, este produto, com o preço atual, prejudica o resultado da empresa!";
        SE(E(F13>0;F13<B18);"Fulano, este produto, mantendo-se o preço atual, impede que o resultado da empresa seja melhor!";
        SE(F13<0;"Fulano, este produto, mantendo-se o preço atual, é nocivo para o resultado da empresa!";"")))))
     */
    var margeEsteProduto =((fat-(cv+cf+gi+gas))/fat);
    if ((_margemComPrecoAtual/100) > margeEsteProduto &&  (_margemComPrecoAtual/100) <=_margemDesejada ) {
      _msgMargemController.add(
          '$_nomeUsuario, este produto, com o preço atual, contribui para que o resultado da empresa não seja menor!');
    } else if ( (_margemComPrecoAtual/100) >margeEsteProduto  && (_margemComPrecoAtual/100)  > _margemDesejada) {
      _msgMargemController.add(
          '$_nomeUsuario, este produto contribui muito positivamente para o resultado da empresa!');
    } else if ((_margemComPrecoAtual/100)  > 0 && (_margemComPrecoAtual/100) <= margeEsteProduto) {
      _msgMargemController.add(
          '$_nomeUsuario, este produto, com o preço atual, prejudica o resultado da empresa!');
    }else if ((_margemComPrecoAtual/100)  > 0 && (_margemComPrecoAtual/100) < margeEsteProduto ) {
      _msgMargemController.add(
          '$_nomeUsuario, este produto, mantendo-se o preço atual, impede que o resultado da empresa seja melhor!');
    }else if ((_margemComPrecoAtual/100)  < 0 ) {
      _msgMargemController.add(
          '$_nomeUsuario, este produto, mantendo-se o preço atual, é nocivo para o resultado da empresa!');
    }
  }
  _ultimoComentario(){

     if(_relacaoPreco>5){
       /* CERTIFIQUE-SE DE QUE: 1.O MOMENTO ATUAL É OPORTUNO;2.ESTE PREÇO SUGERIDO SERÁ SUPORTADO POR SEU PÚBLICO-ALVO;3.QUE ELE SERÁ COMPETITIVO! */
       _msgPrecoSugeridoController.add("CERTIFIQUE-SE DE QUE:\n"
           "1. O MOMENTO ATUAL É OPORTUNO;\n"
           "2. ESTE PREÇO SUGERIDO SERÁ SUPORTADO POR SEU PÚBLICO-ALVO;\n"
           "3. QUE ELE SERÁ COMPETITIVO!");
     }else{
       _msgPrecoSugeridoController.add("verifica ser vai  informação quando  a relação de preço for menor de 5% ");
     }
     _primeiroComentario();
  }
  _calculoMargemAtual(){
   // print(_precoVendaAtual);
    /***------------------------calculadora ------------------------ * ---------------------------Dados básicos------------------------- * ----------------Calculardora----------------****/
    // ((preco atual de vendas calculadora-(preço insumos calculadora+((( total outros custos variaveis + custos fixo)/ faturamento vendas)*preço atual vendas)))/preco atual de vendas))
    _margemComPrecoAtual =((_precoVendaAtual-(_custoInsumo+(((cv+ cf)/fat)*_precoVendaAtual)))/_precoVendaAtual)*100;
    var margem = formatter.format(_margemComPrecoAtual);
    _calculoMargemController.add(margem);
    _calculoPrecodugerido();

  }

  calculoRelacaoPreco(){
   // (preço sugerido/preço atual) – 100%
     _relacaoPreco = ((_calculoPrecoSuregirdo/_precoVendaAtual)-1)*100;
    _relacaoPrecoController.add(formatter.format(_relacaoPreco));
    _ultimoComentario();
  }
  calculadoraCusto(custoInsumos) {
    var _custoInsumos = (custoInsumos
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _custoInsumo = double.parse(_custoInsumos);
    _calculoMargemAtual();
  }
  margemDesejada(margen) {
  //  _margemDesejada = margen/100;
    var _margem = (margen
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
       var mar1 = double.parse(_margem);
       var mar2 = mar1/100;
      _margemDesejada = mar2;
       _calculoMargemAtual();
  }
 percoVendaAtual(preco){
    var price =(preco
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _precoVendaAtual = double.parse(price);
    _precoVendaAtualController.add(_precoVendaAtual);
    _calculoMargemAtual();
}
_calculoPrecodugerido(){
  //(1/1-((((total outros custos variaveis + custos fixo)/faturamento vendas)+margem desejada)/(1)))*custo insumos
  //(1/(1-((((B10+B11)/B7)+F15)/1)))*F10
    _calculoPrecoSuregirdo = (1/(1-((((cf+cv)/fat)+_margemDesejada)/1)))*_custoInsumo;
    _calcluloSugeridoController.add(formatter.format(_calculoPrecoSuregirdo));
    calculoRelacaoPreco();
}
  _nomeUsuarioLogado() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      var email = user!.email;
      if (user == null) {
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            // print(documentSnapshot.data());
            Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
            print(data);
            _nomeUsuario = data['nome'];
          }
        });
      }
    });
  }

  savarCalculo(produto){
   var _db = CalculadoraSqlite();
    /*
          Informações par historico da calculadora
          -> Nome do produto
          -> data em que for salvo(Data cadastro)
          -> preço atual ( preço atual digitado na calculadora)
          -> margem( magem desejada digitado na calculadora)
          -> preço sugerido
          -> margem( margem atual)
     */
    print("save");
    print(produto);
   DateTime now = DateTime.now();
   String formattedDate = DateFormat('dd/MM/yyyy ').format(now);

   var pcAtualFormatado = formatter.format(_precoVendaAtual);
   var precoAtual = "R\$ $pcAtualFormatado";
   var _mg = _margemDesejada * 100;
   var _marDesejada = "$_mg  %";
   var  pSugerigidoFormatado = formatter.format(_calculoPrecoSuregirdo);
   var pSugerigido = "R\$ $pSugerigidoFormatado";
   var mgComPrecoAtualFomatada = formatter.format(_margemComPrecoAtual);
   var mgComPrecoAtual = "$mgComPrecoAtualFomatada %";

   var dados =  calculadoraHistorico(null,produto,formattedDate,precoAtual.toString(),pSugerigido.toString(),_marDesejada,mgComPrecoAtual.toString());
   _db.save(dados.toJson()).then((value) {
      print("save value");
      print(value);
      selectHistorico();
    //  alert.alertSnackBar(context, Colors.green, msg);
    });
  }
  selectHistorico(){
    var _db = CalculadoraSqlite();
    _db.lista().then((data) {
      data.forEach((element) {

        var dados =  calculadoraHistorico(element['id'],element['produto'],element['data'],element['preco_atual'],element['preco_sugerido'],element['margem_desejada'],element['margem_atual']);
        var json = dados.toJson();
     print(json);

        list.add(json);
       // _historicolController.add(json);

      });
    });
   return list;
  }

  excluirHistorico(id){
    print('excluirHistorico');
    print(id);
 //   delete(id)
    var _db = CalculadoraSqlite();
    _db.delete(id).then((value){
      print(value);
     // selectHistorico();
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _calculoMargemController.close();
    _msgMargemController.close();
    _calcluloSugeridoController.close();
    _comparativoPrecoController.close();
    _msgPrecoSugeridoController.close();
  }
}
