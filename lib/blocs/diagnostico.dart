

import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/classes/sqlite/importanciameses.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';


class DignosticoBloc extends BlocBase{
  var bd = DadosBasicosSqlite();
  var dadosBasicosBloc = DadosBasicosBloc();

  final _textDiagnosticoController = BehaviorSubject();
  Stream get textDiagnosticoController => _textDiagnosticoController.stream;

  var  qualTextoMostrar;
  //var _marInformada;
  var calc_qtd;
  var calc_fat;
  var calc_cf;
  var calc_cv;
  var calc_gi;
  var calc_gas;
  var calc_cpv;
  var calc_mar;


  var _fulano;
  var _A;
  var _B;
  var _C;
  var _D;
  var _E;
  var _F;
  var _G;
  var _H;
  var _I;
  var _J;
  var _K;
  var _L;
  var _M;
  var _N;
  var _O;

  var calculo_a;
  var calculo_b;
  var calculo_c;
  var calculo_d;
  var calculo_e;
  var calculo_f;
  var calculo_g;


  var  _text_1;
  var  _text_2;
  var _text_3;
  var  _text_4;
  var _text_5;



  DignosticoBloc(){
    _fulanoLogado();
  }
  NumberFormat formatterMoeda = NumberFormat("0.00");
  _fulanoLogado()async{
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      var email = user!.email;
      if (user == null) {
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            //  print(documentSnapshot.data());
            Map<String, dynamic> data =  documentSnapshot.data()! as Map<String, dynamic>;
            _fulano = data['nome'];
            _getDadosBasicos();

          }
        });
      }
    });
  }
  _montaTexto(qualTextoMostrar){
    _text_1 = "${_fulano} as informações relativas ao mês de ${_A} indicam que o seu negócio apresentou lucro de ${_B}%. "
        "O ticket médio foi de R\$ ${_C} . Margem de contribuição R\$ ${_D}. Para começar a ter lucro foi preciso vender R\$ ${_E}, "
        "o que representa ${_F}% do total faturado no mês. A produtividade foi de R\$ ${_G} de faturamento para cada R\$1,00 de custo fixo.";

    _text_2 = "O fato é que o resultado não é aquele que você gostaria. Então, ${_fulano}, "
        "use o SIMULADOR para ver o que pode ser feito! Com a ajuda da CALCULADORA DE PREÇOS verifique (pelo menos), "
        "a margem dos seus produtos que mais vendem. Com um aumento de xx% na produtividade você alcançaria os xx% que considera ideal!";

    _text_3 = "Parabéns ${_fulano}! Você certamente está satisfeito com a lucratividade do negócio. Mesmo assim dê uma analisada com a ajuda do SIMULADOR para ver se poderia ser ainda melhor.";

     _text_4 = "Sua previsão de vendas para o corrente mês indica que possivelmente ele se encerrará com lucro/prejuízo(J) de % (K) e em xxxxxx (L), com resultado positivo/negativo (M) de(N)%.";

    _text_5 = "${_fulano} as informações relativas ao mês de ${_A} indicam que o seu negócio apresentou prejuízo de ${_O}%. Esta é uma situação que requer providências imediatas. ";

   print(_text_1);
    print(_text_2);
    print(_text_3);
    print(_text_4);
    print(_text_5);
  //  _textDiagnosticoController.add( _text_1);
  }
  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print(element);
        _A = element['mes'];
        calculo_a = element['mes'];
        _H = element['margen'];
        _convertFoat(element);
      });
    });
  }
  _lucroOuPrejuiso(){

    _consultarMeses();
   // _montaTexto(qualTextoMostrar);
  }
  _consultarMeses() async {

    var bd = InportanciasMeses();
    await bd.lista().then((data) {
      data.forEach((element) {
          print(element);
         // jan: 9, fev: 8, mar: 5, abr: 4, mai: 4, jun: 6, jul: 7, ago: 3, setb: 3, out: 4, nov: 6, dez: 7
        

      });

    });

  }
  _calculoG(){
     calculo_g = calc_fat/calc_cf;
    _G = formatterMoeda.format(calculo_g);
     _lucroOuPrejuiso();
  }
  _calculoF(){
    calculo_f = calculo_e/calc_fat;
    _F = calculo_f.toStringAsPrecision(2);
    _calculoG();
  }
  _calculoPontoEquilibrio() {
    calculo_e = (calc_cv / calculo_d) * calculo_c;
    _E = formatterMoeda.format(calculo_e);
    _calculoF();
  }
  _calculoMargemConribuicao() {
    calculo_d =(calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _D = formatterMoeda.format(calculo_d);
    _calculoPontoEquilibrio();
  }
  _calculoTiketMedio() {
     calculo_c = calc_fat / calc_qtd ;
    _C =  formatterMoeda.format(calculo_c);
     _calculoMargemConribuicao();
  }
  _calculoMargemResultante() {
     calculo_b =(((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) * 100);
    _B = calculo_b.toStringAsPrecision(2);
     _O =_B;
     _calculoTiketMedio();
  }
  _convertFoat(element) {
    var faturamento = (element['faturamento']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var custo_fixo = (element['custo_fixo']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var custo_varivel = (element['custo_varivel']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var gastos_insumos = (element['gastos_insumos']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var gastos = (element['gastos']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var qtd = (element['qtd']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    calc_qtd = double.parse(qtd).truncateToDouble();
    calc_fat = double.parse(faturamento).truncateToDouble();
    calc_cf = double.parse(custo_fixo).truncateToDouble();
    calc_cv = double.parse(custo_varivel).truncateToDouble();
    calc_gi = double.parse(gastos_insumos).truncateToDouble();
    calc_gas = double.parse(gastos).truncateToDouble();

    _calculoMargemResultante();
  }


}