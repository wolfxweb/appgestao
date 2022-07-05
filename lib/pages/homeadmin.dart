



import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:header.getAppBar('Home'),
      drawer: Menu(),
      body: const SingleChildScrollView(
        child:  Center(
          child:  Text("Home"),
        ),
      ),
    );
  }
}
