import 'package:appgestao/blocs/simulador_bloc.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:form_validator/form_validator.dart';

class Simulador extends StatefulWidget {
  const Simulador({Key? key}) : super(key: key);

  @override
  State<Simulador> createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {
  var simuladorBloc;
  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var corFundo = Colors.grey[150];

  void initState() {
    simuladorBloc = SimuladorBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Simulador'),
      drawer: Menu(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Espacamento(),
                  Container(
                    child: const Text(
                      "Para você definir prioridades",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Espacamento(),
                  buildRow(
                    buildStreamBuilder(
                      simuladorBloc.margemIdealController,
                      "Margem desejada",
                      "desabilitado",
                      false,
                      buildIcon(),
                      null,
                    ),
                    buildStreamBuilder(
                      simuladorBloc.margemInformadaController,
                      "Margem informada",
                      "desabilitado",
                      false,
                      buildIcon(),
                      null,
                    ),
                  ),
                  const Espacamento(),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: TextDropdownFormField(
                      //   keyboardType: TextInputType.none,
                      options: const [
                        "Quantidade de vendas",
                        "Ticket médio",
                        "Custo insumos",
                        "Custos produtos 3os",
                        "Outros custo variaveis",
                        "Custo fixo"
                      ],
                      decoration: _styleInput(
                          'Selecione um item ',
                          "padrao",
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 26,
                          )),

                      // dropdownHeight: 120,
                    ),
                  ),
                  buildContainerAddRemove(),
                  const Espacamento(),
                  buildRow(
                    buildStreamBuilder(
                      simuladorBloc.vendasController,
                      "Vendas",
                      "padrao",
                      false,
                      null,
                      null,
                    ),
                    buildStreamBuilder(
                      simuladorBloc.ticketMedioController,
                      "Ticket médio",
                      "padrao",
                      true,
                      null,
                      null,
                    ),
                  ),
                  const Espacamento(),
                  buildContainerFaturamento(),
                  const Espacamento(),
                  buildRow(
                    StreamBuilder(
                        stream: null,
                        builder: (context, snapshot) {
                          return buildStreamBuilder(
                            simuladorBloc.custoInsumosController,
                            "Custo insumos",
                            "padrao",
                            false,
                            null,
                            null,
                          );
                        }),
                    StreamBuilder(
                        stream: null,
                        builder: (context, snapshot) {
                          return buildStreamBuilder(
                            simuladorBloc.custoProdutoController,
                            "Custo produto 3os",
                            "padrao",
                            true,
                            null,
                            null,
                          );
                        }),
                  ),
                  const Espacamento(),
                  buildRow(
                    buildStreamBuilder(
                      simuladorBloc.custoInsumosController,
                      "Outros custos variáveis",
                      "padrao",
                      false,
                      null,
                      null,
                    ),
                    buildStreamBuilder(
                      simuladorBloc.margemDeContribuicaoController,
                      "Margem de contribuição",
                      "desabilitado",
                      true,
                      null,
                      null,
                    ),
                  ),
                  const Espacamento(),
                  buildRow(
                    buildStreamBuilder(
                      simuladorBloc.custoInsumosController,
                      "Custos fixos",
                      "padrao",
                      false,
                      null,
                      null,
                    ),
                    buildStreamBuilder(
                      simuladorBloc.pontoEquilibrioController,
                      "Ponto de equilibrio",
                      "desabilitado",
                      true,
                      null,
                      null,
                    ),
                  ),
                  const Espacamento(),
                  Container(
                    child: StreamBuilder(
                        stream: simuladorBloc.margemResultateController,
                        builder: (context, snapshot) {
                      //    print(snapshot.data);
                          var data = snapshot.data;
                          return buildContainer(
                            "$data",
                            "Margem resultante",
                            "desabilitado",
                            false,
                            null,
                            null,
                          );
                        }),
                  ),
                  const Espacamento(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainerAddRemove() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            width: 190,
            child: TextFormField(
                keyboardType: TextInputType.number,
                //  controller: TextEditingController(text: "$data"),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  suffixIcon: Icon(Icons.percent),
                  fillColor: corFundo,
                  filled: true,
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.green,
                      size: 20.0,
                    ),
                  ),
                  // disabledBorder: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1.0,
                        style: BorderStyle.none),
                  ),
                  border: InputBorder.none,
                  //  labelText: text,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    //  backgroundColor: Colors.white,
                  ),
                  // hintText: 'Quantidade de clientes atendidos',
                ),
                onChanged: null),
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            width: 190,
            child: TextFormField(
                keyboardType: TextInputType.number,
                //  controller: TextEditingController(text: "$data"),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  prefixIcon: Icon(Icons.percent),
                  fillColor: corFundo,
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                      size: 20.0,
                    ),
                  ),
                  // disabledBorder: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1.0,
                        style: BorderStyle.none),
                  ),
                  border: InputBorder.none,
                  //  labelText: text,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    //  backgroundColor: Colors.white,
                  ),
                  // hintText: 'Quantidade de clientes atendidos',
                ),
                onChanged: null),
          ),
        ],
      ),
    );
  }

  Container buildContainerFaturamento() {
    return Container(
      child: StreamBuilder(
          stream: simuladorBloc.faturamentoController,
          builder: (context, snapshot) {
          //  print(snapshot.data);
            var data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Container(
                decoration: buildBoxDecoration(),
                child: StreamBuilder(
                    stream: null,
                    builder: (context, snapshot) {
                      return TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "$data"),
                        decoration:
                            _styleInput("Faturamento", "desabilitado", null),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      );
                    }),
              ),
            );
          }),
    );
  }

/*
 buildStreamBuilder(simuladorBloc.margemInformadaController, "Margem desejada","ops",false, buildIcon()),
                  buildStreamBuilder(simuladorBloc.margemInformadaController, "Margem informada","ops",false, buildIcon()),
 */
  Row buildRow(coluna1, coluna2) {
    const Espacamento();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [coluna1, coluna2],
    );
  }

  Padding buildStreamBuilder(
      stream, inputTitulo, cor, format, icone, onChanged) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
          //  print(snapshot.data);
            var data = snapshot.data;
            return buildContainer(
                "$data", inputTitulo, cor, format, icone, onChanged);
          }),
    );
  }

  Icon buildIcon() {
    return const Icon(
      Icons.percent,
      color: Colors.black54,
      size: 16.0,
    );
  }

  Padding buildContainer(data, inputTitulo, cor, format, icone, onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      child: Container(
        width: 185,
        decoration: buildBoxDecoration(),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              if (format) {
                return TextFormField(
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: "$data"),
                  decoration: _styleInput(inputTitulo, cor, icone),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  onChanged: onChanged,
                );
              } else {
                return TextFormField(
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: "$data"),
                  decoration: _styleInput(inputTitulo, cor, icone),
                  onChanged: onChanged,
                );
              }
            }),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 1,
          offset: Offset(1, 3), // Shadow position
        ),
      ],
    );
  }

  buildSpinBox(String TextDecoretion) {
    return SpinBox(
      min: 1,
      max: 100000000,
      value: 5,
      decoration: buildDecoratorSpinBox(TextDecoretion),
      incrementIcon: const Icon(
        Icons.add,
        color: Colors.green,
      ),
      decrementIcon: const Icon(
        Icons.remove,
        color: Colors.red,
      ),
      onChanged: (onChanged) {},
    );
  }

  buildDecoratorSpinBox(String labelText) {
    return _styleInput(labelText, "ops", null);
  }

  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundo = Colors.orangeAccent[100];
        break;
      case 'desabilitado':
        corFundo = Colors.grey[100];
        break;
      case 'vermelho':
        corFundo = Colors.red[200];
        break;
      case 'verde':
        corFundo = Colors.green[200];
        break;
    }

    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      suffixIcon: suffixIcon,
      fillColor: corFundo,
      filled: true,

      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.orange, width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
}
