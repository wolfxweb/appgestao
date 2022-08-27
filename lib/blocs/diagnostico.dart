import 'dart:ffi';

import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/classes/sqlite/importanciameses.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class DignosticoBloc extends BlocBase {
  var bd = DadosBasicosSqlite();
  var bdi = InportanciasMeses();
  var dadosBasicosBloc = DadosBasicosBloc();

  final _textDiagnosticoController = BehaviorSubject();
  final _textPrejuisoController = BehaviorSubject();
  final _textLucro_1_Controller = BehaviorSubject();
  final _textLucro_2_Controller = BehaviorSubject();
  final _textLucro_3_Controller = BehaviorSubject();

  Stream get textDiagnosticoController => _textDiagnosticoController.stream;
  Stream get textPrejuisoController => _textPrejuisoController.stream;
  Stream get textLucro_1_Controller => _textLucro_1_Controller.stream;
  Stream get textLucro_2_Controller => _textLucro_2_Controller.stream;
  Stream get textLucro_3_Controller => _textLucro_3_Controller.stream;

  var qualTextoMostrar;
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
  var calculo_k;

  var _text_1;
  var _text_2;
  var _text_3;
  var _text_4;
  var _text_5;
  var _text_6;
  var _text_strean;
  //info inportancia dos meses
  var _jan;
  var _fev;
  var _mar;
  var _abr;
  var _mai;
  var _jun;
  var _jul;
  var _ago;
  var _set;
  var _out;
  var _nov;
  var _dez;
  var _totalMeses = 0;

  DignosticoBloc() {
    _textPrejuisoController.add('');
    _textDiagnosticoController.add('');
    _fulanoLogado();
  }
  NumberFormat formatterMoeda = NumberFormat("0.00");
  _fulanoLogado() async {
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
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            _fulano = data['nome'];
            _getDadosBasicos();
          }
        });
      }
    });
  }

  _montaTexto(qualTextoMostrar) {
    _text_1 =
        "${_fulano} as informações relativas ao mês de ${_A} indicam que o seu negócio apresentou lucro de ${_B}%. "
        "O ticket médio foi de R\$ ${_C} . Margem de contribuição R\$ ${_D}. Para começar a ter lucro foi preciso vender R\$ ${_E}, "
        "o que representa ${_F}% do total faturado no mês. A produtividade foi de R\$ ${_G} de faturamento para cada R\$1,00 de custo fixo.";

    _text_2 =
        "O fato é que o resultado não é aquele que você gostaria. Então, ${_fulano}, "
        "use o SIMULADOR para ver o que pode ser feito! Com a ajuda da CALCULADORA DE PREÇOS verifique (pelo menos), "
        "a margem dos seus produtos que mais vendem. Com um aumento de xx% na produtividade você alcançaria os xx% que considera ideal!";

    _text_3 = "Parabéns ${_fulano}! Você certamente está satisfeito com a lucratividade do negócio. Mesmo assim dê uma analisada com a ajuda do SIMULADOR para ver se poderia ser ainda melhor.";

    _text_4 = "Sua previsão de vendas para o corrente mês indica que possivelmente ele se encerrará com ${_J} de   ${_K} % e em ${_L}, com resultado ${_M} de ${_N}%.";

    _text_5 = "${_fulano} as informações relativas ao mês de ${_A} indicam que o seu negócio apresentou prejuízo de ${_O}%. "
               "Esta é uma situação que requer providências imediatas. ";

    _text_6 = "1. Verifique se os DADOS BÁSICOS informados estão corretos"
              "2. Analise, no SIMULADOR, as providências prioritárias para sair do prejuízo."
              "3. Com a CALCULADORA DE PREÇOS verifique a margem de cada produto. Se você concluir que precisa vender mais, ou descontinuar algum produto, estude a VIABILIDADE DE PROMOÇÃO & PROPAGANDA"
              "4. Avalie como está sua disponibilidade de CAPITAL DE GIRO.  Se for o caso, consulte o CHECKLIST 'O que fazer para diminuir a necessidade de capital de giro!'";

    var _b = double.parse(_B).truncateToDouble();
    var _h = double.parse(_H).truncateToDouble();

    if (_b > 0.0) {
      if (_b < _h) {
       // print(_b);
    //    print(_h);
        _textDiagnosticoController.add("Lucro");
        _textLucro_1_Controller.add(_text_1);
        _textLucro_2_Controller.add(_text_2);
        _textLucro_3_Controller.add(_text_4);

      } else if (_b > _h) {
       // print(_b);
     //   print(_h);
        _textDiagnosticoController.add("Lucro");
        _textLucro_1_Controller.add(_text_1);
        _textLucro_2_Controller.add(_text_3);
        _textLucro_3_Controller.add(_text_4);
      }
    } else if (_b < 0.0) {
      _textPrejuisoController.add(_text_5);
      _textDiagnosticoController.add("prejuízo");
    }
  }

  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
      //  print(element);
        _A = element['mes'];
        calculo_a = element['mes'];
        _H = (element['margen'].toString().replaceAll("%", ""));
        _convertFoat(element);
      });
    });
  }

  _lucroOuPrejuiso() {
    var _b = double.parse(_B).truncateToDouble();
    if (_b > 0.0) {
      _J = "lucro";
    } else {
      _J = "prejuízo";
    }
    _consultarMeses();
  }

  _consultarMeses() async {
    await bdi.lista().then((data) {
     // print(data);
      data.forEach((element) {
        //    print(element);
        _jan = (element['jan'] * 100) / element['total'];
        _fev = (element['fev'] * 100) / element['total'];
        _mar = (element['mar'] * 100) / element['total'];
        _abr = (element['abr'] * 100) / element['total'];
        _mai = (element['mai'] * 100) / element['total'];
        _jun = (element['jun'] * 100) / element['total'];
        _jul = (element['jul'] * 100) / element['total'];
        _ago = (element['ago'] * 100) / element['total'];
      //  _set = (element['setb']*100)/element['total'];
        _out = (element['out'] * 100) / element['total'];
        _nov = (element['nov'] * 100) / element['total'];
        _dez = (element['dez'] * 100) / element['total'];
//print(_A);

        switch (_A) {
          case 'Janeiro':
            // do something
            break;
          case 'Fevereiro':
            // do something else
            break;
          case 'Março':
            // do something
            break;
          case 'Abril':
            // do something else
            break;
          case 'Maio':
            // do something
            break;
          case 'Junho':
            var junho =  _calculoK(_jun, _jul);
            var calculo_n =_calculoK(_jun, _ago);
            _K = formatterMoeda.format(junho*100);
            _N = formatterMoeda.format(calculo_n*100);
            _L = "Agosto";
            _calculoM( calculo_n );

            break;
          case 'Julho':
            var Julho =  _calculoK(_jul, _ago);
           // var calculo_n =_calculoK(_jul, _setb);
            _K = formatterMoeda.format(Julho*100);
         //   print(_K);
            break;
          case 'Agosto':
            // do something else
            break;
          case 'Setembro':
            // do something
            break;
          case 'Outubro':
            // do something else
            break;
          case 'Novembro':
            // do something
            break;
          case 'Dezembro':
            // do something else
            break;
        }
      });
    });

    //
  }

  _calculoM( _n){
    if(_n > 0.0){
      _M ="lucro";
    }else{
      _M = "prejuízo";
    }
    _montaTexto(qualTextoMostrar);
  }
  // mesInicial = _jun;
  // mesProximo = _jul;
  _calculoK(mesInicial, mesProximo) {
    calculo_k = ((((mesProximo * calc_qtd) / mesInicial) * calculo_c) -((((calc_gi + calc_gas + calc_cf) / calc_fat) * (((mesProximo * calc_qtd) / mesInicial) * calculo_c)) +calc_cv)) /(((mesProximo * calc_qtd) / mesInicial) * calculo_c);
    return calculo_k;
  }
  _calculoG() {
    calculo_g = calc_fat / calc_cf;
    _G = formatterMoeda.format(calculo_g);
    _lucroOuPrejuiso();
  }
  _calculoF() {
    calculo_f = calculo_e / calc_fat;
    _F = calculo_f.toStringAsPrecision(2);
    _calculoG();
  }
  _calculoPontoEquilibrio() {
    calculo_e = (calc_cv / calculo_d) * calculo_c;
    _E = formatterMoeda.format(calculo_e);
    _calculoF();
  }
  _calculoMargemConribuicao() {
    calculo_d = (calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _D = formatterMoeda.format(calculo_d);
    _calculoPontoEquilibrio();
  }
  _calculoTiketMedio() {
    calculo_c = calc_fat / calc_qtd;
    _C = formatterMoeda.format(calculo_c);
    _calculoMargemConribuicao();
  }
  _calculoMargemResultante() {
    calculo_b =
        (((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) *
            100);
    _B = calculo_b.toStringAsPrecision(2);
    _O = _B;
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
