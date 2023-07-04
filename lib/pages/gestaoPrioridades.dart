import 'package:appgestao/blocs/simulador_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/telaAjudaSimulador.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:form_validator/form_validator.dart';

class GestaoPrioridade extends StatefulWidget {
  const GestaoPrioridade({Key? key}) : super(key: key);

  @override
  State<GestaoPrioridade> createState() => _GestaoPrioridadeState();
}

class _GestaoPrioridadeState extends State<GestaoPrioridade> {
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var info = AlertSnackBar();
  var route = PushPage();

  //var corFundo = Colors.grey[150];
  var corFundo = Color.fromRGBO(159, 105, 56,0.5);

  var clientesAtendidosVariacao = TextEditingController();

  var vendasController = TextEditingController();
  var ticketMedioController = TextEditingController();
  var custoInsumosController = TextEditingController();
  var custoProdutoController = TextEditingController();
  var custoVariavelController = TextEditingController();
  var custoFixoController = TextEditingController();
  var addController = TextEditingController();
  var removeController = TextEditingController();
  var ticketMedioDadosBasicoController =TextEditingController();
  var tickerMedioVariacao =TextEditingController();

  var selectController = "";

  var dataVendas;
  var vendasColor = 'desabilitado';
  var ticketMedioCor = 'desabilitado';
  var custoInsumosColor = 'desabilitado';
  var custoProdutoColor = 'desabilitado';
  var custoVariavelColor = 'desabilitado';
  var custoFixoColor = 'desabilitado';
  var vendasStatus = true;
  var valorInicialTicket = "";
  var _dadosBasicoNULL = false;
  var simuladorBloc;
  var addRemoveInput = false;
  //**//

  var ticketMedioDadosBasico ="";

  //**//
  final _formKey = GlobalKey<FormState>();
  var color = const Color.fromRGBO(1, 57, 44, 1);
  @override
  void initState() {
    simuladorBloc = SimuladorBloc();

    addController.text = '';
    removeController.text = '';

    super.initState();
    setState(() {
      clientesAtendidosVariacao.text = "100";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.getAppBar('Gestão de prioridades'),
        drawer: Menu(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Espacamento(),
                  buidTitulo(context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selecione um item'),
                      buildTextDropdownFormField(),
                      buildNewRemoveAdd(context),
                    ],
                  ),
                  buildClientesAtendidos(context),
                  const Espacamento(),
                  const Espacamento(),
                  const Text("Preparado para vender mais, com qualidade?"),
                  const Espacamento(),
                  const Espacamento(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: color,
                          width: 1.0,
                          style: BorderStyle.solid,
                        )),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: const Text("Ticket Médio"),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Column(
                                    children: [
                                  Padding(  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                          child: Container(
                                            //  width: 185,
                                            width: MediaQuery.of(context).size.width*0.45,
                                            //  decoration: buildBoxDecoration(),
                                            child: StreamBuilder(
                                              stream: simuladorBloc.ticketDadosBasicos,
                                              builder: (context, snapshot) {
                                                var data = snapshot.data;
                                                if(!snapshot.hasData){
                                                  data ="";
                                                }
                                                return TextFormField(
                                                    enabled: false,
                                                    keyboardType: TextInputType.number,
                                                    controller: ticketMedioDadosBasicoController = TextEditingController(text: '$data'),
                                                   // decoration:       TextAlignVertical.center,
                                                    style :const  TextStyle( color: Colors.white),
                                                    decoration: const InputDecoration(
                                                      floatingLabelBehavior:
                                                      FloatingLabelBehavior.always,
                                                      contentPadding: EdgeInsets.symmetric( horizontal: 5, vertical: 0),
                                                      fillColor: Color.fromRGBO(1, 57, 44, 1),
                                                      // fillColor:  Color.fromRGBO(245, 245, 245, 1),
                                                      filled: true,
                                                      border: InputBorder.none,
                                                      // labelStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                                                      // filled: true,
                                                      // disabledBorder: true,

                                                      focusedBorder: OutlineInputBorder(
                                                        // borderSide: BorderSide(color: Color(0xFFffd600)),
                                                        borderSide: BorderSide(
                                                            color: Color.fromRGBO(  1, 57, 44, 1), width: 1.0),
                                                      ),
                                                      /*   border:  OutlineInputBorder(
                                                         borderSide: BorderSide(color: Colors.white),
                                                      //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                                                      ),*/
                                                      // hintText: 'Quantidade de clientes atendidos',
                                                    ),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      CentavosInputFormatter(
                                                          moeda: true, casasDecimais: 2)
                                                    ],
                                                    onChanged: (text) { simuladorBloc
                                                          .calculoTicketMedioInput(text);
                                                    });
                                              },
                                            ),
                                          ),
                                        ),
                                      StreamBuilder(
                                        stream: simuladorBloc.corTicketMediolController,
                                        builder: (context, snapshot) {
                                          var dataCor = snapshot.data;
                                          ticketMedioCor = dataCor.toString();
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                            child: Container(
                                              //  width: 185,
                                             // width: MediaQuery.of(context).size.width*0.45,
                                            //  decoration: buildBoxDecoration(),
                                              child: StreamBuilder(
                                                  stream: simuladorBloc.ticketMedioController,
                                                  builder: (context, snapshot) {
                                                    var data = snapshot.data;
                                                    if(!snapshot.hasData){
                                                      data ="";
                                                    }
                                                    return TextFormField(
                                                     //   enabled: false,
                                                        keyboardType: TextInputType.number,
                                                        controller: ticketMedioController = TextEditingController(text: '$data'),
                                                        decoration: _styleInput( 'Ticket Médio', ticketMedioCor, null),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter.digitsOnly,
                                                          CentavosInputFormatter(
                                                              moeda: true, casasDecimais: 2)
                                                        ],
                                                        onChanged: (text) {
                                                          //simuladorBloc.calculoTicketMedioInput(text);
                                                          var ticketTemp = (text
                                                              .toString()
                                                              .replaceAll("R\$", "")
                                                              .replaceAll('.', '')
                                                              .replaceAll(',', '.'));
                                                          var ticketTempBasico = (ticketMedioDadosBasicoController.text
                                                              .toString()
                                                              .replaceAll("R\$", "")
                                                              .replaceAll('.', '')
                                                              .replaceAll(',', '.'));

                                                         var tkmd = double.parse(ticketTempBasico).truncateToDouble();
                                                         var tkMedio = (double.parse(ticketTemp).truncateToDouble() /double.parse(ticketTemp).truncateToDouble() ) * 100;
                                                          tickerMedioVariacao.text =tkMedio.toString();
                                                        });
                                                  },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              child: inputPercentual(context, tickerMedioVariacao),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundo =  Colors.white10;
        break;
      case 'desabilitado':
        corFundo = Colors.green;
        break;
      case 'vermelho':
        corFundo = Colors.red;
        break;
      case 'verde':
        corFundo = Colors.green;
        break;
      case 'null':
        corFundo = Color.fromRGBO(245, 245, 245, 1);
        break;
    }

    return  InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric( horizontal: 5, vertical: 0),
      fillColor: corFundo,
    //  fillColor:  Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      border: InputBorder.none,
      labelStyle:new TextStyle(color: Colors.white, fontSize: 16.0),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  Container buildClientesAtendidos(BuildContext context) {
    return Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: color,
                        width: 1.0,
                        style: BorderStyle.solid,
                      )),
                  child: Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: const Text("Clientes Atendidos"),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: Container(
                              child: StreamBuilder(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                      // enabled: false,
                                      //   keyboardType: TextInputType.number,
                                      controller: null,
                                      // controller: null,
                                      textAlignVertical:
                                      TextAlignVertical.center,
                                      style :const  TextStyle( color: Colors.white),
                                      decoration: const InputDecoration(
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        contentPadding: EdgeInsets.symmetric( horizontal: 5, vertical: 0),
                                        fillColor: Color.fromRGBO(1, 57, 44, 1),
                                       // fillColor:  Color.fromRGBO(245, 245, 245, 1),
                                        filled: true,
                                        border: InputBorder.none,
                                       // labelStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                                        // filled: true,
                                        // disabledBorder: true,

                                        focusedBorder: OutlineInputBorder(
                                          // borderSide: BorderSide(color: Color(0xFFffd600)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(  1, 57, 44, 1), width: 1.0),
                                        ),
                                        /*   border:  OutlineInputBorder(
                                             borderSide: BorderSide(color: Colors.white),
                                          //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                                          ),*/
                                        // hintText: 'Quantidade de clientes atendidos',
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: Container(
                              child: StreamBuilder(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                      // enabled: false,
                                      //   keyboardType: TextInputType.number,
                                      controller: null,
                                      // controller: null,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        //fillColor:Color.fromRGBO(1, 57, 44, 1),
                                          fillColor:  Color.fromRGBO(245, 245, 245, 1),
                                        filled: true,
                                        border: InputBorder.none,
                                        // filled: true,
                                        // disabledBorder: true,
                                        focusedBorder: OutlineInputBorder(
                                          // borderSide: BorderSide(color: Color(0xFFffd600)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  1, 57, 44, 1),
                                              width: 1.0),
                                        ),
                                        /*   border:  OutlineInputBorder(
                                             borderSide: BorderSide(color: Colors.white),
                                          //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                                          ),*/
                                        // hintText: 'Quantidade de clientes atendidos',
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: inputPercentual(context, clientesAtendidosVariacao),
                      ),
                    ],
                  ),
                );
  }

  Container inputPercentual(BuildContext context, contoler) {
    return Container(
      // decoration: buildBuildBoxDecoration(),
      padding: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.28,
      child: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return TextFormField(
              // enabled: false,
              //   keyboardType: TextInputType.number,
              inputFormatters: [
                // obrigatório
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(moeda: true, casasDecimais: 2)
              ],
              controller: contoler,
              // controller: null,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:                    EdgeInsets.symmetric(horizontal: 5, vertical: 0),
               fillColor: Color.fromRGBO(245, 245, 245, 1),
               // fillColor:  Color.fromRGBO(105, 105, 105, 1),
                filled: true,
                border: InputBorder.none,
                // filled: true,
                suffixIcon: Icon(
                  Icons.percent,
                  color: Colors.black54,
                  size: 20,
                ),
                // disabledBorder: true,
                focusedBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Color(0xFFffd600)),
                  borderSide: BorderSide(
                      color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
                ),
                /*   border:  OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.white),
                //  borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
                ),*/
                // hintText: 'Quantidade de clientes atendidos',
              ),
            );
          }),
    );
  }

  Container buildNewRemoveAdd(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Indique um percentual"),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                      // enabled: false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: addController,
                      decoration: buildInputDecoration(null),
                      onChanged: (text) {
                        // simuladorBloc.calculoPercentual(text,1,valorInicialTicket,2,context);
                      }),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                  width: MediaQuery.of(context).size.width * 0.47,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            const Text(
                              'Aumentar',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (addController.text.isEmpty) {
                                  alerta.openModal(
                                      context, "Adicione o percentual.");
                                } else {
                                  simuladorBloc.calculoPercentual(
                                      addController.text,
                                      1,
                                      valorInicialTicket,
                                      1,
                                      context);
                                  addController.text = '';
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                }
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color.fromRGBO(1, 57, 44, 1),
                                size: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            Text(
                              'Diminuir',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (addController.text.isEmpty) {
                                  alerta.openModal(
                                      context, "Adicione o percentual.");
                                } else {
                                  simuladorBloc.calculoPercentual(
                                      addController.text,
                                      2,
                                      valorInicialTicket,
                                      2,
                                      context);
                                  addController.text = '';
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                }
                              },
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Color.fromRGBO(1, 57, 44, 1),
                                size: 35.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextDropdownFormField buildTextDropdownFormField() {
    return TextDropdownFormField(
      //keyboardType: TextInputType.none,
      onChanged: (dynamic text) {
        removeController.text = '';
        addController.text = '';
        //   simuladorBloc.setPercentualInput();
        setState(() {
          valorInicialTicket = text;
          addRemoveInput = true;
        });
      },
      options: const [
        "Quantidade de vendas",
        "Ticket médio",
        "Custo insumos",
        "Custos produtos 3º",
        "Outros custo variaveis",
        "Custo fixo"
      ],
      decoration: buildInputDecoration( const Icon(
        Icons.arrow_drop_down,
        color: Color.fromRGBO(1, 57, 44, 1),
        size: 26,
      )),
      dropdownHeight: 350,
    );
  }

  InputDecoration buildInputDecoration(suffixIcon) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

      fillColor: Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide: BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:
            BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),
      // labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        //  backgroundColor: Colors.white,
      ),
      suffixIcon: suffixIcon,
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  Container buidTitulo(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          route.pushPage(context, const TelaAjudaSimulador());
        },
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: 'Para você definir prioridades',
            prefixIcon: Icon(
              Icons.help,
              color: Colors.black54,
              size: 20,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
