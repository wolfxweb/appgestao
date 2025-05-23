import 'dart:ffi';

import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/classes/dadosbasicossqlite.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/listaDadosBasicos.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'dart:async';

class NovoDadosBasicos extends StatefulWidget {
  NovoDadosBasicos({Key? key}) : super(key: key);

  @override
  State<NovoDadosBasicos> createState() => _NovoDadosBasicosState();
}

class _NovoDadosBasicosState extends State<NovoDadosBasicos> {
  var mesRef;
  var mesSave;
  DropdownEditingController<String>? mesController;
  var mesBloc = DadosBasicosBloc();
  var bd = DadosBasicosSqlite();
  var route = PushPage();
  var importanciaMesesBLoc = ImportanciaMesesBLoc();
  var color = Color.fromRGBO(105, 105, 105, 1);
  var id = 0;
  String? data_cadastro;
  var fatVendas = 100.0;
  var gastosInsumos = 0.0;
  var outrosCustos = 0.0;
  var custoFixo = 0.0;
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
  final percentualVendas = TextEditingController();
  final percentualGastosInsumos = TextEditingController();
  final percentualOutrosCustos = TextEditingController();
  final percentualCustoFixo = TextEditingController();
  final _capacidadeAtendimento =  TextEditingController();
  final _horas_trabalho =  TextEditingController();
  final _pro_labore =  TextEditingController();
  final _demais_custos_fixos =  TextEditingController();
  var mesSelect = ValueNotifier('');

  NumberFormat formatterPercentual = NumberFormat("0.00");
  bool _conn = false;
  String _message = '';
  StreamSubscription? subscription;
  String msgAlertaMes ="Todos os dados devem se referir ao mês selecionado. Caso você esteja estudando a viabilidade de um negócio novo, anote suas estimativas e metas.";
  final SimpleConnectionChecker _simpleConnectionChecker =   SimpleConnectionChecker()..setLookUpAddress('pub.dev');

  String retorno = "S";
  String operacaoBancoDados = 'i';
  @override
  List<Map<String, String>> listaMeses = [];
  void _consultarMeses(mesSelecionado) async {
    int anoAtual = DateTime.now().year;
   // var retorno = "S";
    await bd.getDadosBasicoMesesCadastrado().then((data) {
      data.forEach((element) {
        String mes = element['mes'];
        String ano = element['data_cadastro'].substring(0, 4); // Extrai apenas o ano
        if( mes == mesSelecionado  &&  ano == anoAtual.toString()){
          setState(() {
            retorno = 'N';
          //  operacaoBancoDados = 'A';
          });
        }
        listaMeses.add({'mes': mes, 'ano': ano});
      });

    });
    _confirmarOperacao();
    // return retorno;

  }
  void _consultar() async {
    await bd.getDadosBasicoAtual().then((data) {
      data.forEach((element) {
    //    print('element');
    //    print(element['capacidade_atendimento']);
        id = element['id'];
        _quantidadeController.text = element['qtd'];
        _faturamentoController.text = element['faturamento'];
        _gastoinsumosController.text = element['gastos'];
        _custoFixoController.text = element['custo_fixo'];
        _margenController.text = element['margen'];
        _custoVariavelController.text = element['custo_varivel'];
        _custoInsumosController.text = element['gastos_insumos'];
        mesSelect.value = element['mes'];
       _capacidadeAtendimento.text = element['capacidade_atendimento'];
        data_cadastro     = element['data_cadastro'];
        _horas_trabalho.text = element['horas_trabalho'];
        _pro_labore.text = element['pro_labore'];
        _demais_custos_fixos.text = element['demais_custos'];

        var faturamentoTemp = (element['faturamento']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastosTemp = (element['custo_fixo']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var custo_fixoTemp = (element['custo_varivel']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastosIsumosTemp = (element['gastos_insumos']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        fatVendas = double.parse(faturamentoTemp).truncateToDouble();
        gastosInsumos =
            (double.parse(gastosIsumosTemp).truncateToDouble() / fatVendas) *
                100;
        outrosCustos =
            (double.parse(gastosTemp).truncateToDouble() / fatVendas) * 100;
        custoFixo =
            (double.parse(custo_fixoTemp).truncateToDouble() / fatVendas) * 100;
      });
    //  _consultarMeses('Fevereiro');

    });

  }
  var users = VerificaStatusFairebase();

  var _tipoEmpresa = '';
  var tipoEmpresaSemEspacos = "";
  @override
  void initState() {
    super.initState();
    _consultar();
    users.getTipoEmpresa().then((tipoEmpresa) {
     // print('tipoEmpresa: $tipoEmpresa');
      _tipoEmpresa = tipoEmpresa!;
      tipoEmpresaSemEspacos = _tipoEmpresa.replaceAll(' ', '');
   //   print(_tipoEmpresa);
      setState(() {
        _tipoEmpresa = tipoEmpresa!;
        tipoEmpresaSemEspacos = _tipoEmpresa.replaceAll(' ', '');
      });
    });

    users.verificaTrial(context);

    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _getConection();
        _message = connected ? 'Connected' : 'Not connected';


      });
    });
  }

  _getConection() async {
    bool _isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    setState(() {
      _conn = _isConnected;
    });
    if (!_isConnected) {
      alerta.openModal(context, 'Sem conexão com a internet');
    }
  }

  st(element) {
    setState(() {
      //mesRef = element['mes'];
      mesController = DropdownEditingController(value: element);
    });
  }

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
              padding: const EdgeInsets.all(10.0),
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
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Espacamento(),

                  const Espacamento(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Selecione o mês'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context, msgAlertaMes),
                          buildSelecioneMes(dropOpcoes),
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  containerMsgMesSelecionado(),
                  const Espacamento(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Quantidade de clientes atendidos'),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Container(),
                          ),
                          quantidadClientesAtendido(),
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Faturamento com vendas'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context,
                              'Valor bruto apurado com as vendas realizadas (valor pago pelos clientes).'),
                          buildContainerInput(
                            context,
                            'Valor bruto apurado com as vendas realizadas (valor pago pelos clientes).',
                            "",
                            _faturamentoController,
                            'Faturamento',
                          ),
                          inputPercentual(context, percentualVendas)
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Gastos com vendas'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context,
                              'Considere todos os custos e despesas que variam em função das vendas.\nPor exemplo:\nTaxas e impostos;\nCusto dos cartões de débito, crédito, tickets e '
                                  'vales;\nCustos das eventuais antecipações de vencimento e desconto de títulos;\nComissões, gorjetas;\nEstacionamento (quando pago em função do uso por clientes);\nCusto'
                                  ' das entregas delivery.'),
                       /*   buildIconeMsg(context,
                              'Considere o custo de todos os insumos empregados na produção ou preparo dos itens que comercializa. \nIMPORTANTE: somente os utilizados para realizar as vendas '
                                  '(inclusive perdas ocorridas).'),

                        */
                          buildContainerInput(
                            context,
                            'Considere o custo de todos os insumos empregados na produção ou preparo dos itens que comercializa. \nIMPORTANTE: somente os utilizados para realizar as vendas (inclusive perdas ocorridas).',
                            "",
                            _custoInsumosController,
                            'Gastos com insumos',
                          ),
                          inputPercentual(context, percentualGastosInsumos)
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  /* Row(
                    children: [
                      buildIconeMsg(context,'Considere os produtos de terceiros adquiridos e comercializados no mês informado.'),
                      buildContainerInput(
                          context,
                          'Considere os produtos de terceiros adquiridos e comercializados no mês informado.',
                          "Gastos com produtos para revenda",
                          _gastoinsumosController),
                    ],
                  ),
                  const Espacamento(),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Gastos com insumos e produtos de 3°'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context,
                              'Considere os gastos com aquisição de insumos empregados na produção ou preparo dos itens em oferta, bem como dos produtos adquiridos de terceiros para revender.'),
                       /*   buildIconeMsg(context,
                              'Considere todos os custos e despesas que variam em função das vendas.\nPor exemplo:\nTaxas e impostos;\nCusto dos cartões de débito, crédito, tickets e '
                                  'vales;\nCustos das eventuais antecipações de vencimento e desconto de títulos;\nComissões, gorjetas;\nEstacionamento (quando pago em função do uso por clientes);\nCusto'
                                  ' das entregas delivery.'),

                        */
                          buildContainerInput(
                              context,
                              'Considere todos os custos e despesas que variam em função das vendas.\nPor exemplo:\nTaxas e impostos;\nCusto dos cartões de débito, crédito, tickets e vales;\nCustos das eventuais antecipações de vencimento e desconto de títulos;\nComissões, gorjetas;\nEstacionamento (quando pago em função do uso por clientes);\nCusto das entregas delivery.',
                              '',
                              _custoFixoController,
                              'Outros custos variáveis'
                              //  _custoVariavelController
                              ),
                           inputPercentual(context, percentualOutrosCustos)
                        ],
                      ),
                    ],
                  ),


                    const Espacamento(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tipoEmpresaSemEspacos == 'Serviços'?buildTituloInput(context,'Demais custos fixos'): buildTituloInput(context,'Custos fixos'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildIconeMsg(context,
                                'Custos e despesas que ocorrem independentemente das vendas.\nPor exemplo:\nSalários, encargos, provisões, benefícios e pró-labore;\nContratos de serviços: contador, Internet, TV à cabo, leitoras de cartões e estacionamento (quando for um valor mensal fechado);\nAluguéis, IPTU e taxas;\nÁgua, eletricidade, gás, materiais de limpeza e higiene.'),
                            buildContainerInput(
                                context,
                                'Custos e despesas que ocorrem independentemente das vendas.\nPor exemplo:\nSalários, encargos, provisões, benefícios e pró-labore;\nContratos de serviços: contador, Internet, TV à cabo, leitoras de cartões e estacionamento (quando for um valor mensal fechado);\nAluguéis, IPTU e taxas;\nÁgua, eletricidade, gás, materiais de limpeza e higiene.',
                                '',
                                _custoVariavelController,
                                'Custos fixos'
                                //_custoFixoController
                                ),
                            inputPercentual(context, percentualCustoFixo)
                          ],
                        ),
                      ],
                    ),
                  // const Espacamento(),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     buildTituloInput(context,'Demais custos fixos'),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       mainAxisSize: MainAxisSize.max,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         buildIconeMsg(context,
                  //             'Custos e despesas que ocorrem independentimente da prestação dos serviços: salários, encargos,provisões, benefícios, aluguéis, IPTU,  leitoras de cartões, contabilidade, Internet, TV a cabo, água, eletricidade, gás, materiais de limpeza e higiene.'),
                  //         buildContainerInput(
                  //             context,
                  //             '',
                  //             '',
                  //             _demais_custos_fixos,
                  //             'Demais custos fixos'
                  //           //_custoFixoController
                  //         ),
                  //         inputPercentual(context, percentualCustoFixo)
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  const Espacamento(),
                  tipoEmpresaSemEspacos == 'Serviços'?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Pró-labore'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context,
                              'Informe o valor da retirada mensal que você desejada (o quanto precisa mensalmente), inclusive dos demais quotistas, sócios, etc., se for o caso.'),
                          proLabore(context),
                        ],
                      ),
                    ],
                  ):Container(),
                  // const Espacamento(),
                  // tipoEmpresaSemEspacos == 'Serviços'?Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     buildTituloInput(context,'Hora de trabalho em uma semana'),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       mainAxisSize: MainAxisSize.max,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         buildIconeMsg(context,
                  //             'A soma das horas de expediente em uma semana'),
                  //         horasTrabalho(context),
                  //       ],
                  //     ),
                  //   ],
                  // ):Container(),
                  const Espacamento(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTituloInput(context,'Margen que você considera ideal'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildIconeMsg(context,
                              'Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.'),
                          margemDesejada(context),
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                //String textAjudaCapacidadeAtendimento ="Quantidade de clientes que o Negócio está estruturado para atender, com qualidade, durante um mês de atividade.";

              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tipoEmpresaSemEspacos == 'Serviços'?buildTituloInput(context,'Hora de trabalho em uma semana'):buildTituloInput(context,'Capacidade de atendimento'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.14,
                          //   child: Container(),
                          // ),
                          tipoEmpresaSemEspacos == 'Serviços'? buildIconeMsg(context,
                              'Hora de trabalho em uma semana.'):buildIconeMsg(context,
                'Quantidade de clientes que o Negócio está estruturado para atender, com qualidade, durante um mês de atividade.'),
                          capacidadeAtendimento(),
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: tipoEmpresaSemEspacos == 'Serviços'?  buildIconeMsg(context,
                            '''A soma das horas de expediente em uma semana'''):buildIconeMsg(context,
                            '''O botão "SALVAR"  deve ser pressionado todas as vezes que forem preenchidos os Dados básicos, ou algum dado for
                             posteriormente alterado.\nO botão "ATUALIZAR" deve ser pressionado sempre que "reutilizar" dados Básicos armazenados no 
                             Histórico.\nO botão "HISTÓRICO" abre a tela de todos os Dados básicos salvos.  '''),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.4,
                      //   child: ElevatedButton(
                      //     style: colorButtonStyle(),
                      //       /*ElevatedButton.styleFrom(
                      //       textStyle: const TextStyle(fontSize: 20),
                      //       //primary: const Color.fromRGBO(1, 57, 44, 1),
                      //     ),*/
                      //     onPressed: () {
                      //      // route.pushPage(context, NovoDadosBasicos());
                      //
                      //       _faturamentoController.text = "";
                      //       _quantidadeController.text = "";
                      //       _gastoinsumosController.text = "";
                      //       _custoFixoController.text = "";
                      //       _margenController.text = "";
                      //       _custoVariavelController.text = "";
                      //       _custoInsumosController.text = "";
                      //       mesSelecionaController.text = "";
                      //       mesSelect.value = "";
                      //       percentualVendas.text = "";
                      //       percentualGastosInsumos.text = "";
                      //       percentualOutrosCustos.text = "";
                      //       percentualCustoFixo.text = "";
                      //       _custoInsumosController.text ="";
                      //
                      //
                      //     },
                      //     child: const Text("Limpar"),
                      //   ),
                      // ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: colorButtonStyle(),
                          onPressed: _inserir,
                          child: const Text("Salvar"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: colorButtonStyle(),
                          onPressed: _listaDadosBasicos,
                          child: const Text("Histórico"),
                        ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.4,
                      //   child: ElevatedButton(
                      //     style: colorButtonStyle(),
                      //     onPressed: _buildBuildOnPressed,
                      //     child: const Text("Atualizar"),
                      //   ),
                       ),
                    ],
                  ),
                   // Row(
                   //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   //   mainAxisSize: MainAxisSize.max,
                   //   crossAxisAlignment: CrossAxisAlignment.center,
                   //   children: <Widget>[
                   //     SizedBox(
                   //       width: MediaQuery.of(context).size.width * 0.13,
                   //       child: Container(),
                   //     ),
                   //     SizedBox(
                   //       width: MediaQuery.of(context).size.width * 0.4,
                   //       child: ElevatedButton(
                   //         style: colorButtonStyle(),
                   //         onPressed: _inserir,
                   //         child: const Text("Salvar"),
                   //       ),
                   //     ),
                   //     SizedBox(
                   //       width: MediaQuery.of(context).size.width * 0.4,
                   //       child: ElevatedButton(
                   //         style: colorButtonStyle(),
                   //        onPressed: _delete,
                   //         child: const Text("Delete"),
                   //       ),
                   //     ),
                   //   ],
                   //   //_listaDadosBasicos
                   // ),
                   // SizedBox(
                   //   width: MediaQuery.of(context).size.width * 0.4,
                   //   child: ElevatedButton(
                   //     style: colorButtonStyle(),
                   //     onPressed: _listaDadosBasicos,
                   //     child: const Text("Histórico"),
                   //   ),
                   // ),

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

  Row buildTituloInput(BuildContext context, titulo) {
    return Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                          child: Container(),
                        ),
                       Text(titulo)
                      ],
                    );
  }

  Container inputPercentual(BuildContext context, contoler) {
    return Container(
      decoration: buildBuildBoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.30,
      child: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return TextFormField(
             // enabled: false,
           //   keyboardType: TextInputType.number,
              controller: contoler,
              // controller: null,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:    EdgeInsets.symmetric(horizontal: 5, vertical:0),
                fillColor:  Color.fromRGBO(245, 245, 245, 1),
                filled: true,
               // filled: true,
                suffixIcon: Icon(
                  Icons.percent,
                  color: Colors.black54,
                  size: 20,
                ),
                // disabledBorder: true,
                 focusedBorder:  OutlineInputBorder(
                // borderSide: BorderSide(color: Color(0xFFffd600)),
                 borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
               ),
                border:  OutlineInputBorder(
                  // borderSide: BorderSide(color: Color(0xFFffd600)),
                  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                ),
                // hintText: 'Quantidade de clientes atendidos',
              ),
            );
          }),
    );
  }
  Container proLabore(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        controller: _pro_labore,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter(moeda: true, casasDecimais: 2)
        ],
        // decoration: buildInputDecoration(context,'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).'),
        decoration:const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          fillColor:  Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          border:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
          ),
          labelText: "",
          labelStyle:  TextStyle(
            color: Colors.black,
            fontSize: 13,
            //  backgroundColor: Colors.white,
          ),
          // hintText: 'Quantidade de clientes atendidos',
        ),
      ),
    );
  }

  Container horasTrabalho(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        controller: _horas_trabalho,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
        ],
        // decoration: buildInputDecoration(context,'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).'),
        decoration:const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          /*    prefixIcon: IconButton(
                        icon: const Icon(Icons.help, color: Colors.black54,),
                        color: Colors.black54,
                        onPressed: () {
                          buildIconeMsg.openModal(context, 'Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.');
                        },
                      ),*/
          // suffixIcon: Icon(
          //
          //   Icons.percent,
          //   color: Colors.black54,
          //   size: 20,
          // ),
          fillColor:  Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          // disabledBorder: true,
          /*  focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),*/
          border:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
          ),

          labelText: "",
          labelStyle:  TextStyle(
            color: Colors.black,
            fontSize: 13,
            //  backgroundColor: Colors.white,
          ),
          // hintText: 'Quantidade de clientes atendidos',
        ),
      ),
    );
  }

  Container margemDesejada(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        controller: _margenController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
        ],
        // decoration: buildInputDecoration(context,'Valor bruto apurado com as vendas realizadas (valor pago pelo cliente).'),
        decoration:const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          /*    prefixIcon: IconButton(
                        icon: const Icon(Icons.help, color: Colors.black54,),
                        color: Colors.black54,
                        onPressed: () {
                          buildIconeMsg.openModal(context, 'Em relação ao faturamento, quanto % você gostaria que o seu empreendimento desse de lucro.');
                        },
                      ),*/

          suffixIcon: Icon(

            Icons.percent,
            color: Colors.black54,
            size: 20,
          ),
          fillColor:  Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          // disabledBorder: true,
          /*  focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),*/
          border:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
          ),

          labelText: "",
          labelStyle:  TextStyle(
            color: Colors.black,
            fontSize: 13,
            //  backgroundColor: Colors.white,
          ),
          // hintText: 'Quantidade de clientes atendidos',
        ),
      ),
    );
  }

  Container quantidadClientesAtendido() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        controller: _quantidadeController,
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          fillColor: const Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          // disabledBorder: true,
            focusedBorder:  OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
          border:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
          ),
          labelText: "",
          labelStyle:  TextStyle(
            color: Colors.black54,
            fontSize: 13,
            //  backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }


  Container capacidadeAtendimento() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        validator: ValidationBuilder().maxLength(50).required().build(),
        keyboardType: TextInputType.number,
        controller: _capacidadeAtendimento,
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          fillColor: const Color.fromRGBO(245, 245, 245, 1),
          filled: true,
          // disabledBorder: true,
          focusedBorder:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
          ),
          border:  OutlineInputBorder(
            // borderSide: BorderSide(color: Color(0xFFffd600)),
            borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
          ),
          labelText: "",
          labelStyle:  TextStyle(
            color: Colors.black54,
            fontSize: 13,
            //  backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Container containerMsgMesSelecionado() {
    return Container(
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
                textAlign: TextAlign.justify,
                enabled: false,
                keyboardType: TextInputType.none,
                maxLines: 6,
                controller: TextEditingController(text: data.toString()),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  fillColor: Colors.grey[100],
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(159, 105, 56, 1),
                       // width: 1.0,
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
    );
  }

  IconButton buildIconeMsg(BuildContext context, msgAlertaMes) {
    return IconButton(
      iconSize: 35,
      icon:const Icon(
        Icons.lightbulb,
        //color: Color.fromRGBO(1, 57, 44, 1),
        color: Colors.amberAccent,
      ),
      onPressed: () {
        alerta.openModal(context, msgAlertaMes);
      },
    );
  }

  Container buildSelecioneMes(List<String> dropOpcoes) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: buildBuildBoxDecoration(),
      child: ValueListenableBuilder(
          valueListenable: mesSelect,
          builder: (BuildContext context, String value, _) {
            return SizedBox(
              child: DropdownButtonFormField<String>(
                  decoration:const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                         EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    fillColor:  Color.fromRGBO(245, 245, 245, 1),
                    filled: true,
                    // disabledBorder: true,
                      focusedBorder:  OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),
                    border:  OutlineInputBorder(
                      // borderSide: BorderSide(color: Color(0xFFffd600)),
                      borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                    ),
                    labelText: "",
                    labelStyle:  TextStyle(
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
                    importanciaMesesBLoc.msgInfoMesSelecionado(onChanged);
                    _faturamentoController.text = "";
                    _custoInsumosController.text = "";
                    _custoFixoController.text = "";
                    _gastoinsumosController.text = "";
                    _quantidadeController.text = "";
                    _margenController.text = "";
                    _custoVariavelController.text = "";
                    percentualVendas.text = "";
                    percentualGastosInsumos.text = "";
                    percentualOutrosCustos.text = "";
                    percentualCustoFixo.text = "";
                    _custoInsumosController.text="";
                    _capacidadeAtendimento.text ="";
                    _pro_labore.text ="";
                    mesSelect.value = onChanged.toString();
                  }),
            );
          }),
    );
  }

  Container buildContainerInput(
      BuildContext context, text, titulo, controllerInformado, nomeCampo) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.50,
      decoration: buildBuildBoxDecoration(),
      child: TextFormField(
        onTap: () {
          //  FocusScope.of(context).unfocus(); // Fecha o teclado ao tocar fora do campo de text
        },
        onChanged: (value) {
          // print('nomeCampo');
          // print('value');
          // print(nomeCampo);
          // print(value);
          if ('Faturamento' == nomeCampo) {
            calculoPercentual(value, _custoFixoController.text,_custoVariavelController.text, _custoInsumosController.text,nomeCampo);
          }
          if ('Gastos com insumos' == nomeCampo) {
            calculoPercentual(
                _faturamentoController.text,
                _custoFixoController.text,
                _custoVariavelController.text,
                value,nomeCampo);
          }
          if ('Outros custos variáveis' == nomeCampo) {
            calculoPercentual(_faturamentoController.text, value,
                _custoVariavelController.text, _custoInsumosController.text,nomeCampo);
          }
          if ('Custos fixos' == nomeCampo) {
            calculoPercentual(_faturamentoController.text, _custoFixoController.text, value, _custoInsumosController.text,nomeCampo);
          }

          setState(() {
            percentualVendas.text = "100,00";
            if ('Faturamento' == nomeCampo) {
              calculoPercentual(value, _custoFixoController.text,_custoVariavelController.text, _custoInsumosController.text,nomeCampo);

            }
            if ('Gastos com insumos' == nomeCampo) {
              calculoPercentual(
                  _faturamentoController.text,
                  _custoFixoController.text,
                  _custoVariavelController.text,
                  value,nomeCampo);
              percentualGastosInsumos.text =  '${formatterPercentual.format(gastosInsumos)} ';
            }
            if ('Outros custos variáveis' == nomeCampo) {
              calculoPercentual(_faturamentoController.text, value,                  _custoVariavelController.text, _custoInsumosController.text,nomeCampo);
              percentualOutrosCustos.text =  '${formatterPercentual.format(outrosCustos)} ';
            }
            if ('Custos fixos' == nomeCampo) {
              calculoPercentual(_faturamentoController.text, _custoFixoController.text, value, _custoInsumosController.text,nomeCampo);
              percentualCustoFixo.text =         '${formatterPercentual.format(custoFixo)} ';
            }

            if ('Demais custos fixos' == nomeCampo) {
              calculoPercentual(_faturamentoController.text, _custoFixoController.text, value, _custoInsumosController.text,nomeCampo);
              percentualCustoFixo.text =         '${formatterPercentual.format(custoFixo)} ';
            }


          });
        },
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

  calculoPercentual(faturamento, gastos, custo, insumos,nomeCampo) {
    var faturamentoTemp = (faturamento
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var gastosTemp = (gastos //_custoFixoController.text
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var custo_fixoTemp = (custo //  _custoVariavelController.text
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var gastosIsumosTemp = (insumos //_custoInsumosController.text
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    if ('Faturamento' == nomeCampo) {
      fatVendas = double.parse(faturamentoTemp).truncateToDouble();
    }
    if ('Gastos com insumos' == nomeCampo) {
      gastosInsumos = (double.parse(gastosIsumosTemp).truncateToDouble() / fatVendas) * 100;
    }
    if ('Outros custos variáveis' == nomeCampo) {
      outrosCustos = (double.parse(gastosTemp).truncateToDouble() / fatVendas) * 100;
    }
    if ('Custos fixos' == nomeCampo) {
      custoFixo = (double.parse(custo_fixoTemp).truncateToDouble() / fatVendas) * 100;
    }
  }

  buildBuildBoxDecoration() {
    return const BoxDecoration(
    //  color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.white,
       //   blurRadius: 1,
        //  offset: Offset(1, 3), // Shadow position
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration(BuildContext context, text, titulo) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      /*    prefixIcon: IconButton(
        icon: const Icon(Icons.help, color: Colors.black54,),
        color: Colors.black54,
        onPressed: () {
          alerta.openModal(context, text);
        },
      ),*/

      //   suffixIcon: suffixIcon,
      fillColor: const Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      // disabledBorder: true,
        focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),

      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  _insertUpdate(operacao) async {
    final isValid = _formKey.currentState!.validate();
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    // if (!isConnected) {
    //   alerta.openModal(context, 'Sem conexão com a internet.');
    // }
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
    if (mesSelect.value.isEmpty) {
      alerta.openModal(context, "Selecionde o mês de referencia");
      return;
    }
    if (!isValid) {
      alerta.openModal(context,
          "É NECESSÁRIO QUE TODOS OS CAMPOS SEJAM PREENCHIDOS! Exceção: no caso de 'gastos com insumos' e 'gastos com produto para revenda' será admimivel apenas um deles seja preenchido");
      return;
    }
    setState(() {
      retorno = 'A';
      //  operacaoBancoDados = 'A';
    });
    data_cadastro ??= DateTime.now().toIso8601String();
     _consultarMeses(mesSelect.value);



    // desabilitado o salvamento no firebase
    // var dados = {
    //   'quantidade_clientes_atendido': _quantidadeController.text,
    //   'faturamento_vendas': _faturamentoController.text,
    //   'gastos_insumos': _gastoinsumosController.text,
    //   'custo_fixo': _custoFixoController.text,
    //   'custo_insumos_terceiros': _custoVariavelController.text,
    //   'mes_selecionado': mesSelect.value,
    //   'custo insumos': _custoInsumosController.text,
    //   'magem_desejada': _margenController.text,
    //   'gasto_com_vendas': _custoInsumosController.text,
    //   'capacidade_atendimento':_capacidadeAtendimento.text ,
    //   'data_cadastro': data_cadastro
    // };

    // if (id == 0 || operacao =='i') {
    // gravação sql migrada para função execucao
    //   _saveUpdate(_getDados(null, mesSave),"Dados básicos cadastrado com sucesso");
    // } else {
    //   _saveUpdate(_getDados(id, mesSave), "Dados básicos atulizado com sucesso");
    // }
  }

  _execucao(operacao){
 //   print('_tipoEmpresaws');
  //  print(_tipoEmpresa);
    print(_getDados(id, mesSelect.value,_tipoEmpresa));
      if (id == 0 || operacao =='i') {
        _saveUpdate(_getDados(null, mesSelect.value,_tipoEmpresa),"Dados básicos cadastrado com sucesso");
      } else {
        _saveUpdate(_getDados(id, mesSelect.value,_tipoEmpresa), "Dados básicos atulizado com sucesso");
      }
  }
  _inserir()async{
    data_cadastro = DateTime.now().toIso8601String();
    _insertUpdate('i');
  }
  _delete()async{

    var alert = AlertSnackBar();
    await bd.deleteDadosBasicos(id);
    await bd.deleteDadosBasicos(id);
    alert.alertSnackBar(context, Colors.green, "Excluído com sucesso");
    route.pushPage(context, NovoDadosBasicos());
    _consultar();
  }
  _listaDadosBasicos(){

    route.pushPage(context, ListaDadosBasicos());
  }
  _buildBuildOnPressed() async {
    data_cadastro = DateTime.now().toIso8601String();
    _insertUpdate('a');
  }

  _getDados(idinfo, mesRef, empresaTipo) {

    data_cadastro ??= DateTime.now().toIso8601String();
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
        _capacidadeAtendimento.text,
        data_cadastro,
        _tipoEmpresa,
        _horas_trabalho.text,
        _pro_labore.text,
        _demais_custos_fixos.text,
    );
  }
  ButtonStyle colorButtonStyle() {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromRGBO(1, 57, 44, 1)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }

  _saveUpdate(dados, msg) {
    var alert = AlertSnackBar();
    bd.save(dados.toJson()).then((value) {
      alert.alertSnackBar(context, Colors.green, msg);
    });
  }
  void _confirmarOperacao() async {
    print("_confirmarOperacao");
    print(operacaoBancoDados);
     print(retorno);
    if ('N' == retorno) {
      bool? confirmar = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text("Confirmação"),
            content: Text("Para o mes seleceionado já tem dados basíco cadastrado ao salvar o mesmo será atualizado com estas inforamções.\nDeseja continuar?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Fecha a modal sem alterar a variável
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirma a ação
                },
                child: Text("Atualizar"),
              ),
            ],
          );
        },
      );
      if (confirmar == true) {
        setState(() {
          operacaoBancoDados = 'a';
          _execucao('a');
        });
      }
    }else{
      print("swasd");
      _execucao('i');
    }
  }

}
