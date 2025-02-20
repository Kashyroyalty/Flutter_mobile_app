import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import '../Constants/Strings.dart';
import 'AccountContract.dart';
import 'TransactionContract.dart';

class ApiService {

  Future<CardContract> fetchCardContract(String contractId) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId");

    print("Fetching data: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return CardContract.fromJson(jsonDecode(response.body));
    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load card contract');
    }
  }



  Future<AccountContract> fetchAccountContract(String contractId) async {
    final url = Uri.parse("$kBaseUrl/api/account-contracts/$contractId");

    print("Fetching data: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AccountContract.fromJson(jsonDecode(response.body));
    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load account contract');
    }
  }


  Future<TransactionContract> fetchTransactionContract(String contractId) async {
    final url = Uri.parse("$kBaseUrl/transaction/$contractId");

    print("Fetching data: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return TransactionContract.fromJson(jsonDecode(response.body));
    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load account contract');
    }
  }



  Future<http.Response> updateCardStatus(String contractId, String statusCode, String reason) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId/status");
    final requestData = {"reason": reason, "statusCode": statusCode};

    print("\n--- Updating Card Status ---");
    print("Request: PUT $url");
    print("Request Body: ${jsonEncode(requestData)}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    print("Response: ${response.statusCode} - ${response.body}");
    print("-----------------------------\n");

    return response;
  }




  Future<http.Response> updateCardPinAttempts(String contractId) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId/online-pin-attempts-counter");
    final requestData = {"cleared": "true"};

    print("\n--- Clearing PIN Attempts ---");
    print("Request: PUT $url");
    print("Request Body: ${jsonEncode(requestData)}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    print("Response: ${response.statusCode} - ${response.body}");
    print("------------------------------\n");

    return response;
  }



  Future<http.Response> createCardContract(Map<String, String> contractData) async {
    final url = Uri.parse("$kBaseUrl/cards/createCardContract");

    print("\n--- Creating Card Contract ---");
    print("Request: POST $url");
    print("Request Body: ${jsonEncode(contractData)}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(contractData),
    );

    print("\n--- POST Response ---");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("----------------------\n");

    return response;
  }

}

