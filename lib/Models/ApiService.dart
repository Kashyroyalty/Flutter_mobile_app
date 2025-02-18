import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import '../Constants/Strings.dart';

class ApiService {
  // Fetch Card Contract (GET) - Fetches data, only logs errors
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

  // Update Card Status (PUT) - Logs request & response clearly
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

  // Clear Card PIN Attempts (PUT) - Logs request & response clearly
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

  // Create a new Card Contract (POST) - Logs response in structured format
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
