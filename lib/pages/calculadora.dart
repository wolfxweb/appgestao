


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

  void initState() {
    calBloc = CalculadoraBloc();
  }


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
                  StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        print(snapshot.data);

                        var data = snapshot.data;
                        return TextFormField(
                          validator: ValidationBuilder().maxLength(50).required().build(),
                        //  keyboardType: TextInputType.number,
                          controller: null,
                          decoration: _styleInput("Produto","ops"),
                          onChanged: (text){

                          },
                        );
                      }
                  ),
                  const Espacamento(),
                  StreamBuilder(
                    stream: calBloc.outPrecoVendaAtualController,
                    builder: (context, snapshot) {
                      print(snapshot.data);

                      var data = snapshot.data;
                      return TextFormField(
                        validator: ValidationBuilder().maxLength(50).required().build(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "$data"),
                        decoration: _styleInput("Preço de venda atual","ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                        onChanged: (text){

                          if(text.isNotEmpty){
                            calBloc.percoVendaAtual(text);
                          }
                        },
                      );
                    }
                  ),

                  const Espacamento(),
              //    const Text("Custo de insumos para seu preparo ou de mercadoria para vendas"),
                  const Espacamento(),
                  StreamBuilder(
                    stream: calBloc.outCustosComInsumosController,
                    builder: (context, snapshot) {
                      print(snapshot.data);

                      var data = snapshot.data;
                      return TextFormField(
                        validator: ValidationBuilder().maxLength(50).required().build(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "$data"),
                        decoration: _styleInput("Preço dos insumos ou da mercadoria adquirida","ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                        onChanged: (text){
                          print(text);
                          //calculadoraCusto(text)
                          if(text.isNotEmpty){
                            calBloc.calculadoraCusto(text);
                          }
                        },
                      );
                    }
                  ),
                  const Espacamento(),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 //   mainAxisSize: MainAxisSize.max,
                  //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        width: 150,
                        child:  StreamBuilder(
                            stream: null,
                            builder: (context, snapshot) {
                              print(snapshot.data);

                              var data = snapshot.data;
                              //    /=margemPrecoAtual = data.toString();
                              return TextFormField(
                                validator: ValidationBuilder().maxLength(50).required().build(),
                                keyboardType: TextInputType.number,
                                controller: margemPrecoAtual = TextEditingController(text: "10 %"),
                                decoration: _styleInput("Margem atual","ops"),
                              );
                            }
                        ),
                      ),
                      Container(
                        width: 150,
                        child:  StreamBuilder(
                            stream: calBloc.outCalculoMargem,
                            builder: (context, snapshot) {
                              print(snapshot.data);

                              var data = snapshot.data;
                              //    /=margemPrecoAtual = data.toString();
                              return TextFormField(
                                validator: ValidationBuilder().maxLength(50).required().build(),
                                keyboardType: TextInputType.number,
                                controller: margemPrecoAtual = TextEditingController(text: "$data %"),
                                decoration: _styleInput("Margem desejada","ops"),
                              );
                            }
                        ),
                      ),
                    ],
                  ),

                  const Espacamento(),
                  StreamBuilder(
                    stream: calBloc.outMsgMargem,
                    builder: (context, snapshot) {
                  //    print(snapshot.data);
                      var data = snapshot.data;
                      return TextFormField(
                        validator: ValidationBuilder().maxLength(50).required().build(),
                        keyboardType: TextInputType.number,
                        maxLines: 2,
                        controller:TextEditingController(text: "$data "),
                        decoration: _styleInput("","ops"),
                        inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: true, casasDecimais: 2)
                        ],
                      );
                    }
                  ),
                  const Espacamento(),

                  StreamBuilder(
                    stream: calBloc.outCaculoPrecoSugerido,
                    builder: (context, snapshot) {
                //      print(snapshot.data);
                      var data = snapshot.data;
                      return TextFormField(
                      //  validator: ValidationBuilder().maxLength(50).required().build(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "R\$ 1500,00"),
                        decoration: _styleInput("Preço sugerido","ops"),
                          inputFormatters: [ FilteringTextInputFormatter.digitsOnly,],

                      );
                    }
                  ),
                  const Espacamento(),
                  StreamBuilder(
                    stream: calBloc.outRelacaoPrecoController,
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      var data = snapshot.data.toString();
                      return TextFormField(
                        validator: ValidationBuilder().maxLength(50).required().build(),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: "0 %"),
                        decoration: _styleInput("Relação com preço atual","ops"),
                      );
                    }
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: null,
                    decoration: _styleInput("","ops"),
                  ),
                  const Espacamento(),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   mainAxisSize: MainAxisSize.max,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        child:   SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              child: const Text('Ver o histórico'),
                              onPressed: _buildOnPressed,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 18),
                                primary: Colors.orange,
                              ),
                            )
                        ),
                      ),
                      Container(
                        width: 150,
                        child:    SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              child: const Text('Salvar'),
                              onPressed: _buildOnPressed,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 18),
                                primary: Colors.orange,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildOnPressed() {
  print("salvar");
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        labelText: labelText
    );
  }
  _styleInput(String text,String modal){
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        fillColor: Colors.grey[150],
        filled: true,
      focusedBorder: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.orange, width: 1.0),
      ),
      border: const OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.orange, width: 1.0),
      ),
      labelText: text,
      labelStyle: const TextStyle(
          color: Colors.black,
          backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
}
