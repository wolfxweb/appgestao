import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class MsgDia extends StatefulWidget {
  const MsgDia({Key? key}) : super(key: key);

  @override
  State<MsgDia> createState() => _MsgDiaState();
}

class _MsgDiaState extends State<MsgDia> {
  String msgDodia = '';
  String msgDodiaSub = '';
  String msgDodiaInfo = '';
  final stilo = const TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    _diasemana();
    return Column(
      children: [
        Text(
          msgDodia,
          style: stilo,
          textAlign: TextAlign.justify,
          softWrap: true,
        ),
        Text(
          msgDodiaSub,
          style: stilo,
          textAlign: TextAlign.justify,
          softWrap: true,
        ),
        Text(
          msgDodiaInfo,
          style: stilo,
          textAlign: TextAlign.justify,
          softWrap: true,
        ),
      ],
    );
  }

  _diasemana() async {
    final dia = DateTime.now().day;
    final mes = DateTime.now().month;
    final ano = DateTime.now().year;
    int qtdDiasUteis = 0;
    for (var i = 1; i <= dia; i++) {
      final diaUtil = DateTime(ano, mes, i).getWeekday;
      if (diaUtil == 6 ) {
        qtdDiasUteis = 30;
        continue;
      } else if(diaUtil == 7){
        qtdDiasUteis = 31;
        continue;
      }else{
        qtdDiasUteis++;
      }
    }
    //print(dia);
    //print(mes);
  //  print(ano);
    print(qtdDiasUteis);

    switch (qtdDiasUteis) {
      case 1:
        msgDodia =
            "Primeiro dia do mês! Que não lhe falte o bom ânimo, equilíbrio e entusiasmo para superar os desafios, tomar algumas decisões ousadas e ter sucesso!";
        msgDodiaSub =
            "O tempo não para, e o mercado também não! Bem informado, experiente, decidido e sempre disposto a aprender, você alcançará suas metas!";
        msgDodiaInfo = "";
        break;
      case 2:
        msgDodia =
            "Fluxo de Caixa: ferramenta fundamental para aferir a saúde financeira e definir providências vitais para a empresa. O seu acompanhamento deve ser diário. ";
        msgDodiaSub =
            "Com a prática, não demora mais do que o primeiro cafezinho do dia.";
        msgDodiaInfo = "";
        break;
      case 3:
        msgDodia =
            "Já providenciou o envio para a contabilidade das informações do mês passado? ...Peça que lhe mandem os DADOS BÁSICOS para que você possa atualizar este Aplicativo. ";
        msgDodiaSub =
            "Aliás, a qualidade destas informações será responsável por sua utilidade.";
        msgDodiaInfo = "";
        break;
      case 4:
        msgDodia =
            "Dizem que fazer caminhadas é bom para a saúde. Para os negócios também! ";
        msgDodiaSub =
            "Então, que tal fazer um giro rápido pela empresa? ...Temperatura ambiente, iluminação, ordem, limpeza. Providências? Até quando? Quem? ...Anote na agenda do celular.";
        msgDodiaInfo = "";
        break;
      case 5:
        msgDodia =
            "Assim como os veículos têm um painel de instrumentos, os negócios, também: fluxo de caixa, controle das vendas, dos estoques, da produtividade, da produção e das entregas, dos desperdícios, perdas e desvios, preços, lucratividade.";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 6:
        msgDodia =
            "Você já lançou as informações do mês passado em DADOS BÁSICOS?  ";
        msgDodiaSub =
            "A qualidade dessas informações é o que garante sua utilidade!";
        msgDodiaInfo =
            "Veja o DIAGNÓSTICO, e tire suas conclusões pensando no que poderá fazer este mês para melhorar o resultado. O SIMULADOR também vai te ajudar! Providências? ...Anote na agenda do celular.";
        break;
      case 7:
        msgDodia =
            "Na hora de decidir prioridades é importante distinguir entre o que é realmente importante e o que é apenas impressionante.";
        msgDodiaSub =
            "Fazer primeiro o que contribuirá para que outras ações sejam concluídas. Estabelecer prazos e quem faz o que. Providências?";
        msgDodiaInfo = "... Anote na agenda do celular.";
        break;
      case 8:
        msgDodia =
            "O ideal é conseguir aumentar o valor do 'tiket' médio estimulando a compra de maiores quantidades ou de itens adicionais, por cliente.";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 9:
        msgDodia =
            "Considerando que suas despesas e custos não são sempre os mesmos, vale a pena usar a CALCULADORA DE PREÇOS para analisar como está a lucratividade dos itens que comercializa, principalmente aqueles cujas vendas representam a maior parte do seu faturamento.";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 10:
        msgDodia =
            "Você mantém em oferta produto pouco rentável porque é importante para a venda de outros? ";
        msgDodiaSub =
            "Com a CALCULADORA DE PREÇOS análise o lucro que no conjunto proporcionam.";
        msgDodiaInfo =
            "Estime um volume de vendas e o ticket médio deste conjunto; lance no SIMULADOR para definir providências... vender mais? Estude a VIABILIDADE DE AÇÃO PROMOCIONAL.";
        break;
      case 11:
        msgDodia =
            "Quando você oferece descontos 'impressionantes', desaponta quem comprou com o preço normal e desvaloriza os produtos. ";
        msgDodiaSub =
            "Já ouviu falar de 'cashback'? ...O cliente compra e você devolve parte do valor pago.";
        msgDodiaInfo = "";
        break;
      case 12:
        msgDodia =
            "Pesquise: você tem algum amigo que se enquadre no perfil do seu público-alvo? Peça para ele opinar sobre seu produto com menor venda. Por que ele acha que vende pouco? ";
        msgDodiaSub =
            "Com a ajuda da CALCULADORA DE PREÇO, veja a rentabilidade.";
        msgDodiaInfo =
            " Converse com seu pessoal que tem contato direto com os clientes: vale a pena mantê-lo em oferta?";
        break;
      case 13:
        msgDodia =
            "Como está o desempenho do mês? As vendas estão dentro do previsto? O ticket médio também? E os custos? ";
        msgDodiaSub =
            "Use o SIMULADOR, a CALCULADORA DE PREÇOS e a VIABILIDADE DE AÇÃO PROMOCIONAL. ";
        msgDodiaInfo = "Providências... Anote na agenda do celular.";
        break;
      case 14:
        msgDodia =
            "Rotina saudável para o negócio: iniciar o dia examinando sua agenda; o fluxo de caixa e a conciliação bancária; o comportamento das vendas; desempenho da produção; programação de entregas; recebimento das compras; disponibilidades e giro dos estoques.";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 15:
        msgDodia =
            "Assim como os comandantes usam um 'checklist' antes de levantar voo, cada atividade principal da empresa deve ter seu checklist para assegurar que todos os procedimentos de rotinas necessárias sejam observados.";
        msgDodiaSub = "Pode crer, ajuda muito!";
        msgDodiaInfo = "";
        break;
      case 16:
        msgDodia =
            "Produtividade é o que justifica seus investimentos, despesas e custos fixos.";
        msgDodiaSub =
            "É consequência de ambientes adequados, layouts inteligentes, mão-de-obra qualificada e motivada, disciplina, ordem, rotinas práticas, controles, equipamentos adequados, manutenção preventiva e estoques bem administrados.";
        msgDodiaInfo = "";
        break;
      case 17:
        msgDodia =
            "Um tipo de praga que ataca o lucro da empresa é a ociosidade, ou seja: tudo que custa e não produz o que poderia (salas fechadas, pessoal e equipamentos subutilizados). ";
        msgDodiaSub = "Ou você aumenta sua utilização ou se desfaz.";
        msgDodiaInfo = "";
        break;
      case 18:
        msgDodia =
            "Já está preparado para o próximo mês? Dê uma lida em DIAGNÓSTICO e use o SIMULADOR para antever prioridades. ";
        msgDodiaSub =
            "Se for o caso, analise a VIABILIDADE DE AÇÃO PROMOCIONAL.";
        msgDodiaInfo = "";
        break;
      case 19:
        msgDodia =
            "Desperdício: torneira vazando, lâmpada acesa, ar condicionado funcionando sem necessidade, etc.";
        msgDodiaSub =
            "Ele é consequência de atitudes humanas, tais como: displicência, desordem, falta de ficha técnica, compras mal feitas, estoques mal armazenados e controlados, consumo exagerado.";
        msgDodiaInfo = "";
        break;
      case 20:
        msgDodia =
            "Você pode diminuir a necessidade de capital de giro se conseguir fornecedores que reduzam sua necessidade de estoques e cujos prazos para pagamento sejam compatíveis com o tempo que decorre entre a entrada das mercadorias e o recebimento de suas vendas.";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 21:
        msgDodia =
            "Pense no relacionamento com seu público-alvo, clientes, fornecedores, prestadores de serviços.";
        msgDodiaSub =
            "Na Internet existem várias ferramentas (CRM) gratuitas que podem ajudar.";
        msgDodiaInfo = "";
        break;
      case 22:
        msgDodia =
            "Se procurarmos na Internet pelos produtos que você vende, encontraremos sua empresa?";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 30:
        msgDodia ="Bom fim de sabado!";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
      case 31:
        msgDodia = "Bom dominigo";
        msgDodiaSub = "";
        msgDodiaInfo = "";
        break;
    }
  }
}
