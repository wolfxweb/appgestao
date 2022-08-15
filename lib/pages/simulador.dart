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
  var vendasController = TextEditingController();
  var ticketMedioController = TextEditingController();
  var custoInsumosController = TextEditingController();
  var custoProdutoController  = TextEditingController();
  var custoVariavelController = TextEditingController();
  var custoFixoController = TextEditingController();

  var dataVendas;
  var vendasColor = 'padrao';
  var ticketMedioCor = 'padrao';
  var custoInsumosColor = 'padrao';
  var custoProdutoColor = 'padrao';
  var custoVariavelColor = 'padrao';
  var custoFixoColor ='padrao';
  var vendasStatus  = true;
  var valorInicialTicket = "";

  void initState() {
    simuladorBloc = SimuladorBloc();
    var venda = simuladorBloc.getVendas();
      venda.then((data){
        data.forEach((element) {
          vendasController.text = element["qtd"];
        });
    });
    var ticket =  simuladorBloc.calTiketMedio();
    ticket.then((data){
      ticketMedioController.text =  data;
    });
    var custoInsumos  = simuladorBloc.getCustoInsumos();
    custoInsumos.then((data){
      custoInsumosController.text = data;
    });
    var custoProduto = simuladorBloc.getCustoProduto();
    custoProduto.then((data){
      custoProdutoController.text = data;
    });
    var custoVariavel = simuladorBloc.getCustoVariavel();
    custoVariavel.then((data){
      custoVariavelController.text = data;
    });
    var custoFixo = simuladorBloc.getCustoFixo();
    custoFixo.then((data){
      print('data');
      print(data);
      custoFixoController.text = data;
    });

    super.initState();
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
                    StreamBuilder(
                        stream: simuladorBloc.corVendalController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          vendasColor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                                  stream: simuladorBloc.vendasController,
                                  builder: (context, snapshot) {
                                      return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: vendasController,
                                        decoration: _styleInput('vendas', vendasColor , null),
                                        onChanged:  (text){
                                          simuladorBloc.calculoVendas(text);
                                        }
                                      );

                                  }),
                            ),
                          );
                        }),
                    StreamBuilder(
                        stream: simuladorBloc.corTicketMediolController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          ticketMedioCor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                                  stream: simuladorBloc.ticketMedioController,
                                  builder: (context, snapshot) {
                                    var data = snapshot.data;

                                    return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: ticketMedioController,
                                        decoration: _styleInput('Ticket Médio', ticketMedioCor , null),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                                        ],
                                        onChanged:  (text){

                                          simuladorBloc.calculoTicketMedioInput(text);
                                        }
                                    );

                                  }),
                            ),
                          );
                        }),
                  ),
                  const Espacamento(),

                  buildContainerFaturamento(),
                  const Espacamento(),
                  buildRow(
                    StreamBuilder(
                        stream: simuladorBloc.corCustoInsumoslController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          custoInsumosColor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                                  stream: simuladorBloc.custoInsumosController,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: custoInsumosController,
                                        decoration: _styleInput('Custo insumos', custoInsumosColor , null),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                                        ],
                                        onChanged:(text){
                                          simuladorBloc.calculoCustoInsumosInptu(text);
                                        }
                                    );

                                  }),
                            ),
                          );
                        }),
                    StreamBuilder(
                        stream: simuladorBloc.corCustoProdutolController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          custoProdutoColor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                                  stream:  simuladorBloc.custoFixoController,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: custoProdutoController,
                                        decoration: _styleInput('Custo produto 3os', custoProdutoColor , null),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                                        ],
                                        onChanged:(text){
                                          simuladorBloc.calculoCustoProdutoInptu(text);
                                        }
                                    );

                                  }),
                            ),
                          );
                        }),

                  ),
                  const Espacamento(),
                  buildRow(
                    StreamBuilder(
                        stream: simuladorBloc.corCustoVariavelController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          custoVariavelColor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                              //    stream:  simuladorBloc.custoProdutoController,
                                  stream:  simuladorBloc.custoVariavelController,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: custoVariavelController,
                                        decoration: _styleInput('Outros custos variáveis', custoVariavelColor , null),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                                        ],
                                        onChanged:(text){
                                          simuladorBloc.calculoCustoVariavelInptu(text);
                                        }
                                    );

                                  }),
                            ),
                          );
                        }),

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
                    StreamBuilder(
                        stream: simuladorBloc.corCustoFixoController,
                        builder: (context, snapshot) {
                          var dataCor = snapshot.data;
                          custoFixoColor = dataCor.toString();
                          print(dataCor);
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            child: Container(
                              width: 185,
                              decoration: buildBoxDecoration(),
                              child: StreamBuilder(
                                  stream: simuladorBloc.vendasController,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: custoFixoController,
                                        decoration: _styleInput('Custo fixo', custoFixoColor , null),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                                        ],
                                        onChanged:  (text){
                                          simuladorBloc.calculoCustoFixo(text);
                                        }
                                    );

                                  }),
                            ),
                          );
                        }),
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

  buildCalculoVendas() {
   // print('vendas');
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
            return buildContainer("$data", inputTitulo, cor, format, icone, onChanged);
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
                  onChanged: (text){
                    onChanged;
                },
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
