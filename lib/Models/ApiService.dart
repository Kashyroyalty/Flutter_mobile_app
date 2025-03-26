import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/CardPlastics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/Strings.dart';
import 'AccountContract.dart';
import 'NotificationContract.dart';
import 'TransactionContract.dart';

class ApiService {


  Future<CardContract> fetchCardContract(String contractId) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId");
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("Fetching data: GET $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add Authorization header
      },
    );

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
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("API Response: ${url.toString()}");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add Authorization header
      },
    );

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


  Future<TransactionContract> fetchTransactionContract(
      String contractId) async {
    final url = Uri.parse("$kBaseUrl/transaction/$contractId");
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("Fetching data: GET $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add Authorization header
      },
    );

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


  Future<List<NotificationContract>> fetchNotificationContracts(
      String clientId) async {
    final endpoints = [
      "status_notification",
      "overlimit_notification",
      "declined_notification",
      "card_activation_notification",
      "auth_notification"
    ];

    final urlBase = "$kBaseUrl/api/$clientId/";
    final accessToken = await getAuthToken(); // Retrieve auth token

    if (accessToken.isEmpty) {
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("Fetching notifications for client: $clientId");

    // Create a list of futures to fetch all notifications in parallel
    List<Future<NotificationContract>> requests = endpoints.map((endpoint) async {
      final url = Uri.parse("$urlBase$endpoint");

      try {
        print("Requesting: GET $url");
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "AppToken $accessToken",
          },
        );

        if (response.statusCode == 200) {
          print("✅ Success: $endpoint");
          return NotificationContract.fromJson(jsonDecode(response.body));
        } else {
          print("❌ Error fetching $endpoint (Status: ${response.statusCode})");
          print("Response: ${response.body}");
          throw Exception("Failed to load notification contract for $endpoint");
        }
      } catch (e) {
        print("⚠️ Exception during request: $e");
        throw Exception("Error fetching data for $endpoint: $e");
      }
    }).toList();

    // Wait for all requests to complete
    try {
      return await Future.wait(requests);
    } catch (e) {
      print("🚨 Failed to fetch all notifications: $e");
      throw Exception("Some notifications could not be retrieved.");
    }
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
      final accessToken = await getAuthToken(); // Retrieve token
      print("Retrieved Token: $accessToken");

      if (accessToken.isEmpty) {
        print("Error: Missing  accessToken!");
        throw Exception("Authorization token not found. Please log in again.");
      }

      print("Fetching data: GET $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "AppToken $accessToken", // Add Authorization header
        },
      );

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


  Future<http.Response> updateCardStatus(String contractId,
      {required String clientId, required String statusCode, required String reason}) async {
    final url = Uri.parse("$kBaseUrl/cards/$contractId/status");
    final requestData = {
      "reason": reason,
      "statusCode": statusCode,
      "clientId": clientId
    };


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
    final url = Uri.parse(
        "$kBaseUrl/cards/$contractId/online-pin-attempts-counter");
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

  Future<http.Response> createAccountContract(
      {required Map<String, dynamic> accountData}) async {
    final url = Uri.parse(
        "$kBaseUrl/account_contracts_id/createAccountContract");

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


    final response = await http.put(
      url, headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),);

    print("Response: ${response.statusCode} - ${response.body}");
    print("------------------------------\n");

    return response;
  }


  Future<String> fetchClientContract(String Email) async {
    final url = Uri.parse("$kBaseUrl/clients/contract-id?email=$Email");
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("Fetching data: GET $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add Authorization header
      },
    );

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

  Future<Map<String, dynamic>?> fetchUserProfile(int clientId) async {
    final response = await http.get(
        Uri.parse("$kBaseUrl/clients/client_id/$clientId"));


    if (response.statusCode == 200) {
      print("API Response: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load profile');
    }
  }


  static Future<String> updateUserProfile(Int ClientId,
      Map<String, dynamic> updatedData) async {
    final url = Uri.parse("$kBaseUrl/clients/client_id/$ClientId");


    print("Updating data: PUT $url");
    print("Request Body: ${jsonEncode(updatedData)}");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      print("Update Successful: ${response.body}");
      return response.body;
    } else {
      print("\n--- ERROR (PUT) ---");
      print("Status Code: ${response.statusCode}");
      print("Error Response: ${response.body}");
      print("---------------------\n");
      throw Exception('Failed to update user profile');
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
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Extract the "clientCardContracts" list
        List<dynamic> cardsList = jsonData["clientCardContracts"] ?? [];

        // Convert to List<CardContract>
        List<CardContract> cards = cardsList.map((data) =>
            CardContract.fromJson(data)).toList();

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
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Extract the "clientAccountContracts" list
        List<dynamic> accountlist = jsonData["clientAccountContracts"] ?? [];

        // Convert to List<AccountContract>
        List<AccountContract> account = accountlist.map((data) =>
            AccountContract.fromJson(data)).toList();

        // Ensure API returns expected data
        if (account.isEmpty) {
          throw Exception("No account found for the given client ID.");
        }

        return account;
      } else {
        throw Exception(
            "Failed to fetch account: ${response.statusCode} - ${response
                .body}");
      }
    } catch (e) {
      print("Exception in fetchClientAccounts: $e");
      throw Exception("Error fetching Accounts: $e");
    }
  }

  Future<Map<String, dynamic>> fetchClientData(String clientId) async {
    final url = Uri.parse("$kBaseUrl/clients/$clientId");
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("Fetching data: GET $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add Authorization header
      },
    );

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

  Future<http.Response> updateCardContract(String contractId,
      Map<String, dynamic> updatedDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getString('client_id') ?? '';
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    if (clientId.isEmpty) {
      print('Client ID not found');
      return http.Response(
          'Client ID not found', 400); // Return a mock bad request response
    }

    final url = Uri.parse("$kBaseUrl/cards/card_contract_id/$contractId");
    final requestData = {
      'client_id': clientId,
      ...updatedDetails, // Merge other details
    };

    print("\n--- Updating Card Contract ---");
    print("Request: PUT $url");
    print("Request Body: ${jsonEncode(requestData)}");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "AppToken $accessToken",
      },
      body: jsonEncode(requestData),
    );

    print("Response: ${response.statusCode} - ${response.body}");
    print("------------------------------\n");

    return response;
  }


  Future<void> getCardContract() async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getString('client_id') ?? '';
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    if (clientId.isEmpty) {
      print('Client ID not found');
      return;
    }

    final response = await http.get(
      Uri.parse('https://api.example.com/card-contracts?client_id=$clientId'),
      headers: {
        "Authorization": "AppToken $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Card contract details: $data');
    } else {
      print('Failed to retrieve card contract: ${response.body}');
    }
  }

  Future<void> getTransactions(String contractId) async {
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    final response = await http.get(
      Uri.parse('https://api.example.com/transactions?contract_id=$contractId'),
      headers: {
        "Authorization": "AppToken $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Transactions: $data');
    } else {
      print('Failed to fetch transactions: ${response.body}');
    }
  }

  Future<void> getCardUsageLimit(String contractId) async {
    final accessToken = await getAuthToken(); // Retrieve token
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    final response = await http.get(
      Uri.parse('https://api.example.com/card-contracts/$contractId/limits'),
      headers: {
        "Authorization": "AppToken $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Card Usage Limits: $data');
    } else {
      print('Failed to fetch card usage limits: ${response.body}');
    }
  }

  Future<http.Response> registerUser(Map<String, String> userData) async {
    final url = Uri.parse("$kBaseUrl/api/v1/users/register");
    final accessToken = await getAuthToken();
    print("Retrieved Token: $accessToken");

    if (accessToken.isEmpty) {
      print("Error: Missing  accessToken!");
      throw Exception("Authorization token not found. Please log in again.");
    }

    print("\n--- Storing user data  ---");
    print("Request: POST $url");
    print("Request Body: ${jsonEncode(userData)}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "AppToken $accessToken", // Add             header
      },
    );

    print("\n--- POST Response ---");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("----------------------\n");

    return response;
  }


  Future<Map<String, String?>> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();

    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');

    if (accessToken == null || accessToken.isEmpty || refreshToken == null || refreshToken.isEmpty) {
      print("❌ Error: Auth tokens not found in SharedPreferences.");
      return {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
    }

    print("✅ Retrieved Access Token: $accessToken");
    print("✅ Retrieved Refresh Token: $refreshToken");

    // Check if new tokens are available and update SharedPreferences
    String? newAccessToken = await ApiService.refreshAccessToken(refreshToken);
    if (newAccessToken != null && newAccessToken.isNotEmpty) {
      await prefs.setString('access_token', newAccessToken);
      print("🔄 Updated Access Token: $newAccessToken");
      accessToken = newAccessToken; // Update local variable
    }

    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }




  static Future<String?> refreshAccessToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      print("❌ No refresh token found. User must log in again.");
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('$kBaseUrl/auth/refresh'),
        body: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? newAccessToken = data['access_token'];

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await prefs.setString('access_token', newAccessToken);
          print("✅ Access Token Refreshed: $newAccessToken");
          return newAccessToken;
        }
      }
    } catch (e) {
      print("❌ Error refreshing token: $e");
    }

    return null;
  }


  Future<void> saveAuthTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);

    print("✅ Tokens saved successfully!");
  }

  Future<void> retrieveAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');

    if (accessToken == null || refreshToken == null) {
      print("❌ No access or refresh token found. Redirecting to login...");
      // Handle re-login
    } else {
      print("✅ Retrieved Access Token: $accessToken");
      print("🔄 Retrieved Refresh Token: $refreshToken");
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // Clear stored token
    print("User logged out. Token removed.");
  }



  static Future<http.Response> verifyOTP(String email, String otpCode) async {
    final url = Uri.parse("$kBaseUrl/auth/login/otp");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email, // ✅ Ensure keys match API expectations
        "otpCode": otpCode,
      }),
    );

    print("📤 Sent Request: ${jsonEncode({"email": email, "otpCode": otpCode})}");
    print("📥 Response: ${response.statusCode} - ${response.body}");
    return response;
  }

  Future<void> _storeEmailOnLogin(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? previousEmails = prefs.getStringList("previous_login_emails");

    if (previousEmails == null) {
      previousEmails = [];
    }

    // Add email if it's not already in the list
    if (!previousEmails.contains(email)) {
      previousEmails.add(email);
      await prefs.setStringList("previous_login_emails", previousEmails);
    }
  }



  Future<http.Response> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    final url = Uri.parse("$kBaseUrl/api/v1/users/change-password");

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",

      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmationPassword": confirmPassword,
      }),
    );

    print(response.body);
    return response;
  }

  static Future<int?> fetchOtp(String email) async {
    final url = Uri.parse("$kBaseUrl/api/otp/generate?email=$email");
    final response = await http.post(url);

    // Debug: Print response body
    print("API Response: ${response.body}");
    String data = response.body;

    return int.tryParse(data.toString());
  }

}















