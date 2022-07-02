




import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc implements BlocBase{



  final _themeController = BehaviorSubject<int>();

 // final StreamController _themeController = StreamController();
 // Stream get themeColor =>_themeController.stream;

  final StreamController _selectTheme = StreamController();
  Sink get inTheme =>_selectTheme.sink;


   void setTheme(){
    _selectTheme.stream.listen((event) {

      print(event);

    });
  }


  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _themeController.close();
    _selectTheme.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }


}