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
  final _especialidadeController = TextEditingController();
  final _telefoneController = TextEditingController(text: '');
  final _senhaController = TextEditingController();
  final _tokenAtivacaoController = TextEditingController();


  var color = const Color.fromRGBO(1, 57, 44, 1);
  List<String> restricoesLimpezaLista = ['Outra',];
 final dropOpcoesEspecialidade =[];
  final dropOpcoes = [
    'AMBULANTE',
    'ATACADO',
    'AUTOMOTORES',
    'VAREJO - Alimentação fora do Lar',
    'Varejo - Animais domésticos',
    'Varejo - Arte, decoração e utilidades para o Lar',
    'Varejo - Bebidas e produtos alimentícios',
    'Varejo - Copa e cozinha',
    'Varejo - Eletroeletrônicos e informática',
    'Varejo - Festas, leitura, música, esporte e lazer',
    'Varejo - Jardinagem',
    'Varejo - Materiais de construção',
    'Varejo - Papéis e utilidades para escritórios',
    'Varejo - Saúde e bem-estar',
    'Varejo - Vestuário,calçados e complementos'
  ];

  final AMBULANTE = [
    'Açaí',
    'Algodão doce',
    'Artesanato',
    'Balas, bombons e chocolates',
    'Barraca de pastel',
    'Bebidas e refresco',
    'Bijuterias',
    'Cachorro-quente',
    'Calçados',
    'Caldo de cana',
    'Churrasquinho',
    'Churros',
    'Crepe',
    'Doces',
    'Eletrônicos',
    'Ervas medicinais',
    'Sanduiches',
    'Mate',
    'Milho cozido',
    'Óculos',
    'Pipoca',
    'Relógios',
    'Revenda de bijuterias e semi-jóias',
    'Roupas e/ou acessórios',
    'Sorvete',
    'Souvenirs temáticos e lembranças',
    'Tapioca',
    'Outra area ambulante'
  ];
  final ATACADO = [
    'Acessórios para aparelhos celulares',
    'Adubos e defensivos agrícolas',
    'Alimentos congelados',
    'Artigos de decoração',
    'Artigos esportivos',
    'Artigos para festas',
    'Autopeças e acessórios',
    'Bebidas',
    'Bolsas, carteiras, cintos, malas, etc.',
    'Brinquedos e jogos',
    'Calçados atacado',
    'Cama, mesa e banho',
    'Cereais',
    'Doces atacado',
    'Eletrodomésticos atacado',
    'Eletro-eletrônicos e informática',
    'Equipamentos de sinalização e segurança',
    'Equipamentos e acessórios para a área da saúde',
    'Equipamentos e utensílios para copa e cozinha',
    'Fantasias',
    'Implementos agrícolas',
    'Instrumentos musicais',
    'Livros, revistas, jornais',
    'Materiais de construção',
    'Materiais de escritório',
    'Materiais de higiene e limpeza',
    'Medicamentos',
    'Medicamentos e produtos veterinários',
    'Produtos alimentícios',
    'Produtos e implementos de jardinagem',
    'Roupas',
    'Sorvetes',
    'Uniformes atacado',
    'Vestuário',
    'Outra área atacado'
  ];
  final AUTOMOTORES = [
    'Automóveis e utilitários',
    'Autopeças e acessórios',
    'Barcos, botes, lanchas, jet-skis',
    'Baterias',
    'Bicicletas',
    'Caminhões',
    'Caminhões, ônibus e vans',
    'Carrocerias e baús',
    'Carrocerias para ônibus e vans',
    'Combustíveis e lubrificantes',
    'Equipamentos para transporte coletivo',
    'Equipamentos para transporte de cargas',
    'Máquinas e implementos agrícolas',
    'Motocicletas',
    'Ônibus e vans',
    'Pneus',
    'Outra área automotores'
  ];
  final VAREJOAlimentacaoForaDoLar = [
    'Bar/Boteco',
    'Açaiteria',
    'Biscoitos',
    'Bistrô',
    'Bomboniere',
    'Boulangerie',
    'Cachaçaria',
    'Café colonial',
    'Cafeteria - café expresso',
    'Cantina Italiana',
    'Casa de chá',
    'Casa de sucos',
    'Cervejaria',
    'Chocolates',
    'Choperia',
    'Churrascaria',
    'Comidas delivery',
    'Confeitaria',
    'Creperia',
    'Delicatessen',
    'Doceria',
    'Fast food',
    'Food truck',
    'Gelateria',
    'Hamburgueria',
    'Lanchonete',
    'Loja de bolos e tortas',
    'Loja de conveniências',
    'Loja de sanduíches naturais',
    'Loja de vinhos e destilados',
    'Mate e salgados',
    'Padaria',
    'Pamonharia',
    'Panificadora',
    'Pastelaria',
    'Petisqueria',
    'Pizzaria',
    'Quiosque de praia',
    'Quiosque de Shopping',
    'Refeições industriais',
    'Refeições prontas ("marmitex")',
    'Restaurante à la carte',
    'Restaurante árabe',
    'Restaurante chinês',
    'Restaurante coreano',
    'Restaurante culinária baiana',
    'Restaurante culinária capixaba',
    'Restaurante culinária goiana',
    'Restaurante culinária internacional',
    'Restaurante culinária mineira',
    'Restaurante culinária nordestina',
    'Restaurante culinária portuguesa',
    'Restaurante de alta gastronomia',
    'Restaurante de caldos e saladas',
    'Restaurante de frutos do mar',
    'Restaurante frango assado - galeteria',
    'Restaurante japonês',
    'Restaurante regional',
    'Restaurante self-service',
    'Restaurante temático',
    'Restaurante vegano',
    'Restaurante vegetariano',
    'Rotisserie',
    'Snack-bar',
    'Sorveteria',
    'Sucos',
    'Tapiocaria',
    'Temakeria',
    'Outra área varejo alimentação'
  ];
  final VarejoAnimaisDomesticos = [
    'Medicamentos veterinários',
    'Pet shop',
    'Rações',
    'Outra área animais domesticos'
  ];
  final VarejoArteDecoracaoUtilidades = [
    'Antiquário',
    'Aquários e peixes ornamentais',
    'Arte e artesanato',
    'Artigos de cama, mesa e banho',
    'Colchões',
    'Cortinas, tapetes e carpetes',
    'Eletrodomésticos',
    'Equipamentos e utensílios para copa e cozinha',
    'Flores e plantas artificiais',
    'Floricultura - flores naturais',
    'Gás de cozinha',
    'Louças',
    'Lustres e iluminação',
    'Materiais e peças para artesanato',
    'Móveis',
    'Móveis de aço',
    'Móveis e estofados',
    'Móveis planejados',
    'Móveis rústicos',
    'Móveis usados',
    'Persianas e cortinas',
    'Plantas ornamentais',
    'Presentes e artigos de decoração',
    'Quadros e molduras',
    'Tapetes',
    'Outra área varejo utilizadades e decoração'
  ];

  final VarejoBebidasProdutosAlimenticios = [
    'Açougue',
    'Adega',
    'Armazém',
    'Embalagens',
    'Frutaria',
    'Minimercado',
    'Padarias',
    'Peixaria',
    'Quitanda',
    'Supermercado',
    'Outra área varejo alimenticío'
  ];

  final VarejCopaCozinha = [
    'Equipamentos de refrigeração',
    'Máquinas e equipamentos',
    'Materiais de limpeza e higiene',
    'Mobiliário',
    'Uniformes para cozinha',
    'Utensílios, louças, talheres e acessórios',
    'Outra área varejo copa cozinha'
  ];
  final VarejoEletroeletronicosInformatica = [
    'Acessórios para celulares',
    'Computadores e acessórios',
    'Equipamentos de som',
    'Equipamentos e materiais de Informática',
    'Materiais de informática',
    'Telefones celulares e tablets',
    'Outra área eletronicos e imformática'
  ];

  final VarejoFestasLeituraMusicaEsporteLazer = [
    'Barcos e artigos náuticos',
    'Brinquedos e jogos infantis',
    'Caça e pesca',
    'Camping',
    'Discos para colecionadores',
    'Equipamentos de ginástica',
    'Equipamentos de salvatagem',
    'Equipamentos para esportes',
    'Esportes náuticos',
    'Esportes radicais',
    'Fantasias para festas',
    'Instrumentos musicais para festas',
    'Livraria',
    'Loja de roupas e acessórios para surfistas',
    'Moda praia',
    'Piano',
    'Roupas, uniformes e calçados esportivos',
    'Suplementos nutricionais e vitaminas',
    'Outra área varejo festas'
  ];

  final VarejoJardinagem = [
    'Adubos, sementes e defensivos',
    'Árvores adultas',
    'Máquinas, equipamentos e acessórios',
    'Móveis para exteriores',
    'Plantas ornamentais',
    'Sementes e mudas',
    'Viveiro de mudas',
    'Outra área varejo jardinagem'
  ];

  final VarejoMateriaisConstrucao = [
    'Aquecedor solar',
    'Brita',
    'Brita',
    'Carpintaria',
    'Cimento',
    'Equipamentos de segurança',
    'Esquadrias',
    'Exploração e comércio de areia',
    'Ferragens',
    'Ferramentas, máquinas e equipamentos',
    'Ferro e aço para construção',
    'Laje pré-moldada',
    'Loja de ferragens',
    'Loja de tintas',
    'Louças sanitárias',
    'Madeireira',
    'Máquinas, implementos e acessórios',
    'Materiais de construção',
    'Materiais elétricos',
    'Peças para refrigeração',
    'Pisos e revestimentos',
    'Pisos e revestimentos',
    'Portas e janelas',
    'Serralheria',
    'Telhas e tijolos',
    'Tintas e materias para pintura',
    'Vidraçaria',
    'Outra área varejo materiais construcao'
  ];

  final VarejoPapeisUtilidadesEscritorios=[
     'Materiais de escritório'
    ,'Papelaria'
    ,'Outra área varejo utilidades escritório'
  ];

  final VarejoSaudeBemestar =[
     'Aparelhos auditivos'
    ,'Aparelhos ortopédicos'
    ,'Drogaria'
    ,'Ervas medicinais e homeopatia'
    ,'Farmácia'
    ,'Farmácia de manipulação'
    ,'Ótica'
    ,'Produtos fitness'
    ,'Produtos naturais'
    ,'Outra área varejo saúde e bem estar'
  ];
  final VarejoVestuarioCalcadosComplementos=[
    'Armarinho'
    ,'Aviamentos'
    ,'Bijuterias e semi-jóias'
    ,'Bolsas e calçados'
    ,'Calçados e acessórios'
    ,'Calçados e acessórios femininos'
    ,'Calçados e acessórios infantis'
    ,'Calçados e acessórios masculinos'
    ,'Cosméticos, perfumes e acessórios'
    ,'Joalheria'
    ,'Loja de departamentos'
    ,'Moda feminina'
    ,'Moda infantil'
    ,'Moda íntima'
    ,'Moda jovem'
    ,'Moda masculina'
    ,'Moda praia'
    ,'Perfumaria'
    ,'Roupas e acessórios plus size'
    ,'Roupas usadas (Brechó)'
    ,'Roupas, acessórios e produtos para bebês'
    ,'Sex shop'
    ,'Tecidos'
    ,'Uniformes'
    ,'Vestidos de noiva'
    ,'Outra área vestuário e calçados'
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
          .map<String>((item) => item['sigla'])
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
            .map<String>((item) => item['nome'])
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
       // print(_cidades);
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
                 // const Logo(),
                  // const SizedBox(
                  //   height: 50.0,
                  // ),

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
                                "O número do WhatsApp será sua 'Identidade'no Get UP.\nNenhum nome nem Rasão social ou CNPJ, Nenhum endereço.\nApenas o número que nos informar.");
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
                  GestureDetector(
                      onTap: (){
                        dropOpcoesEspecialidade.clear();
                     //  _especialidadeController.text ='';
                      },
                      child: buildAtividadeEmpresa(context),
                  ),
                  const Espacamento(),
                  buildAtividade(context),
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
                            buildTextoInput('Chave de  ativação'),
                            TextFormField(
                                validator: ValidationBuilder()
                                    .minLength(6)
                                    .maxLength(50)
                                    .required()
                                    .build(),
                                keyboardType: TextInputType.text,
                               // obscureText: true,
                                controller: _tokenAtivacaoController,
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
                            child: const Text(
                              'Termo de uso e privacidade',
                              style: TextStyle(
                                color: Colors.blue, // Define a cor do texto como azul
                              ),
                            ),
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

  Row buildAtividade(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.82,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextoInput('Área/Especialidade'),
              DropdownButtonFormField<String>(
                itemHeight: null,
                value: _especialidadeController.text.isNotEmpty?_especialidadeController.text:null,
                isExpanded: true,
                decoration:
                buildInputDecoration(""),
                onChanged: (values) {
                  setState(() {
                    _especialidadeController.text =values!;
                  });
                },
                items: dropOpcoesEspecialidade.map((item) {
                 // print(_especialidadeController.text);
                  return buildDropdownEspecialidades(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildDropdownEspecialidades(item) {
    return DropdownMenuItem<String>(
                  value:  item !=""?item:_especialidadeController.text,
                  child: Text(
                    item !=""?item:_especialidadeController.text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      // fontWeight: FontWeight.bold,
                      // fontSize: 14,
                      //  color: const Color.fromRGBO(159, 105, 56,1),
                    ),
                  ),
                );
  }

  Row buildAtividadeEmpresa(BuildContext context) {
    return Row(
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
                              "Pedimos que informe a atividade, cidade e Estado para que, ao somar os Dados Básicos de todos os participantes, possamos lhe enviar indicadores (que hoje você não tem), muito úteis para suas análises e providências.");
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
                            value:null,
                            isExpanded: true,
                            decoration:
                            buildInputDecoration(""),
                            onChanged: (values) {
                            //  print(values);

                              setState(() {
                               // _especialidadeController.text =_especialidadeController.text;
                                _nomeController.text = values!;
                              //dropOpcoesEspecialidade.add(_especialidadeController.text);
                             //   print("especialisa");
                             //   print(_especialidadeController.text);
                                if(!restricoesLimpezaLista.contains(_especialidadeController.text)) {
                                  dropOpcoesEspecialidade.retainWhere((titulo) => titulo == _especialidadeController.text );

                                }else{
                                  dropOpcoesEspecialidade.clear();
                                }
                               addLista(values);
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
                );
  }

  void addLista(String values) {


    _especialidadeController.text="";
     if(values == 'AMBULANTE'){
      AMBULANTE.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "ATACADO"){
      ATACADO.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "AUTOMOTORES"){
      AUTOMOTORES.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "VAREJO - Alimentação fora do Lar"){
      VAREJOAlimentacaoForaDoLar.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Animais domésticos"){
      VarejoAnimaisDomesticos.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Arte, decoração e utilidades para o Lar"){
      VarejoArteDecoracaoUtilidades.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Bebidas e produtos alimentícios"){
      VarejoBebidasProdutosAlimenticios.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Copa e cozinha"){
      VarejCopaCozinha.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Eletroeletrônicos e informática"){
      VarejoEletroeletronicosInformatica.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Festas, leitura, música, esporte e lazer"){
      VarejoFestasLeituraMusicaEsporteLazer.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Jardinagem"){
      VarejoJardinagem.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Materiais de construção"){
      VarejoMateriaisConstrucao.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Papéis e utilidades para escritórios"){
      VarejoPapeisUtilidadesEscritorios.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Saúde e bem-estar"){
      VarejoSaudeBemestar.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }else if(values == "Varejo - Vestuário,calçados e complementos"){
      VarejoVestuarioCalcadosComplementos.forEach((element) {
        dropOpcoesEspecialidade.add(element);
      });
    }
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
                          style:colorButtonStyle() ,
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
                              style: colorButtonStyle() ,
                              child: const Text('Login'),
                              onPressed: () {
                                irPagina.pushPage(context, const Login());
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: TextButton(
                              style: colorButtonStyle() ,
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
      'atividade_empresa': _nomeController.text,
      'area_empresa':_especialidadeController.text,
      'telefone': _telefoneController.text,
      'email': _emailController.text,
      'status': true,
      'admin': false,
      'cidade': _cidadesValue,
      'estado': _selectedItem,
      'chave_ativacao': _tokenAtivacaoController.text
    };
    var token_ativacao = _tokenAtivacaoController.text;

    if(token_ativacao == ""){
      alerta.openModal(context,
          'Chave de ativação é obrigatoria.');
      return;
    }
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
      // Consultar a coleção 'licenses' para verificar o status do token de ativação
      final querySnapshot = await FirebaseFirestore.instance
          .collection('licenses')
          .where('code', isEqualTo: token_ativacao)
          .where('status', isEqualTo: 'disponível')
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Se nenhum documento for encontrado com o token de ativação e status 'disponível'
        alerta.openModal(context, 'Token de ativação inválido ou não disponível.');
        return;
      }

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (credential.additionalUserInfo != null) {
        print(credential.user!.email);
        FirebaseFirestore.instance
            .collection("usuario")
            .doc(_emailController.text)
            .set(data);
      }
      // ignore: use_build_context_synchronously
      alert.alertSnackBar(context, Colors.green, 'Cadastro realizado com sucesso');

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
  ButtonStyle colorButtonStyle() {
    var corVerde  = const Color.fromRGBO(1, 57, 44, 1);
    var corBranco = Colors.white;
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(corVerde),
      foregroundColor: MaterialStateProperty.all<Color>(corBranco),
    );
  }
}
