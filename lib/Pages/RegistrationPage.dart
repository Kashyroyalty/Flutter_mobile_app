import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registration successful!"),
        duration: Duration(seconds: 2),
      ));
      // Navigate to the Login Page after showing the Snackbar
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: kTopBar,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: kTextSizeTitles,
                  fontWeight: FontWeight.bold,
                  color: kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Sign up to get started with mobile banking.",
                style: TextStyle(
                  fontSize: kTextSize,
                  color:kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 20),
              // Name Field
              TextFormField(
                style: TextStyle(color:kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Email Field
              TextFormField(
                style: TextStyle(color:kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color:kTextColorLightTheme),
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
              SizedBox(height: 15),
              // Password Field
              TextFormField(
                obscureText: true,
                style: TextStyle(color: kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color:kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Confirm Password Field
              TextFormField(
                obscureText: true,
                style: TextStyle(color:kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color:kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Register Button
              ElevatedButton(
                onPressed: _onRegisterPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:kButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      color:kButtonText,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      color:kTextColorLightTheme,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
