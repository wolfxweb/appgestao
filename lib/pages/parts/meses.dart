


import 'package:flutter/material.dart';

class PartsMeses extends StatefulWidget {
  const PartsMeses({Key? key}) : super(key: key);

  @override
  State<PartsMeses> createState() => _PartsMesesState();
}

class _PartsMesesState extends State<PartsMeses> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child:  Center(
        child:  Text("Importância dos meses PartsMeses"),
      ),
    );
  }
}
