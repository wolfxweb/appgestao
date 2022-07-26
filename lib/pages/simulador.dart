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
                      'Sempre com você... participando do seu sucesso!',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const Espacamento(),
                    const Text(
                      'PARA VOCÊ DEFINIR PRIORIDADES',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Espacamento(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration:
                            _styleInput("Lucro considerado ideal ", "ops"),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      ),
                    ),

                    const Espacamento(),
                    // const Text("Custo de insumos para seu preparo ou de mercadoria para vendas"),
                    // const Espacamento(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration:
                            _styleInput("Lucro (DADOS INFORMADOS)", "ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      ),
                    ),
                    const Espacamento(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration: _styleInput("Lucro Resultate", "ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            //  padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Vendas");
                                }),
                          ),
                          Container(
                            width: 150,
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Ticket Médio");
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration: _styleInput("Fatutamento", "ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            //  padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Custo com insumos");
                                }),
                          ),
                          Container(
                            width: 150,
                            child: StreamBuilder(
                                stream: null,
                                builder: (context, snapshot) {
                                  return buildSpinBox("Custos fixos");
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child:      Container(

                        child: StreamBuilder(
                            stream: null,
                            builder: (context, snapshot) {
                              return buildSpinBox("Outros custos variaveis");
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                        child: TextFormField(

                          validator: ValidationBuilder()
                              .maxLength(50)
                              .required()
                              .build(),
                          keyboardType: TextInputType.number,
                          controller: null,
                          decoration: _styleInput("Margen de distribuição", "ops"),
                          inputFormatters: [
                            // obrigatório
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true, casasDecimais: 2)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                      child: TextFormField(
                        validator: ValidationBuilder()
                            .maxLength(50)
                            .required()
                            .build(),
                        keyboardType: TextInputType.number,
                        controller: null,
                        decoration: _styleInput("Ponto de equilibrio", "ops"),
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
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      prefixIcon: IconButton(
        icon: const Icon(Icons.help),
        color: Colors.transparent,
        onPressed: () {
          alerta.openModal(context, modal);
        },
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 1.0),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 1.0),
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black54),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
}
