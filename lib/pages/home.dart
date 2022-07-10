


import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/pages/homeadmin.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child:   HomeAdmin(),
      ),
    );
  }
}
