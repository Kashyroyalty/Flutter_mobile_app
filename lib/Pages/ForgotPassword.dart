import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_banking_system/Pages/ResetPasswordPage.dart';
import '../Models/ApiService.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? "";

    setState(() {
      _emailController.text = savedEmail; // Auto-fill email if found
    });
  }

  void _requestOTP() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }
    setState(() => _isLoading = true);
    int? otp = await ApiService.fetchOtp(email);
    setState(() => _isLoading = false);

    if (otp != null) {
      print("Fetched OTP: $otp"); // Print OTP to the terminal
      _showOtpDialog(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP. Try again.")),
      );
    }
  }

  void _showOtpDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button press
          child: AlertDialog(
            title: Text("Enter OTP"),
            content: TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6, // Ensures only 6 characters can be entered
              inputFormatters: [
                LengthLimitingTextInputFormatter(6), // Limits to 6 digits
                FilteringTextInputFormatter.digitsOnly, // Allows only numbers
              ],
              decoration: InputDecoration(
                labelText: "OTP",
                counterText: "", // Hides character counter
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => _verifyOtp(email),
                child: Text("Verify"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _verifyOtp(String email) async {
    String otpCode = _otpController.text.trim();
    if (otpCode.isEmpty) return;

    setState(() => _isLoading = true);
    http.Response response = await ApiService.verifyOTP(email, otpCode);
    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      Navigator.pop(context); // Close OTP dialog
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Resetpasswordpage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Icon(Icons.lock_outline, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your email to receive a password reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _requestOTP,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Request OTP",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Login", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
