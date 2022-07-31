import 'package:appgestao/blocs/calculadora_bloc.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
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
  var _precoAtualController = TextEditingController();
  var _precoInsumosController = TextEditingController();
  var _margemDesejadaController = TextEditingController();
  var _btnStatus = false;
  var _pesquisaController = TextEditingController();

  List historico = [];

  void initState() {
    calBloc = CalculadoraBloc();
    historico = calBloc.selectHistorico();
  }

  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var corFundo = Colors.grey[150];
  var _mostrarComponentes = false;
  var _verHistorico = false;

  @override
  Widget build(BuildContext context) {
    print(historico);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _verHistorico
                          ? Container(
                              width: 100,
                              //   decoration: buildBoxDecoration(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 6.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    child: _verHistorico
                                        ? Text('Voltar ')
                                        : Text('Ver o histórico'),
                                    onPressed: () {
                                      setState(() {
                                        _verHistorico = !_verHistorico;
                                        historico.clear();
                                        calBloc.selectHistorico();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 18),
                                      primary: Colors.orange,
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      padding: EdgeInsets.all(14),
                                    ),
                                  )),
                            )
                          : Container(),
                      //width: 220,
                      _verHistorico
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 6.0),
                              child: Container(
                                width: 220,
                                decoration: buildBoxDecoration(),
                                child: StreamBuilder(
                                    stream: null,
                                    builder: (context, snapshot) {
                                      var data = snapshot.data;
                                      return TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: _pesquisaController,
                                        decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                            fillColor: Colors.orangeAccent[100],
                                            filled: true,
                                            border: InputBorder.none,
                                            labelText: "Localizar produto",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              //  backgroundColor: Colors.white,
                                            ),
                                            suffixIcon:  IconButton(
                                              icon: const Icon(Icons.refresh),
                                              color: Colors.black54,
                                              onPressed: () {
                                                     _pesquisaController.text ="";
                                                     setState(() {
                                                        historico.clear();
                                                        historico =  calBloc.selectHistorico();
                                                     });
                                              },
                                            )),
                                        onChanged: (text) {
                                          if(historico.isEmpty){
                                          //  alerta.openModal(context, 'Nenhum item encontrado');
                                          }
                                          setState(() {
                                            historico.retainWhere((element){
                                              return element['produto'].toString().contains(text.toString());
                                            });
                                          });
                                        },
                                      );
                                    }),
                              ),
                            )
                          : Container(),
                    ],
                  ),

                  const SizedBox(
                    height: 6.0,
                  ),

                  //  const Espacamento(),
                  _verHistorico ? Container(
                          child: ListView.builder(
                                  shrinkWrap: true,
                                  // padding: const EdgeInsets.all(8),
                                  itemCount: historico.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildContainer(index, historico);
                                  })
                       )

                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Container(
                          decoration: buildBoxDecoration(),
                          child: StreamBuilder(
                              stream: null,
                              builder: (context, snapshot) {
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
                        )
                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Container(
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
                                  controller: _precoAtualController,
                                  decoration: _styleInput(
                                      "Preço de venda atual", "cor"),
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
                                          _btnStatus = true;
                                        } else {
                                          _mostrarComponentes = false;
                                          _btnStatus = false;
                                        }
                                      });
                                    } else {
                                      if (text.isEmpty) {
                                        setState(() {
                                          _mostrarComponentes = false;
                                          _btnStatus = false;
                                        });
                                      }
                                    }
                                  },
                                );
                              }),
                        )
                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Container(
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
                                  controller: _precoInsumosController,
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
                                          _btnStatus = true;
                                        } else {
                                          _mostrarComponentes = false;
                                          _btnStatus = false;
                                        }
                                      });
                                    } else if (text.isEmpty) {
                                      setState(() {
                                        _mostrarComponentes = false;
                                        _btnStatus = false;
                                      });
                                    }
                                  },
                                );
                              }),
                        )
                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Row(
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
                                          controller: TextEditingController(
                                              text: "$data %"),
                                          decoration: _styleInput(
                                              "Margem atual", "ops"),
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
                                      controller: _margemDesejadaController,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
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
                                                _margemDesejada
                                                    .text.isNotEmpty) {
                                              _mostrarComponentes = true;
                                              _btnStatus = true;
                                            } else {
                                              _mostrarComponentes = false;
                                              _btnStatus = false;
                                            }
                                          });
                                        } else if (text.isEmpty) {
                                          setState(() {
                                            _mostrarComponentes = false;
                                            _btnStatus = false;
                                          });
                                        }
                                      },
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Container(
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
                                        controller: TextEditingController(
                                            text: "$data "),
                                        decoration: _styleInput("", "ops"),
                                        inputFormatters: [
                                          // obrigatório
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          CentavosInputFormatter(
                                              moeda: true, casasDecimais: 2)
                                        ],
                                      )
                                    : Container();
                              }),
                        )
                      : Container(),
                  const Espacamento(),
                  const Espacamento(),
                  !_verHistorico
                      ? Row(
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
                                                text: "R\$ $data"),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),

                                            decoration: _styleInput(
                                                "Preço sugerido", "1"),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
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
                                                "Relação com preço atual",
                                                "ops"),
                                          )
                                        : Container();
                                  }),
                            ),
                          ],
                        )
                      : Container(),
                  const Espacamento(),
                  !_verHistorico
                      ? Container(
                          decoration: buildBoxDecoration(),
                          child: StreamBuilder(
                              stream: calBloc.outMsgPrecoSugerido,
                              builder: (context, snapshot) {
                                var data = snapshot.data.toString();
                                var obs = true;
                                if(data.isEmpty){
                                  print('data');
                                  obs = false;

                                }

                                return _mostrarComponentes && obs
                                    ? TextFormField(
                                        validator: ValidationBuilder()
                                            .maxLength(50)
                                            .required()
                                            .build(),
                                        keyboardType: TextInputType.none,
                                        enabled: false,
                                        maxLines: 6,
                                        controller: TextEditingController(
                                            text: "$data"),
                                        decoration: _styleInput("", "ops"),
                                      )
                                    : Container();
                              }),
                        )
                      : Container(),
                  /*
                  const Espacamento(),
                  !_mostrarComponentes
                      ? Container(
                          child: !_verHistorico
                              ? const Text(
                                  'Preencha os campos acima',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                        )
                      : Container(),

                   */
                  const Espacamento(),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   mainAxisSize: MainAxisSize.max,
                    //  crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      !_verHistorico
                          ? Container(
                              width: 150,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    child: _verHistorico
                                        ? Text('Voltar Calculadora')
                                        : Text('Ver o histórico'),
                                    onPressed: () {
                                      setState(() {
                                        _verHistorico = !_verHistorico;
                                        _margemDesejadaController.text = "";
                                        _precoInsumosController.text = "";
                                        _precoAtualController.text = "";
                                        _precoAtual.text = "";
                                        _precoInsumos.text = "";
                                        _margemDesejada.text = "";
                                        _produto.text = "";
                                        _mostrarComponentes = false;
                                        _btnStatus = false;
                                        _pesquisaController.text ="";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 18),
                                      primary: Colors.orange,
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      padding: EdgeInsets.all(14),
                                    ),
                                  )),
                            )
                          : Container(),
                      !_verHistorico
                          ? Container(
                              width: 150,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    child: const Text('Salvar'),
                                    onPressed:
                                        _btnStatus ? _buildOnPressed : null,
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 18),
                                      primary: Colors.orange,
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      padding: EdgeInsets.all(14),
                                    ),
                                  )),
                            )
                          : Container()
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainer(int index, historico) {
    print(index);
    var produto = historico[index]['produto'].toString();
    var data = historico[index]['data'].toString();
    var preco_atual = historico[index]['preco_atual'].toString();
    var preco_sugerido = historico[index]['preco_sugerido'].toString();
    var margem_desejada = historico[index]['margem_desejada'].toString();
    var margem_atual = historico[index]['margem_atual'].toString();

    var id = historico[index]['id'];
    print('id');
    print(id);

    return Container(
      // height: 250,
      // color: Colors.amber,
      // child: Center(child: Text(historico[index]['produto'].toString())),
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //  mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
                title: Text("Produto: $produto"),
                subtitle: Text("Data: $data"),
                trailing: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onTap: () {
                  confrimModal(context, id, index);
                  //  calBloc.excluirHistorico(id);
                  //   historico.removeAt(index);

                  setState(() {
                   // historico.clear();
                   // calBloc.selectHistorico();
                  });
                }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preco Atual: $preco_atual"),
                  Text("Preço Sugerido: $preco_sugerido"),
                  Text("Margem Desejada: $margem_desejada"),
                  Text("Margem Atual: $margem_atual"),
                ],
              ),
            ),
            const Espacamento(),
          ],
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
          color: Colors.black12,
          blurRadius: 1,
          offset: Offset(1, 3), // Shadow position
        ),
      ],
    );
  }

  _buildOnPressed() {
    if (_produto.text.isEmpty) {
      alerta.openModal(context, 'Campo produto é obrigatório.');
      return;
    }

    calBloc.savarCalculo(_produto.text).then((value) {
      var alert = AlertSnackBar();
      historico.clear();
      alert.alertSnackBar(
          context, Colors.green, 'Cadastro realizado com sucesso.');
      calBloc.selectHistorico();
      setState(() {
        _margemDesejadaController.text = "";
        _precoInsumosController.text = "";
        _precoAtualController.text = "";
        _precoAtual.text = "";
        _precoInsumos.text = "";
        _margemDesejada.text = "";
        _produto.text = "";
        _mostrarComponentes = false;
        _btnStatus = false;
        _pesquisaController.text ="";
      });
    });

    setState(() {
      //  historico = calBloc.selectHistorico();
    });
  }

  confrimModal(context, id, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Deseja mesmo excluir, esta ação é ireversivel.",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
              softWrap: true,
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  calBloc.excluirHistorico(id).then((value) {
                    var alert = AlertSnackBar();
                    // historico.clear();
                    alert.alertSnackBar(context, Colors.green,
                        'Exclusão realizada com sucesso');
                    //  calBloc.selectHistorico();
                    setState(() {
                      //  _verHistorico = !_verHistorico;
                      _pesquisaController.text ="";
                      historico.clear();
                      calBloc.selectHistorico();
                    });
                  });

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
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
