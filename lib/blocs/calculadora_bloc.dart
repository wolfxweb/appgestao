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
     ALTERADO DIA 08/12/2024
      O cliente altera as fórmulas desta tela com frequência e parece que ainda não definiu o cálculo.
      Para facilitar a vida do desenvolvedor, vamos usar uma função separada com os nomes das
      colunas do Excel que ele envia.

    ALTERADO DIA 08/02/2025
      As funções antigas foram deletadas nesta data, e o commit foi realizado no mesmo dia.
      Caso seja necessário alterar a fórmula, verifique a versão anterior, pois às vezes o
      cliente solicita a reversão do cálculo, mas envia como se fosse uma nova alteração.

     */
    var margeEsteProduto = ((fat - (cv + cf + gi + gas)) / fat);// Tudo informação dos dados basico
    var b11 = _precoVendaAtual;
    var b13 =_custoInsumo;
    var b15 = (_margemComPrecoAtual / 100);
    var e15 = margeEsteProduto;
    var textResponse  = analisarProduto(b11, b13, b15, e15);
    _msgMargemController.add(textResponse);
  }
  String analisarProduto(double? b11, double? b13, double? b15, double? e15) {
    if (b11 == null || b13 == null) {
      return "";
    }
    if (b15 == null || e15 == null) {
     return "";
    }
    if (b15 < 0) {
      return "Não venda para perder dinheiro!";
    }
    if (b15 > 0 && e15 < 0) {
      return "Este produto evita que o prejuízo da empresa seja maior. Ele vende bem?";
    }
    if (b15 > 0 && e15 > 0) {
      if (b15 >= e15 * 0.95 && b15 <= e15) {
        return "Este produto contribui mais do que outros para melhorar a margem da empresa! Vende bem?";
      }
      if (b15 < e15 * 0.95) {
        return "Sugestão: digite o % da Margem da empresa em Margem desejada!";
      }
    }
    return "";
  }


  _ultimoComentario() {

   /*
   A partir da versão de agosto de 2024, passamos a utilizar as variáveis com os mesmos nomes do
   Excel do cliente, pois ele tem alterado as fórmulas com frequência.
   Dessa forma, iniciamos o rastreamento mantendo a nomenclatura dele para futuras validações.

    Alterado em 08/02/2025
      As funções antigas foram removidas nesta data, e o commit foi realizado no mesmo dia.
      Caso seja necessário modificar a fórmula, verifique a versão anterior,
      pois o cliente às vezes solicita a reversão do cálculo, mas envia como se
      fosse uma nova alteração.

    /
   */

    var margeEsteProduto = ((fat - (cv + cf + gi + gas)) / fat);// Tudo informação dos dados basico
    var b13 =_custoInsumo;
    var b17 = _margemDesejada;
    var b19 = _calculoPrecoSuregirdo;
    var b15 = (_margemComPrecoAtual / 100);
    var e15 = margeEsteProduto;
    var e19 = _relacaoPreco;
    var textMarge = analisarMargem(b13,b17,b19,b15,e15,e19);
    _msgPrecoSugeridoController.add(textMarge);
    _primeiroComentario();
  }
  String analisarMargem(double? b13, double? b17, double? b19, double? b15, double? e15, double? e19) {
    if (b13 == null || b17 == null) {
      return "";
    }
    if (b13 > 0 && b17 > 0 && b17 >= 1.0) {
      return "Esta margem é impossível, devido à necessária inclusão dos seus custos no cálculo do preço!";
    }
    if (b13 > 0 && b17 > 0 && b17 < 1.0 && b19 == null) {
      return "Com os custos atuais não é possível alcançar esta margem desejada.";
    }
    if (e19 != null && e15 != null) {
      if (e19 < 0 && b17 > 0 && e19 >= e15 * 0.70 && e19 < e15 * 0.98) {
        return "Com essa margem o % de lucro da empresa diminuirá. Mas dependendo do quanto vender a mais, o valor do lucro poderá aumentar!";
      }
      if (e19 < 0 && b17 > 0 && e19 < e15 * 0.70) {
        return "Com esta Margem desejada, este produto prejudicará o lucro da empresa!";
      }
      if (e19 < 0 && e19 > e15 * 0.98 && e19 <= e15 * 1.02) {
        return "Com este preço sugerido, se vender bem, contribuirá para aumentar o lucro da empresa!";
      }
    }
    if (b15 != null && e19 != null && b15 > 0 && e19 > 0 && e19 >= 0.05) {
      return "Não quer alterar preço? Digite este preço sugerido em preço de venda atual. Em seguida, o preço de venda atual em Preço médio concorrente!";
    }
    if (b17 != null && e15 != null && b17 > e15 && b17 < e15 * 1.05) {
      return "Com esta Margem desejada a venda deste produto contribuirá para aumentar o lucro da empresa!";
    }
    return "";
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

    // print(_custoInsumo);
    // print(_custoInsumo);

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

    double precoMedioConcorrente = precoMedioConcorrencia;

    String resultado = " ";
    double custoInsumos = G11;
    double E = 0;
    var e = formatterPercentual.format(E);
    if (precoVendaAtual > 0 &&
        margemPrecoAtual < 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual == precoMedioConcorrente) {
        //G11 custo de insumos
        E = G11 - (margemPrecoAtual * -1 * precoVendaAtual);
        // print(G11);
        // print(E);
      //return "O custo ajustado dos insumos seria: R\$${novoCusto.toStringAsFixed(2)}.";
    }
    if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual > precoMedioConcorrente * 0.95 &&
        precoVendaAtual < precoMedioConcorrente * 1.05) {
      resultado = "Com preço equivalente ao do concorrente, pense em criar um diferencial competitivo.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual >= precoMedioConcorrente * 1.05) {
      resultado = "Para praticar o mesmo preço do concorrente e manter sua margem atual, seu gasto com insumos e/ou mercadorias de 3os deveria ser de R\$${RB}, isto é: ${A}% menor.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual > 0 &&
        precoMedioConcorrente > 0 &&
        precoVendaAtual <= precoMedioConcorrente * 0.95) {
      resultado = "Se o concorrente vende bem este mesmo item, pense em praticar o mesmo preço. Sua margem passaria de ${RC}% para ${RD}%.";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual <= 0 &&
        precoMedioConcorrente > 0 &&
        precoMedioConcorrente < precoVendaAtual) {
      resultado = "Com o preço e custos atuais este produto dá prejuízo. Assim não dá para competir! Cuidado: é possível que o concorrente esteja vendendo com prejuízo maior que o seu!";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual <= 0 &&
        precoMedioConcorrente > 0 &&
        precoMedioConcorrente > precoVendaAtual) {
      resultado = "Digite o Preço médio concorrente em seu Preço de venda atual. Se a Margem preço atual continuar negativa é evidente que você precisará rever seus custos!";
    } else if (precoVendaAtual > 0 &&
        margemPrecoAtual < 0 &&
        precoMedioConcorrente > 0 &&
        precoMedioConcorrente == precoVendaAtual) {
      resultado = "Praticar o mesmo preço do concorrente não é solução. Aliás, quem garante que ele também não está com prejuízo? Para margem zero, o custo dos insumos ou mercadoria de terceiro deveria ser de R\$${E.toStringAsFixed(2)}. Ou, você pode digitar a margem desejada para saber por quanto vender com o custo atual!";
    }

    _precoConcorrenteController.add(resultado);
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
