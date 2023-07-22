import 'package:appgestao/blocs/gestao_prioridade_bloc.dart';
import 'package:appgestao/blocs/simulador_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/telaAjudaSimulador.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:form_validator/form_validator.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class GestaoPrioridade extends StatefulWidget {
  const GestaoPrioridade({Key? key}) : super(key: key);

  @override
  State<GestaoPrioridade> createState() => _GestaoPrioridadeState();
}

/*
* Esta tela e uma alteração da tela  simulador  como o cleinte esta alterando algumas formulas  a tela simulador pode não calcular corretamente
*
* */

class _GestaoPrioridadeState extends State<GestaoPrioridade> {
  var alerta = AlertModal();
  var header = HeaderAppBar();
  var info = AlertSnackBar();
  var route = PushPage();

  NumberFormat formatterPercentual = NumberFormat("0.00");
  //var corFundo = Colors.grey[150];
  var corFundo = Color.fromRGBO(159, 105, 56, 0.5);
  var corFundos =Color.fromRGBO(159, 105, 56, 0.5);
  var clientesAtendidosVariacao = TextEditingController();

  var vendasController = TextEditingController();
  var ticketMedioController = TextEditingController();
  var custoInsumosController = TextEditingController();
  var custoProdutoController = TextEditingController();
  var custoVariavelController = TextEditingController();
  var custoFixoController = TextEditingController();
  var addController = TextEditingController();
  var removeController = TextEditingController();
  var ticketMedioDadosBasicoController = TextEditingController();


  var selectController = "";

  var dataVendas;
  var vendasColor = 'desabilitado';
  var ticketMedioCor = 'desabilitado';
  var custoInsumosColor = 'desabilitado';
  var custoProdutoColor = 'desabilitado';
  var custoVariavelColor = 'desabilitado';
  var custoFixoColor = 'desabilitado';
  var vendasStatus = true;
  var valorInicialTicket = "";
  var _dadosBasicoNULL = false;
  var simuladorBloc;
  var addRemoveInput = false;
  //**//

  var clientesAtendidoDadosBasico = TextEditingController();
  var clientesAtendido = TextEditingController();
  var clientesVariacao = TextEditingController();

  var tickerMedioVariacao = TextEditingController();
  var tickerMedioInicial = TextEditingController();
  var faturamentoVariacao= TextEditingController();
  var ticketMedioDadosBasico = "";
   var bloc;
  //**//
  final _formKey = GlobalKey<FormState>();
  var color = const Color.fromRGBO(1, 57, 44, 1);
  @override
  void initState() {
    simuladorBloc = SimuladorBloc();
    bloc = gestao_prioridade_bloc();

    addController.text = '';
    removeController.text = '';

    super.initState();
    setState(() {
      clientesAtendidosVariacao.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.getAppBar('Gestão de prioridades'),
        drawer: Menu(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Espacamento(),
                  buidTitulo(context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selecione um item'),
                      buildTextDropdownFormField(),
                      buildNewRemoveAdd(context),
                    ],
                  ),
                  const Espacamento(),
                  builtItulo("Margem"),
                  buildInputs(
                      context,
                      bloc.margemInicial,
                      bloc.corMargem,
                      bloc.margemCalculada,
                      bloc.margemVariacao,
                      null,
                      null,
                      null,
                      "Margem",
                      null),
                  const Espacamento(),
                  const Espacamento(),
                  builtItulo("Clientes atendidos"),
                  buildInputs(
                      context,
                      bloc.clientesAtendidoDadosBasico,
                      bloc.corClientesAtendido,
                      bloc.clientesAtendidoCalculado,
                      bloc.clientesAtendidoVaricacao,
                      null,
                      null,
                      null,
                      'Clientes atendidos',
                      null
                  ),
                  const Espacamento(),
                  builtItulo("Preço médio das vendas"),
                  buildInputs(context,
                      bloc.precoInicial,
                      bloc.corPrecoMedioVendas,
                      bloc.precoMedioCalculado,
                      bloc.variacaoPrecoMedioVendas,
                      null,
                      null,
                      null,
                      "Preço médio das vendas",
                      null),
                  const Espacamento(),
               /*   const Text(
                    "Preparado para vender mais, com qualidade?",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  *
                */
                //  const Espacamento(),
                  builtItulo("Ticket médio"),
                  buildInputs(
                      context,
                      bloc.tickeMedioInicial,
                      bloc.corTicketMedio,
                      bloc.ticketMedioCalculado,
                      bloc.variacaoTicketMedio,
                      tickerMedioInicial,
                      ticketMedioController,
                      tickerMedioVariacao,
                      'Ticket Médio',
                      ticketMedioCor
                  ),
                  const Espacamento(),
                  builtItulo("Faturamento"),
                  buildInputs(
                      context,
                      bloc.faturamentoInicial,
                      bloc.corfaturamento,
                      bloc.faturamentoCalculado,
                      bloc.faturamentoVariacao,
                      null,
                      null,
                      faturamentoVariacao,
                      'Faturamento',
                      "desabilitado"
                  ),
                  const Espacamento(),
                  builtItulo("Custo das Vendas"),
                  buildInputs(
                      context,
                      bloc.custoInicialVendas,
                      bloc.corCustoInsumos,
                      bloc.custoInsumosCalculado,
                      bloc.custoFixoVariacao,
                      null,
                      null,
                      null,
                      "Custo das Vendas",
                      null),
                  const Espacamento(),
                  builtItulo("Custo dos insumos e mercadorias de 3°"),
                  buildInputs(
                    // nome esta difenrente pois cliente quis alterar o nome do campo
                      context,
                      bloc.custoInsumosMercadoria3,
                      bloc.corCustoProduto,
                      bloc.custoTreceirosCalculado,
                      bloc.variacaoCustoDe3,
                      null,
                      null,
                      faturamentoVariacao,
                      'Custos dos insumos e mercadoris de 3°',
                      "desabilitado"
                  ),

                  const Espacamento(),
                  builtItulo("Custos Fixos"),
                  buildInputs(
                      context,
                      bloc.custoFixoInicialDadosBasicos,
                      bloc.corCustoFixo,
                      bloc.custoFixoCalculado,
                      bloc.custoFixosVariacao,
                      null,
                      null,
                      null,
                      "Custos Fixos",
                      null),
                  const Espacamento(),
             /*     builtItulo("Margem"),
                  buildInputs(context,null,null, null, null, null, null, null, "Custos Fixos",null),
                  const Espacamento(),
                  const Espacamento(),
                  const Text('Vender mais sem aumentar custo fixo?',
                      style: TextStyle(fontSize: 16.0)),
                  const Espacamento(),
                  const Text('Trabalha com capacidade ociosa?',
                      style: TextStyle(fontSize: 16.0)),
                      */
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        primary: const Color.fromRGBO(1, 57, 44, 1),
                      ),
                      onPressed: () {

                        route.pushPage(context, GestaoPrioridade());
                      },
                      child: const Text("Limpar"),
                    ),
                  ),
                  const Espacamento(),
                  const Espacamento(),
                  const Espacamento(),
                  const Espacamento(),
                ],
              ),
            ),
          ),
        ));
  }

  Align builtItulo(titulo) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(titulo),
    );
  }

  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundos = Colors.white10;
        break;
      case 'desabilitado':
        corFundos = Colors.green;
        break;
      case 'vermelho':
        corFundos = Colors.red;
        break;
      case 'verde':
        corFundos = Colors.green;
        break;
      case 'null':
        corFundos = Color.fromRGBO(245, 245, 245, 1);
        break;
    }

    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      fillColor: corFundos,
      //  fillColor:  Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      border: InputBorder.none,
      labelStyle: new TextStyle(color: Colors.white, fontSize: 16.0),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  Container buildInputs(BuildContext context, stream1, stream2, stream3, stream4,
      controller1, controller2, controller3,campo, corCampo) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: color,
            width: 1.0,
            style: BorderStyle.solid,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Container(
                  child: StreamBuilder(
                      stream: stream1,
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                      //  print(data);
                        if (snapshot.data == null) {
                          data = "";
                        }
                        return TextFormField(
                          enabled: false,
                          controller: controller1 = TextEditingController(text: '$data'), //controller1,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            fillColor: Color.fromRGBO(211, 211, 211, 1),
                            filled: true,
                            suffixIcon: Icon(
                              Icons.percent,
                              color: Color.fromRGBO(211, 211, 211, 1),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color: Color(0xFFffd600)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(1, 57, 44, 1),
                                  width: 1.0),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Container(
                  child:  StreamBuilder(
                    stream: stream2,
                    builder: (context, snapshot) {
                      var dataCor = snapshot.data;
                      corCampo = dataCor.toString();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Container(
                          //  width: 185,
                          width: MediaQuery.of(context).size.width*0.45,
                         // decoration: buildBoxDecoration(),
                          child: StreamBuilder(
                              stream: stream3,
                              builder: (context, snapshot) {
                                var data = snapshot.data;
                                if(!snapshot.hasData){
                                  data ="";
                                }

                                return TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    controller: controller2 = TextEditingController(text: '$data'),
                                    decoration: _styleInput( campo, corCampo, null),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      CentavosInputFormatter(
                                          moeda: true, casasDecimais: 2)
                                    ],
                                    onChanged: (text) {

                                     if( campo == 'Ticket Médio'){
                                       simuladorBloc.calculoTicketMedioInput(text);
                                     }
                                    },
                                );
                              }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.31,
            child: inputPercentual(context, stream4, controller3),
          ),
        ],
      ),
    );
  }

  Container buildClientesAtendidos(BuildContext context, stream1, stream2,
      stream3, controller1, controller2, controller3) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: color,
            width: 1.0,
            style: BorderStyle.solid,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Container(
                  child: StreamBuilder(
                      stream: stream1,
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                        if (snapshot.data == null) {
                          data = "";
                        }
                        return TextFormField(
                          enabled: false,
                          controller: controller1 = TextEditingController(
                              text: '$data'), //controller1,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            fillColor: Color.fromRGBO(211, 211, 211, 1),
                            filled: true,
                            suffixIcon: Icon(
                              Icons.percent,
                              color: Color.fromRGBO(211, 211, 211, 1),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color: Color(0xFFffd600)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(1, 57, 44, 1),
                                  width: 1.0),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Container(
                  child: StreamBuilder(
                      stream: stream2,
                      builder: (context, snapshot) {
                        return TextFormField(
                            // enabled: false,
                            keyboardType: TextInputType.number,
                            controller: controller2,
                            // controller: null,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              //fillColor:Color.fromRGBO(1, 57, 44, 1),
                              fillColor: Color.fromRGBO(245, 245, 245, 1),
                              filled: true,
                              border: InputBorder.none,

                              focusedBorder: OutlineInputBorder(
                                // borderSide: BorderSide(color: Color(0xFFffd600)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(1, 57, 44, 1),
                                    width: 1.0),
                              ),
                              /*   border:  OutlineInputBorder(
                                             borderSide: BorderSide(color: Colors.white),
                                          //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                                          ),*/
                              // hintText: 'Quantidade de clientes atendidos',
                            ),
                            onChanged: (value) {
                              var controllerValeu = (controller1.text
                                  .toString()
                                  .replaceAll("R\$", "")
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.'));
                              setState(() {
                                if (value.isNotEmpty) {
                                  var calc = (double.parse(value) /
                                          double.parse(controllerValeu)) *
                                      100;
                                  controller3.text = formatterPercentual
                                      .format(calc)
                                      .toString();
                                } else {
                                  controller3.text = "";
                                }
                              });
                            });
                      }),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.31,
            child: inputPercentual(context, stream3, controller3),
          ),
        ],
      ),
    );
  }

  Container inputPercentual(BuildContext context, stream3, controller3) {
    return Container(
      // height: 100,
      // decoration: buildBuildBoxDecoration(),
      padding: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.40,
      // height: MediaQuery.of(context).size.width * 0.88,
      child: StreamBuilder(
          stream: stream3,
          builder: (context, snapshot) {
            var data = snapshot.data;
          //  print(data);
          //  print('data');
            if (snapshot.data == null) {
              data = "";
            }
            return TextFormField(
              enabled: false,
              //   keyboardType: TextInputType.number,
              // maxLines: 5,
              inputFormatters: [
                // obrigatório
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(moeda: true, casasDecimais: 2)
              ],
              controller: controller3 = TextEditingController(text: '$data'),
              // controller: null,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                //      contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                fillColor: Color.fromRGBO(211, 211, 211, 1),
                // fillColor:  Color.fromRGBO(105, 105, 105, 1),
                filled: true,
                border: InputBorder.none,
                // filled: true,
                suffixIcon: Icon(
                  Icons.percent,
                  color: Colors.black54,
                  size: 20,
                ),
                // disabledBorder: true,
                focusedBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Color(0xFFffd600)),
                  borderSide: BorderSide(
                      color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
                ),
                /*   border:  OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.white),
                //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                ),*/
                // hintText: 'Quantidade de clientes atendidos',
              ),
            );
          }),
    );
  }

  Container buildNewRemoveAdd(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Espacamento(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Indique um percentual"),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                      // enabled: false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: addController,
                      decoration: buildInputDecoration(null),
                      onChanged: (text) {
                        // simuladorBloc.calculoPercentual(text,1,valorInicialTicket,2,context);
                      }),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                  width: MediaQuery.of(context).size.width * 0.47,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            const Text(
                              'Aumentar',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (addController.text.isEmpty) {
                                  alerta.openModal(
                                      context, "Adicione o percentual.");
                                } else {
                                  bloc.calculoPercentual(
                                      addController.text,
                                      1,
                                      valorInicialTicket,
                                      1,
                                      context);
                                  addController.text = '';
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                }
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color.fromRGBO(1, 57, 44, 1),
                                size: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            Text(
                              'Diminuir',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (addController.text.isEmpty) {
                                  alerta.openModal(
                                      context, "Adicione o percentual.");
                                } else {

                                  bloc.calculoPercentual(
                                      addController.text,
                                      2,
                                      valorInicialTicket,
                                      2,
                                      context);
                                  addController.text = '';
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                }
                              },
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Color.fromRGBO(1, 57, 44, 1),
                                size: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextDropdownFormField buildTextDropdownFormField() {
    return TextDropdownFormField(
      //keyboardType: TextInputType.none,
      onChanged: (dynamic text) {
        removeController.text = '';
        addController.text = '';
        //   simuladorBloc.setPercentualInput();
        setState(() {
          valorInicialTicket = text;
          addRemoveInput = true;
        });
      },
      options: const [
        "Quantidade clientes atendidos",
      //  "Quantidade de vendas",
        "Preço médio de vendas",
        "Ticket médio",
        "Custo das vendas",
        "Custos dos insumos e mercadorias de 3°",
      //  "Outros custo variaveis",
        "Custo fixo"
      ],
      decoration: buildInputDecoration(const Icon(
        Icons.arrow_drop_down,
        color: Color.fromRGBO(1, 57, 44, 1),
        size: 26,
      )),
      dropdownHeight: 350,
    );
  }

  InputDecoration buildInputDecoration(suffixIcon) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

      fillColor: Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide: BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:
            BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),
      // labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        //  backgroundColor: Colors.white,
      ),
      suffixIcon: suffixIcon,
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  Container buidTitulo(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          route.pushPage(context, const TelaAjudaSimulador());
        },
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: 'Para você definir prioridades',
            prefixIcon: Icon(
              Icons.help,
              color: Color.fromRGBO(1, 57, 44, 1),
              size: 25,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
