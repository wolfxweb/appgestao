




import 'package:flutter/material.dart';


class  PushPage {

  pushPage(context, page){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }



}