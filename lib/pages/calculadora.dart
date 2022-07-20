


import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:appgestao/componete/alertamodal.dart';
class Calculadora extends StatefulWidget {
  const Calculadora({Key? key}) : super(key: key);

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:header.getAppBar('Calculadora preços'),
      drawer: Menu(),
      body:  SingleChildScrollView(
        child:  Form(
          key: _formKey,
          child:  Center(
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Espacamento(),
                  const  Text(
                    'Sempre com você... participando do seu sucesso!',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),

                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Preço de venda atual","ops"),
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                  ),

                  const Espacamento(),
                  const Text("Custo de insumos para seu preparo ou de mercadoria para vendas"),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Custo de insumos","ops"),
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Produto","ops"),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Margem com preço atual","ops"),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("text area","ops"),
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Informe a margem desejada","ops"),

                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Preço sugerido","ops"),
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Relação com preço atual","ops"),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Venda previstas","ops"),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("Contribuição para ponto de equilibrio","ops"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _styleInput(String text,String modal){
    return InputDecoration(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      prefixIcon: IconButton(
        icon: const Icon(Icons.help),
        color: Colors.orangeAccent,
        onPressed: () {
             alerta.openModal(context,modal);
        },
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.orange, width: 1.0),
      ),
      border: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.orange, width: 1.0),
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black54),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
}
