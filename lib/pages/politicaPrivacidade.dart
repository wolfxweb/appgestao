import 'package:flutter/material.dart';
import 'package:appgestao/componete/headerAppBar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PoliticaPrivacidadeScreen(),
    );
  }
}

class PoliticaPrivacidadeScreen extends StatefulWidget {
  @override
  _PoliticaPrivacidadeScreenState createState() =>
      _PoliticaPrivacidadeScreenState();
}

class _PoliticaPrivacidadeScreenState extends State<PoliticaPrivacidadeScreen> {
  var header = HeaderAppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Política de Privacidade'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    _buildTextSpan(
                      '\nTERMO DE USO, PRIVACIDADE E OUTRAS AVENÇAS\n\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'MR Marketing de Resultado Ltda.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', CNPJ 59.391.516/0001-57, doravante denominada',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' “Administradora”',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ',proprietária do aplicativo',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up.app.br',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', doravante denominado',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' “Get Up”',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', desenvolveu esse documento que expõem os direitos, as obrigações, a política de privacidade e proteção dos dados de seus usuários e clientes, doravante denominados',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' “Usuário”',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', conforme as cláusulas seguintes:\n\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '1. DO APLICATIVO:\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '1.1 O',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' destina-se aos empreendedores e gestores dos ramos da indústria e do comércio.\n ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '1.2 O',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' não substitui sistemas e outros recursos utilizados para registrar, dar tratamento e produzir relatórios relacionados com a atividade da empresa.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n1.3 O',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      """ 
                      é um aplicativo que ajuda os gestores a entender, analisar, fazer simulações e tomar decisões, com base nos indicadores produzidos pelos sistemas que já utilizam e/ou projeções para efeito de planejamento e análises de viabilidade. Por tanto, deve ser entendido como uma ferramenta de consultoria, sem qualquer valor contábil.
                      """,
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '1.4 O',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      """ 
                      foi desenvolvido para uso em dispositivos móveis (telefones celulares), que utilizam a plataforma Android.
                      """,
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '1.5 O',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      """ 
                      independe da Internet para ser utilizado, exceto uma única vez: para baixar o aplicativo em seu celular. 
                      """,
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n2. DA PROTEÇÃO DOS DADOS DO USUÁRIO:',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n2.1 Para baixar o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  em seu celular, o',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '  Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  deverá preencher cadastro, com as seguintes informações:\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' \u2022  Endereço de E-mail',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  – para que o',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  recupere a senha de acesso ao aplicativo e receba eventuais atualizações do ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get up.\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' \u2022  Endereço de WhatsApp',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  – para que a Administradora possa reconhecer que se trata de um usuário, caso seja procurada, e para o envio de notificações “push”. ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n2.2 Muito embora o cadastro não contenha informações sensíveis ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '  (nome, razão social, números de identificação ou endereço, entre outros), a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      """, adotará todas as medidas necessárias para o adequado tratamento das informações requeridas, conforme disposto pela legislação vigente, notadamente a """,
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Lei Geral de Proteção de Dados - LGPD.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n2.3 No caso de promoções de fornecedores interessados em fazer uma oferta vantajosa para o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  quando e se ocorrerem, a',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  as enviará para o WhatsApp cadastrado, com um “link” para que o',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  acesse,',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' por sua iniciativa e se for de seu interesse',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', sempre permitindo que o',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' manifeste seu desejo de não receber mais essas informações.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n2.4 Como falar com a Administradora? ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Se o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' quiser apresentar comentários ou sugestões relacionadas a esta ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Política de Privacidade,',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  poderá entrar em contato através do endereço do WhatsApp ou de E-mail disponibilizados no próprio aplicativo.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n2.5 Mudanças na Política de Privacidade:\n ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' Considerando a busca permanente de aprimoramento do',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up, ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' enfatiza que essa Política de Privacidade pode passar por atualizações. Desta forma, recomenda ao ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' que visite periodicamente esta página para que tenha conhecimento sobre as modificações. Caso sejam feitas alterações relevantes que necessitem de novo consentimento do',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ', a',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' irá informa-lo e solicitar um novo consentimento.\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n3. DA LICENÇA DE USO: ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n3.1 O Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' declara-se ciente de que esta é uma licença limitada, não transferível, não exclusiva, livre de royalties e revogável, para baixar, instalar, executar e utilizar em seu dispositivo móvel.\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '3.2 O Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' reconhece e concorda que a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      " concede uma licença exclusiva para uso por ele",
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      " , e, desta forma, não lhe transfere os direitos sobre o",
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n3.3 O Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      " declara-se ciente de que não poderá:\n",
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' \u2022 Copiar nem modificar o',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ',  nenhuma de suas partes, nem suas marcas comerciais, de nenhuma maneira;',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' \n\u2022 Extrair o código-fonte do ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ',  realizar engenharia reversa, modificar, traduzir seu conteúdo para outros idiomas ou fazer versões derivadas.\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\u2022Distribuir, vender, transferir ou reclamar e alegar direitos sobre todas as marcas comerciais, direitos de autor, direitos a base de dados e outros direitos de propriedade intelectual relacionados com este, pertencentes a  ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n3.4 O Usuário desde já concorda com o direito da ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'de limitar total ou parcialmente o acesso de determinadas pessoas ao ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'sem a necessidade de apresentar uma justificativa.\n',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4. DA UTILIZAÇÃO:\n ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '4.1',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '  A atualidade e fidedignidade das informações que o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' USUÁRIO ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' venha a inserir no aplicativo são de sua única e inteira responsabilidade e serão a garantia da qualidade dos resultados que o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '  Get Up ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      " apresentar.",
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.2',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' A confidencialidade da senha de acesso é de inteira e única responsabilidade do  ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'USUÁRIO.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n4.3 A Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'fica isenta de reclamações de qualquer natureza na eventual divulgação, perda ou furto do que estiver contido no dispositivo em uso pelo ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário. ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n4.4',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Da mesma forma, por quaisquer consequências decorrentes de negligência, imprudência ou imperícia do ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário. ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n4.5 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Também não lhes caberá responsabilidade quanto as informações ou qualidade das estimativas que o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' venha a inserir no aplicativo.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.6 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Também, por recomendações e sugestões que o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' faça à terceiros com base no',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Get Up ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'as quais serão de sua única e exclusiva responsabilidade.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.7 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Tão pouco será a',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'responsável pela não disponibilidade no aplicativo de funcionalidades informadas por terceiros ao usuário, ou por ações maliciosas de terceiros, como ataques de “hackers”.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.8 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Este aplicativo estará em contínuo desenvolvimento e pode conter erros e, por isso, o uso é fornecido "no estado em que se encontra". Na extensão máxima permitida pela legislação aplicável, a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' e seus fornecedores isentam-se de quaisquer garantias e condições expressas ou implícitas incluindo, sem limitação, garantias de comercialização, adequação a um propósito específico, titularidade e não violação no que diz respeito ao aplicativo e qualquer um de seus componentes ou ainda à prestação ou não de serviços de suporte.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.9 A Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'não garante que a operação deste aplicativo seja contínua e sem defeitos.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.10 A Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'não garante, declara nem assegura que este aplicativo esteja livre de perda, interrupção, ataque, vírus, interferência, pirataria ou outra invasão de segurança a que o dispositivo do usuário esteja sujeito, e isenta-se de qualquer responsabilidade em relação à essas questões.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.11 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Em hipótese alguma a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' suas representadas, seus diretores, executivos, funcionários, afiliadas, agentes, contratados ou licenciadores responsabilizar-se-ão por perdas ou danos causados pelo mal uso do ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Get Up.',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n4.12 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'Objetivando garantir que o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Get Up ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' seja o mais útil e eficiente possível, a ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Administradora',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' se reserva o direito de realizar atualizações, sem aviso prévio nem limite, podendo inclusive habilitá-las para outros sistemas operativos. Para beneficiar-se, o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' deverá baixar as atualizações.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.13 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'O aqui disposto não se constitui em obrigatoriedade de atualizar o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Get UP',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' para que seja relevante para o ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      'Usuário',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' e /ou funcione com a versão do Android que tenha instalado em seu dispositivo.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n4.14 A Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'se reserva o direito de deixar de fornecer parte ou a totalidade de seus serviços em qualquer momento, sem notificar sua finalização, uma vez que isso não afetará a utilização de versão baixada pelo',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Usuário.\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n5. DISPOSIÇÕES GERAIS:\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'A',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Administradora ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' se reserva o direito de alterar este',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '  TERMO DE USO, PRIVACIDADE E OUTRAS AVENÇAS ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'a qualquer tempo para refletir alterações que venha a introduzir no aplicativo ',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '“Getup.app.br”',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      ' decorrentes de novas funcionalidades ou para atender aos avanços tecnológicos. Eventuais alterações entrarão em vigor a partir de sua publicação, e em hipótese nenhuma prejudicarão o uso da versão ora em seu poder.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n5.1 O Usuário ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'declara e garante, para todos os fins de direito e sob as penas da lei, ser maior de 18 anos e possuir capacidade jurídica para celebrar este CONTRATO.',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      '\n5.2 ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'A vigência deste CONTRATO é por prazo indeterminado, podendo ser encerrado pelas partes sem quaisquer ônus, multas ou contestações, uma vez que sua extinção não acarretará perdas para quaisquer das partes, e que, para todos os efeitos este fato não exime a administradora do cumprimento da',
                      FontWeight.normal,
                    ),
                    _buildTextSpan(
                      ' Lei Geral de Proteção de Dados - LGPD.\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\n6 DA ACEITAÇÃO:\n ',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      'O usuário afirma que analisou, entendeu e aceitou na íntegra este TERMO DE USO, PRIVACIDADE E OUTRAS AVENÇAS, e que o ato de baixar o Get Up em seu dispositivo móvel demonstra de forma inequívoca sua aceitação e concordância em relação ao mesmo.\n',
                      FontWeight.bold,
                    ),
                    _buildTextSpan(
                      '\nMR – Marketing de Resultado Ltda.\n ',
                      FontWeight.bold,
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildTextSpan(String texto, FontWeight fontWeight) {
    return TextSpan(
      text: texto,
      style: TextStyle(
        fontWeight: fontWeight, // Aplicando o parâmetro FontWeight
        fontSize: 16,
      ),
    );
  }

}
