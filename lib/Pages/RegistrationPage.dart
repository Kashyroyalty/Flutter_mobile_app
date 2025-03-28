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
  bool _isPasswordHidden = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
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
      String email = _emailController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Processing registration..."),
          duration: Duration(seconds: 2),
        ),
      );

      try {
        final response = await apiService.fetchClientContract(email);
        if (response != null) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email not found."),
              backgroundColor: Colors.redAccent,
            ),
          );
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

  IconData _getIconForLabel(String label) {
    switch (label) {
      case "First Name":
      case "Last Name":
        return Icons.person;
      case "Email":
        return Icons.email;
      case "Phone":
        return Icons.phone;
      case "password":
        return Icons.password;
      case "confirmPassword":
        return Icons.password;
      default:
        return Icons.password_outlined;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Get Started with Your Secure Card Management",
              style: TextStyle(
                fontSize: kTextSizeTitles,
                fontWeight: FontWeight.bold,
                color: kTextColorLightTheme,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  for (var field in ["First Name", "Last Name", "Email", "Phone", "Password", "Confirm Password"])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        keyboardType: field == "Email" ? TextInputType.emailAddress : TextInputType.text,
                        obscureText: field.contains("Password") ? _isPasswordHidden : false,
                        style: TextStyle(color: kTextColorLightTheme),
                        controller: field == "First Name" ? _firstNameController :
                        field == "Last Name" ? _lastNameController :
                        field == "Email" ? _emailController :
                        field == "Phone" ? _phoneController :
                        field == "Password" ? _passwordController : _confirmpasswordController,
                        decoration: InputDecoration(
                          labelText: field,
                          labelStyle: TextStyle(color: kTextColorLightTheme),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(_getIconForLabel(field), color: kTextColorLightTheme),
                          suffixIcon: field.contains("Password")
                              ? IconButton(
                            icon: Icon(
                              _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                              color: kTextColorLightTheme,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your $field";
                          }
                          if (field == "Email" && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          if (field == "Phone" && !RegExp(r'^\d+$').hasMatch(value)) {
                            return "Please enter a valid phone number";
                          }
                          if (field == "Password" &&
                              !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$').hasMatch(value)) {
                            return "Password must be at least 8 characters long and include:\n• One uppercase letter\n• One lowercase letter\n• One number\n• One special character";
                          }
                          if (field == "Confirm Password" && value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ),
                ],
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
