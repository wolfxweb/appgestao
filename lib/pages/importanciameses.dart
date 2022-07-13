import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import '../componete/menu.dart';

class InportanciaMeses extends StatefulWidget {
  const InportanciaMeses({Key? key}) : super(key: key);

  @override
  State<InportanciaMeses> createState() => _InportanciaMesesState();
}

class _InportanciaMesesState extends State<InportanciaMeses> {
  late ImportanciaMesesBLoc _importanciaMesesBLoc;

  void initState() {
    _importanciaMesesBLoc = ImportanciaMesesBLoc();
  }

  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Importância dos meses'),
      drawer: Menu(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Espacamento(),
            StreamBuilder(
                stream: _importanciaMesesBLoc.outResult,
                builder: (context, snapshot) {
                  print(snapshot.data.toString());
                  var total = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("total: $total"),
                      ),
                      StreamBuilder(
                        stream: _importanciaMesesBLoc.outMedia,
                        builder: (context, snapshot) {
                          var media = snapshot.data;
                          return Container(
                            child: Text("media $media "),
                          );
                        }
                      ),
                      Container(
                        child: Text("Adicionar"),
                      ),
                    ],
                  );
                }),
            const Espacamento(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Janeiro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      //_importanciaMesesBLoc.setJaneiroController.(value);
                      //   print(value);
                      _importanciaMesesBLoc.jan(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Fevereiro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.fev(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Março'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.mar(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Abril'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.abr(value);
                      // print(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Maio'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.mai(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Junho'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.jun(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Julho'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.jul(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Agosto'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.ago(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Setembro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.set(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Outubro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.out(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  padding: EdgeInsets.all(6),
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Novembro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.nov(value);
                    },
                  ),
                ),
                Container(
                  width: 150,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: 5,
                    decoration: const InputDecoration(labelText: 'Dezembro'),
                    incrementIcon: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    decrementIcon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                    onChanged: (value) {
                      _importanciaMesesBLoc.dez(value);
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      )),
    );
  }
}
