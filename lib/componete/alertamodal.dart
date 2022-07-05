import 'package:flutter/material.dart';

class AlertModal{

   openModal(context, msg){

     showDialog(context: context, builder: (context){
       return AlertDialog(
         title: Text(msg),
         actions: [
           TextButton(
             child: const Text("Fechar"),
             onPressed: () {
               Navigator.pop(context);
             },
           )
         ],
       );
     });
   }

}