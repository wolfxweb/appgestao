import 'package:appgestao/classes/model/estados.dart';
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
  int _idEstado =0;
  bool _conn = false;
  bool _valueCheck = true;
  String _message = '';
  StreamSubscription? subscription;
  final SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()..setLookUpAddress('pub.dev');
  @override
  void initState() {
    super.initState();
    _loadItems();
    subscription = _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected? 'Connected': 'Not connected';
      });
    });
    _getConection();
  }
  var irPagina = PushPage();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController(text: '');
  final _senhaController = TextEditingController();
  var color = Color.fromRGBO(159, 105, 56,0.5);
  final dropOpcoes = [
    'Varejo de moda e vestuário',
    'Supermercados e mercearias',
    'Eletrônicos e tecnologia',
    'Alimentos e bebidas',
    'Automóveis e peças automotivas',
    'Cosméticos e produtos de beleza'

  ];
  Future<void> _loadItems() async {
    const url ="https://servicodados.ibge.gov.br/api/v1/localidades/estados";
    try{
       final response = await Dio().get<List>(url);
       final listaEstados = response.data!.map((e) => estados.fromJson(e)).toList()..sort((a,b)=> a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
       final List<String> estadosUFS = response.data!.map<String>((item) => item['sigla']).toList()..sort((a,b)=> a!.toLowerCase().compareTo(b!.toLowerCase()));
        setState(() {
          if(estadosUFS.isNotEmpty){
            _items = estadosUFS;
            _uf = listaEstados;
          }
          //_cidades=[];
        });
      }on DioExceptionType{
      return Future.error("Nã foi possivel obter os estados, verifique se esta conectado a internete.");
    }

  }
  _loadCidades()async{

    if(_idEstado.toString().isNotEmpty){
      var url ="https://servicodados.ibge.gov.br/api/v1/localidades/estados/$_idEstado/distritos";
      try{
        final response = await Dio().get<List>(url);
        final List<String> cidades = response.data!.map<String>((item) => item['nome']).toList()..sort((a,b)=> a!.toLowerCase().compareTo(b!.toLowerCase()));
        print(_cidades);
        setState(() {
          _cidades = cidades;
        });

      //  return cidades;
      }on DioExceptionType{
        return [];
      }
    }else{
      return [];
    }
  }

  _getConection()async{
    bool _isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    setState(() {
      _conn = _isConnected;
    });
    if(!_isConnected ){
      alerta.openModal(context,'Sem conexão com a internet');
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
      body: Center(
        child:Container(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Logo(),
                    const Espacamento(),
                    const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: const Color.fromRGBO(159, 105, 56,1),
                      ),
                    ),
                    const Espacamento(),

                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        validator: ValidationBuilder().email().maxLength(50).required().build(),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration:  buildInputDecoration("Email")
                      ),
                    ),
                    const Espacamento(),
                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                          validator: ValidationBuilder().required().build(),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          controller: _telefoneController,
                          decoration: buildInputDecoration("WhatsApp")
                      ),
                    ),
                    const Espacamento(),
                /*    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                          validator: ValidationBuilder().minLength(3).maxLength(50).required().build(),
                          keyboardType: TextInputType.text,
                          controller: _nomeController,
                          decoration: buildInputDecoration("Setor de atuação")
                      ),
                    ),*/
                    Container(
                    //  width: 295,
                      decoration: buildBoxDecoration(),

                      child:  DropdownButtonFormField<String>(
                        itemHeight: null,
                        value: null,
                        decoration: buildInputDecoration("Setor de atuação"),
                        onChanged: (values) {
                          print(values);
                          setState(() {
                            //  _items=[];
                            _nomeController.text =values!;
                          });
                        },
                        items: dropOpcoes.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child:    Text(
                              item,
                              style:const TextStyle(
                                // fontWeight: FontWeight.bold,
                              //  fontSize: 13,
                                //  color: const Color.fromRGBO(159, 105, 56,1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Espacamento(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 295,
                          decoration: buildBoxDecoration(),

                          child:  DropdownButtonFormField<String>(
                            itemHeight: null,
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
                                child:    Text(
                                 item,
                                  style:const TextStyle(
                                   // fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  //  color: const Color.fromRGBO(159, 105, 56,1),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: 81,
                          decoration: buildBoxDecoration(),
                          child:  DropdownButtonFormField<String>(
                            value:null,
                            decoration: buildInputDecoration("Estado"),

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
                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                          validator: ValidationBuilder().minLength(3).maxLength(50).required().build(),
                          keyboardType: TextInputType.text,
                          controller: _nomeController,
                          decoration: buildInputDecoration("Setor de atuação")
                      ),
                    ),
                    const Espacamento(),
                    Row(
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
                    const Espacamento(),
                    Container(

                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                          validator: ValidationBuilder().minLength(6).maxLength(50).required().build(),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: _senhaController,
                          decoration: buildInputDecoration("Cidade")
                      ),
                    ),
                    const Espacamento(),
                    Container(

                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        validator: ValidationBuilder().minLength(6).maxLength(50).required().build(),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _senhaController,
                        decoration: buildInputDecoration("Senha")
                      ),
                    ),
                    const Espacamento(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child:    Checkbox(value: _valueCheck,
                              activeColor: Color.fromRGBO(159, 105, 56,0.5),
                              onChanged:(value){
                                setState(() {
                                  print(value);
                                  _valueCheck = !_valueCheck;
                                  // checkBoxValue = newValue;
                                });
                               // Text('Remember me');
                              }),
                        ),
                        Container(
                          width:180,
                          child: InkWell(
                              child: new Text('Política de privacidade.'),
                              onTap: () => launch('https://wolfx.com.br/')
                          ),
                        ),
                      ],
                    ),

                    const Espacamento(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(159, 105, 56,1),
                           // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed:_conn? _buildOnPressed:null,
                        child: const Text('Cadastrar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const Espacamento(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: const Color.fromRGBO(159, 105, 56,1),

                          ),
                          child: const Text('Login'),
                          onPressed: () {
                            irPagina.pushPage(context, const Login());
                          },
                        ),
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            primary: const Color.fromRGBO(159, 105, 56,0.5),

                          ),
                          child: const Text('Esqueceu a senha?'),
                          onPressed: () {
                            irPagina.pushPage(context, const RecuperarSenha());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  InputDecoration buildInputDecoration(text) {
    var iconeAjuda =null;
    var textoAjuda ="";
    bool mostrarAlerta = false;
    if(text =='Cep') {
      textoAjuda =   "Digite o seu cep e a cidade e estado são adicionado automaticamente.";
      mostrarAlerta = true;
    }

    if(mostrarAlerta){
      iconeAjuda = IconButton(
        icon: const Icon(Icons.help, color: Colors.black54,),
        color: Colors.black54,
        onPressed: () {
          alerta.openModal(context,textoAjuda );
        },
      );
    }
    return  InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //   suffixIcon: suffixIcon,
      fillColor: const Color.fromRGBO(159, 105, 56,0.5),
      filled: true,

      prefixIcon:iconeAjuda,
      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Color.fromRGBO(159, 105, 56,0.5), width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        //  backgroundColor: Colors.white,
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
  _buildOnPressed()async {
    final isValid = _formKey.currentState!.validate();
    if(!isValid){
      return;
    }
    var alert = AlertSnackBar();
    var data ={
      'setor_atuação': _nomeController.text,
      'telefone':_telefoneController.text,
      'email':_emailController.text,
      'status':false,
      'admin':false,
      'cidade':_cidadesValue,
      'estado':_selectedItem
    };
    print(_valueCheck);
    if(_valueCheck == false){
      alerta.openModal(context,'Aceite da policita de privacidade para dar continuidade.');
      return;
    }
    if(_selectedItem.isEmpty){
      alerta.openModal(context,'Selecione o estado');
      return ;
    }
    if(_cidadesValue.isEmpty){
      alerta.openModal(context,'Selecione o cidade');
      return ;
    }
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if(credential.additionalUserInfo != null){
       // print(credential.user!.email);
        FirebaseFirestore.instance.collection("usuario").doc(_emailController.text).set(data);
      }
      alert.alertSnackBar(context,Colors.green, 'Cadastro realizado com sucesso');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
       // print('The password provided is too weak.');
        alert.alertSnackBar(context,Colors.red, 'A senha fornecida é muito fraca.');

      } else if (e.code == 'email-already-in-use') {
       // print('The account already exists for that email.');
        alert.alertSnackBar(context,Colors.red, 'A conta já existe para esse e-mail.');

      }
    } catch (e) {
      print(e);
    }
    print(data);
  }
}



