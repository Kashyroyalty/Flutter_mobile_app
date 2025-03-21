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

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  Future<void> saveClientId(int clientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('clientId', clientId);
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_email', email);
    await prefs.setString('one_time_password', password);
    await prefs.setBool('password_used', false);
  }

  String generateOTP() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      String email = _clientController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Processing registration..."),
          duration: Duration(seconds: 2),
        ),
      );
      try {
        final response = await apiService.fetchClientContract(email);
        if (response.isNotEmpty) {
          int? clientId = int.tryParse(response);
          if (clientId == null) {
            throw Exception("Invalid client ID received from API.");
          }
          String otp = generateOTP();
          await saveClientId(clientId);
          await saveCredentials(email, otp);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful! OTP generated."),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/login');
          });
        } else {
          throw Exception("Invalid email address or no client contract found.");
        }
      } catch (e) {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create Your Secure Banking Account",
              style: TextStyle(
                fontSize: kTextSizeTitles,
                fontWeight: FontWeight.bold,
                color: kTextColorLightTheme,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your registered email to verify your identity and set up mobile banking.",
              style: TextStyle(
                fontSize: kTextSize,
                color: kTextColorLightTheme,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: kTextColorLightTheme),
                controller: _clientController,
                decoration: InputDecoration(
                  labelText: "Registered Email",
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
            ),
            const SizedBox(height: 20),
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
                  "Register Now",
                  style: TextStyle(
                    fontSize: 18,
                    color: kButtonText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                "Already have an account? Log in",
                style: TextStyle(
                  color: kTextColorLightTheme,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
