


import 'package:appgestao/classes/dadosbasicossqlite.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class DadosBasicos extends StatefulWidget {
  const DadosBasicos({Key? key}) : super(key: key);

  @override
  State<DadosBasicos> createState() => _DadosBasicosState();
}

class _DadosBasicosState extends State<DadosBasicos> {

  var header = HeaderAppBar();
  var alerta = AlertModal();

  final _formKey = GlobalKey<FormState>();
  final _faturamentoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _gastoinsumosController = TextEditingController();
  final _custoFixoController = TextEditingController();
  final _margenController = TextEditingController();
  final _custoVariavelController = TextEditingController();

  String textBtn = "Adicionar";
  @override
  Widget build(BuildContext context) {
    ValidationBuilder.setLocale('pt-br');
    return Scaffold(
      appBar:header.getAppBar('Dados básicos'),
      drawer: Menu(),
      body:  Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(26.0),
              child: Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Espacamento(),
                    const Logo(),
                    const Espacamento(),
                    const Text('Sempre com você... participando do seu sucesso!',style: TextStyle(fontSize: 24),textAlign: TextAlign.center,),
                    const Espacamento(),
                   // Text('DADOS BÁSICOS',style: TextStyle(color: Colors.white)),
                    const Text('Todos os dados devem compreender o mesmo período.', style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
                    const Espacamento(),
                    TextFormField(
                      validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _quantidadeController,
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.transparent,
                          onPressed: () {
                         //   alerta.openModal(context,'opaaa');
                          },
                        ),
                        hintText: 'Quantidade de clientes atendidos',
                      ),
                    ),

                    TextFormField(
                      validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _faturamentoController,
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      decoration:  InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon:  IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.orange,
                          onPressed: () {
                            alerta.openModal(context,'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).');
                          },
                        ),
                        hintText: 'Faturamento com vendas',
                      ),
                    ),
                    TextFormField(
                      validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _gastoinsumosController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      decoration:  InputDecoration(
                        focusedBorder:const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon:  IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.orange,
                          onPressed: () {
                            alerta.openModal(context,'Considere o custo de todos os insumos empregados na produção ou preparo dos itens que comercializa, bem como os produtos adquiridos prontos para revender. IMPORTANTE: somente os utilizados para realizar as vendas (inclusive perdas ocorridas).');
                          },
                        ),
                        hintText: 'Gasto com insumos para atender as  vendas',
                      ),
                    ),      TextFormField(
                      validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _custoVariavelController ,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      decoration:  InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon:  IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.orange,
                          onPressed: () {
                            alerta.openModal(context,'Total outros custos variaveis');
                          },
                        ),
                        hintText: 'Total outros custos variaveis',
                      ),
                    ),
                    TextFormField(
                      validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _custoFixoController ,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      decoration:  InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon:  IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.orange,
                          onPressed: () {
                            alerta.openModal(context,'Custos e despesas que ocorrem independentemente das vendas. Ex.: Salários, encargos, benefícios; pró-labore; aluguéis; contratos de serviços: contador, Internet, TV à cabo, aluguel de leitoras de cartões, estacionamento (quando for um valor mensal fechado); água, eletricidade, gáz, materiais de limpeza e higiene.');
                          },
                        ),
                        hintText: 'Total de custos fixos',
                      ),
                    ),
                    TextFormField(
                       validator: ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _margenController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      decoration:  InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orange, width: 1.0),
                        ),
                        prefixIcon:  IconButton(
                          icon: const Icon(Icons.help),
                          color: Colors.orange,
                          onPressed: () {
                            alerta.openModal(context,' Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.');
                          },
                        ),
                        hintText: 'Margen que você considera ideal',
                      ),
                    ),
                    SizedBox(

                      width: MediaQuery.of(context).size.width,
                      child:  ElevatedButton(
                        style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20), primary: Colors.orange,),
                        onPressed: _buildBuildOnPressed,
                        child: Text(textBtn),
                      ),
                    ),
                    const Espacamento(),
                    const Espacamento(),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildBuildOnPressed()async{
    final isValid = _formKey.currentState!.validate();
    if(!isValid){
      return;
    }
    var alert = AlertSnackBar();

    var bd = DadosBasicosSqlite();
    var data ={
      1,
      _quantidadeController.text,
      _faturamentoController.text,
      _gastoinsumosController.text,
      _custoVariavelController.text,
      _custoFixoController.text,
      _margenController.text
    };
    bd.save(data);
  /*  final _faturamentoController = TextEditingController();
    final _quantidadeController = TextEditingController();
    final _gastoinsumosController = TextEditingController();
    final _custoFixoController = TextEditingController();
    final _margenController = TextEditingController();
    final _custoVariavelController = TextEditingController();

   */
    print(_quantidadeController.text);
    print(_faturamentoController.text);
    print(_gastoinsumosController.text);
    print(_custoVariavelController.text);
    print(_custoFixoController.text);
    print(_margenController.text);
  //  print(_custoVariavelController.text);
  }
}








