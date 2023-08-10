import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:form_validator/form_validator.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:appgestao/classes/util/ibge.dart';

import 'package:appgestao/classes/model/estado.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  var alerta = AlertModal();
  String _selectedItem = '';
  String _cidadesValue = '';
  List _items = [];
  List _uf = [];
  List _cidades = [];
  int _idEstado = 0;
  bool _conn = false;
  bool _valueCheck = true;
  String _message = '';
  StreamSubscription? subscription;
  final SimpleConnectionChecker _simpleConnectionChecker =
      SimpleConnectionChecker()..setLookUpAddress('pub.dev');
  @override
  void initState() {
    super.initState();
    _loadItems();
    subscription =    _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
    _getConection();
  }

  var irPagina = PushPage();
  String atividadeEmpresa =
      "Pedimos que informe a atividade, cidade e Estado para que, ao somar os dados de todos os participantes, possamos lhe enviar indicadores (que hoje você não tem), muito úteis para suas análises e providências.";
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController(text: '');
  final _senhaController = TextEditingController();
  var color = const Color.fromRGBO(1, 57, 44, 1);
  final dropOpcoes = [
    'Açougue'
    ,'Adubos e defensivos'
    ,'Água potável'
    ,'Alimentos congelados'
    ,'Aparelhos auditivos'
    ,'Aparelhos ortopédicos'
    ,'Aquários e peixes ornamentais'
    ,'Areia para construção'
    ,'Armarinho'
    ,'Armas e munições'
    ,'Armazém'
    ,'Arte e artesanato'
    ,'Artigos de cama, mesa e banho'
    ,'Artigos de uso doméstico'
    ,'Artigos para festas'
    ,'Árvores adultas'
    ,'Automóveis'
    ,'Autopeças'
    ,'Aves e ovos'
    ,'Aviamentos'
    ,'Aviária'
    ,'Balanças'
    ,'Balas, bombons e chocolates'
    ,'Banho e Tosa'
    ,'Bar/Boteco'
    ,'Barcos e artigos náuticos'
    ,'Baterias'
    ,'Bebidas'
    ,'Bicicletas'
    ,'Bijuterias'
    ,'Bomboniere'
    ,'Brita '
    ,'Buffet para festas'
    ,'Caça e pesca'
    ,'Cafeteria'
    ,'Calçados e acessórios'
    ,'Calçados e acessórios femininos'
    ,'Calçados e acessórios infantis'
    ,'Calçados e acessórios masculinos'
    ,'Cama, mesa, banho'
    ,'Caminhões e ônibus'
    ,'Cantina Italiana'
    ,'Carnes'
    ,'Casa de chá'
    ,'Celulares, Tablets e acessórios'
    ,'Chocolates'
    ,'Choperia'
    ,'Churrascaria'
    ,'Cimento'
    ,'Colchões'
    ,'Combustíveis e lubrificantes'
    ,'Comida de rua'
    ,'Computadores e acessórios'
    ,'Confeitaria'
    ,'Cosméticos'
    ,'Delivery'
    ,'Doceria'
    ,'Doces'
    ,'Drogaria, farmácia'
    ,'Eletrodomésticos'
    ,'Embalagens'
    ,'Equipamentos de ginástica'
    ,'Equipamentos de segurança'
    ,'Equipamentos e materiais de Informática'
    ,'Equipamentos e utensílios de cozinha'
    ,'Equipamentos esportivos'
    ,'Esportes náuticos'
    ,'Esquadrias'
    ,'Fantasias'
    ,'Farmácia'
    ,'Farmácia de manipulação'
    ,'Farmácia veterinária'
    ,'Fast food'
    ,'Ferragens e ferramentas'
    ,'Ferro e aço para construção'
    ,'Floricultura'
    ,'Foodtruck'
    ,'Frutaria'
    ,'Galeteria'
    ,'Gás de cozinha'
    ,'Gelo'
    ,'Hamburgueria'
    ,'Joalheria'
    ,'Jornais e revistas'
    ,'Lan house'
    ,'Lanchonete'
    ,'Laticínios'
    ,'Leiteria'
    ,'Livros'
    ,'Loja de brinquedos'
    ,'Loja de conveniências'
    ,'Loja de departamentos'
    ,'Loja de ferragens'
    ,'Louças'
    ,'Lustres e iluminação'
    ,'Madeireira'
    ,'Máquinas, implementos e acessórios'
    ,'Materiais de construção'
    ,'Materiais de decoração'
    ,'Materiais de higiene e limpeza'
    ,'Materiais de informática'
    ,'Materiais elétricos'
    ,'Material de escritório'
    ,'Material de pesca'
    ,'Material escolar'
    ,'Material esportivo'
    ,'Minimercado'
    ,'Moda feminina'
    ,'Moda infantil'
    ,'Moda íntima'
    ,'Moda jovem'
    ,'Moda masculina'
    ,'Moda pet'
    ,'Moda praia'
    ,'Motocicletas'
    ,'Motos'
    ,'Móveis de aço'
    ,'Móveis e estofados'
    ,'Móveis e objetos de decoração'
    ,'Móveis planejados'
    ,'Objetos para decoração'
    ,'Olaria'
    ,'Ótica'
    ,'Padaria'
    ,'Panificadora'
    ,'Papelaria'
    ,'Pastelaria'
    ,'Peixaria'
    ,'Perfumaria'
    ,'Persianas e cortinas'
    ,'Pet shopp'
    ,'Petisqueria'
    ,'Pisos e revestimentos'
    ,'Pizzaria'
    ,'Plantas ornamentais'
    ,'Pneus'
    ,'Portas e janelas'
    ,'Produtos de higiene'
    ,'Produtos diet'
    ,'Produtos fitness'
    ,'Produtos naturais'
    ,'Produtos orgânicos e veganos'
    ,'Produtos veterinários'
    ,'Quadros e molduras'
    ,'Queijos'
    ,'Quiosque'
    ,'Quitanda'
    ,'Rações'
    ,'Refeições industriais'
    ,'Refeições prontas (""marmitex"")'
    ,'Restaurante a la carte'
    ,'Restaurante self service/Kilo'
    ,'Rotisserie'
    ,'Roupas e acessórios para bebês'
    ,'Roupas e acessórios plus size'
    ,'Roupas usadas (Brechó)'
    ,'Secos e molhados'
    ,'Sementes e mudas'
    ,'Snack-bar'
    ,'Sorveteria'
    ,'Supermercado'
    ,'Suplementos nutricionais e vitaminas'
    ,'Tapetes'
    ,'Tecidos'
    ,'Tintas e materias para pintura'
    ,'Uniformes'
    ,'Utensílios e equipamentos para cozinha'
    ,'Utilidades para o Lar'
    ,'Utilitários'
    ,'Veículos multimarcas'
    ,'Verdureiro'
    ,'Vestidos de noiva'
    ,'Vidraçaria'
    ,'Vinhos e destilados'
  ];
  Future<void> _loadItems() async {
    const url = "https://servicodados.ibge.gov.br/api/v1/localidades/estados";
    try {
      final response = await Dio().get<List>(url);

      final listaEstados = response.data!
          .map((e) => estado.fromJson(e))
          .toList()
        ..sort(
            (a, b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
      final List<String> estadosUFS = response.data!
          .map<String>((item) => item['sigla'])!
          .toList()
        ..sort((a, b) => a!.toLowerCase().compareTo(b!.toLowerCase()));
      //  final List<String> estadosUFS =[];
      setState(() {
        if (estadosUFS.isNotEmpty) {
          _items = estadosUFS;
          _uf = listaEstados;
        }
        //_cidades=[];
      });
    } on DioExceptionType {
      return Future.error(
          "Nã foi possivel obter os estados, verifique se esta conectado a internete.");
    }
  }

  _loadCidades() async {
    if (_idEstado.toString().isNotEmpty) {
      var url =
          "https://servicodados.ibge.gov.br/api/v1/localidades/estados/$_idEstado/distritos";
      try {
        final response = await Dio().get<List>(url);
        final List<String> cidades = response.data!
            .map<String>((item) => item['nome'])!
            .toList()
          ..sort((a, b) => a!.toLowerCase().compareTo(b!.toLowerCase()));
        print(_cidades);
        setState(() {
          _cidades = cidades;
        });

        //  return cidades;
      } on DioExceptionType {
        return [];
      }
    } else {
      return [];
    }
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

  var estados = ibge().getEstados().then((value) => print(value));
  @override
  Widget build(BuildContext context) {
    ValidationBuilder.setLocale('pt-br');
    return Scaffold(
/*
      appBar: AppBar(
        title: Text("Cadastre-se"),
      ),*/
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Logo(),
                  const SizedBox(
                    height: 50.0,
                  ),

                  const Espacamento(),
                  const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: 'Lato',
                      color: const Color.fromRGBO(1, 57, 44, 1),
                    ),
                  ),
                  const Espacamento(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                          child: Container()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextoInput('Email'),
                          Container(
                            decoration: buildBoxDecoration(),
                            width: MediaQuery.of(context).size.width * 0.82,
                            child: TextFormField(
                              validator: ValidationBuilder()
                                  .email()
                                  .maxLength(50)
                                  .required()
                                  .build(),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: buildInputDecoration(""),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: IconButton(
                          icon: const Icon(
                            Icons.help,
                            color: Color.fromRGBO(1, 57, 44, 1),
                          ),
                          color: Colors.black54,
                          onPressed: () {
                            alerta.openModal(context,
                                "O número do WhatsApp será sua 'Identidade'no Get UP.\nNenhum nome nem Rasão social ou CNPJ, Nenhum endereço.\nApenas númenro que nos informar.");
                          },
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.82,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextoInput('WhatsApp'),
                              buildWhatsAPP(),
                            ],
                          )),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: IconButton(
                          icon: const Icon(
                            Icons.help,
                            color: Color.fromRGBO(1, 57, 44, 1),
                          ),
                          color: Colors.black54,
                          onPressed: () {
                            alerta.openModal(context,
                                "Pedimos que informe a atividade, cidade e Estado para que, ao somar os dados de todos os participantes, possamos lhe enviar indicadores (que hoje você não tem), muito úteis para suas análises e providências.");
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.82,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextoInput('Atividade da empresa'),
                            DropdownButtonFormField<String>(
                              itemHeight: null,
                              value: null,
                              isExpanded: true,
                              decoration:
                                  buildInputDecoration(""),
                              onChanged: (values) {
                                print(values);
                                setState(() {
                                  //  _items=[];
                                  _nomeController.text = values!;
                                });
                              },
                              items: dropOpcoes.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,

                                  child: Text(
                                    item,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                     // fontSize: 14,
                                      //  color: const Color.fromRGBO(159, 105, 56,1),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                          child: Container()),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.82,
                        decoration: buildBoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextoInput('Estado'),
                            DropdownButtonFormField<String>(
                              value: null,
                              isExpanded: true,
                              decoration: buildInputDecoration(""),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _cidadesValue = '';
                                  _uf.forEach((element) {
                                    if (element.sigla == value) {
                                      _idEstado = element.id;
                                      _loadCidades();
                                    }
                                  });
                                  _selectedItem = value!;
                                });
                              },
                              items: _items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      //  color: const Color.fromRGBO(159, 105, 56,1),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                          child: Container()),
                 /*     SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: IconButton(
                          icon: const Icon(
                            Icons.help,
                            color:  Color.fromRGBO(1, 57, 44, 1)
                          ),
                          color: Colors.black54,
                          onPressed: () {
                            alerta.openModal(context,
                                "Para selecionar a cidade o estado deve este selecionado.");
                          },
                        ),
                      ),

                  */
                      Container(
                        width: MediaQuery.of(context).size.width * 0.82,
                        decoration: buildBoxDecoration(),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextoInput('Cidade'),
                            DropdownButtonFormField<String>(
                              itemHeight: null,
                              isExpanded: true,

                              value:
                                  _cidadesValue.isNotEmpty ? _cidadesValue : null,
                              decoration:
                                  buildInputDecoration(""),
                              onChanged: (values) {
                                print(values);
                                setState(() {
                                  //  _items=[];
                                  _cidadesValue = values!;
                                });
                              },
                              items: _cidades.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(
                                    width: 200.0,
                                    child: Text(
                                      item,
                                      overflow: TextOverflow.ellipsis,
                                      style: const  TextStyle(
                                        // fontWeight: FontWeight.bold,
                                      //  fontSize: 14,
                                        //  color: const Color.fromRGBO(159, 105, 56,1),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                  /*                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                  child:  DropdownButtonFormField<String>(
                    value:null,
                    decoration: buildInputDecoration("Selecione o estado"),

                    onChanged: (value) {
                      setState(() {
                         print(value);
                         _cidadesValue ='';
                        // _items=_items;
                      //  _idEstado =0;
                        _uf.forEach((element) {
                          if(element.sigla == value){
                            _idEstado =element.id;
                            _loadCidades();
                          }
                        });
                        _selectedItem = value!;
                      });
                    },
                    items: _items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                ),


                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child:  DropdownButtonFormField<String>(
                      value: _cidadesValue.isNotEmpty?_cidadesValue:null,
                      decoration: buildInputDecoration("Selecione o cidade"),
                      onChanged: (values) {
                        print(values);
                        setState(() {
                        //  _items=[];
                          _cidadesValue =values!;
                        });
                      },
                      items: _cidades.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                    ),
                  ),
                  */
                  const Espacamento(),

                  /*   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 220,
                        decoration: buildBoxDecoration(),
                        child: TextFormField(
                            validator: ValidationBuilder().minLength(3).maxLength(50).required().build(),
                            keyboardType: TextInputType.text,
                            controller: _nomeController,
                            decoration: buildInputDecoration("Cep")
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: buildBoxDecoration(),
                        child: TextFormField(
                            validator: ValidationBuilder().minLength(3).maxLength(50).required().build(),
                            keyboardType: TextInputType.text,
                            controller: _nomeController,
                            decoration: buildInputDecoration("Estado")
                        ),
                      ),
                    ],
                  ),
                  */
                  //   const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                          child: Container()),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.82,
                        decoration: buildBoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextoInput('Senha'),
                            TextFormField(
                                validator: ValidationBuilder()
                                    .minLength(6)
                                    .maxLength(50)
                                    .required()
                                    .build(),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                controller: _senhaController,
                                decoration: buildInputDecoration("")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: Checkbox(
                            value: _valueCheck,
                            activeColor: Color.fromRGBO(1, 57, 44, 1),
                            onChanged: (value) {
                              setState(() {
                                print(value);
                                _valueCheck = !_valueCheck;
                                // checkBoxValue = newValue;
                              });
                              // Text('Remember me');
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: InkWell(
                            child: new Text('Termo de uso e privacidade'),
                            onTap: () => launch('https://wolfx.com.br/')),
                      ),
                    ],
                  ),

                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.10,
                        child: Container(),
                      ),
                      buildBtns(context),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.10,
                        child: Container(),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildBtns(BuildContext context) {
    return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(1, 57, 44, 1),
                            // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: _conn ? _buildOnPressed : null,
                          child: const Text('Cadastrar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const Espacamento(),
                      Row(
                     //   mainAxisAlignment: MainAxisAlignment.center,
                     //   crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: const Color.fromRGBO(1, 57, 44, 1),
                              ),
                              child: const Text('Login'),
                              onPressed: () {
                                irPagina.pushPage(context, const Login());
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: TextButton(
                              style: OutlinedButton.styleFrom(
                                primary: const Color.fromRGBO(1, 57, 44, 1),
                              ),
                              child: const Text('Esqueceu a senha?'),
                              onPressed: () {
                                irPagina.pushPage(context, const RecuperarSenha());
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
  }

  Text buildTextoInput(titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      //  color:   Color.fromRGBO(245, 245, 245, 1),
      ),
    );
  }

  SizedBox buildIcone(BuildContext context, texto) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.01,
      child: Text("p"),
    );
  }

  Container buildWhatsAPP() {
    return Container(
      decoration: buildBoxDecoration(),
      child: TextFormField(
          validator: ValidationBuilder().required().build(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          controller: _telefoneController,
          decoration: buildInputDecoration("")),
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
    } else if (text == 'Atividade da empresa') {
      textoAjuda =
          "Pedimos que informe a atividade, cidade e Estado para que, ao somar os dados de todos os participantes, possamos lhe enviar indicadores (que hoje você não tem), muito úteis para suas análises e providências.";
      mostrarAlerta = true;
    } else if (text == 'WhatsApp') {
      textoAjuda =
          "O número do WhatsApp será sua 'Identidade'no Get UP.\nNenhum nome nem Rasão social ou CNPJ, Nenhum endereço.\nApenas númenro que nos informar.";
      mostrarAlerta = true;
    } else if (text == 'Selecione o cidade') {
      textoAjuda = "Para selecionar a cidade o estado deve este selecionado.";
      mostrarAlerta = true;
    }

    if (mostrarAlerta) {
      iconeAjuda = Text("P");
    }
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //   suffixIcon: suffixIcon,
      fillColor: const Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      // border:InputBorder,

      // prefixIcon:iconeAjuda,
      //  disabledBorder: false,

      focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:
            BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:
            BorderSide(color:  Color.fromRGBO(245, 245, 245, 1), width: 1.0),
      ),
      labelText: text,

      labelStyle: const TextStyle(
        color: Colors.black,

        fontFamily: 'Lato',
        fontSize: 16,
        //  color: const Color.fromRGBO(159, 105, 56,1),

        backgroundColor: Colors.white,
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.transparent,
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

  _buildOnPressed() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    var alert = AlertSnackBar();
    var data = {
      'setor_atuação': _nomeController.text,
      'telefone': _telefoneController.text,
      'email': _emailController.text,
      'status': false,
      'admin': false,
      'cidade': _cidadesValue,
      'estado': _selectedItem
    };
    print(_valueCheck);
    if (_valueCheck == false) {
      alerta.openModal(context,
          'Aceite da policita de privacidade  e termo de uso para dar continuidade.');
      return;
    }
    if (_selectedItem.isEmpty) {
      alerta.openModal(context, 'Selecione o estado');
      return;
    }
    if (_cidadesValue.isEmpty) {
      alerta.openModal(context, 'Selecione o cidade');
      return;
    }
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (credential.additionalUserInfo != null) {
        // print(credential.user!.email);
        FirebaseFirestore.instance
            .collection("usuario")
            .doc(_emailController.text)
            .set(data);
      }
      alert.alertSnackBar(
          context, Colors.green, 'Cadastro realizado com sucesso');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        alert.alertSnackBar(
            context, Colors.red, 'A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        alert.alertSnackBar(
            context, Colors.red, 'A conta já existe para esse e-mail.');
      }
    } catch (e) {
      print(e);
    }

  }
}
