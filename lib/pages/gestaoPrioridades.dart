import 'package:appgestao/blocs/simulador_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class gestaoPrioridades extends StatefulWidget {
  const gestaoPrioridades({Key? key}) : super(key: key);

  @override
  State<gestaoPrioridades> createState() => _gestaoPrioridadesState();
}

class _gestaoPrioridadesState extends State<gestaoPrioridades> {
  var header = new HeaderAppBar();
  var alerta = AlertModal();
  var color = const Color.fromRGBO(1, 57, 44, 1);
  var corFundo = Colors.grey[150];
  var corBox = Colors.white;

  var simuladorBloc;
  final _formKey = GlobalKey<FormState>();

  var info = AlertSnackBar();

  var vendasController = TextEditingController();
  var ticketMedioController = TextEditingController();
  var custoInsumosController = TextEditingController();
  var custoProdutoController = TextEditingController();
  var custoVariavelController = TextEditingController();
  var custoFixoController = TextEditingController();
  var addController = TextEditingController();
  var removeController = TextEditingController();
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

  var addRemoveInput = false;

  var route = PushPage();
  final dropOpcoes = [
    "Quantidade de vendas",
    "Ticket médio",
    "Custo insumos",
    "Custos produtos 3º",
    "Outros custo variaveis",
    "Custo fixo"
  ];
  void initState() {
    simuladorBloc = SimuladorBloc();
    simuladorBloc.getDadosBasicos();

    addController.text = '';
    removeController.text = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    simuladorBloc.getDadosBasicos();

    return Scaffold(
      appBar: header.getAppBar('Home'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Espacamento(),
              buildRow(context),
              const Espacamento(),
              builSelect(),
              const Espacamento(),
              buildNewRemoveAdd(context),
              const Espacamento(),
              buildCardCampos(
                context,
                "Margem",
                simuladorBloc.margemIdealController,
                simuladorBloc.margemResultateController,
                simuladorBloc.varicaoMargemController,
                "Informada",
                "Caculada",
                "desabilitado",
                "desabilitado",
                buildIcon(),
                buildIcon(),
                false,
                false,
                null,
                null
              ),
              const Espacamento(),
              buildCardCampos(
                  context,
                  "Margem",
                  simuladorBloc.margemIdealController,
                  simuladorBloc.margemResultateController,
                  simuladorBloc.varicaoMargemController,
                  "Informada",
                  "Caculada",
                  "desabilitado",
                  "desabilitado",
                  buildIcon(),
                  buildIcon(),
                  false,
                  false,
                  null,
                  null
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildCardCampos(BuildContext context, titulo, stremBadosBasico,
      stremCalculada, stremVariacao, imputTitulo1, imputTitulo2,imputStatus1,imputStatus2,icone1, icone2, format1,format2,onChanged1,onChanged2) {
    return Container(
      decoration: BoxDecoration(
        // color: corBox,
        border: Border.all(color: color),
        // borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: corBox,
            blurRadius: 1,
            offset: Offset(1, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(titulo),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                buildStreamBuilder(
                  stremBadosBasico,
                  imputTitulo1,
                  imputStatus1,
                  format1,
                  icone1,
                  onChanged1,
                ),
                SizedBox(height: 10.0),
                buildStreamBuilder(
                  stremCalculada,
                  imputTitulo2,
                  imputStatus2,
                  format2,
                  icone2,
                  onChanged2,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: StreamBuilder(
                stream: stremVariacao,
                builder: (context, snapshot) {
                  return Text("${snapshot.data.toString()} %");
                }),
          )
        ],
      ),
    );
  }

  Padding buildStreamBuilder(
      stream, inputTitulo, cor, format, icone, onChanged) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              var data = snapshot.data;
              return buildContainer(
                  "$data", inputTitulo, cor, format, icone, onChanged);
            } else {
              return buildContainer(
                  "", inputTitulo, cor, format, icone, onChanged);
            }
          }),
    );
  }

  Padding buildContainer(data, inputTitulo, cor, format, icone, onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        // width: 185,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: buildBoxDecoration(),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              if (format) {
                return TextFormField(
                  // textAlign: TextAlign.center,
                  //textAlignVertical: TextAlignVertical.center,
                  enabled: false,
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: "$data"),
                  decoration: _styleInput(inputTitulo, cor, icone),
                  inputFormatters: [
                    // FilteringTextInputFormatter.digitsOnly,
                    //  CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  onChanged: onChanged,
                );
              } else {
                return TextFormField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: "$data"),
                  decoration: _styleInput(inputTitulo, cor, icone),
                  onChanged: (text) {
                    onChanged;
                  },
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }
            }),
      ),
    );
  }

  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundo = Color.fromRGBO(112, 111, 111, 1);
        break;
      case 'desabilitado':
        corFundo =Color.fromRGBO(112, 111, 111, 1);
        break;
      case 'vermelho':
        corFundo = Colors.red;
        break;
      case 'verde':
        corFundo = Colors.green;
        break;
      case 'null':
        corFundo = Colors.grey[100];
        break;
    }

    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      suffixIcon: suffixIcon,
      fillColor: corFundo,
      filled: true,

      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color:Color.fromRGBO(112, 111, 111, 1), width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }

  Icon buildIcon() {
    return const Icon(
      Icons.percent,
      color: Colors.black54,
      size: 16.0,
    );
  }

  Container builSelect() {
    return Container(
      //  width: 295,

      child: DropdownButtonFormField<String>(
        itemHeight: null,
        value: null,
        decoration: buildInputDecoration("Selecione um item"),
        onChanged: (values) {
          print(values);
          setState(() {
            //  _items=[];
            //   _nomeController.text =values!;
          });
        },
        items: dropOpcoes.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  //  fontSize: 13,
                  //  color: const Color.fromRGBO(159, 105, 56,1),
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 35,
          icon: const Icon(
            Icons.help,
            color: Color.fromRGBO(1, 57, 44, 1),
          ),
          onPressed: () {
            alerta.openModal(context, 'textoAjuda');
          },
        ),
        const Text(
          'Gestão de prioridades',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Container buildNewRemoveAdd(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: const BoxDecoration(

                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(1, 3), // Shadow position
                    ),
                  ],
                ),
                child: TextFormField(
                    // enabled: false,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: addController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      suffixIcon: Icon(
                        Icons.percent,
                        color: Colors.black54,
                      ),
                      fillColor: Color.fromRGBO(112, 111, 111, 1),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(112, 111, 111, 1),
                            width: 1.0,
                            style: BorderStyle.none),
                      ),
                      border: InputBorder.none,
                      labelText: '',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        //  backgroundColor: Colors.white,
                      ),
                      // hintText: 'Indique',
                    ),
                    onChanged: (text) {
                      // simuladorBloc.calculoPercentual(text,1,valorInicialTicket,2,context);
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
              width: MediaQuery.of(context).size.width * 0.50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
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
                            color: Color.fromRGBO(159, 105, 56, 0.5),
                            size: 35.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        const Text(
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
                            color: Color.fromRGBO(159, 105, 56, 0.5),
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
      ),
    );
  }
}

BoxDecoration buildBoxDecoration() {
  return const BoxDecoration(
    color: Colors.transparent,
    //borderRadius: BorderRadius.circular(20),
    /*
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 1,
        offset: Offset(1, 3), // Shadow position
      ),


    ],*/
  );
}

InputDecoration buildInputDecoration(text) {
  var iconeAjuda = null;
  var textoAjuda = "";
  bool mostrarAlerta = false;
  if (text == 'Cep') {
    textoAjuda =
        "Digite o seu cep e a cidade e estado são adicionado automaticamente.";
    mostrarAlerta = true;
  }

  if (mostrarAlerta) {
    iconeAjuda = IconButton(
      icon: const Icon(
        Icons.help,
        color: Colors.black54,
      ),
      color: Colors.black54,
      onPressed: () {
        //  alerta.openModal(context,textoAjuda );
      },
    );
  }
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    //   suffixIcon: suffixIcon,
    fillColor: const Color.fromRGBO(159, 105, 56, 0.5),
    filled: true,

    prefixIcon: iconeAjuda,
    // disabledBorder: true,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: Color.fromRGBO(159, 105, 56, 0.5),
          width: 1.0,
          style: BorderStyle.none),
    ),
    border: InputBorder.none,
    labelText: text,
    labelStyle: const TextStyle(
      color: Colors.black,
      //  backgroundColor: Colors.white,
    ),
  );
}
