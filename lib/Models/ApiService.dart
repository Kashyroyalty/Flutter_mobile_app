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
  Future<http.Response> updateCardStatus(String contractId,String statusCode, String reason) async{
    Map<String,String> requestData ={
      "reason": reason,
      "statusCode":statusCode
    };
    print(requestData);
    final response = await http.put(Uri.parse("$kBaseUrl/cards/$contractId/status"),
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode(requestData));
    print(response.body);
    return response;
  }

  Future<http.Response> updateCardPinAttempts(String contractId) async{
    Map<String,String> requestData = {
      "cleared": "true"
    };
    final response = await http.put(Uri.parse("$kBaseUrl/cards/$contractId/online-pin-attempts-counter"),
    headers: {"content-type": "application/json"},
      body: jsonEncode(requestData));
    print(response.body);
    return response;
  }
}
