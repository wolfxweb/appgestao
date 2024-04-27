import 'dart:ffi';

import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/classes/dadosbasicossqlite.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class DadosBasicos extends StatefulWidget {
  DadosBasicos({Key? key}) : super(key: key);

  @override
  State<DadosBasicos> createState() => _DadosBasicosState();
}

class _DadosBasicosState extends State<DadosBasicos> {
  var mesRef;
  var mesSave;
  DropdownEditingController<String>? mesController;
  var mesBloc = DadosBasicosBloc();
  var bd = DadosBasicosSqlite();
  var importanciaMesesBLoc = ImportanciaMesesBLoc();

  var id = 0;
  @override
  void _consultar() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print('element');
        print(element);
        id = element['id'];
        _quantidadeController.text = element['qtd'];
        _faturamentoController.text = element['faturamento'];
        _gastoinsumosController.text = element['gastos'];
        _custoFixoController.text = element['custo_fixo'];
        _margenController.text = element['margen'];
        _custoVariavelController.text = element['custo_varivel'];
        _custoInsumosController.text = element['gastos_insumos'];
        mesSelect.value = element['mes'];
      });
    });
  }

  initState() {
    _consultar();
  }

  st(element) {
    setState(() {
      //mesRef = element['mes'];
      mesController = DropdownEditingController(value: element);
    });
  }

  var header = HeaderAppBar();
  var alerta = AlertModal();
  final _formKey = GlobalKey<FormState>();

  final _faturamentoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _gastoinsumosController = TextEditingController();
  final _custoFixoController = TextEditingController();
  final _margenController = TextEditingController();
  final _custoVariavelController = TextEditingController();
  final _custoInsumosController = TextEditingController();
  final mesSelecionaController = TextEditingController();

  var mesSelect = ValueNotifier('');

  var color = Color.fromRGBO(159, 105, 56,0.5);
  @override
  Widget build(BuildContext context) {
    final dropOpcoes = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    ValidationBuilder.setLocale('pt-br');
    return Scaffold(
      appBar: header.getAppBar('Dados básicos'),
      drawer: Menu(),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Espacamento(),
                  // Text('DADOS BÁSICOS',style: TextStyle(color: Colors.white)),
                  const Text(
                    'Todos os dados devem compreender o mesmo período.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Espacamento(),

                  const Espacamento(),
                  Container(
                    decoration: buildBuildBoxDecoration(),
                    child: ValueListenableBuilder(
                        valueListenable: mesSelect,
                        builder: (BuildContext context, String value, _) {
                          return SizedBox(
                            child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  prefixIcon: IconButton(
                                    icon: const  Icon(
                                      Icons.help,
                                      color: Colors.black54,
                                    ),
                                    // color: Colors.transparent,
                                    onPressed: () {
                                      alerta.openModal(context,
                                          'Todos os dados devem se referir ao mês selecionado. Caso você esteja estudando a viabilidade de um negócio novo, anote suas estimativas e metas.');
                                    },
                                  ),
                                  fillColor: color,
                                  filled: true,
                                  // disabledBorder: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(159, 105, 56,1),
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Selecione o mês",
                                  labelStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    //  backgroundColor: Colors.white,
                                  ),
                                ),
                                isExpanded: true,
                                hint: const Text("Selecione o mês referência"),
                                value: (value.isEmpty) ? null : value,
                                items: dropOpcoes.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  );
                                }).toList(),
                                onChanged: (onChanged) {
                                 // print('onChanged');
                               //   print(onChanged);
                                  importanciaMesesBLoc.msgInfoMesSelecionado(onChanged);
                                  _faturamentoController.text = "";
                                  _custoInsumosController.text = "";
                                  _custoFixoController.text = "";
                                  _gastoinsumosController.text = "";
                                  _quantidadeController.text = "";
                                  _margenController.text = "";
                                  _custoVariavelController.text = "";
                                  mesSelect.value = onChanged.toString();
                                }),
                          );
                        }),
                  ),
                  const Espacamento(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(1, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: StreamBuilder(
                        stream: importanciaMesesBLoc.outInfoMesSelecionado,
                        builder: (context, snapshot) {
                          var data = "";
                          if (snapshot.hasData) {
                            data = snapshot.data.toString();
                            return TextFormField(
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.none,
                              maxLines: 3,
                              controller:
                              TextEditingController(text: data.toString()),
                              decoration:  InputDecoration(
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                contentPadding:const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                fillColor: Colors.grey[100],
                                filled: true,
                                focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(159, 105, 56,1),
                                      width: 1.0,
                                      style: BorderStyle.none),
                                ),
                                border: InputBorder.none,
                                //  labelText: 'Desconto máximo para vender sem prejuizo',
                                labelStyle: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                         return Container();
                        }),
                  ),

                  const Espacamento(),
                  Container(
                    decoration: buildBuildBoxDecoration(),
                    child: TextFormField(
                      validator:
                          ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _quantidadeController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.help,),
                          color: Colors.transparent,
                          onPressed: () {
                            //  alerta.openModal(context, text);
                          },
                        ),
                        fillColor: color,
                        filled: true,
                        // disabledBorder: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  Color.fromRGBO(159, 105, 56,1),
                              width: 1.0,
                              style: BorderStyle.none),
                        ),
                        border: InputBorder.none,
                        labelText: "Quantidade de clientes atendidos",
                        labelStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          //  backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Espacamento(),
                  buildContainerInput(
                      context,
                      'Valor bruto apurado com as vendas realizadas (valor pago pelos clientes).',
                      "Faturamento com vendas",
                      _faturamentoController),
                  const Espacamento(),
                  buildContainerInput(
                      context,
                      'Considere o custo de todos os insumos empregados na produção ou preparo dos itens que comercializa. \nIMPORTANTE: somente os utilizados para realizar as vendas (inclusive perdas ocorridas).',
                      "Gastos com insumos",
                      _custoInsumosController),
                  const Espacamento(),
                  buildContainerInput(
                      context,
                      'Considere os produtos de terceiros adquiridos e comercializados no mês informado.',
                      "Gastos com produtos para revenda",
                      _gastoinsumosController),

                  const Espacamento(),
                  buildContainerInput(
                      context,
                      'Considere todos os custos e despesas que variam em função das vendas.\nPor exemplo:\nTaxas e impostos;\nCusto dos cartões de débito, crédito, tickets e vales;\nCustos das eventuais antecipações de vencimento e desconto de títulos;\nComissões, gorjetas;\nEstacionamento (quando pago em função do uso por clientes);\nCusto das entregas delivery.',
                      'Outros custos variáveis',

                      _custoFixoController
                      //  _custoVariavelController
                      ),
                  const Espacamento(),
                  buildContainerInput(
                      context,
                      'Custos e despesas que ocorrem independentemente das vendas.\nPor exemplo:\nSalários, encargos, provisões, benefícios e pró-labore;\nContratos de serviços: contador, Internet, TV à cabo, leitoras de cartões e estacionamento (quando for um valor mensal fechado);\nAluguéis, IPTU e taxas;\nÁgua, eletricidade, gás, materiais de limpeza e higiene.',
                      'Custos fixos',
                      _custoVariavelController
                    //_custoFixoController
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBuildBoxDecoration(),
                    child: TextFormField(
                      validator:
                          ValidationBuilder().maxLength(50).required().build(),
                      keyboardType: TextInputType.number,
                      controller: _margenController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
                      ],
                      // decoration: buildInputDecoration(context,'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).'),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.help, color: Colors.black54,),
                          color: Colors.black54,
                          onPressed: () {
                            alerta.openModal(context, 'Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.');
                          },
                        ),
                        suffixIcon: Icon(Icons.percent, color: Colors.black54,),
                        fillColor: color,
                        filled: true,
                        // disabledBorder: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromRGBO(159, 105, 56,1),
                              width: 1.0,
                              style: BorderStyle.none),
                        ),
                        border: InputBorder.none,
                        labelText: "Margen que você considera ideal",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          //  backgroundColor: Colors.white,
                        ),
                        // hintText: 'Quantidade de clientes atendidos',
                      ),
                    ),
                  ),
                  const Espacamento(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        primary: const Color.fromRGBO(159, 105, 56,1),
                      ),
                      onPressed: _buildBuildOnPressed,
                      child: const Text("Salvar"),
                    ),
                  ),
                  const Espacamento(),
                  const Espacamento(),
                  const Espacamento(),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainerInput(
      BuildContext context, text, titulo, controllerInformado) {
    return Container(
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        //  controller: _faturamentoController,
        controller: controllerInformado,
        inputFormatters: [
          // obrigatório
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter(moeda: true, casasDecimais: 2)
        ],
        decoration: buildInputDecoration(context, text, titulo),
      ),
    );
  }

  buildBuildBoxDecoration() {
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

  InputDecoration buildInputDecoration(BuildContext context, text, titulo) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      prefixIcon: IconButton(
        icon: const Icon(Icons.help, color: Colors.black54,),
        color: Colors.black54,
        onPressed: () {
          alerta.openModal(context, text);
        },
      ),
      fillColor: color,
      filled: true,
      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.orange, width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  _buildBuildOnPressed() async {
    final isValid = _formKey.currentState!.validate();
    print(_gastoinsumosController.text);
    if (_gastoinsumosController.text == "" &&
        _custoInsumosController.text == "") {
      //  alerta.openModal(context,"É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      // return;
    }
    if (_gastoinsumosController.text != "" &&
        _custoInsumosController.text != "") {
      //    alerta.openModal(context,"É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      // return;
    }
    if(mesSelect.value.isEmpty){
      alerta.openModal(context,
          "Selecionde o mês de referencia");
      return;
    }
    if (!isValid) {
      alerta.openModal(context,
          "É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      return;
    }



    if (id == 0) {
      _saveUpdate(_getDados(null, mesSave), "Dados básicos cadastrado realizado com sucesso");
    } else {
      _saveUpdate( _getDados(id, mesSave), "Dados básicos atulizado com sucesso");
    }


  }

  _getDados(idinfo, mesRef) {
    return dadosbasicossqlite(
        idinfo,
        _quantidadeController.text,
        _faturamentoController.text,
        _gastoinsumosController.text,
        _custoFixoController.text,
        _custoVariavelController.text,
        _margenController.text,
        mesSelect.value,
        _custoInsumosController.text,
       '0'
    );
  }

  _saveUpdate(dados, msg) {

    print(dados);
    var alert = AlertSnackBar();
    bd.save(dados.toJson()).then((value) {
      alert.alertSnackBar(context, Colors.green, msg);
    });
  }
}
