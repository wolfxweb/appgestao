import 'package:appgestao/blocs/calculadora_bloc.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:form_validator/form_validator.dart';
import 'package:appgestao/componete/alertamodal.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({Key? key}) : super(key: key);

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  var calBloc;

  var margemPrecoAtual = TextEditingController();
  var _precoAtual = TextEditingController();
  var _precoInsumos = TextEditingController();
  var _margemDesejada = TextEditingController();
  var _produto = TextEditingController();
  void initState() {
    calBloc = CalculadoraBloc();
  }

  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var corFundo = Colors.grey[150];
  var _mostrarComponentes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Calculadora preços'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            //         const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: StreamBuilder(
                        stream: null,
                        builder: (context, snapshot) {
                          //     print(snapshot.data);

                          var data = snapshot.data;
                          return TextFormField(
                            validator: ValidationBuilder()
                                .maxLength(50)
                                .required()
                                .build(),
                            //  keyboardType: TextInputType.number,
                            controller: _produto,
                            decoration: _styleInput("Produto", "cor"),
                            onChanged: (text) {},
                          );
                        }),
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: StreamBuilder(
                        stream: calBloc.outPrecoVendaAtualController,
                        builder: (context, snapshot) {
                          //  print(snapshot.data);
                          var data = snapshot.data;
                          return TextFormField(
                            validator: ValidationBuilder()
                                .maxLength(50)
                                .required()
                                .build(),
                            keyboardType: TextInputType.number,
                            controller: null,
                            decoration:
                                _styleInput("Preço de venda atual", "cor"),
                            inputFormatters: [
                              // obrigatório
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter(
                                  moeda: true, casasDecimais: 2)
                            ],
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                calBloc.percoVendaAtual(text);
                                setState(() {
                                  _precoAtual.text = text;
                                  if (_precoAtual.text.isNotEmpty &&
                                      _precoInsumos.text.isNotEmpty &&
                                      _margemDesejada.text.isNotEmpty) {
                                    _mostrarComponentes = true;
                                  } else {
                                    _mostrarComponentes = false;
                                  }
                                });
                              } else {
                                if (text.isEmpty) {
                                  setState(() {
                                    _mostrarComponentes = false;
                                  });
                                }
                              }
                            },
                          );
                        }),
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: StreamBuilder(
                        stream: calBloc.outCustosComInsumosController,
                        builder: (context, snapshot) {
                          //  print(snapshot.data);

                          var data = snapshot.data;
                          return TextFormField(
                            validator: ValidationBuilder()
                                .maxLength(50)
                                .required()
                                .build(),
                            keyboardType: TextInputType.number,
                            controller: null,
                            decoration: _styleInput(
                                "Preço dos insumos ou da mercadoria adquirida",
                                "cor"),
                            inputFormatters: [
                              // obrigatório
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter(
                                  moeda: true, casasDecimais: 2)
                            ],
                            onChanged: (text) {
                              //  print(text);
                              //calculadoraCusto(text)
                              if (text.isNotEmpty) {
                                calBloc.calculadoraCusto(text);
                                setState(() {
                                  _precoInsumos.text = text;
                                  if (_precoAtual.text.isNotEmpty &&
                                      _precoInsumos.text.isNotEmpty &&
                                      _margemDesejada.text.isNotEmpty) {
                                    _mostrarComponentes = true;
                                  } else {
                                    _mostrarComponentes = false;
                                  }
                                });
                              } else if (text.isEmpty) {
                                setState(() {
                                  _mostrarComponentes = false;
                                });
                              }
                            },
                          );
                        }),
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   mainAxisSize: MainAxisSize.max,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        decoration: buildBoxDecoration(),
                        child: _mostrarComponentes
                            ? StreamBuilder(
                                stream: calBloc.outCalculoMargem,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  //var margemPrecoAtual = data.;
                                  return TextFormField(
                                    /// validator: ValidationBuilder().maxLength(50).required().build(),
                                    keyboardType: TextInputType.none,
                                    enabled: false,
                                    controller:
                                        TextEditingController(text: "$data %"),
                                    decoration:
                                        _styleInput("Margem atual", "ops"),

                                  );

                                })
                            : null,
                      ),
                      Container(
                        width: 180,
                        decoration: buildBoxDecoration(),
                        child: StreamBuilder(
                            stream: null,
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              return TextFormField(
                                validator: ValidationBuilder()
                                    .maxLength(5)
                                    .required()
                                    .build(),
                                keyboardType: TextInputType.number,
                                controller: null,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

                                  fillColor: Colors.orangeAccent[100],
                                  filled: true,
                                 suffixIcon: const Icon(
                                     Icons.percent,
                                     color: Colors.black54,
                                     size: 20.0,
                                 ),
                                 /* focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 1.0, style: BorderStyle.none),
                                  ),*/
                                  border: InputBorder.none,
                                  labelText: 'Margem desejada',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    // backgroundColor: Colors.white,
                                  ),
                                ),
                                onChanged: (text) {
                                  //      print(text);
                                  //calculadoraCusto(text)
                                  if (text.isNotEmpty) {
                                    calBloc.margemDesejada(text);
                                    setState(() {
                                      _margemDesejada.text = text;
                                      if (_precoAtual.text.isNotEmpty &&
                                          _precoInsumos.text.isNotEmpty &&
                                          _margemDesejada.text.isNotEmpty) {
                                        _mostrarComponentes = true;
                                      } else {
                                        _mostrarComponentes = false;
                                      }
                                    });
                                  } else if (text.isEmpty) {
                                    setState(() {
                                      _mostrarComponentes = false;
                                    });
                                  }
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: StreamBuilder(
                        stream: calBloc.outMsgMargem,
                        builder: (context, snapshot) {
                          //    print(snapshot.data);
                          var data = snapshot.data;
                          return _mostrarComponentes
                              ? TextFormField(
                                  validator: ValidationBuilder()
                                      .maxLength(50)
                                      .required()
                                      .build(),
                                  keyboardType: TextInputType.none,
                                  enabled: false,
                                  maxLines: 3,
                                  controller:
                                      TextEditingController(text: "$data "),
                                  decoration: _styleInput("", "ops"),
                                  inputFormatters: [
                                    // obrigatório
                                    FilteringTextInputFormatter.digitsOnly,
                                    CentavosInputFormatter(
                                        moeda: true, casasDecimais: 2)
                                  ],
                                )
                              : Container();
                        }),
                  ),
                  const Espacamento(),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   mainAxisSize: MainAxisSize.max,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        decoration: buildBoxDecoration(),
                        child: StreamBuilder(
                            stream: calBloc.outCaculoPrecoSugerido,
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              return _mostrarComponentes
                                  ? TextFormField(
                                      //  validator: ValidationBuilder().maxLength(50).required().build(),
                                      keyboardType: TextInputType.none,
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "R\$ $data"

                                      ),
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),


                                      decoration:
                                          _styleInput("Preço sugerido", "1"),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    )
                                  : Container();
                            }),
                      ),
                      Container(
                        width: 180,
                        decoration: buildBoxDecoration(),
                        child: StreamBuilder(
                            stream: calBloc.outRelacaoPrecoController,
                            builder: (context, snapshot) {
                              var data = snapshot.data.toString();
                              return _mostrarComponentes
                                  ? TextFormField(
                                      validator: ValidationBuilder()
                                          .maxLength(50)
                                          .required()
                                          .build(),
                                      keyboardType: TextInputType.none,
                                      enabled: false,
                                      controller: TextEditingController(
                                          text: "$data %"),
                                      decoration: _styleInput(
                                          "Relação com preço atual", "ops"),
                                    )
                                  : Container();
                            }),
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: StreamBuilder(
                        stream: calBloc.outMsgPrecoSugerido,
                        builder: (context, snapshot) {
                          var data = snapshot.data.toString();
                          return _mostrarComponentes
                              ? TextFormField(
                                  validator: ValidationBuilder()
                                      .maxLength(50)
                                      .required()
                                      .build(),
                                  keyboardType: TextInputType.none,
                                  enabled: false,
                                  maxLines: 6,
                                  controller:
                                      TextEditingController(text: "$data"),
                                  decoration: _styleInput("", "ops"),
                                )
                              : Container();
                        }),
                  ),
                  const Espacamento(),
                  _mostrarComponentes
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   mainAxisSize: MainAxisSize.max,
                          //  crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    child: const Text('Ver o histórico'),
                                    onPressed: _buildOnPressed,
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 18),
                                      primary: Colors.orange,
                                    ),
                                  )),
                            ),
                            Container(
                              width: 150,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    child: const Text('Salvar'),
                                    onPressed: _buildOnPressed,
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 18),
                                      primary: Colors.orange,
                                    ),
                                  )),
                            ),
                          ],
                        )
                      : const Text(
                          'Preencha os campos acima',
                          style: TextStyle(fontSize: 24,color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 1,
          offset: Offset(1, 3), // Shadow position
        ),
      ],
    );
  }

  _buildOnPressed() {
    calBloc.savarCalculo(_produto.text);
  }

  buildSpinBox(String TextDecoretion) {
    return SpinBox(
      min: 1,
      max: 10,
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
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        labelText: labelText);
  }

  _styleInput(String text, String modal) {
    if (modal == "cor") {
      corFundo = Colors.orangeAccent[100];
    } else {
      corFundo = Colors.grey[100];
    }
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

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
