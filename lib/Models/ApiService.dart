import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/CardPlastics.dart';
import 'package:online_banking_system/Models/ClientContract.dart';
import 'package:online_banking_system/Models/SearchManagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
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




  Future<List<AccountContract>> fetchAccountContracts(String contractId) async {
    final url = Uri.parse("$kBaseUrl/api/account-contracts/$contractId");

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
    print("Transaction response: ${response.body}");

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




  Future<http.Response> updateCardStatus(String contractId, {required String clientId, required String statusCode, required String reason}) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId/status");
    final requestData = {"reason": reason, "statusCode": statusCode ,"clientId":clientId};

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
    final url = Uri.parse("$kBaseUrl/account_contracts_id/createAccountContract");

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


  Future<String> fetchClientContract(String Email) async {
    final url = Uri.parse("$kBaseUrl/clients/contract-id?email=$Email");

    print("Fetching data: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      return response.body;

    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load client contract');
    }
  }

  Future<int?> getClientId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? clientId = prefs.getInt('clientId');

      if (clientId == null) {
        print("Client ID not found in SharedPreferences.");
      } else {
        print("Retrieved Client ID: $clientId");
      }

      return clientId;
    } catch (e) {
      print("Error retrieving client ID: $e");
      return null;
    }
  }




  Future<List<CardContract>> fetchClientCards(int clientId) async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/clients/$clientId/card-contracts'),
        headers: {"Content-Type": "application/json"},
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String,dynamic> jsonData = json.decode(response.body);

        // Extract the "clientCardContracts" list
        List<dynamic> cardsList = jsonData["clientCardContracts"] ?? [];

        // Convert to List<CardContract>
        List<CardContract> cards = cardsList.map((data) => CardContract.fromJson(data)).toList();

        // Ensure API returns expected data
        if (cards.isEmpty) {
          throw Exception("No cards found for the given client ID.");
        }

        return cards;
      } else {
        throw Exception(
            "Failed to fetch cards: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception in fetchClientCards: $e");
      throw Exception("Error fetching cards: $e");
    }
  }

  Future<List<AccountContract>> fetchClientAccounts(int clientId) async {
    try {
      final response = await http.get(
        Uri.parse('$kBaseUrl/clients/$clientId/account-contracts'),
        headers: {"Content-Type": "application/json"},
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String,dynamic> jsonData = json.decode(response.body);

        // Extract the "clientAccountContracts" list
        List<dynamic> accountlist = jsonData["clientAccountContracts"] ?? [];

        // Convert to List<AccountContract>
        List<AccountContract> account = accountlist.map((data) => AccountContract.fromJson(data)).toList();

        // Ensure API returns expected data
        if (account.isEmpty) {
          throw Exception("No account found for the given client ID.");
        }

        return account;
      } else {
        throw Exception(
            "Failed to fetch account: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception in fetchClientAccounts: $e");
      throw Exception("Error fetching Accounts: $e");
    }
  }

  Future<Map<String, dynamic>> fetchClientData(String clientId) async {
    final url = Uri.parse("$kBaseUrl/clients/$clientId");

    print("Fetching data: GET $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      print("Client data response: ${response.body}");
      return json.decode(response.body); // Convert response body to a Map

    } else {
      print("\n--- ERROR (GET) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to load client data');
    }
  }

  double getAccountBalance(String clientId, String account) {
    return 5000.00; // Placeholder logic
  }

  double getCardBalance(String clientId, String card) {
    return 1000.00; // Placeholder logic
  }
}













