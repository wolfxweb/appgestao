import 'package:appgestao/classes/sqlite/dadosbasicos.dart';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';


class gestao_prioridade_bloc extends BlocBase{
  var bd = DadosBasicosSqlite();

  /* Margem */
  final _margemInicial = BehaviorSubject();
  final _margemCalculada = BehaviorSubject();
  final _margemVariacao = BehaviorSubject();
  final _corMargem = BehaviorSubject();
  Stream get margemInicial => _margemInicial.stream;
  Stream get margemCalculada => _margemCalculada.stream;
  Stream get margemVariacao =>_margemVariacao.stream;
  Stream get corMargem => _corMargem.stream;

  /*Clientes atendidos */
  final _clientesAtendidoDadosBasico =BehaviorSubject();
  final _corClientesAtendido = BehaviorSubject();
  final _clientesAtendidoCalculado = BehaviorSubject();
  final _clientesAtendidoVaricacao =BehaviorSubject();
  Stream get clientesAtendidoDadosBasico => _clientesAtendidoDadosBasico.stream;
  Stream get corClientesAtendido => _corClientesAtendido.stream;
  Stream get clientesAtendidoCalculado => _clientesAtendidoCalculado.stream;
  Stream get clientesAtendidoVaricacao => _clientesAtendidoVaricacao.stream;

  /*Preço médio das vendas*/
  final _precoInicial =BehaviorSubject();
  final _corPrecoMedioVendas = BehaviorSubject();
  final _precoMedioCalculado = BehaviorSubject();
  final _variacaoPrecoMedioVendas =BehaviorSubject();
  Stream get precoInicial => _precoInicial.stream;
  Stream get corPrecoMedioVendas => _corPrecoMedioVendas.stream;
  Stream get precoMedioCalculado => _precoMedioCalculado.stream;
  Stream get variacaoPrecoMedioVendas => _variacaoPrecoMedioVendas.stream;

  /*Ticket médio*/
  final _tickeMedioInicial =BehaviorSubject();
  final _corTicketMedio = BehaviorSubject();
  final _ticketMedioCalculado = BehaviorSubject();
  final _variacaoTicketMedio =BehaviorSubject();
  Stream get tickeMedioInicial => _tickeMedioInicial.stream;
  Stream get corTicketMedio => _corTicketMedio.stream;
  Stream get ticketMedioCalculado => _ticketMedioCalculado.stream;
  Stream get variacaoTicketMedio=> _variacaoTicketMedio.stream;

  /*Faturamento*/
  final _faturamentoInicial =BehaviorSubject();
  final _corfaturamento = BehaviorSubject();
  final _faturamentoCalculado = BehaviorSubject();
  final _faturamentoVariacao =BehaviorSubject();
  Stream get faturamentoInicial => _faturamentoInicial.stream;
  Stream get corfaturamento => _corfaturamento.stream;
  Stream get faturamentoCalculado => _faturamentoCalculado.stream;
  Stream get faturamentoVariacao=> _faturamentoVariacao.stream;

  /*Custo das Vendas*/
  final _custoInicialVendas =BehaviorSubject();
  final _corCustoInsumos = BehaviorSubject();
  final _custoInsumosCalculado = BehaviorSubject();
  final _custoFixoVariacao =BehaviorSubject();
  Stream get custoInicialVendas => _custoInicialVendas.stream;
  Stream get corCustoInsumos => _corCustoInsumos.stream;
  Stream get custoInsumosCalculado => _custoInsumosCalculado.stream;
  Stream get custoFixoVariacao=> _custoFixoVariacao.stream;

  /*Custo dos insumos e mercadorias de 3°*/
  final _custoInsumosMercadoria3 =BehaviorSubject();
  final _corCustoProduto = BehaviorSubject();
  final _custoTreceirosCalculado = BehaviorSubject();
  final _variacaoCustoDe3 =BehaviorSubject();
  Stream get custoInsumosMercadoria3 => _custoInsumosMercadoria3.stream;
  Stream get corCustoProduto => _corCustoProduto.stream;
  Stream get custoTreceirosCalculado => _custoTreceirosCalculado.stream;
  Stream get variacaoCustoDe3=> _variacaoCustoDe3.stream;

  /*Custos Fixos*/
  final _custoFixoInicialDadosBasicos =BehaviorSubject();
  final _corCustoFixo = BehaviorSubject();
  final _custoFixoCalculado = BehaviorSubject();
  final _custoFixosVariacao =BehaviorSubject();
  Stream get custoFixoInicialDadosBasicos => _custoFixoInicialDadosBasicos.stream;
  Stream get corCustoFixo => _corCustoFixo.stream;
  Stream get custoFixoCalculado => _custoFixoCalculado.stream;
  Stream get custoFixosVariacao => _custoFixosVariacao.stream;

  final _percentualAddController = BehaviorSubject();
  final _percentualRemoveController = BehaviorSubject();
  Stream get percentualAddController => _percentualAddController.stream;
  Stream get percentualRemoveController => _percentualRemoveController.stream;
  /* variaveis  */
  var faturamentoDadosBasicos;
  var custoVendasDadosBasicos;
  var custoInsumosTerceirosDadosBasicos;
  var custoFixoDadosBasicos;
  var margenDadosBasicos;
  var quantidadeDadosBasicos;
  var gastoComInsumosDadosBasicos;
  var quantidadeDeClientesAtendidoDadosBasicos;
  var quantidadeDeClientesAtendidoCalculada;
  var margemInicalCalculada;
  var quantidadeDeClientesAtendido;

  var ticketMedioInicialValor;
  var precoMedioVendasCalculado;

  var margemAtual;
  var qtdClienteAtual;
  var percoMedioVendasAtual;
  var ticketMedioAtual;
  var faturamentoAtual;
  var custoVendasAtual;
  var custosTerceirosAtual;
  var custoFixoAtual;
  var calculoFaturamento;
  var custoTercerirosReferencia;



  gestao_prioridade_bloc(){
    getDadosBasicos();
  }
  NumberFormat formatterPercentual = NumberFormat("0.00");
  NumberFormat formatterMoeda = NumberFormat("#,##0.00", "pt_BR");
  getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print('gestao_prioridade_bloc');
        print(element);
        faturamentoDadosBasicos =  convertMonetarioFloat(element["faturamento"]);
        custoVendasDadosBasicos = convertMonetarioFloat(element["gastos_insumos"]);
        custoInsumosTerceirosDadosBasicos =  convertMonetarioFloat(element["custo_fixo"]);
        custoFixoDadosBasicos =  convertMonetarioFloat(element["custo_varivel"]);
        margenDadosBasicos = convertMonetarioFloat(element["margen"]);
        quantidadeDadosBasicos =  convertMonetarioFloat(element["qtd"]);
        gastoComInsumosDadosBasicos =  convertMonetarioFloat(element["gastos"]);
        quantidadeDeClientesAtendidoDadosBasicos = element["qtd"];
        quantidadeDeClientesAtendidoCalculada  = element["qtd"];
        quantidadeDeClientesAtendido =element["qtd"];
        valoresIniciais();
      });
    });
  }

  limparCampos(){

  }


  calculoPercentual(percent, operacao, selecionado, modo, context) {

    var select = selecionado;
    var percentual = double.parse(percent);

    if (select == "") {
      select = 'Quantidade clientes atendidos';
    }
    if (modo == 1 && operacao == 1) {
      _percentualRemoveController.add('');
      _percentualAddController.add(percentual.toStringAsPrecision(2));
    }
    if (modo == 2 && operacao == 2) {
      _percentualAddController.add('');
      _percentualRemoveController.add(percentual.toStringAsPrecision(2));
    }
    switch (select) {
      case 'Quantidade clientes atendidos':
        if (operacao == 1) {
          quantidadeDeClientesAtendido = double.parse(quantidadeDeClientesAtendidoCalculada) * ((percentual/100)+1);
        } else {
          var quantidadeDeClientesAtendidoAx = (double.parse(quantidadeDeClientesAtendidoCalculada) * (percentual/100));
          quantidadeDeClientesAtendido = double.parse(quantidadeDeClientesAtendidoCalculada) - quantidadeDeClientesAtendidoAx;
        }
        qtdClienteAtual = quantidadeDeClientesAtendido;

        calculoFaturamentos();
        calculoClientesAtendidos();
        calculoCustoTerceiros();
        calculoMargemAtual();
        break;
      case 'Preço médio de vendas':

        custoTercerirosReferencia = custosTerceirosAtual;
        if (operacao == 1) {
          percoMedioVendasAtual = percoMedioVendasAtual *((percentual / 100) + 1);
          ticketMedioAtual = ticketMedioAtual *((percentual / 100) + 1);
          custosTerceirosAtual = custosTerceirosAtual*((percentual / 100) + 1);
        } else {
          var qtdAUX = percoMedioVendasAtual *(percentual / 100);
          var qtdAUX2 = ticketMedioAtual *(percentual / 100);
          var qtdAUX3 = ticketMedioAtual *(percentual / 100);
          percoMedioVendasAtual = percoMedioVendasAtual - qtdAUX;
          ticketMedioAtual = ticketMedioAtual - qtdAUX2;
          custosTerceirosAtual = custosTerceirosAtual - qtdAUX3;
        }
        if(qtdClienteAtual is String){
          qtdClienteAtual = double.parse(qtdClienteAtual);
        }

        _custoTreceirosCalculado.add(valorFormatadoReal(custosTerceirosAtual));
    //    _variacaoCustoDe3.add(formatterPercentual.format(calculoCampoVariacao(custoInsumosTerceirosDadosBasicos, custosTerceirosAtual)));
       // corCustoTerceiros();
        calculoPrecoMedio();
        calculoTicketMedio();
        calculoFaturamentos();
        calculoCustoTerceiros();
        calculoMargemAtual();
        break;
      case 'Ticket médio':
        custoTercerirosReferencia = custosTerceirosAtual;
        if (operacao == 1) {
          ticketMedioAtual = ticketMedioAtual *((percentual / 100) + 1);
        } else {
          var qtdAUX = ticketMedioAtual *(percentual / 100);
          ticketMedioAtual = ticketMedioAtual - qtdAUX;
        }

        calculoTicketMedio();
        calculoFaturamentos();
        calculoCustoTerceiros();
        corTicketMedioAtual();
        calculoMargemAtual();
        break;
      case 'Custo das vendas':
        if (operacao == 1) {
          custoVendasAtual = (faturamentoAtual*(custoVendasDadosBasicos/faturamentoDadosBasicos)) * ((percentual/100)+1);
        //  custoVendasAtual = custoVendasDadosBasicos* ((percentual/100)+1);
        } else {
          var custoTemp = custoVendasAtual;
          var calculoCustoTemp = (faturamentoAtual*(custoVendasDadosBasicos/faturamentoDadosBasicos)) * (percentual/100);
          custoVendasAtual =custoTemp -calculoCustoTemp;
        //  var quantidadeDeClientesAtendidoAx = (custoVendasDadosBasicos * (percentual/100));
        //  custoVendasAtual = custoVendasDadosBasicos - quantidadeDeClientesAtendidoAx;
        }
        calculoCustoVendasAtual();
        calculoMargemAtual();
        break;
      case 'Custos dos insumos e mercadorias de 3°':

        if (operacao == 1) {
          custosTerceirosAtual = custosTerceirosAtual *((percentual / 100) + 1);
        } else {
          var qtdAUX = custosTerceirosAtual *(percentual / 100);
          custosTerceirosAtual = custosTerceirosAtual - qtdAUX;
        }
        _custoTreceirosCalculado.add(valorFormatadoReal(custosTerceirosAtual));
        _variacaoCustoDe3.add(formatterPercentual.format(calculoCampoVariacao(custoInsumosTerceirosDadosBasicos, custosTerceirosAtual)));
        corCustoTerceiros();
        calculoMargemAtual();
        break;
      case 'Custo fixo':

        if (operacao == 1) {
          custoFixoAtual = custoFixoAtual *((percentual / 100) + 1);
        } else {
          var qtdAUX = custoFixoAtual *(percentual / 100);
          custoFixoAtual = custoFixoAtual - qtdAUX;
        }

        _custoFixoCalculado.add(valorFormatadoReal(custoFixoAtual));
        _custoFixosVariacao.add(formatterPercentual.format(calculoCampoVariacao(custoFixoDadosBasicos, custoFixoAtual)));
        corCustoFixoAtual();
        calculoMargemAtual();

        break;
    }
  }

calculoCustoVendasAtual(){
  _custoInsumosCalculado.add(valorFormatadoReal(custoVendasAtual));
  _custoFixoVariacao.add(formatterPercentual.format(calculoCampoVariacao(custoVendasDadosBasicos, custoVendasAtual)));
  corCustoVendasAtual();
}
calculoTicketMedio(){
  _ticketMedioCalculado.add(valorFormatadoReal(ticketMedioAtual));
  _variacaoTicketMedio.add(formatterPercentual.format(calculoCampoVariacao(ticketMedioInicialValor, ticketMedioAtual)));
  corTicketMedioAtual();
}
 calculoPrecoMedio(){
   _precoMedioCalculado.add(valorFormatadoReal(percoMedioVendasAtual));
   _variacaoPrecoMedioVendas.add(formatterPercentual.format(calculoCampoVariacao(ticketMedioInicialValor, percoMedioVendasAtual)));
   corPrecoMedioAtual();
 }
 calculoMargemAtual(){
    margemAtual =(faturamentoAtual -(custoVendasAtual+custosTerceirosAtual+custoFixoAtual))/faturamentoAtual;
   _margemCalculada.add(formatterPercentual.format(margemAtual*100));
   _margemVariacao.add(formatterPercentual.format(calculoCampoVariacao(margemInicalCalculada, margemAtual*100)));
   corMargemCalculada();
 }
 calculoCustoTerceiros(){

   if(qtdClienteAtual is String){
     qtdClienteAtual = double.parse(qtdClienteAtual);
   }
   faturamentoAtual = ticketMedioAtual * qtdClienteAtual;

   custosTerceirosAtual =(faturamentoAtual-((percoMedioVendasAtual-ticketMedioInicialValor)*qtdClienteAtual))*(custoInsumosTerceirosDadosBasicos/faturamentoDadosBasicos);
  var custoTerceiros =calculoCampoVariacao(custoInsumosTerceirosDadosBasicos, custosTerceirosAtual);
   _custoTreceirosCalculado.add(valorFormatadoReal(custosTerceirosAtual));

   print('custosTerceirosAtual');
   print(custosTerceirosAtual);
   print(custoTercerirosReferencia);
   print(custoTerceiros);
    if(custoTercerirosReferencia != custosTerceirosAtual) {
      _variacaoCustoDe3.add(formatterPercentual.format(custoTerceiros));
      corCustoTerceiros();
    }
 }
 calculoFaturamentos(){
   if(qtdClienteAtual is String){
     qtdClienteAtual = double.parse(qtdClienteAtual);
   }
     faturamentoAtual = ticketMedioAtual * qtdClienteAtual;
    _faturamentoCalculado.add(valorFormatadoReal(faturamentoAtual));
    _faturamentoVariacao.add(formatterPercentual.format(calculoCampoVariacao(faturamentoDadosBasicos, faturamentoAtual)));
   corFaturamento();
 }

 calculoClientesAtendidos(){
   _clientesAtendidoCalculado.add(formatterPercentual.format(quantidadeDeClientesAtendido));
   _clientesAtendidoVaricacao.add(formatterPercentual.format(calculoCampoVariacao(double.parse(quantidadeDeClientesAtendidoDadosBasicos), quantidadeDeClientesAtendido)));
   corClientesAtendidos();
 }

 corCustoFixoAtual(){
   if (custoFixoDadosBasicos < custoFixoAtual) {
     _corCustoFixo.add('vermelho');
   } else if (custoFixoDadosBasicos > custoFixoAtual) {
     _corCustoFixo.add('verde');
   } else {
     _corCustoFixo.add("desabilitado");
   }
 }
  corCustoVendasAtual(){
    if (custoVendasDadosBasicos > custoVendasAtual) {
      _corCustoInsumos.add('verde');
    } else if (custoVendasDadosBasicos < custoVendasAtual) {
      _corCustoInsumos.add('vermelho');
    } else {
      _corCustoInsumos.add('desabilitado');
    }
  }
  corPrecoMedioAtual(){
    if (ticketMedioInicialValor < percoMedioVendasAtual) {
      _corPrecoMedioVendas.add('verde');
    } else if (ticketMedioInicialValor > percoMedioVendasAtual) {
      _corPrecoMedioVendas.add('vermelho');
    } else {
      _corPrecoMedioVendas.add('desabilitado');
    }
  }
 corTicketMedioAtual(){
   if (ticketMedioInicialValor < ticketMedioAtual) {
     _corTicketMedio.add('verde');
   } else if (ticketMedioInicialValor > ticketMedioAtual) {
     _corTicketMedio.add('vermelho');
   } else {
     _corTicketMedio.add('desabilitado');
   }
 }
 corMargemCalculada(){
    var mAtual =  margemAtual*100;
    if(margemInicalCalculada > mAtual){
     _corMargem.add('vermelho');
   }else if(margemInicalCalculada < mAtual ){
     _corMargem.add('verde');
   }else{
     _corMargem.add('desabilitado');
   }
 }

  corCustoTerceiros(){
    if(margemInicalCalculada < custoInsumosTerceirosDadosBasicos ){
      _corCustoProduto.add('vermelho');
    }else if(margemInicalCalculada > custoInsumosTerceirosDadosBasicos ){
      _corCustoProduto.add('verde');
    }else{
      _corCustoProduto.add('desabilitado');
    }
  }
  corFaturamento(){
    if(faturamentoAtual < faturamentoDadosBasicos ){
      _corfaturamento.add('vermelho');
    }else if(faturamentoAtual > faturamentoDadosBasicos ){
      _corfaturamento.add('verde');
    }else{
      _corfaturamento.add('desabilitado');
    }
  }
  corClientesAtendidos(){
    if(quantidadeDeClientesAtendido < quantidadeDadosBasicos ){
      _corClientesAtendido.add('vermelho');
    }else if(quantidadeDeClientesAtendido > quantidadeDadosBasicos ){
      _corClientesAtendido.add('verde');
    }else{
      _corClientesAtendido.add('desabilitado');
    }
  }

  valoresIniciais(){
    _clientesAtendidoDadosBasico.add(formatterPercentual.format(double.parse(quantidadeDeClientesAtendidoDadosBasicos)));
    _clientesAtendidoCalculado.add(formatterPercentual.format(double.parse(quantidadeDeClientesAtendidoDadosBasicos)));
     margemInicalCalculada = ((faturamentoDadosBasicos -(custoVendasDadosBasicos +custoFixoDadosBasicos + custoInsumosTerceirosDadosBasicos))/faturamentoDadosBasicos)*100;
    _margemInicial.add('${formatterPercentual.format(margemInicalCalculada)}');
    _margemCalculada.add('${formatterPercentual.format(margemInicalCalculada)}');
    _faturamentoInicial.add(valorFormatadoReal(faturamentoDadosBasicos));
    _faturamentoCalculado.add(valorFormatadoReal(faturamentoDadosBasicos));
    _custoInicialVendas.add(valorFormatadoReal(custoVendasDadosBasicos));
    _custoInsumosCalculado.add(valorFormatadoReal(custoVendasDadosBasicos));
    _custoInsumosMercadoria3.add(valorFormatadoReal(custoInsumosTerceirosDadosBasicos));
    _custoTreceirosCalculado.add(valorFormatadoReal(custoInsumosTerceirosDadosBasicos));
    _custoFixoInicialDadosBasicos.add(valorFormatadoReal(custoFixoDadosBasicos));
    _custoFixoCalculado.add(valorFormatadoReal(custoFixoDadosBasicos));
     ticketMedioInicialValor = faturamentoDadosBasicos/double.parse(quantidadeDeClientesAtendidoDadosBasicos);
    _tickeMedioInicial.add( valorFormatadoReal(ticketMedioInicialValor));
    _ticketMedioCalculado.add( valorFormatadoReal(ticketMedioInicialValor));
    _precoInicial.add( valorFormatadoReal(ticketMedioInicialValor));
    _precoMedioCalculado.add( valorFormatadoReal(ticketMedioInicialValor));
    _percentualAddController.add('0');
    _percentualRemoveController.add('0');
    margemAtual =margenDadosBasicos;
    qtdClienteAtual =quantidadeDeClientesAtendidoDadosBasicos;
    percoMedioVendasAtual = ticketMedioInicialValor;
    ticketMedioAtual =ticketMedioInicialValor;
    faturamentoAtual = faturamentoDadosBasicos;
    custoVendasAtual =custoVendasDadosBasicos;
    custosTerceirosAtual= custoInsumosTerceirosDadosBasicos;
    custoFixoAtual = custoFixoDadosBasicos;
  }

   valorFormatadoReal(valor){
     return "R\$ ${formatterMoeda.format(valor)}";
   }
  calculoCampoVariacao(valorDadosBasicos, valorCalculado){
    return ((1-(valorCalculado/valorDadosBasicos))*100)*-1;
  }
  convertMonetarioFloat(element) {
    var data = (element
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    return double.parse(data).truncateToDouble();
  }
}