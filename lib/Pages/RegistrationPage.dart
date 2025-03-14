import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientController = TextEditingController();
  late ApiService apiService;

  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  // Save client ID in SharedPreferences
  Future<void> saveClientId(int clientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('clientId', clientId);
    print("✅ Client ID successfully stored: $clientId");
  }

  // Save email and password in SharedPreferences
  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_email', email);
    await prefs.setString('registered_password', password);
    print("✅ Credentials saved: Email - $email | Password - $password");
  }

  Future<String> fetchPassword(String email) async {
    final response = await http.get(Uri.parse('https://yourapi.com/getPassword?email=$email'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['password'];
    } else {
      throw Exception("Failed to fetch password from API");
    }
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      email = _clientController.text.trim();


      // Show loading Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Processing registration..."),
          duration: Duration(seconds: 2),
        ),
      );

      try {
        // Call API to check card contract
        final response = await apiService.fetchClientContract(email);
        print("🔍 API Response: $response");

        if (response.isNotEmpty) {
          int? clientId = int.tryParse(response);
          if (clientId == null) {
            throw Exception("Invalid client ID received from API.");
          }

          print("✅ Client ID received: $clientId");

          // Fetch password from API
          password = await fetchPassword(email);
          print("📧 Registered Email: $email");
          print("🔑 Fetched Password: $password");

          // Save client ID and credentials
          await saveClientId(clientId);
          await saveCredentials(email, password);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful!"),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to Login Page after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/login');
          });
        } else {
          throw Exception("Invalid email address or no client contract found.");
        }
      } catch (e) {
        print("❌ Error during registration: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: kTopBar,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Verify Client",
                  style: TextStyle(
                    fontSize: kTextSizeTitles,
                    fontWeight: FontWeight.bold,
                    color: kTextColorLightTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Verify to get started with mobile banking.",
                  style: TextStyle(
                    fontSize: kTextSize,
                    color: kTextColorLightTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                // Email Field
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: kTextColorLightTheme),
                  controller: _clientController,
                  decoration: InputDecoration(
                    labelText: "Client Email",
                    labelStyle: TextStyle(color: kTextColorLightTheme),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: kButtonText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Redirect
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: kTextColorLightTheme,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
