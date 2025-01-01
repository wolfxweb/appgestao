import 'dart:ffi';

import 'package:appgestao/classes/calculadorahistorico.dart';
import 'package:appgestao/classes/sqlite/calculadora_sqlite.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  final _margemEmpresalController = BehaviorSubject();
  final _precoConcorrenteController = BehaviorSubject();

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
  Stream get outMargemEmpresalControllerr => _margemEmpresalController.stream;
  Stream get outPrecoConcorrente => _precoConcorrenteController.stream;

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
  var _precoMedioConcorrente;

  List list = [];
  CalculadoraBloc() {
    Intl.defaultLocale = 'pt_BR';
    _getDadosBasicos();
    _nomeUsuarioLogado();
    //selectHistorico();
  }
  //NumberFormat formatter = NumberFormat.simpleCurrency();
  NumberFormat formatter = NumberFormat("0.00");
  NumberFormat formatterPercentual = NumberFormat("0.00");
  NumberFormat formatterPercentual2 = NumberFormat("0.00");
  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
          //  print(element);
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
       // gas = double.parse(gastos).truncateToDouble();
        gas = 0.0;
        mars = double.parse(element['margen']);
        mar = mars / 100;

        _precoVendaAtualController.add(formatter.format(fat));
        _custoComInsumoslController.add(formatter.format(_custoInsumo));
        _precoVendaAtual = fat;

        _calculoMargemAtual();
        _margemDaEmpresa();
      });
    });
  }

  _margemDaEmpresa(){
    //(faturamento - (gastos com insumos + gastos com produtos para revenda + outros custos variáveis + custos fixos)) /faturamento.

    var margeEmpresa = ((fat-(cf+cv+gi+gas))/fat)*100;
    _margemEmpresalController.add(formatter.format(margeEmpresa));
  }
  _primeiroComentario() {

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
    var margeEsteProduto = ((fat - (cv + cf + gi + gas)) / fat);
    if ((_margemComPrecoAtual / 100) > margeEsteProduto &&
        (_margemComPrecoAtual / 100) <= _margemDesejada) {
      _msgMargemController.add('Este produto, com o preço atual, contribui para que o resultado da empresa não seja menor!');
    //  _msgMargemController.add('$_nomeUsuario, este produto, com o preço atual, contribui para que o resultado da empresa não seja menor!');
    } else if ((_margemComPrecoAtual / 100) > margeEsteProduto &&
        (_margemComPrecoAtual / 100) > _margemDesejada) {
     // _msgMargemController.add('$_nomeUsuario, este produto contribui muito positivamente para o resultado da empresa!');
      _msgMargemController.add('Este produto contribui muito positivamente para o resultado da empresa!');
    } else if ((_margemComPrecoAtual / 100) > 0 &&
        (_margemComPrecoAtual / 100) <= margeEsteProduto) {
     // _msgMargemController.add(          '$_nomeUsuario, este produto, com o preço atual, prejudica o resultado da empresa!');
      _msgMargemController.add('Este produto, com o preço atual, prejudica o resultado da empresa!');
    } else if ((_margemComPrecoAtual / 100) > 0 &&
        (_margemComPrecoAtual / 100) < margeEsteProduto) {
      _msgMargemController.add(
          'Este produto, mantendo-se o preço atual, impede que o resultado da empresa seja melhor!');
    } else if ((_margemComPrecoAtual / 100) < 0) {
      _msgMargemController.add('Este produto, mantendo-se o preço atual, é nocivo para o resultado da empresa!');
    }else{
      _msgMargemController.add('Este produto, mantendo-se o preço atual, é nocivo para o resultado da empresa!');
    }
  }

  _ultimoComentario() {
    // if (_relacaoPreco > 5) {
    //   /* CERTIFIQUE-SE DE QUE: 1.O MOMENTO ATUAL É OPORTUNO;2.ESTE PREÇO SUGERIDO SERÁ SUPORTADO POR SEU PÚBLICO-ALVO;3.QUE ELE SERÁ COMPETITIVO! */
    //   _msgPrecoSugeridoController.add("CERTIFIQUE-SE DE QUE:\n"
    //       "1. O MOMENTO ATUAL É OPORTUNO;\n"
    //       "2. ESTE PREÇO SUGERIDO SERÁ SUPORTADO POR SEU PÚBLICO-ALVO;\n"
    //       "3. QUE ELE SERÁ COMPETITIVO!");
    // } else {
    //   _msgPrecoSugeridoController.add("");
    // }
   // APARTIR DA VESÃO DE AGOSTO DE 2024 ESTAMOS USANDO AS VARIAVEIS COM NOME DAS DO EXECEL DO CLIENTE POIS O MESMO
    // ANDA ALTERANDO AS FORMULAS ENTÃO INICIAMOS O RATREIO MANTENDO IGUAL A DELE PARA VALIDAÇÕES FUTURA.

    var j21 = _relacaoPreco; // Substitua com o valor real
    var resultado = "";
    if (j21 == null ) {
      resultado = "";
    } else if (j21 > 5) {
      _msgPrecoSugeridoController.add('Certifique-se de que:\n1) O momento atual é oportuno;\n2) Este preço sugerido será suportado por seu público-alvo.');
    } else if (j21 < 0) {
      _msgPrecoSugeridoController.add('Redução só se justifica se for para promover mais vendas!');
    } else {
    //  print("else");
      resultado = "";
    }

    _primeiroComentario();
  }
  _comentarioPrecoConcorrete(){
    var margeEmpresa = ((fat-(cf+cv+gi+gas))/fat);
   // var margeEmpresaS = ((fat-(cf+cv+gi+gas))/fat);
   // print(margeEmpresaS);
    var A ;
    var RB;
    var RC;
    var RD;
    var RE;
    var RF;
    /*
      Informaçãoes do excel enviado dia 20 março de 2024
        E23 = PrecoConcorente
        B17 = Preco venda atual
        B21 = Margem preco atual
        B19 = Custo insumos terceiros
        (A%)  = SE(E(E23>0;B17>0;B21>0;B17>E23);100%-E23/(B17/B19)/B19;"")
        (R$B) = SE(E(B17>0;E23>0;B21>0;B17>E23);B19*(100%-C28);"")
        (R$C) = SE(E(B17>0;B17=E23;B21<E21);B17-(B17*(F9+F11)+(B17*E21));"")
        (R$D) = SE(E(B21<0;B17>E23);E23-(E23*(F9+F11+E21));"")
        (R$E) = SE(E(B21<0;B17=E23);B17-(B17*(F9+F11+E21));"")
        (R$F) = =SE(E(B21<E21*99%;E23="";B23="");B17-(B17*(F9+F11+E21));"")

    */

    var preco_venda_atual = _precoVendaAtual;
    var preco_concorrente = _precoMedioConcorrente;
    var custo_fixo = cv;
    var gasto_com_vendas = gi;
    var margem_empresa = mar;
    var faturamento = fat;
    var percentual_gasto_vendas = gasto_com_vendas/fat;
    var percentual_custo_fixo = custo_fixo/fat;
    var gasto_insumos_terceiros = cf;
    var percentual_gasto_insumos_terceiros = cf/fat;


    double margemPrecoAtual = 0.0;
    double margemEmpresa = 0.0 ;
    double precoMedioConcorrencia =  0.0;
    double precoVendaAtual = 0.0;
    double margemDesejada =0.00;
    margemPrecoAtual = _margemComPrecoAtual/100 ;
    margemEmpresa = margeEmpresa ?? 0.0 ;
    precoMedioConcorrencia = preco_concorrente ?? 0.0;
    precoVendaAtual = preco_venda_atual ;
    margemDesejada =_margemDesejada;

    String mensagem = "";
    double G9 = preco_venda_atual;
    double C10 = percentual_gasto_vendas;
    double C14 = percentual_custo_fixo;
    double G11 = _custoInsumo;
    RC = formatter.format(((G9-((C10*G9)+(C14*G9)+G11))/G9)*100);
    var a_calculado;
    if (preco_concorrente != null && preco_venda_atual != null && preco_venda_atual != 0) {
        a_calculado = (1 -  (preco_concorrente / (preco_venda_atual / _custoInsumo) / _custoInsumo));
        A = formatter.format(a_calculado*100);
    }
    if( a_calculado != null){
      RB = formatter.format(_custoInsumo- (_custoInsumo * (a_calculado)));
    }

    RF = formatter.format(precoVendaAtual -(precoVendaAtual*( percentual_gasto_vendas + percentual_custo_fixo +margemEmpresa )));
    // CALCULO ALTERADO EMAIL DIA 17/08/2024
    // RD = formatter.format( precoMedioConcorrencia -(precoMedioConcorrencia *(percentual_gasto_vendas + percentual_custo_fixo + margemEmpresa)));
    double H26 = precoMedioConcorrencia; // Valor de exemplo para H26
    RD = formatter.format(((H26 - ((H26 * (C10 + C14)) + G11)) / H26)*100);
    RE = RF;
    double precoMedioConcorrente = 60;
    // if (precoVendaAtual > 0 && precoMedioConcorrencia > 0) {
    //   double percentual90 = precoMedioConcorrencia * 0.9;
    //   double percentual110 = precoMedioConcorrencia * 1.05;
    //   // Nova condição que você quer adicionada 05/12
    //   double formula = (precoMedioConcorrencia - (((percentual_gasto_vendas + percentual_custo_fixo) * precoMedioConcorrencia) + _custoInsumo)) / precoMedioConcorrencia;
    //   if(precoVendaAtual <=0 && precoVendaAtual < preco_concorrente && formula <= 0){
    //     mensagem = "Mesmo praticando o preço médio concorrente você não conseguirá ter lucro. Reveja seus custos!";
    //   }else if (precoVendaAtual > percentual90 && precoVendaAtual < percentual110) {
    //     mensagem = "Com preço equivalente ao do concorrente, pense em criar um diferencial competitivo.";
    //   } else if (precoVendaAtual >= percentual110) {
    //     mensagem =   "Para praticar o mesmo preço do concorrente seu gasto com insumos e/ou mercadorias de 3os deveria ser de R\$ ${RB}, isto é: ${A}% menor.";
    //   } else if (precoVendaAtual <= percentual90) {
    //     mensagem = "Se o concorrente vende bem este mesmo item, pense em praticar o mesmo preço. Sua margem passaria de ${RC}% para ${RD}%.";
    //   }else if (precoVendaAtual > 0 && margemPrecoAtual <= 0 && precoMedioConcorrente > 0) {
    //     if (precoMedioConcorrente < precoVendaAtual) {
    //       return "Com o preço e custos atuais este produto dá prejuízo. Assim não dá para competir! Cuidado: é possível que o concorrente esteja vendendo com prejuízo maior que o seu!";
    //     } else if (precoMedioConcorrente > precoVendaAtual) {
    //       return "Digite o Preço médio concorrente em seu Preço de venda atual. Se a Margem preço atual continuar negativa é evidente que você precisará rever seus custos!";
    //     }
    //   }
    // }
    double precoVendaAtual_ = preco_venda_atual;
    double margemPrecoAtual_ = margemPrecoAtual;
    double precoMedioConcorrente_ = precoMedioConcorrencia;

    double a = (RB != null) ? double.tryParse(RB.toString()) ?? 0.0 : 0.0;
    double b = (A != null)  ? double.tryParse(A.toString())  ?? 0.0 : 0.0;
    double c = (RC != null) ? double.tryParse(RC.toString()) ?? 0.0 : 0.0;
    double d = (RD != null) ? double.tryParse(RD.toString()) ?? 0.0 : 0.0;

    String resultado = analisarPreco(
      precoVendaAtual: precoVendaAtual_,
      margemPrecoAtual: margemPrecoAtual_,
      precoMedioConcorrente: precoMedioConcorrente_,
      a: a,
      b: b,
      c: c,
      d: d,
    );

    _precoConcorrenteController.add(resultado);
  }
  String analisarPreco({
    required double precoVendaAtual,
    required double margemPrecoAtual,
    required double precoMedioConcorrente,
    required double a, // Valor de insumos para margem
    required double b, // Percentual menor para insumos
    required double c, // Nova margem percentual
    required double d, // Margem ajustada
  }) {
    if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual > precoMedioConcorrente * 0.95 &&
        precoVendaAtual < precoMedioConcorrente * 1.05) {
      return "Com preço equivalente ao do concorrente, pense em criar um diferencial competitivo.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual >= precoMedioConcorrente * 1.05) {
      return "Para praticar o mesmo preço do concorrente e manter sua margem atual, seu gasto com insumos e/ou mercadorias de 3os deveria ser de R\$${a}, isto é: ${b}% menor.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual <= precoMedioConcorrente * 0.95) {
      return "Se o concorrente vende bem este mesmo item, pense em praticar o mesmo preço. Sua margem passaria de ${c}% para ${d}%.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual <= 0 &&
        precoMedioConcorrente > 0 &&
        precoMedioConcorrente < precoVendaAtual) {
      return "Com o preço e custos atuais este produto dá prejuízo. Assim não dá para competir! Cuidado: é possível que o concorrente esteja vendendo com prejuízo maior que o seu!";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual <= 0 &&
        precoMedioConcorrente > 0 &&
        precoMedioConcorrente > precoVendaAtual) {
      return "Digite o Preço médio concorrente em seu Preço de venda atual. Se a Margem preço atual continuar negativa é evidente que você precisará rever seus custos!";
    } else {
      return "";
    }
  }

  _calculoMargemAtual() {
    // print(_precoVendaAtual);
    /***------------------------calculadora ------------------------ * ---------------------------Dados básicos------------------------- * ----------------Calculardora----------------****/
    // ((preco atual de vendas calculadora-(preço insumos calculadora+((( total outros custos variaveis + custos fixo)/ faturamento vendas)*preço atual vendas)))/preco atual de vendas))

    _margemComPrecoAtual = ((_precoVendaAtual -(_custoInsumo + (((gi +cv ) / fat) * _precoVendaAtual))) / _precoVendaAtual) * 100;
    var margem = formatterPercentual.format(_margemComPrecoAtual);
    if(_precoVendaAtual == '' ||_custoInsumo ==''){
      margem ="";
    }

    _calculoMargemController.add(margem);
    _calculoPrecodugerido();
    _margemDaEmpresa();
    _comentarioPrecoConcorrete();
    _ultimoComentario();

  }

  calculoRelacaoPreco() {
    // (preço sugerido/preço atual) – 100%
    _relacaoPreco = ((_calculoPrecoSuregirdo / _precoVendaAtual) - 1) * 100;
    _relacaoPrecoController.add(formatterPercentual.format(_relacaoPreco));
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
    var mar2 = mar1 / 100;
    _margemDesejada = mar2;
    _calculoMargemAtual();
    _comentarioPrecoConcorrete();

  }

  percoVendaAtual(preco) {
    var price = (preco
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _precoVendaAtual = double.parse(price);
    _precoVendaAtualController.add(_precoVendaAtual);
    _calculoMargemAtual();
  }

  precoConcorrente(preco){
    var price = (preco
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _precoMedioConcorrente = double.parse(price);
   // print('_precoMedioConcorrente');
   // print(_precoMedioConcorrente);
    _comentarioPrecoConcorrete();
  }

  _calculoPrecodugerido() {
    //(1/1-((((total outros custos variaveis + custos fixo)/faturamento vendas)+margem desejada)/(1)))*custo insumos
    //(1/(1-((((B10+B11)/B7)+F15)/1)))*F10
    // _calculoPrecoSuregirdo =(1 / (1 - ((((gi + cv) / fat) + _margemDesejada) / 1))) * _custoInsumo;
    var calTemp1 =1/(1-((((gi + cv) / fat)+ (_margemDesejada))-1)-1);
    _calculoPrecoSuregirdo =calTemp1*_custoInsumo;
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
           // print(data);
            _nomeUsuario = data['nome'];
          }
        });
      }
    });
  }

  savarCalculo(produto) {
    initializeDateFormatting();
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
   // print("save");
   // print(produto);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy ').format(now);

    var pcAtualFormatado = formatter.format(_precoVendaAtual);
    var precoAtual = "R\$ $pcAtualFormatado";
    var _mg = _margemDesejada * 100;
    var mgFomatado = formatterPercentual2.format(_mg);
    var _marDesejada = "$mgFomatado  %";
    var pSugerigidoFormatado = formatter.format(_calculoPrecoSuregirdo);
    var pSugerigido = "R\$ $pSugerigidoFormatado";
    var mgComPrecoAtualFomatada = formatterPercentual.format(_margemComPrecoAtual);
    var mgComPrecoAtual = "$mgComPrecoAtualFomatada %";

    var dados = calculadoraHistorico(
        null,
        produto,
        formattedDate,
        precoAtual.toString(),
        pSugerigido.toString(),
        _marDesejada,
        mgComPrecoAtual.toString());

 //   print(dados);
    return _db.save(dados.toJson()); /*
   _db.save(dados.toJson()).then((value) {
      print("save value");
      print(value);
      selectHistorico();
    //  alert.alertSnackBar(context, Colors.green, msg);
    });
    */
  }

  selectHistorico() {
    var _db = CalculadoraSqlite();
    _db.lista().then((data) {
      data.forEach((element) {
        var dados = calculadoraHistorico(
            element['id'],
            element['produto'],
            element['data'],
            element['preco_atual'],
            element['preco_sugerido'],
            element['margem_desejada'],
            element['margem_atual']);
        var json = dados.toJson();
       // print(json);
        list.add(json);
        // _historicolController.add(json);
      });
    });
    return list;
  }



  excluirHistorico(id) {
    //   print('excluirHistorico');
    //    print(id);
    //   delete(id)
    var _db = CalculadoraSqlite();
    return _db.delete(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calculoMargemController.close();
    _msgMargemController.close();
    _calcluloSugeridoController.close();
    _comparativoPrecoController.close();
    _msgPrecoSugeridoController.close();
    _precoConcorrenteController.close();
  }
}
