import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
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
  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var corFundo = Colors.grey[150];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Simulador'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Espacamento(),
                    const Text(
                      'PARA VOCÊ DEFINIR PRIORIDADES',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Espacamento(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
                          child: Container(
                            width: 135,
                            decoration: buildBoxDecoration(),
                            child:TextFormField(
                              validator: ValidationBuilder()
                                  .maxLength(50)
                                  .required()
                                  .build(),
                              keyboardType: TextInputType.number,
                              controller: null,
                              decoration:
                              _styleInput("Margem ideal ", "ops",null),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(moeda: true, casasDecimais: 2)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
                          child: Container(
                            width: 145,
                            decoration: buildBoxDecoration(),
                            child:TextFormField(
                              validator: ValidationBuilder()
                                  .maxLength(50)
                                  .required()
                                  .build(),
                              keyboardType: TextInputType.number,
                              controller: null,
                              decoration:
                              _styleInput("Margem informada ", "ops",null),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(moeda: true, casasDecimais: 2)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Espacamento(),
                    // const Text("Custo de insumos para seu preparo ou de mercadoria para vendas"),
                    // const Espacamento(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
                     child: Container(
                        decoration: buildBoxDecoration(),
                        child: TextFormField(
                          maxLines: 3,
                          validator: ValidationBuilder()
                              .maxLength(50)
                              .required()
                              .build(),
                          keyboardType: TextInputType.number,
                          controller: null,
                          decoration:
                              _styleInput("", "ops",null),
                          inputFormatters: [
                            // obrigatório
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true, casasDecimais: 2)
                          ],
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),
                            //  padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Custos insumos");
                                }),
                          ),
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),

                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Custo produto 3ºs");
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),
                            //  padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Outros custos");
                                }),
                          ),
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Margem contribuição");
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),
                            //  padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Custos fixos");
                                }),
                          ),
                          Container(
                            width: 150,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Ponto equilibio");
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      decoration: buildBoxDecoration(),
                    //  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration: _styleInput(
                            "Margem resultante",
                            "ops", null
                        ),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      ),
                    ),

                  ],
                ),
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
      onChanged:(onChanged){

      },
    );
  }

  buildDecoratorSpinBox(String labelText) {
    return   _styleInput(labelText, "ops",null);
  }

  _styleInput(String text, String modal, suffixIcon) {
    if (modal == "cor") {
      corFundo = Colors.grey[100];
    } else {
      corFundo = Colors.orangeAccent[100];
    }
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      suffixIcon:suffixIcon,
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
