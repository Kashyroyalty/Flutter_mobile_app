import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/CardPlastics.dart';
import '../Constants/Strings.dart';
import 'AccountContract.dart';
import 'NotificationContract.dart';
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

  Future<List<AccountContract>> fetchAccountContracts([String? s]) async {
    final url = Uri.parse("$kBaseUrl/api/account-contracts");

    print("API Response: ${url.toString()}");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => AccountContract.fromJson(item)).toList();
    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: \${response.statusCode}");
      print("Error Response: \${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load account contracts');
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


  Future<List<NotificationContract>> fetchNotificationContracts(String clientId) async {
    final endpoints = [
      "status_notification",
      "overlimit_notification",
      "declined_notification",
      "card_activation_notification",
      "auth_notification"
    ];

    List<NotificationContract> notifications = [];

    for (var endpoint in endpoints) {
      final url = Uri.parse("$kBaseUrl/api/$clientId/$endpoint");
      print("Fetching data: GET $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        notifications.add(NotificationContract.fromJson(jsonDecode(response.body)));
      } else {
        print("\n--- Response (GET) ---");
        print("Status Code: \${response.statusCode}");
        print('Response Headers: ${response.headers}');
        print("Error Response: \${response.body}");
        print("---------------------\n");
        throw Exception('Failed to load notification contract for $endpoint');
      }
    }

    return notifications;
  }


  Future<List<CardPlastics>> fetchCardPlastics(String cardContractId) async {
    final endpoints = [
      "get_card_plastics",
      "reissue_card",
      "get_pin",
      "get_card_verification_code",
      "decrypt_get_card_verification_code"
    ];

    List<CardPlastics> cardplastics = [];

    for (var endpoint in endpoints) {
      final url = Uri.parse("$kBaseUrl/api/cards/$cardContractId/$endpoint");
      print("Fetching data: GET $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        cardplastics.add(CardPlastics.fromJson(jsonDecode(response.body)));
      } else {
        print("\n--- Response (GET) ---");
        print("Status Code: \${response.statusCode}");
        print('Response Headers: ${response.headers}');
        print("Error Response: \${response.body}");
        print("---------------------\n");
        throw Exception('Failed to load notification contract for $endpoint');
      }
    }

    return cardplastics;
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

  Future<http.Response> resetCardPin(String contractId) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId/reset-pin");
    final requestData = {"reset": "true"};

    print("\n--- Resetting Card PIN ---");
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

  Future<http.Response> createCardContract(Map<String, String> cardData) async {
    final url = Uri.parse("$kBaseUrl/cards/createCardContract");

    print("\n--- Creating Card Contract ---");
    print("Request: POST $url");
    print("Request Body: ${jsonEncode(cardData)}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cardData),
    );

    print("\n--- POST Response ---");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("----------------------\n");

    return response;
  }

  Future<http.Response> createAccountContract({required Map<String, dynamic> accountData}) async {
    final url = Uri.parse("$kBaseUrl/account-contracts/createAccountContract");

    print("\n--- Creating Account Contract ---");
    print("Request: POST $url");
    print("Request Body: ${jsonEncode(accountData)}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(accountData),
    );

    print("\n--- POST Response ---");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("----------------------\n");

    return response;
  }


  Future<http.Response> activateCard(String contractId) async {
    final url = Uri.parse("$kBaseUrl/api/cards/$contractId/active");
    final requestData = {"activated": "true"};

    final response = await http.put(url,headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),);

    print("Response: ${response.statusCode} - ${response.body}");
    print("------------------------------\n");

    return response;
  }

}



