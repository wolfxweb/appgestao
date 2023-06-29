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
  var simuladorBloc;
  var addRemoveInput = false;
  final _formKey = GlobalKey<FormState>();
  var color =  const Color.fromRGBO(1, 57,44,1);
  @override
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

                ],
              ),
            ),
          ),

        )
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
                  width: MediaQuery.of(context).size.width*0.45,

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
                                color:Color.fromRGBO(1, 57, 44, 1),
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
                      decoration: buildInputDecoration(  Icon(
                        Icons.arrow_drop_down,
                        color:color,
                        size: 26,
                      )),
                      dropdownHeight: 350,
                    );
  }

  InputDecoration buildInputDecoration(suffixIcon) {
    return InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

                    fillColor: corFundo,
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
