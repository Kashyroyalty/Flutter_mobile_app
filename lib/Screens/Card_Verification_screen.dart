import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/ApiService.dart';

class CardVerificationScreen extends StatefulWidget {
  @override
  _CardVerificationScreenState createState() => _CardVerificationScreenState();
}

class _CardVerificationScreenState extends State<CardVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _phoneError;
  String? _identityError;
  String? _emailError;

  bool _validateInputs() {
    String phone = _phoneController.text.trim();
    String identity = _identityController.text.trim();
    String email = _emailController.text.trim();

    bool isValid = true;

    setState(() {
      _phoneError = null;
      _identityError = null;
      _emailError = null;
    });

    if (phone.isEmpty || !RegExp(r'^\d{10,}$').hasMatch(phone)) {
      setState(() {
        _phoneError = "Enter a valid phone number (at least 10 digits)";
      });
      isValid = false;
    }

    if (identity.isEmpty || !RegExp(r'^\d{6,}$').hasMatch(identity)) {
      setState(() {
        _identityError = "Enter a valid identity number (at least 6 digits)";
      });
      isValid = false;
    }

    if (email.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      setState(() {
        _emailError = "Please enter a valid email address";
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> verifyCard() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String phone = _phoneController.text.trim();
    String identity = _identityController.text.trim();
    String email = _emailController.text.trim();

    try {
      http.Response response =
      (await ApiService.verifyCard(phone, identity, email)) as http.Response;

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, "/welcome");
      } else {
        setState(() {
          _errorMessage = "Details not found or invalid input.";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Verification"),
        actions: [
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      errorText: _phoneError,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _identityController,
                    decoration: InputDecoration(
                      labelText: "Identity Number",
                      errorText: _identityError,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      errorText: _emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: verifyCard,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              "Page 1 of 3",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
