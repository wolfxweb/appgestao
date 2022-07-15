import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/componete/espasamento.dart';

import 'package:appgestao/componete/headerAppBar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../componete/menu.dart';

class InportanciaMeses extends StatefulWidget {
  const InportanciaMeses({Key? key}) : super(key: key);

  @override
  State<InportanciaMeses> createState() => _InportanciaMesesState();
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _InportanciaMesesState extends State<InportanciaMeses> {
  late ImportanciaMesesBLoc _importanciaMesesBLoc;
  late final CrosshairBehavior _crosshairBehavior;
  void initState() {
    _importanciaMesesBLoc = ImportanciaMesesBLoc();
    _crosshairBehavior = CrosshairBehavior(enable: false);
  }

  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Importância dos meses'),
      drawer: Menu(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Espacamento(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: const Text("Selecione a importancia dos meses")
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.orange, // background
                    ),
                    child: const Text('Atualizar'),
                    onPressed:(){
                      _importanciaMesesBLoc.adicionarImportanciaMeses(context);

                    },
                  ),

                ),
              ],
            ),
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
            Container(
              height: 350,
              width: 300,
              child: StreamBuilder<List?>(
                  stream: _importanciaMesesBLoc.outValorMeses,
                  builder: (context, snapshot) {
                    List<_SalesData> data = [
                      _SalesData('Jan', snapshot.data?[1] ?? 5.0),
                      _SalesData('Feb', snapshot.data?[2] ?? 5.0),
                      _SalesData('Mar', snapshot.data?[3] ?? 5.0),
                      _SalesData('Abr', snapshot.data?[4] ?? 5.0),
                      _SalesData('Mai', snapshot.data?[5] ?? 5.0),
                      _SalesData('Jun', snapshot.data?[6] ?? 5.0),
                      _SalesData('Jul', snapshot.data?[7] ?? 5.0),
                      _SalesData('Ago', snapshot.data?[8] ?? 5.0),
                      _SalesData('Set', snapshot.data?[9] ?? 5.0),
                      _SalesData('Out', snapshot.data?[10] ?? 5.0),
                      _SalesData('Nov', snapshot.data?[11] ?? 5.0),
                      _SalesData('Dez', snapshot.data?[12] ?? 5.0),
                    ];
                    return Column(children: [
                      //Initialize the chart widget
                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(
                              text:'PARTICIPAÇÃO DOS MESES NO RESULTADO DO ANO'),
                          // Enable legend
                          legend: Legend(isVisible: false),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: false),
                          series: <ChartSeries<_SalesData, String>>[
                            LineSeries<_SalesData, String>(
                              color: Colors.orangeAccent,

                                dataSource: data,
                                xValueMapper: (_SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (_SalesData sales, _) =>
                                    sales.sales,
                                name: 'Meses',
                                // Enable data label
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: false))
                          ]),
                    ]);
                  }),

            ),

          ],
        ),
      )),
    );
  }
}
