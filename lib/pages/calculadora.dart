import 'package:appgestao/blocs/calculadora_bloc.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
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
  var _precoAtual = TextEditingController();
  var _precoInsumos = TextEditingController();
  var _margemDesejada = TextEditingController();
  var _produto = TextEditingController();
  var _precoAtualController = TextEditingController();
  var _precoInsumosController = TextEditingController();
  var _margemDesejadaController = TextEditingController();
  var _btnStatus = false;
  var _pesquisaController = TextEditingController();
  var _percoConcorrenteController = TextEditingController();



  List historico = [];

  void initState() {
    calBloc = CalculadoraBloc();
    historico = calBloc.selectHistorico();
  }

  final _formKey = GlobalKey<FormState>();
  var alerta = AlertModal();
  var header = new HeaderAppBar();
  var corFundo = Colors.grey[150];
  var _mostrarComponentes = true;
  var _verHistorico = false;
  var mostrarValores = true;
  var mostraPrecoSugerido = true;
  var mostraPrecoSugeridoMsg =false;
  @override
  Widget build(BuildContext context) {
    // print(historico);
    return Scaffold(
      appBar: header.getAppBar('Calculadora de Preços'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _verHistorico
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              btnHitorico(context),
                              inputLocalizarProduto(context)
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: listProdutos(context),
                          )
                        ],
                      )
                    : Container(),
                const Espacamento(),
                !_verHistorico
                    ? Column(
                        children: [
                          nomeProduto,
                          Row(
                           //  mainAxisAlignment: MainAxisAlignment.center,
                           //  mainAxisSize: MainAxisSize.max,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               SizedBox(
                                 width: MediaQuery.of(context).size.width * 0.84,
                                 child:  precoVendaAtual(),
                               ),
                               SizedBox(
                                 width: MediaQuery.of(context).size.width * 0.05,
                                 child:
                                       Padding(
                                         padding: const EdgeInsets.only(top: 16.0), // Adiciona um preenchimento de 16.0 pixels na parte superior
                                         child: buildIconeMsg(
                                           context,
                                         /*  ALATERAÇÃO DAS SOLICITIDADA DIA 15/08
                                         'Para calcular o preço de venda de um produto novo, digite o "Custo dos insumos '
                                               'e/ou mercadoria 3o.", e a "Margem desejada". A resposta estará em "Preço sugerido".'
                                               ' Para conferir, digite o valor sugerido em "Preço de venda atual".',

                                          */
                                           '''Para calcular o preço de venda de um produto novo: 1) Digite o “Custo dos insumos e/ou mercadoria 3º.”; 2) Digite a “Margem desejada”. 3) A resposta estará em “Preço sugerido”.\nPara analisar a margem que resulta do preço praticado para um produto: 1) Digite o valor em “Preço de venda atual”; 2) Digite o “Custo dos insumos e/ou mercadoria 3º.”.\nPara analisar seus preços como um todo: 1) Em “Preço de venda atual”, digite o valor do “Ticket médio”, disponível no “Diagnóstico”; 2) Em “Custo dos insumos e/ou mercadoria 3º.”, digite o resultado da divisão do “Custo dos insumos e/ou mercadoria 3º.” pela “Quantidade de clientes atendidos “, (disponíveis em “Dados básicos”).\nPara analisar a oferta de preço promocional, basta colocar em “Preço de venda atual” o valor resultante do desconto que estará sendo oferecido.
                                            ''',
                                         ),
                                       ),

                                   ),
                             ]
                           ),
                         // precoVendaAtual(),
                          Row(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            //  mainAxisSize: MainAxisSize.max,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.84,
                                  child:  custoInsumos(),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.05,
                                  child:
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0), // Adiciona um preenchimento de 16.0 pixels na parte superior
                                    child: buildIconeMsg(
                                      context,
                                          'Você precisa ter a “Fixa técnica gerencial”. Se não tem, recomendamos fortemente que providencie. Não conhece?  '
                                          'Ela descreve todos os insumos utilizados na produção de cada item: quantidades e respectivos valores.'
                                          'Pesquise no Google! Sem saber o custo dos insumos não tem como calcular corretamente o preço de venda.'
                                          'E tem mais: com a Ficha Técnica Gerencial você saberá exatamente qual a quantidade necessária de cada insumo. '
                                          'Desta forma: 1) qual a real necessidade de compras; 2) qual a demanda de recursos financeiros; 3) melhor gestão dos estoques; 4) uso racional do capital de giro; 5) evita interrupções na produção); 6) realiza boas negociações de compras (preços e prazos); 7) alimenta antecipadamente o Fluxo de Caixa (melhores datas para pagamentos). ',
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        //  custoInsumos(),
                          margemPreco(context),
                          if(_precoInsumosController.text.isNotEmpty && _precoAtualController.text.isNotEmpty)
                            areTextoInformativo(),
                         // msgComentario(),
                          margemDesejada(context),
                          precoSugeridoAtual(context),
                          if(_precoInsumosController.text.isNotEmpty && _precoAtualController.text.isNotEmpty && _margemDesejadaController.text.isNotEmpty)
                             msgPrecoSugerido(),
                          precoMedioConcorrente(context),
                          msgComentario()
                        ],
                      )
                    : Container(),
                const Espacamento(),
                btnVerVoltar(context),
                Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        child: _verHistorico
                            ? Text('Voltar Calculadora')
                            : Text('Ver o histórico'),
                        onPressed: () {
                          setState(() {
                            _verHistorico = !_verHistorico;
                            _margemDesejadaController.text = "";
                            _precoInsumosController.text = "";
                            _precoAtualController.text = "";
                            _precoAtual.text = "";
                            _precoInsumos.text = "";
                            _margemDesejada.text = "";
                            _produto.text = "";
                            //  _mostrarComponentes = false;
                            _btnStatus = false;
                            _pesquisaController.text = "";
                          });
                        },
                        style:colorButtonStyle(const Color.fromRGBO(1, 57, 44, 1)),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column btnHitorico(BuildContext context) {
    return Column(
      children: [
        const Text(''),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          //   height: MediaQuery.of(context).size.height * 0.05,
          // width: MediaQuery.of(context).size.width * 0.30,
          //   decoration: buildBoxDecoration(),
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child:
                    _verHistorico ? Text('Voltar ') : Text('Ver o histórico'),
                onPressed: () {
                  setState(() {
                    _verHistorico = !_verHistorico;
                    historico.clear();
                    calBloc.selectHistorico();
                  });
                },
                style:colorButtonStyle(const Color.fromRGBO(1, 57, 44, 1)),
              )),
        ),
      ],
    );
  }

  Padding inputLocalizarProduto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      child: Container(
        //  width: 220,
        width: MediaQuery.of(context).size.width * 0.60,
        decoration: buildBoxDecoration(),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              var data = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Localizar produto'),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _pesquisaController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        fillColor: const Color.fromRGBO(245, 245, 245, 1),
                        filled: true,
                        // disabledBorder: true,
                        focusedBorder: const OutlineInputBorder(
                          // borderSide: BorderSide(color: Color(0xFFffd600)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
                        ),
                        border: const OutlineInputBorder(
                          // borderSide: BorderSide(color: Color(0xFFffd600)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(105, 105, 105, 1),
                              width: 1.0),
                        ),
                        //  border: InputBorder.nome,
                        labelText: "",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          //  backgroundColor: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          color: Colors.black54,
                          onPressed: () {
                            _pesquisaController.text = "";
                            setState(() {
                              historico.clear();
                              historico = calBloc.selectHistorico();
                            });
                          },
                        )),
                    onChanged: (text) {
                      if (historico.isEmpty) {
                        //  alerta.openModal(context, 'Nenhum item encontrado');
                      }
                      setState(() {
                        historico.retainWhere((element) {
                          return element['produto']
                              .toString()
                              .contains(text.toString());
                        });
                      });
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }

  Container btnVerVoltar(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   mainAxisSize: MainAxisSize.max,
      //  crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        !_verHistorico
            ? Container(
                width: MediaQuery.of(context).size.width * 0.42,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      child: const Text('Limpar'),

                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => super.widget),
                        );
                      },
                      style:colorButtonStyle(const Color.fromRGBO(1, 57, 44, 1)),
                    )),
              )
            : Container(),

        !_verHistorico
            ? Container(
                width: MediaQuery.of(context).size.width * 0.42,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      child: const Text('Salvar'),
                      onPressed: _btnStatus ? _buildOnPressed : null,
                      style: colorButtonStyle(const Color.fromRGBO(1, 57, 44, 1)),
                    /*  ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 14),
                       // primary: const Color.fromRGBO(1, 57, 44, 1),
                        elevation: 5,
                        shadowColor: Colors.black,
                        padding: EdgeInsets.all(14),
                      ),*/
                    )),
              )
            : Container(),

      ],
    ));
  }

  Container msgPrecoSugerido() {
    return Container(
      //   width: MediaQuery.of(context).size.width*0.45,
      //  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: const BoxDecoration(
        //  color: Colors.transparent,
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
          stream: calBloc.outMsgPrecoSugerido,
          builder: (context, snapshot) {
            var data = snapshot.data.toString();
            print(data);
            var obs = true;
            if (data.isEmpty) {
              obs = false;
            }

            return mostraPrecoSugeridoMsg
                ? TextFormField(
                    validator: ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.none,
                    enabled: false,
                    maxLines: 6,
                    style: const TextStyle(fontSize: 16,color: Colors.black),
                    controller: TextEditingController(text: snapshot.data.toString()),
                    decoration: _styleInput("", "ops"),
                  )
                : Container();
          }),
    );
  }

  Container msgComentario() {
    return Container(
      //   width: MediaQuery.of(context).size.width*0.45,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: const BoxDecoration(
          color: Colors.transparent,
        //borderRadius: BorderRadius.circular(20),
    /*    boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(1, 3), // Shadow position
          ),
        ],

     */
      ),
      child: StreamBuilder(
          stream: calBloc.outPrecoConcorrente,
          builder: (context, snapshot) {
            var data = snapshot.data.toString();
            var obs = true;
            if (data.isEmpty) {
              obs = false;
            }

            return obs
                ? TextFormField(
              validator: ValidationBuilder().maxLength(50).required().build(),
              keyboardType: TextInputType.none,
              enabled: false,
              maxLines: 6,
            //  style: const TextStyle(color: Colors.black),
              style: const TextStyle(fontSize: 16,color: Colors.black),
              controller: TextEditingController(text: snapshot.data.toString()),
              decoration: _styleInput("", "ops"),
            )
                : Container();
          }),
    );
  }

  Row precoSugeridoAtual(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   mainAxisSize: MainAxisSize.max,
      //  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Preço sugerido"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Container(
                // width: 140,
                //  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                width: MediaQuery.of(context).size.width * 0.45,
                //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: buildBoxDecoration(),
                child: StreamBuilder(
                    stream: calBloc.outCaculoPrecoSugerido,
                    builder: (context, snapshot) {
                      //  var data = snapshot.data;
                      //mostraPrecoSugerido
                      var sanp = snapshot.data;
                      var data = "R\$ $sanp";

                      if (mostraPrecoSugerido) {
                        data = "";
                      }
                      return _mostrarComponentes
                          ? TextFormField(
                              //  validator: ValidationBuilder().maxLength(50).required().build(),
                              keyboardType: TextInputType.none,
                              enabled: false,
                //      style: const TextStyle(color: Colors.black),
                              controller: TextEditingController(text: "$data"),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),

                              decoration: _styleInput("", "1"),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            )
                          : Container();
                    }),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Relação com preço atual"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Container(
                //   width: 170,
                // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                width: MediaQuery.of(context).size.width * 0.46,

                decoration: buildBoxDecoration(),
                child: StreamBuilder(
                    stream: calBloc.outRelacaoPrecoController,
                    builder: (context, snapshot) {
                      var sanp = snapshot.data;
                      var data = "$sanp %";

                      if (mostraPrecoSugerido || _precoAtualController.text.isEmpty) {
                        data = "";
                      }
                      return _mostrarComponentes
                          ? TextFormField(
                              validator: ValidationBuilder()
                                  .maxLength(50)
                                  .required()
                                  .build(),
                              keyboardType: TextInputType.none,
                              enabled: false,
                             style: const TextStyle(color: Colors.black),
                              controller: TextEditingController(text: "$data"),
                              decoration:  decoretorNovo(''),
                            )
                          : Container();
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row margemDesejada(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //   mainAxisSize: MainAxisSize.max,
      //  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Margem desejada"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Container(
                // width: 180,
                width: MediaQuery.of(context).size.width * 0.50,
                //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: buildBoxDecoration(),
                child: StreamBuilder(
                    stream: null,
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      return TextFormField(
                        //validator:  ValidationBuilder().maxLength(5).required().build(),
                        keyboardType: TextInputType.number,
                        controller: _margemDesejadaController,
                        decoration: decoretorNovo(''),
                     /*   inputFormatters: [
                          // obrigatório
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(moeda: false, casasDecimais: 2)
                        ],
                        */
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            calBloc.margemDesejada(text);
                            setState(() {
                              _margemDesejada.text = text;
                              if (_precoAtual.text.isNotEmpty &&
                                  _precoInsumos.text.isNotEmpty &&
                                  _margemDesejada.text.isNotEmpty) {
                                _mostrarComponentes = true;
                                _btnStatus = true;
                                mostraPrecoSugerido = false;
                              } else {
                                // _mostrarComponentes = false;
                                _btnStatus = false;
                                mostraPrecoSugerido = false;
                              }
                            });
                          } else if (text.isEmpty) {
                            setState(() {
                              // _mostrarComponentes = false;
                              _btnStatus = false;
                              mostraPrecoSugerido = false;
                            });
                          }
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Row precoMedioConcorrente(BuildContext context) {
    return Row(
     // mainAxisAlignment: MainAxisAlignment.center,
      //   mainAxisSize: MainAxisSize.max,
      //  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Preço médio concorrente"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.84,
                child:   Container(
                  // width: 180,
                 // width: MediaQuery.of(context).size.width * 0.50,
                  //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  decoration: buildBoxDecoration(),
                  child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                        return TextFormField(
                          validator:  ValidationBuilder().maxLength(5).required().build(),
                          keyboardType: TextInputType.number,
                          controller: _percoConcorrenteController,
                          decoration: decoretorInput(''),
                          inputFormatters: [
                            // obrigatório
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: false, casasDecimais: 2)
                          ],
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              calBloc.precoConcorrente(text);
                              setState(() {
                               // _percoConcorrenteController.text = text;
                              });
                            }
                          },
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
          child:
          Padding(
            padding: const EdgeInsets.only(top: 16.0), // Adiciona um preenchimento de 16.0 pixels na parte superior
            child: buildIconeMsg(
              context,
              'Considere que o concorrente pode estar praticando preços menores que os seus em consequência: a) da operação da empresa com custos menores; b) de melhor negociação nas compras; c) de maiores volumes de vendas; d) qualidade dos processos de produção. Mas também, de: e) preços mal calculados; f) produtos de qualidade inferior; g) campanha promocional.'
              'Ao decidir se é conveniente acompanhar o concorrente, tenha tudo isso em conta. Mas, sobretudo, considere as necessidades, benefícios e expectativas dos seus públicos-alvo:  conveniência, confiabilidade, experiência anterior e status. O equilíbrio entre custo e valor percebido, ao antecipar satisfação, é que definirá a decisão de compra.',
            ),
          ),
        ),
      ],

    );
  }
  Container areTextoInformativo() {
    return Container(
      decoration: buildBoxDecoration(),
      child: StreamBuilder(
          stream: calBloc.outMsgMargem,
          builder: (context, snapshot) {
            var sanp = snapshot.data;
            var data = "$sanp";

            if (mostrarValores) {
              data = "";
            }
            return _mostrarComponentes
                ? TextFormField(
                    validator:
                        ValidationBuilder().maxLength(50).required().build(),
                    keyboardType: TextInputType.none,
                    enabled: false,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 15,color: Colors.black),
                    controller: TextEditingController(text: "$data "),
                    decoration: _styleInput("", "ops"),
                    inputFormatters: [
                      // obrigatório
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2)
                    ],
                  )
                : Container();
          }),
    );
  }

  Row margemPreco(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   mainAxisSize: MainAxisSize.max,
      //  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Margem preço atual"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Container(
                //   width: 140,
                width: MediaQuery.of(context).size.width * 0.47,
                decoration: buildBoxDecoration(),
                child: _mostrarComponentes
                    ? StreamBuilder(
                        stream: calBloc.outCalculoMargem,
                        builder: (context, snapshot) {
                          var sanp = snapshot.data;
                          var data = "$sanp ";
                          if (mostrarValores || _precoInsumosController.text.isEmpty || _precoAtualController.text.isEmpty) {
                            data = "";
                          }

                          //var margemPrecoAtual = data.;
                          return TextFormField(
                            /// validator: ValidationBuilder().maxLength(50).required().build(),
                            keyboardType: TextInputType.none,
                            style: const TextStyle(color: Colors.black),
                            enabled: false,
                            controller: TextEditingController(text: "$data"),
                            // decoration: _styleInput("Margem preço atual", "cor"),
                            decoration: decoretorNovo(''),
                          );
                        })
                    : null,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Margem da empresa"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Container(
                //   width: 170,
                // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                width: MediaQuery.of(context).size.width * 0.45,

                decoration: buildBoxDecoration(),
                child: StreamBuilder(
                    stream: calBloc.outMargemEmpresalControllerr,
                    builder: (context, snapshot) {
                      var sanp = snapshot.data;
                      var data = "$sanp %";

                      if (mostrarValores) {
                        data = "";
                      }
                      return _mostrarComponentes
                          ? TextFormField(
                              validator: ValidationBuilder()
                                  .maxLength(50)
                                  .required()
                                  .build(),
                              keyboardType: TextInputType.none,
                              enabled: false,
                              style: const TextStyle(color: Colors.black),
                              controller: TextEditingController(text: "$data"),
                              // decoration: _styleInput("Margem da empresa", "ops"),
                              decoration: decoretorNovo(''),
                            )
                          : Container();
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column custoInsumos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Custo dos insumos e/ou mercadoria 3º"),
        Container(
          decoration: buildBoxDecoration(),
          child: StreamBuilder(
              stream: calBloc.outCustosComInsumosController,
              builder: (context, snapshot) {
                //  print(snapshot.data);

                var data = snapshot.data;
                return TextFormField(
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: _precoInsumosController,
                  style: const TextStyle(color: Colors.black),
                  decoration: _styleInput("", "cor"),
                  inputFormatters: [
                    // obrigatório
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  onChanged: (text) {
                    //  print(text);
                    //calculadoraCusto(text)
                    if (text.isNotEmpty) {
                      calBloc.calculadoraCusto(text);
                      mostraPrecoSugeridoMsg =true;
                      setState(() {
                        _precoInsumos.text = text;
                        if (_precoAtual.text.isNotEmpty &&
                            _precoInsumos.text.isNotEmpty &&
                            _margemDesejada.text.isNotEmpty) {
                          _mostrarComponentes = true;
                          _btnStatus = true;
                          mostrarValores = false;
                        } else {
                          // _mostrarComponentes = false;
                          _btnStatus = false;
                          mostrarValores = false;
                        }
                      });
                    } else if (text.isEmpty) {
                      setState(() {
                        // _mostrarComponentes = false;
                        mostrarValores = false;
                        _btnStatus = false;
                      });
                    }
                  },
                );
              }),
        ),
      ],
    );
  }
  IconButton buildIconeMsg(BuildContext context, msgAlertaMes) {
    return IconButton(
       iconSize: 35,
      icon:const Icon(
        Icons.lightbulb,
        color:  Colors.amberAccent,
      ),
      onPressed: () {
        alerta.openModal(context, msgAlertaMes);
      },
    );
  }
  Column precoVendaAtual() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preço de venda atual"),
        Container(
          decoration: buildBoxDecoration(),
          child: StreamBuilder(
              stream: calBloc.outPrecoVendaAtualController,
              builder: (context, snapshot) {
                //  print(snapshot.data);
                var data = snapshot.data;
                return TextFormField(
                  validator:ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: _precoAtualController,
                  decoration: _styleInput("", "cor"),
                  inputFormatters: [
                    // obrigatório
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      calBloc.percoVendaAtual(text);
                      setState(() {
                        _precoAtual.text = text;
                        if (_precoAtual.text.isNotEmpty &&
                            _precoInsumos.text.isNotEmpty &&
                            _margemDesejada.text.isNotEmpty) {
                          _mostrarComponentes = true;
                          _btnStatus = true;
                        } else {
                          //     _mostrarComponentes = false;
                          _btnStatus = false;
                        }
                      });
                    } else {
                      if (text.isEmpty) {
                        setState(() {
                          //  _mostrarComponentes = false;
                          _btnStatus = false;
                        });
                      }
                    }
                  },
                  
                );
              }),
        ),
      ],
    );
  }

  Column get nomeProduto {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nome do produto"),
        Container(
          decoration: buildBoxDecoration(),
          child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                var data = snapshot.data;
                return TextFormField(
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  //  keyboardType: TextInputType.number,
                  controller: _produto,
                  decoration: _styleInput("", "cor"),
                  onChanged: (text) {},
                );
              }),
        ),
      ],
    );
  }

  listProdutos(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: historico.length,
            itemBuilder: (BuildContext context, int index) {
              return buildContainer(index, historico);
            }));
  }

  InputDecoration decoretorNovo(titulo) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      fillColor: const Color.fromRGBO(245, 245, 245, 1),
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
      suffixIcon: const Icon(
        Icons.percent,
        color: Colors.black54,
        size: 20.0,
      ),
      /* focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 1.0, style: BorderStyle.none),
                                    ),*/

      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        // backgroundColor: Colors.white,
      ),
    );
  }

  Container buildContainer(int index, historico) {
    var produto = historico[index]['produto'].toString();
    var data = historico[index]['data'].toString();
    var preco_atual = historico[index]['preco_atual'].toString();
    var preco_sugerido = historico[index]['preco_sugerido'].toString();
    var margem_desejada = historico[index]['margem_desejada'].toString();
    var margem_atual = historico[index]['margem_atual'].toString();

    var id = historico[index]['id'];

    return Container(
      // height: 250,
      // color: Colors.amber,
      // child: Center(child: Text(historico[index]['produto'].toString())),
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: Text("Produto: $produto"),
                subtitle: Text("Data: $data"),
                trailing: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onTap: () {
                  confrimModal(context, id, index);
                }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preco Atual R\$: $preco_atual"),
                  buildSizedBox(),
                  Text("Margem Atual: $margem_atual "),
                  buildSizedBox(),
                  Text("Preço Sugerido R\$: $preco_sugerido"),
                  buildSizedBox(),
                  Text("Margem Desejada: $margem_desejada "),
                ],
              ),
            ),
            const Espacamento(),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 4.0,
    );
  }

  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      //  color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        /*  BoxShadow(
          color: Colors.black12,
          blurRadius: 1,
          offset: Offset(1, 3), // Shadow position
        ),*/
      ],
    );
  }
  InputDecoration decoretorInput(titulo) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      fillColor: const Color.fromRGBO(245, 245, 245, 1),
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

      /* focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 1.0, style: BorderStyle.none),
                                    ),*/

      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        // backgroundColor: Colors.white,
      ),
    );
  }
  _buildOnPressed() {
    if (_produto.text.isEmpty) {
      alerta.openModal(context, 'Campo produto é obrigatório.');
      return;
    }

    calBloc.savarCalculo(_produto.text).then((value) {
      var alert = AlertSnackBar();
      historico.clear();
      alert.alertSnackBar(
          context, Colors.green, 'Cadastro realizado com sucesso.');
      calBloc.selectHistorico();
      setState(() {
        _margemDesejadaController.text = "";
        _precoInsumosController.text = "";
        _precoAtualController.text = "";
        _precoAtual.text = "";
        _precoInsumos.text = "";
        _margemDesejada.text = "";
        _produto.text = "";
        //  _mostrarComponentes = false;
        _btnStatus = false;
        _pesquisaController.text = "";
      });
      Navigator.popAndPushNamed(context, '/calculadora');
    });

    setState(() {
      //  historico = calBloc.selectHistorico();
    });
  }

  confrimModal(context, id, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Deseja mesmo excluir, esta ação é ireversivel.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
              softWrap: true,
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Color.fromRGBO(1, 57, 44, 1)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Color.fromRGBO(1, 57, 44, 1)),
                ),
                onPressed: () {
                  calBloc.excluirHistorico(id).then((value) {
                    var alert = AlertSnackBar();
                    // historico.clear();
                    alert.alertSnackBar(context, Colors.green,
                        'Exclusão realizada com sucesso');
                    //  calBloc.selectHistorico();
                    setState(() {
                      //  _verHistorico = !_verHistorico;
                      _pesquisaController.text = "";
                      historico.clear();
                      calBloc.selectHistorico();
                    });
                  });

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
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
      onChanged: (onChanged) {},
    );
  }

  buildDecoratorSpinBox(String labelText) {
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        fillColor: const Color.fromRGBO(105, 105, 105, 1),
        filled: true,
        // disabledBorder: true,
        focusedBorder: const OutlineInputBorder(
          // borderSide: BorderSide(color: Color(0xFFffd600)),
          borderSide:
              BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
        ),
        border: const OutlineInputBorder(
          // borderSide: BorderSide(color: Color(0xFFffd600)),
          borderSide:
              BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        labelText: labelText);
  }

  _styleInput(String text, String modal) {
    if (modal == "cor") {
      corFundo = Color.fromRGBO(245, 245, 245, 1);
    } else {
      corFundo = Color.fromRGBO(245, 245, 245, 1);
    }
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

      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        //  backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
  ButtonStyle colorButtonStyle(color) {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(color),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
}

                                                                                                       


