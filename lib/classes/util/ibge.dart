



import 'package:appgestao/classes/model/estado.dart';
import 'package:dio/dio.dart';


class ibge{


 Future<List<estado>> getEstados()async{
     const url ="https://servicodados.ibge.gov.br/api/v1/localidades/estados";
      try{
        final response = await Dio().get<List>(url);

        final listaEstados = response.data!.map<estado>((e) => estado.fromJson(e)).toList();

        return listaEstados;
      }on DioExceptionType{
         return Future.error("Nã foi possivel obter os estados, verifique se esta conectado a internete.");
      }

  }

  getCidades(){

  }



}