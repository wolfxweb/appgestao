import 'package:flutter/material.dart';


class HeaderAppBar {
  getAppBar(String title) {
    return AppBar(
      title:  Text(title, style: const TextStyle(color: Colors.white), // Altera a cor do texto para branco
      ),
      backgroundColor:const Color.fromRGBO(1, 57, 44, 1), // Altera a cor de fundo da AppBar
      iconTheme: const IconThemeData(color: Colors.white), // Altera a cor do ícone (seta) para branco
    );
    /*
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Arial',
          color: Colors.white, // Cor do texto
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(1, 57, 44, 1),
      iconTheme: const IconThemeData(color: Colors.white), // Cor do ícone
    );

     */
  }
}
