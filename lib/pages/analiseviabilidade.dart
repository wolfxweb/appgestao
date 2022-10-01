import 'package:appgestao/blocs/analiseViabilidade_bloc.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';

class AnaliseViabilidade extends StatefulWidget {
  const AnaliseViabilidade({Key? key}) : super(key: key);

  @override
  State<AnaliseViabilidade> createState() => _AnaliseViabilidadeState();
}

class _AnaliseViabilidadeState extends State<AnaliseViabilidade> {
  var header = new HeaderAppBar();
  var analiseViabilidadeBloc = AnaliseViabilidadeBloc();

  var _precoVendaAtualController = TextEditingController();
  var _custoInsumosProdutoController = TextEditingController();
  var _descontoPromocionalController = TextEditingController();
  var _investimentoComAcaoController = TextEditingController();
  var _objetivoVendaController = TextEditingController();

  var color = const Color.fromRGBO(159, 105, 56,0.5);
  var alerta = AlertModal();
  var corFundo = Colors.grey[100];
  var _comentario = "";
  var _mostrarComentario = false;
  var dataCor = Colors.grey[100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Promoção & Propaganda'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Container(
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
                child: buildContainerPromocaoPropaganda(context),
              ),
              const Espacamento(),
              buildAcaoObjetiva(),
              Container(
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
                  onChanged: (text) {
                    setState(() { _mostrarComentario = false; });
                    analiseViabilidadeBloc.precoVendaAtual(text);
                  },
                  validator:
                      ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: _precoVendaAtualController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  decoration: buildInputDecoration(
                      context,
                      'Se a ação abranger mais de um produto, considere a soma de seus preços',
                      'Preço de venda atual'),
                ),
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
                child: TextFormField(
                  onChanged: (text) {
                    setState(() { _mostrarComentario = false; });
                    analiseViabilidadeBloc.custoInsumosProduto(text);
                  },
                  validator: ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  controller: _custoInsumosProdutoController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  decoration: buildInputDecoration(
                      context,
                      'Se a ação abranger mais de um produto, considere a soma de seus preços',
                      'Custo dos insumos e produtos'),
                ),
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
                    stream: analiseViabilidadeBloc.outPrecoDescontoMaximoSemPrejuizo,
                    builder: (context, snapshot) {
                      var data = "";
                      if (snapshot.hasData) {
                        data = snapshot.data.toString();
                      }
                      return TextFormField(
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.none,
                        controller: TextEditingController(text: data.toString()),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          fillColor: Colors.grey[100],
                          filled: true,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(159, 105, 56,1),
                                width: 1.0,
                                style: BorderStyle.none),
                          ),
                          border: InputBorder.none,
                          labelText: 'Desconto máximo para vender sem prejuizo',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }),
              ),
              const Espacamento(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection:  Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Container(
                         // width: 205,

                          width: MediaQuery.of(context).size.width*0.52,
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
                            onChanged: (text) {
                              setState(() { _mostrarComentario = false; });
                              analiseViabilidadeBloc.descontoPromocional(text);
                            },
                            validator:ValidationBuilder().maxLength(50).required().build(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              fillColor: color,
                              filled: true,
                              suffixIcon:const Icon(
                                Icons.percent,
                                color: Colors.black,
                                size: 14,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(159, 105, 56,1),
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                              border: InputBorder.none,
                              labelText: 'Desconto Promocional',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Container(
                     //   width: 150,
                         // padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
                          width: MediaQuery.of(context).size.width*0.41,
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
                            stream: analiseViabilidadeBloc.outPrecoPromocional,
                            builder: (context, snapshot) {
                              var data = "";
                              if(snapshot.hasData){
                                data =snapshot.data.toString();
                              }
                              return TextFormField(
                                keyboardType: TextInputType.none,
                                controller: TextEditingController(text: data),
                                enabled: false,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  // suffixIcon: const Icon(Icons.percent, color: Colors.grey,),
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  // disabledBorder: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Color.fromRGBO(159, 105, 56,1),
                                        width: 1.0,
                                        style: BorderStyle.none),
                                  ),
                                  border: InputBorder.none,
                                  labelText: 'Preço promocional',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),

                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                child: TextFormField(
                  onChanged: (text) {
                    setState(() { _mostrarComentario = false; });
                    analiseViabilidadeBloc.invertimentoAcao(text);
                  },
                  validator: ValidationBuilder().maxLength(50).required().build(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // obrigatório
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(moeda: true, casasDecimais: 2)
                  ],
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:const EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
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
                    labelText: 'Investimetno com a ação',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const Espacamento(),
              Container(
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
                  stream: analiseViabilidadeBloc.outPrecoVendaParaRecuperarInvestimento,
                  builder: (context, snapshot) {
                    var data ="";
                    if(snapshot.hasData){
                      data = snapshot.data.toString();
                    }
                    return TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: data),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(horizontal:5, vertical: 5),
                        fillColor: Colors.grey[100],
                        filled: true,
                        // disabledBorder: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(159, 105, 56,1),
                              width: 1.0,
                              style: BorderStyle.none),
                        ),
                        border: InputBorder.none,
                        labelText:'Vendas necessárias para recuperar o investimento',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),

                      ),
                    );
                  }
                ),
              ),
              const Espacamento(),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                        child: Container(
                        //  width: 180,

                         width: MediaQuery.of(context).size.width*0.46,
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
                            onChanged: (text) {
                              setState(() { _mostrarComentario = false; });
                              analiseViabilidadeBloc.objetivoVendas(text);
                            },
                            validator: ValidationBuilder()
                                .maxLength(50)
                                .required()
                                .build(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              fillColor: color,
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(159, 105, 56,1),
                                    width: 1.0,
                                    style: BorderStyle.none),
                              ),
                              border: InputBorder.none,
                              labelText: 'Obejetivo de vendas',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                //  backgroundColor: Colors.white,
                              ),

                              // hintText: 'Quantidade de clientes atendidos',
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: analiseViabilidadeBloc.outResultadoCorController,
                        builder: (context, snapshot) {

                          if(snapshot.hasData){
                            print(snapshot.data.toString());
                            if('Prejuizo' ==snapshot.data.toString() ){
                              dataCor = Colors.red;
                            }else if('lucro' ==snapshot.data.toString()){
                              dataCor = Colors.green;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                            child: Container(

                              width: MediaQuery.of(context).size.width*0.48,
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
                                stream: analiseViabilidadeBloc.outResultadoController,
                                builder: (context, snapshot) {
                                  var data = "";
                                  if(snapshot.hasData){
                                    data = snapshot.data.toString();
                                  }
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    enabled: false,
                                    controller:TextEditingController(text: data),
                                    decoration:  InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      // suffixIcon: const Icon(Icons.percent, color: Colors.grey,),
                                      fillColor: dataCor,
                                      filled: true,
                                      // disabledBorder: true,
                                      focusedBorder:const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(159, 105, 56,1),
                                            width: 1.0,
                                            style: BorderStyle.none),
                                      ),
                                      border: InputBorder.none,
                                      labelText: 'Resultado desta ação',
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        //  backgroundColor: Colors.white,
                                      ),
                                      // hintText: 'Quantidade de clientes atendidos',
                                    ),
                                  );
                                }
                              ),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
              const Espacamento(),
              const Espacamento(),
            ],
          ),
        ),
      ),
    );
  }
  InputDecoration buildInputDecoration(BuildContext context, text, titulo) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      prefixIcon: IconButton(
        icon: const Icon(Icons.help),
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
            color: Color.fromRGBO(159, 105, 56,1), width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        //  backgroundColor: Colors.white,
      ),
    );
  }

  Column buildAcaoObjetiva() {
    return Column(
      children: [
        Container(
          decoration:  const BoxDecoration(
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
              setState(() {
                _mostrarComentario = true;
                //   valorInicialTicket = text;
                if (text == "1. VENDER MAIS") {
                  var _venderMais =
                       "Certifique-se de que:\n"
                       "1) Existe demanda;\n"
                       "2) O momento é oportuno (época, conjuntura, fornecedores, concorrência);\n"
                       "3) Está preparado (capacidade de atendimento com qualidade);\n"
                       "4) Não infringe a Lei de Defesa do Consumidor.Descontos do tipo “50% OFF”, não causam boa impressão, e, o cliente que pagou o preço antigo sente-se lesado.\n"
                       "Em fim, pode ser válido em uma data específica (“Black Friday”, aniversário, etc.).\n"
                       "Melhor oferecer este desconto como “cashback” (ao comprar o cliente recebe um crédito para utilizar em compras futuras.";
                  _comentario = _venderMais;
                } else if (text == "2. AUMENTAR O TICKET MÉDIO") {
                  var aumentarTicketMedio =
                      "Sempre oferecer ao cliente o máximo de opções que de alguma forma complementam o objeto da compra.\nVemos muito desta prática em lojas de roupas, materiais de construção, lanchonetes (os famosos combos), etc.\n'Na compra da segunda peça você leva mais uma sem custo'; 'compras acima de R\$...., você ganha um brinde!'; 'a cada R\$... em compras você ganha x pontos!'. ";
                  _comentario = aumentarTicketMedio;
                } else if (text == "3. GIRAR ESTOQUE DE PRODUTO") {
                  var girarEstoqueProduto =
                      "Verifique a possibilidade de criar um “combo” associando a outro(s) produto(s) mais lucrativo(s) e de maior demanda.\nOutra alternativa pode ser o “cashback” (enquanto durar o estoque), em que ao comprar o cliente recebe um crédito para utilizar em compras futuras.";

                  _comentario = girarEstoqueProduto;
                } else if (text == "4. FIDELIZAR CLIENTES") {
                  var fidelizarClientes =
                      "Exemplo de promoção frequente em alguns segmentos: oferta de pontos, milhas e cupons para troca por mercadorias.\nMais recentemente, o “cashback”(dinheiro de volta), em que o cliente recebe um crédito para utilizar em compras futuras.";
                  _comentario = fidelizarClientes;
                } else if (text == "5. ATRAIR NOVOS CLIENTES") {
                  var divulgarMarca =
                      "Neste caso a ação principal é a propaganda. Busque detalhes que o diferencie dos concorrentes.\nFaça-se presente no Google e nas mídias e buscadores digitais.";
                  _comentario = divulgarMarca;
                } else if (text == "6. DIVULGAR A MARCA") {
                  var divulgarMarca =
                      "Neste caso a ação principal é a propaganda. Busque detalhes que o diferencie dos concorrentes.\nFaça-se presente no Google e nas mídias e buscadores digitais.";
                  _comentario = divulgarMarca;
                } else if (text == "7. LANÇAR PRODUTO NOVO") {
                  var lancarProduto =
                      "Neste caso a ação principal é a propaganda/divulgação. Dê destaque aos detalhes que o diferenciam dos concorrentes.\nVeja o que melhor se aplica ao seu caso: amostra grátis, degustação, demonstrações, feiras e exposições, depoimento de especialistas e/ou influenciadores. Faça-se presente no Google e nas mídias e buscadores digitais.";
                  _comentario = lancarProduto;
                }
              });
            },
            //  1. VENDER MAIS; 2. AUMENTAR O TICKET MÉDIO; 3. GIRAR ESTOQUE DE PRODUTO; ; 4. FIDELIZAR CLIENTES; 5. ATRAIR NOVOS CLIENTES; 6. DIVULGAR A MARCA; 7. LANÇAE PRODUTO NOVO.

            options: const [
              "1. VENDER MAIS",
              "2. AUMENTAR O TICKET MÉDIO",
              "3. GIRAR ESTOQUE DE PRODUTO",
              "4. FIDELIZAR CLIENTES",
              "5. ATRAIR NOVOS CLIENTES",
              "6. DIVULGAR A MARCA",
              "7. LANÇAR PRODUTO NOVO"
            ],
            decoration: _styleInput(
                'A ação objetiva',
                "padrao",
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 16,
                )),
            dropdownHeight: 350,
          ),
        ),
        const Espacamento(),
        _mostrarComentario
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  // fillColor: Colors.grey[100],
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(1, 3), // Shadow position
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _comentario,
                    style: const TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            : Container(),
        _mostrarComentario ? const Espacamento() : Container(),
      ],
    );
  }

  Container buildContainerPromocaoPropaganda(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        // fillColor: Colors.grey[100],
        //borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(1, 3), // Shadow position
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.10,
              child: IconButton(
                  onPressed: () {
                    alerta.openModal(context,
                        'Promoção: oferta/divulgação de benefício concreto, por um período específico de tempo. Tudo muito bem explicado Propaganda: assunto para profissionais (o que divulgar, como, onde, quando, por quanto tempo).IMPORTANTE: certifique-se de que sua promoção e/ou propaganda é relevante para o seu público-alvo; garanta que ao serem motivados, os clientes não se decepcionem; evite repetições frequentes e durações longas. Observe o que seus concorrentes estão fazendo. Encontre um diferencial mais atrativo. Crie uma forma de acompanhar e controlar resultados.');
                  },
                  icon: const Icon(Icons.help)),
            ),
            Column(
              children:  [
                Container(
                  width: MediaQuery.of(context).size.width*0.85,
                  child: const Text(
                    'Análise viabilidade',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
            color: Color.fromRGBO(159, 105, 56,1), width: 1.0, style: BorderStyle.none),
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
