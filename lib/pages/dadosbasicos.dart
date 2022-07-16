import 'dart:ffi';

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
  var  mesRef = "Janeiro";

  var bd = DadosBasicosSqlite();
  var id = 0;

  void _consultar() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print(element);
        id = element['id'];
        _quantidadeController.text = element['qtd'];
        _faturamentoController.text = element['faturamento'];
        _gastoinsumosController.text = element['gastos'];
        _custoFixoController.text = element['custo_fixo'];
        _margenController.text = element['margen'];
        _custoVariavelController.text = element['custo_varivel'];
        _custoInsumosController.text = element['gastos_insumos'];
         mesRef  = element['mes'].toString();
        //mesController  =  element['mes']!.toString() as DropdownEditingController<String>?;

      });
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
  //final mesReferenciaController = TextDropdownFormField( options: ["Janeiro","Fevereiro","Março", "Abril", "Maio", "Juho","Julho", "Agosto", "Setembro","Outubro", "Novembro", "Dezembro" ]);
  DropdownEditingController<String>? mesController = DropdownEditingController();


  // final textBtn = "Adicionar";

  @override
  Widget build(BuildContext context) {
    _consultar();

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
                  const Espacamento(),
                  const Text(
                    'Sempre com você... participando do seu sucesso!',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const Espacamento(),
                  // Text('DADOS BÁSICOS',style: TextStyle(color: Colors.white)),
                  const Text(
                    'Todos os dados devem compreender o mesmo período.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const Espacamento(),
                  TextDropdownFormField(

                   // controller: mesController ,
                    options: [
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

                     // mesRef = str;


                      //_mesReferenciaController = str;
                    },
                    // dropdownHeight: 120,
                  ),

                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _quantidadeController,
                    decoration: InputDecoration(
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
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      labelText: "Quantidade de clientes atendidos",
                      labelStyle: TextStyle(color: Colors.black54),
                      // hintText: 'Quantidade de clientes atendidos',
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
                      labelStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:  ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _custoInsumosController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
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
                      labelText: "Gasto com insumos para revenda",
                      labelStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _gastoinsumosController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
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
                      labelStyle: const TextStyle(color: Colors.black54),
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
                      labelStyle: const TextStyle(color: Colors.black54),
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
                      labelStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const Espacamento(),
                  TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.number,
                    controller: _margenController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
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
                      labelStyle: const TextStyle(color: Colors.black54),
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
                      child: Text("Atualizar"),
                    ),
                  ),
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
    if (!isValid) {
       return;
    }
    final mesReferencia =  _validaMes(mesRef);
    print(mesReferencia);
    print(_custoInsumosController.text);
    if (id == 0) {
      _saveUpdate(_getDados(null,mesRef), "Cadastro realizado com sucesso");
    } else {
       _saveUpdate(_getDados(id,mesRef), "Cadastro atulizado com sucesso");
    }
  }
  _validaMes(mesRef){

    switch (mesRef){
      case "Janeiro":
            return "jan";
        break;
      case "Fevereiro":
        return "fev";
        break;
      case "Março":
        return "mar";
        break;
      case "Abril":
        return "abr";
        break;
      case "Maio":
        return "mai";
        break;
      case "Junho":
        return "jun";
        break;
      case "Julho":
        return "jul";
        break;
      case "Agosto":
        return "ago";
        break;
      case "Stembro":
        return "set";
        break;
      case "Outubro":
        return "out";
        break;
      case "Novembro":
        return "nov";
        break;
      case "Dezembro":
        return "dez";
        break;

    }

  }
  _getDados(idinfo,mes) {
    return dadosbasicossqlite(
        idinfo,
        _quantidadeController.text,
        _faturamentoController.text,
        _gastoinsumosController.text,
        _custoVariavelController.text,
        _custoFixoController.text,
        _margenController.text,
         mes,
        _custoInsumosController.text
    );
  }

  _saveUpdate(dados, msg) {
    var alert = AlertSnackBar();
    bd.save(dados.toJson()).then((value) {
      alert.alertSnackBar(context, Colors.green, msg);
    });
  }
}
