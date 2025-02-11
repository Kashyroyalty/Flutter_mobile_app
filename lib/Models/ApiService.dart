import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import '../Constants/Strings.dart';


class ApiService {

  Future<CardContract> fetchCardContract(String contractId) async{
    final response = await http.get(Uri.parse("$kBaseUrl/cards/$contractId"));

    if(response.statusCode == 200){
      // print(response.body);
      return CardContract.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load card contract');
    }
  }
}
