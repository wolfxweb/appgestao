import 'dart:ffi';

import 'package:appgestao/blocs/dados_basico_bloc.dart';
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
  var id = 0;
  @override
  void _consultar() async {
    await bd.lista().then((data) {
      data.forEach((element) {
             id = element['id'];
        _quantidadeController.text = element['qtd'];
        _faturamentoController.text = element['faturamento'];
        _gastoinsumosController.text = element['gastos'];
        _custoFixoController.text = element['custo_fixo'];
        _margenController.text = element['margen']+"%";
        _custoVariavelController.text = element['custo_varivel'];
        _custoInsumosController.text = element['gastos_insumos'];
         mesSelect.value = element['mes'];


      });
    });
  }

  initState() {
    _consultar();
     //itemSelecionado = 'Janeiro';
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
              padding: const EdgeInsets.all(26.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  const Espacamento(),
                  //  const Logo(),
                  /*
                  const Espacamento(),
                  const Text(
                    'Sempre com você... participando do seu sucesso!',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),

                   */
                  const Espacamento(),
                  // Text('DADOS BÁSICOS',style: TextStyle(color: Colors.white)),
                  const Text(
                    'Todos os dados devem compreender o mesmo período.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const Espacamento(),

                  const Espacamento(),
                  ValueListenableBuilder(
                      valueListenable: mesSelect,
                      builder:  (BuildContext context , String value, _){
                        return SizedBox(
                          child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                                ),
                                focusColor: Colors.orangeAccent,
                                border: OutlineInputBorder(),

                                labelText: "Selecione o mês referência",
                                labelStyle: TextStyle(color: Colors.black54),
                                prefixIcon: IconButton(
                                    icon: const Icon(null),
                                    color: Colors.transparent,
                                    onPressed: null),
                              ),
                            isExpanded: true,
                            hint: const Text("Selecione o mês referência"),
                              value: (value.isEmpty)?null:value,
                              items: dropOpcoes.map((e){
                                 return DropdownMenuItem(child: Text(e) , value: e,);
                              }).toList(),
                              onChanged: (onChanged){
                                print(onChanged);
                                _faturamentoController.text = "";
                                _custoInsumosController.text="";
                                _custoFixoController.text="";
                                _gastoinsumosController.text="";
                                _quantidadeController.text="";
                                _margenController.text ="";
                                _custoVariavelController.text="";
                                mesSelect.value =  onChanged.toString();
                              }),
                        );
                      }
                      ),

/*
                  const Espacamento(),
                  StreamBuilder<dynamic>(
                      stream: mesBloc.mesOutUsuario,
                      builder: (context, snapshot) {

                        if (snapshot.hasData) {
                          mesController =  DropdownEditingController(value: mesRef);
                        }
                        return TextDropdownFormField(
                          controller: mesController,
                          options: const [
                            "Janeiro",
                            "Fevereiro",
                            "Março",
                            "Abril",
                            "Maio",
                            "Juho",
                            "Julho",
                            "Agosto",
                            "Setembro",
                            "Outubro",
                            "Novembro",
                            "Dezembro"
                          ],

                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            focusColor: Colors.orangeAccent,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.orangeAccent,
                            ),
                            labelText: "Selecione o mês referência",
                            labelStyle: TextStyle(color: Colors.black54),
                            prefixIcon: IconButton(
                                icon: const Icon(null),
                                color: Colors.transparent,
                                onPressed: null),
                          ),
                          onChanged: (dynamic str) {
                            print(str);
                            //  setState(() { mesRef = str; });
                            //  mesController = str;
                            mesSave = str;
                            // mesController = str;
                          },
                          // dropdownHeight: 120,
                        );
                      }),
*/
                  const Espacamento(),
                  TextFormField(

                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _quantidadeController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.transparent,
                        onPressed: () {
                          //   alerta.openModal(context,'opaaa');
                        },
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),

                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 1.0),
                       ),
                 //    label: "Quantidade de clientes atendidos",
                      labelText: "Quantidade de clientes atendidos",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),

                     //  hintText: 'Quantidade de clientes atendidos',
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _faturamentoController,
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      /*  focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),*/
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).');
                        },
                      ),
                      //  hintText: 'Faturamento com vendas',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Faturamento com vendas",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                   // validator:  ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _custoInsumosController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              'Considere os produtos de terceiros adquiridos e comercializado no mês informado.');
                        },
                      ),
                      //    hintText: 'Gasto com insumos para revenda',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Gasto com insumos",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                  //  validator:  ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _gastoinsumosController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              'Considere o custo de todos os insumos empregados na produção ou preparo dos itens que comercializa, bem como os produtos adquiridos prontos para revender. IMPORTANTE: somente os utilizados para realizar as vendas (inclusive perdas ocorridas).');
                        },
                      ),
                      //  hintText: 'Gasto com produto para revenda',
                      //    hintText: 'Gasto com insumos para revenda',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Gasto com produto para revenda",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _custoVariavelController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              'TOTAL OUTROS CUSTOS VARIÁVEIS.Considere todos os custos e despesas que variam em função das vendas.Por exemplo: taxas e impostos; custo dos cartões de débito, crédito, tickets e vales;custos das eventuais antecipações de vencimento e desconto de títulos; comissões, gorjetas;estacionamento pago em função do uso por clientes; custo das entregas delivery.');
                        },
                      ),
                      //  hintText: 'Total outros custos variaveis',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Total outros custos variaveis",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _custoFixoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              'Custos e despesas que ocorrem independentemente das vendas. Ex.: Salários, encargos, benefícios; pró-labore; aluguéis; contratos de serviços: contador, Internet, TV à cabo, aluguel de leitoras de cartões, estacionamento (quando for um valor mensal fechado); água, eletricidade, gáz, materiais de limpeza e higiene.');
                        },
                      ),
                      //  hintText: 'Total de custos fixos',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Total de custos fixos",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:  ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _margenController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.help),
                        color: Colors.orange,
                        onPressed: () {
                          alerta.openModal(context,
                              ' Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.');
                        },
                      ),
                      //  hintText: 'Margen que você considera ideal',
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Margen que você considera ideal",
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        primary: Colors.orange,
                      ),
                      onPressed: _buildBuildOnPressed,
                      child: const  Text("Salvar"),
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

  _buildBuildOnPressed() async {
    final isValid = _formKey.currentState!.validate();
    print(_gastoinsumosController.text);
    if(_gastoinsumosController.text == "" &&  _custoInsumosController.text =="" ){
      alerta.openModal(context,"É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      return;
    }
    if(_gastoinsumosController.text != "" &&  _custoInsumosController.text !="" ){
      alerta.openModal(context,"É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      return;
    }
    if (!isValid) {
      alerta.openModal(context,"É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      return;
    }

    // final mesReferencia =  _validaMes(mesRef);
    // print(mesSave);
    // print(mesRef);
    // print(mesController.toString());
    if (id == 0) {
      _saveUpdate(_getDados(null, mesSave),
          "Dados básicos cadastrado realizado com sucesso");
    } else {
      _saveUpdate(
          _getDados(id, mesSave), "Dados básicos atulizado com sucesso");
    }
  }

  _getDados(idinfo, mesRef) {
    return dadosbasicossqlite(
        idinfo,
        _quantidadeController.text,
        _faturamentoController.text,
        _gastoinsumosController.text,
        _custoVariavelController.text,
        _custoFixoController.text,
        _margenController.text,
         mesSelect.value,
        _custoInsumosController.text);
  }

  _saveUpdate(dados, msg) {
    var alert = AlertSnackBar();
    bd.save(dados.toJson()).then((value) {
      alert.alertSnackBar(context, Colors.green, msg);
    });
  }
}
