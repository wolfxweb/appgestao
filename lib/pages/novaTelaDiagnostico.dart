import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';
import 'package:appgestao/blocs/diagnostico.dart';

class telaDiagnostico extends StatefulWidget {
  const telaDiagnostico({Key? key}) : super(key: key);

  @override
  State<telaDiagnostico> createState() => _telaDiagnosticoState();
}

class _telaDiagnosticoState extends State<telaDiagnostico> {
  @override
  Widget build(BuildContext context) {
    var header = new HeaderAppBar();
    var dignosticoBloc = DignosticoBloc();

    return Scaffold(
      appBar: header.getAppBar('Diagnóstico'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCard(dignosticoBloc.card1),
            buildCard(dignosticoBloc.card2),
            buildCard(dignosticoBloc.card3),
            buildCard(dignosticoBloc.card4),
            buildCard(dignosticoBloc.card5),

          ],
        ),
      ),
    );
  }

  Container buildCard(strean) {
    return Container(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side:const BorderSide(
                  color:Color.fromRGBO(1, 57, 44, 1), //<-- SEE HERE
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: StreamBuilder(
                    stream:strean,
                    builder: (context, snapshot) {
                   //   print(snapshot.data);
                      var text ="";
                      if(snapshot.hasData){
                        text = snapshot.data.toString();
                      }
                      return  Text(text,
                        style:const TextStyle(
                           //color: Colors.black12,
                          fontSize: 16,
                          //  fontWeight: FontWeight.bold,
                        ),
                      //  textAlign: TextAlign.justify,
                      );
                    },
                ),
              ),
            ),
          );
  }
}
