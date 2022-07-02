
import 'package:appgestao/usuaruio/cadastro.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool status = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("oapap"),
      ),*/
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             const  TextField(
                  decoration:  InputDecoration(
                     // border: InputBorder.none,
                   border: UnderlineInputBorder(),
                      icon: Icon(Icons.email),
                      hintText: 'Digite o seu email',
                  ),
                ),
                const TextField(
                  decoration:  InputDecoration(
                    // border: InputBorder.none,

                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.password),
                    hintText: 'Digite sua senha',
                  ),
                ),
                ElevatedButton (
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Text('Entrar',style: TextStyle(color: Colors.white)),
                  onPressed:_buildOnPressed,

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.amber, // background
                      ),
                      child: const Text('Cadastre-se '),
                      onPressed:(){
                        CadastroUsuario();
                      },
                    ),
                    TextButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.amber, // background

                      ),
                      child: const Text('Esqueceu a senha?'),
                      onPressed:(){
                        RecuperarSenha();
                      },

                    ),

                  ],
                ),
                FlutterSwitch(
                  width: 75.0,
                  activeText:'Dark',
                  inactiveText:'Light',
                  activeColor: Colors.black54,
                  inactiveColor: Colors.amber,
                  activeIcon: const Icon(Icons.dark_mode,color: Colors.black54),
                  inactiveIcon: const Icon(Icons.light_mode, color: Colors.amber),
                  showOnOff: true,
                  key: Key('EasyDynamicThemeSwitch'),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onToggle: (val) {
                    EasyDynamicTheme.of(context).changeTheme(dark: val);
                  },
                ),
              ],
            ),
          ),
        ),
    ),
    );
  }

  _buildOnPressed(){

  }
}
