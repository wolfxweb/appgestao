import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/blocs/usuario_bloc.dart';
import 'package:appgestao/classes/themes.dart';
import 'package:appgestao/splash_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'pt_BR';
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),

  );
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      blocs: [
      //  Bloc((i) => UsuarioBloc()),
        Bloc((i) {
          UsuarioBloc();
          ImportanciaMesesBLoc();
        }),
      ],
      dependencies: const [],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: EasyDynamicTheme.of(context).themeMode,

        home:SplashPage(),
      ),
    );
  }
}


