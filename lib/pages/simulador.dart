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

class Simulador extends StatefulWidget {
  const Simulador({Key? key}) : super(key: key);

  @override
  State<Simulador> createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {
  var simuladorBloc;
  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var info = AlertSnackBar();
  var corFundo = Colors.grey[150];
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
  void initState() {
    simuladorBloc = SimuladorBloc();

    addController.text = '';
    removeController.text = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Simulador'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Espacamento(),
                Container(
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
                          size: 30,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Espacamento(),
                buildRow(
                  buildStreamBuilder(
                    simuladorBloc.margemIdealController,
                    "",
                    "desabilitado",
                    false,
                    buildIcon(),
                    null,
                  ),

                  buildStreamBuilder(
                    simuladorBloc.margemInformadaController,
                    "",
                    "desabilitado",
                    false,
                    buildIcon(),
                    null,
                  ),
                ),
                const Espacamento(),
                Container(
                  child: StreamBuilder(
                      stream: simuladorBloc.margemResultateController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        vendasColor = dataCor.toString();
                        //     print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                          child: Container(
                            width: 185,
                           // width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: simuladorBloc.margemResultateController,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                    _dadosBasicoNULL = true;
                                 //   info.alertSnackBar(context, Colors.red, 'Nenhum usuário encontrado para esse e-mail.');
                                  }
                                  return TextFormField(
                                    // textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    controller:
                                        TextEditingController(text: "$data"),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      //  suffixIcon: suffixIcon,
                                      fillColor: Colors.grey[100],
                                      filled: true,

                                      // disabledBorder: true,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange,
                                            width: 1.0,
                                            style: BorderStyle.none),
                                      ),
                                      border: InputBorder.none,
                                      labelText: 'Margem resultante',
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontStyle: FontStyle.normal,
                                        //  backgroundColor: Colors.white,
                                      ),
                                      // hintText: 'Quantidade de clientes atendidos',
                                    ),
                                  );
                                }),
                          ),
                        );
                      }),
                ),
                const Espacamento(),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.92,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      //borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(1, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: TextDropdownFormField(
                      //keyboardType: TextInputType.none,
                      onChanged: (dynamic text) {

                        removeController.text ='';
                        addController.text ='';
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

                      decoration: _styleInput(
                          'Selecione um item ',
                          "padrao",
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 26,
                          )),
                      dropdownHeight: 350,
                    ),
                  ),
                ),
             //   addRemoveInput ?buildContainerAddRemove(context) : Container(),
                addRemoveInput ? buildNewRemoveAdd(context):Container(),
                const Espacamento(),
                buildRow(
                  StreamBuilder(
                      stream: simuladorBloc.corVendalController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        vendasColor = dataCor.toString();
                        //  print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                          child: Container(
                         //   width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: simuladorBloc.vendasController,
                                builder: (context, snapshot) {

                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }

                                  return TextFormField(
                                      //   enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller:
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput(
                                          'vendas', vendasColor, null),
                                      onChanged: (text) {
                                        simuladorBloc.calculoVendas(text);
                                      });
                                }),
                          ),
                        );
                      }),
                  StreamBuilder(
                      stream: simuladorBloc.corTicketMediolController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        ticketMedioCor = dataCor.toString();
                        print('ticketMedioCor');
                          print(ticketMedioCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          child: Container(
                          //  width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: simuladorBloc.ticketMedioController,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }
                                  return TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: ticketMedioController =
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput(
                                          'Ticket Médio', ticketMedioCor, null),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CentavosInputFormatter(
                                            moeda: true, casasDecimais: 2)
                                      ],
                                      onChanged: (text) {
                                        simuladorBloc
                                            .calculoTicketMedioInput(text);
                                      });
                                }),
                          ),
                        );
                      }),
                ),
                const Espacamento(),
                buildContainerFaturamento(),
                const Espacamento(),
                buildRow(
                  StreamBuilder(
                      stream: simuladorBloc.corCustoInsumoslController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        custoInsumosColor = dataCor.toString();
                           print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          child: Container(
                           // width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: simuladorBloc.custoInsumosController,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }
                                  return TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: custoInsumosController =
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput('Custo insumos',
                                          custoInsumosColor, null),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CentavosInputFormatter(
                                            moeda: true, casasDecimais: 2)
                                      ],
                                      onChanged: (text) {
                                        simuladorBloc
                                            .calculoCustoInsumosInptu(text);
                                      });
                                }),
                          ),
                        );
                      }),
                  StreamBuilder(
                      stream: simuladorBloc.corCustoProdutolController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        custoProdutoColor = dataCor.toString();
                        //    print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          child: Container(
                           // width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                                stream: simuladorBloc.custoFixoController,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }
                                  return TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: custoProdutoController =
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput(
                                          'Custo produto 3º',
                                          custoProdutoColor,
                                          null),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CentavosInputFormatter(
                                            moeda: true, casasDecimais: 2)
                                      ],
                                      onChanged: (text) {
                                        simuladorBloc
                                            .calculoCustoProdutoInptu(text);
                                      });
                                }),
                          ),
                        );
                      }),
                ),
                const Espacamento(),
                buildRow(
                  StreamBuilder(
                      stream: simuladorBloc.corCustoVariavelController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        custoVariavelColor = dataCor.toString();
                        //    print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          child: Container(
                         //   width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                              //     stream:  simuladorBloc.custoProdutoController,
                                stream: simuladorBloc.custoVariavelController,
                               // stream: simuladorBloc.custoVariavelController,
                                builder: (context, snapshot) {
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }
                                  return TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: custoVariavelController =
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput(
                                          'Outros custos variáveis',
                                          custoVariavelColor,
                                          null),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CentavosInputFormatter(
                                            moeda: true, casasDecimais: 2)
                                      ],
                                      onChanged: (text) {
                                        simuladorBloc
                                            .calculoCustoVariavelInptu(text);
                                      });
                                }),
                          ),
                        );
                      }),
                  buildStreamBuilder(
                    simuladorBloc.margemDeContribuicaoController,
                    "Margem de contribuição",
                    "desabilitado",
                    true,
                    null,
                    null,
                  ),
                ),
                const Espacamento(),
                buildRow(
                  StreamBuilder(
                      stream: simuladorBloc.corCustoFixoController,
                      builder: (context, snapshot) {
                        var dataCor = snapshot.data;
                        custoFixoColor = dataCor.toString();

                        //    print(dataCor);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          child: Container(
                         //   width: 185,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: buildBoxDecoration(),
                            child: StreamBuilder(
                               // stream:null,
                            //   stream: simuladorBloc.custoVariavelController,
                                stream:  simuladorBloc.custoProdutoController,
                                builder: (context, snapshot) {
                              //    print(snapshot.data);
                                  var data = snapshot.data;
                                  if(!snapshot.hasData){
                                    data ="";
                                  }
                                  return TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      controller: custoFixoController =
                                          TextEditingController(text: '$data'),
                                      decoration: _styleInput(
                                          'Custo fixo', custoFixoColor, null),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CentavosInputFormatter(
                                            moeda: true, casasDecimais: 2)
                                      ],
                                      onChanged: (text) {
                                        simuladorBloc.calculoCustoFixo(text);
                                      });
                                }),
                          ),
                        );
                      }),
                  buildStreamBuilder(
                    simuladorBloc.pontoEquilibrioController,
                    "Ponto de equilibrio",
                    "desabilitado",
                    true,
                    null,
                    null,
                  ),
                ),
                const Espacamento(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                  //  width: MediaQuery.of(context).size.width*0.45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(159, 105, 56,1), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text('Limpar filtros',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        removeController.text ='';
                        addController.text ='';
                        simuladorBloc.getDadosBasicos();
                        simuladorBloc.limparCorInputs();
                      },
                    ),
                  ),
                ),
                const Espacamento(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildNewRemoveAdd(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child:  Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        suffixIcon: Icon(Icons.percent, color: Colors.black54,),
                        fillColor:Color.fromRGBO(159, 105, 56,0.5),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange,
                              width: 1.0,
                              style: BorderStyle.none),
                        ),
                        border: InputBorder.none,
                        labelText: 'Indique',
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
                padding: EdgeInsets.symmetric(vertical: 0.0 , horizontal: 15.0),
                width: MediaQuery.of(context).size.width*0.47,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child:  Column(
                        children: [
                       const   Text('Aumentar',style:  TextStyle(
                            fontSize: 12,

                          ),),
                          IconButton(
                            onPressed: () {
                              if(addController.text.isEmpty){
                                alerta.openModal(context, "Adicione o percentual.");
                              }else{

                                simuladorBloc.calculoPercentual(addController.text, 1, valorInicialTicket, 1, context);
                                addController.text ='';
                                FocusScope.of(context).requestFocus(new FocusNode());
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color.fromRGBO(159, 105, 56,0.5),
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child:  Column(
                        children: [
                          Text('Diminuir',style:  TextStyle(
                        fontSize: 12,

                      ),),
                          IconButton(
                            onPressed: () {
                              if(addController.text.isEmpty){
                                alerta.openModal(context, "Adicione o percentual.");
                              }else{

                                simuladorBloc.calculoPercentual(addController.text,2, valorInicialTicket, 2, context);
                                addController.text ='';
                                FocusScope.of(context).requestFocus(new FocusNode());
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Color.fromRGBO(159, 105, 56,0.5),
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



  Container buildContainerAddRemoveNew(context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                // padding: const EdgeInsets.all(3.0),
               // width: 180,
                width: MediaQuery.of(context).size.width*0.45,
                decoration: const BoxDecoration(
                color: Colors.transparent,
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(1, 3), // Shadow position
                    ),
                  ],
                ),
                child: StreamBuilder(
                    stream: simuladorBloc.percentualAddController,
                    builder: (context, snapshot) {
                      // print(snapshot.data);
                      var data = snapshot.data;
                      if(!snapshot.hasData){
                        data ="";

                      }
                      return GestureDetector(
                        onTap: () {
                          if(valorInicialTicket.isEmpty){
                         //    alerta.openModal(context, "Selecione um item para a realização da simulação.");
                          }else{

                            if(_dadosBasicoNULL){
                         //     alerta.openModal(context, "Verifique se os dados básicos estão preenchidos.");
                            }

                        //    simuladorBloc.calculoPercentual(addController.text, 1, valorInicialTicket, 1, context);
                          }
                        },
                        child: TextFormField(
                           // enabled: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: addController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              suffixIcon: const Icon(Icons.percent, color: Colors.black54,),
                              fillColor:Color.fromRGBO(159, 105, 56,0.5),
                              filled: true,
                              prefixIcon: IconButton(
                                onPressed: () {

                                  if(addController.text.isEmpty){
                                    alerta.openModal(context, "Adicione o percentual.");
                                  }else{
                                    removeController.text ='';
                                    simuladorBloc.calculoPercentual(addController.text, 1, valorInicialTicket, 1, context);
                                  }

                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                  size: 25.0,
                                ),
                              ),

                              // disabledBorder: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                              border: InputBorder.none,
                              labelText: '',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                //  backgroundColor: Colors.white,
                              ),
                              // hintText: 'Quantidade de clientes atendidos',
                            ),
                            onChanged: (text) {
                              // simuladorBloc.calculoPercentual(text,1,valorInicialTicket,2,context);
                            }),
                      );
                    }),
              ),
            ),
            Padding( //aqui
              padding: const EdgeInsets.all(3.0),
              child: Container(
                // padding: const EdgeInsets.all(3.0),

              //  width: 180,
                width: MediaQuery.of(context).size.width*0.45,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(1, 3), // Shadow position
                    ),
                  ],
                ),
                child: StreamBuilder(
                    stream: simuladorBloc.percentualRemoveController,
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      if(!snapshot.hasData){
                        data ="";
                      }
                      return GestureDetector(
                        onTap: () {
                          if(valorInicialTicket.isEmpty){
                           // alerta.openModal(context, "Selecione um item para a realização da simulação");
                          }else{
                            if(_dadosBasicoNULL){
                           //   alerta.openModal(context, "Verifique se os dados básicos estão preenchidos.");
                            }
                         //   simuladorBloc.calculoPercentual(removeController.text,2, valorInicialTicket, 2, context);
                          }
                        },
                        child: TextFormField(
                          //  enabled: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: removeController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              prefixIcon: IconButton(
                                onPressed: () {
                                  if(removeController.text.isEmpty){
                                    alerta.openModal(context, "Adicione o percentual.");
                                  }else{
                                    addController.text ='';
                                    simuladorBloc.calculoPercentual(removeController.text,2, valorInicialTicket, 2, context);
                                  }

                                },
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                              fillColor: Color.fromRGBO(159, 105, 56,0.5),
                              filled: true,
                              suffixIcon: const Icon(Icons.percent ,  color: Colors.black54),
                              // disabledBorder: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                              border: InputBorder.none,
                              labelText: '',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                //  backgroundColor: Colors.white,
                              ),
                              // hintText: 'Quantidade de clientes atendidos',
                            ),
                            onChanged: null),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildContainerFaturamento() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: StreamBuilder(
          stream: simuladorBloc.faturamentoController,
          builder: (context, snapshot) {
            //  print(snapshot.data);

            if(snapshot.hasData){
              var data = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  decoration: buildBoxDecoration(),
                  child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        return TextFormField(
                          enabled: false,
                          validator: ValidationBuilder()
                              .maxLength(50)
                              .required()
                              .build(),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: "$data"),
                          decoration:
                          _styleInput("Faturamento", "desabilitado", null),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true, casasDecimais: 2)
                          ],
                        );
                      }),
                ),
              );
            }else{
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                child: Container(
                  decoration: buildBoxDecoration(),
                  child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        return TextFormField(
                          enabled: false,
                          validator: ValidationBuilder()
                              .maxLength(50)
                              .required()
                              .build(),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: ""),
                          decoration:
                          _styleInput("Faturamento", "desabilitado", null),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true, casasDecimais: 2)
                          ],
                        );
                      }),
                ),
              );
            }
          }),
    );
  }

/*
 buildStreamBuilder(simuladorBloc.margemInformadaController, "Margem desejada","ops",false, buildIcon()),
                  buildStreamBuilder(simuladorBloc.margemInformadaController, "Margem informada","ops",false, buildIcon()),
 */
  SingleChildScrollView buildRow(coluna1, coluna2) {
    const Espacamento();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [coluna1, coluna2],
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
            print('snapshot.hasData');
            print(snapshot.hasData);
            if(snapshot.hasData){
             var  data = snapshot.data;
              return buildContainer("$data", inputTitulo, cor, format, icone, onChanged);
            }else{
              return buildContainer("", inputTitulo, cor, format, icone, onChanged);
            }
          }),
    );
  }

  Icon buildIcon() {
    return const Icon(
      Icons.percent,
      color: Colors.black54,
      size: 16.0,
    );
  }

  Padding buildContainer(data, inputTitulo, cor, format, icone, onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Container(
       // width: 185,
        width: MediaQuery.of(context).size.width*0.45,
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
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                );
              }
            }),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
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

  buildSpinBox(String TextDecoretion) {
    return SpinBox(
      min: 1,
      max: 10000,
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
      onChanged: (onChanged) {},
    );
  }

  buildDecoratorSpinBox(String labelText) {
    return _styleInput(labelText, "ops", null);
  }

  _styleInput(String text, String cor, suffixIcon) {
    switch (cor) {
      case "padrao":
        corFundo = Color.fromRGBO(159, 105, 56,0.5);
        break;
      case 'desabilitado':
        corFundo = Colors.grey[100];
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
            color: Colors.orange, width: 1.0, style: BorderStyle.none),
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
}
