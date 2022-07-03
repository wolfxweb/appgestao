




import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:flutter/material.dart';

class HomeInativo extends StatefulWidget {
  const HomeInativo({Key? key}) : super(key: key);

  @override
  State<HomeInativo> createState() => _HomeInativoState();
}

class _HomeInativoState extends State<HomeInativo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(
        child:   BtnCadastreSe(),
      ),
    );
  }
}

