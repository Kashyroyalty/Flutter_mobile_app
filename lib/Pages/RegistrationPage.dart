import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';
import 'package:online_banking_system/Models/ApiService.dart';

import '../Constants/Strings.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();

  Future<http.Response> searchManagement(String accountContractId) async {
    final url = Uri.parse("$kBaseUrl/getAccountContractId/$accountContractId");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"accountContractId": accountContractId}),
    );

    return response;
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      String accountNumber = _accountController.text.trim();

      // Show loading Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Processing registration..."),
          duration: Duration(seconds: 2),
        ),
      );

      try {
        // Call API to check account contract
        final response = await searchManagement(accountNumber);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful!"),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to Login Page
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/login');
          });
        } else {
          // Extract error message from response body (if any)
          final responseBody = jsonDecode(response.body);
          String errorMessage = responseBody['message'] ?? "Invalid account contract";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $errorMessage"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: $e"),
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
      body: Center( // Centers the form vertically and horizontally
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the column doesn't take full height
              crossAxisAlignment: CrossAxisAlignment.center, // Centers items horizontally
              children: [
                Text(
                  "Verify Account",
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
                // Account Number Field
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: kTextColorLightTheme),
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    labelStyle: TextStyle(color: kTextColorLightTheme),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    counterText: "", // Hides the default character counter
                  ),
                  maxLength: 16, // Limits input to 16 digits
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your account number";
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return "The field only accepts numbers";
                    }
                    if (value.length < 15) {
                      return "The field should contain at least 15 digits";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Register Button with increased width
                SizedBox(
                  width: double.infinity, // Makes button stretch across available width
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14), // Larger button
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
                      // Navigate to Login Page
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
