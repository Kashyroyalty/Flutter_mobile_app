import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';
import 'RegistrationPage.dart';
import 'ForgotPassword.dart'; // Import ForgotPassword
import '../main.dart'; // Import MainScreen

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  bool isFingerprintAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {
        isFingerprintAvailable = canCheckBiometrics;
      });

      if (canCheckBiometrics) {
        _authenticateWithBiometrics();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Biometric authentication not available: $e"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate using your fingerprint',
        options: AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Authentication successful!"),
          duration: Duration(seconds: 2),
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Authentication failed: $e"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login successful!"),
        duration: Duration(seconds: 2),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kBackgroundColor,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor:kTopBar,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Log in to continue to your account.",
                style: TextStyle(
                  fontSize: 20,
                  color: kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color:kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color:kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white70,
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
              TextFormField(
                obscureText: true,
                style: TextStyle(color:kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color:kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onLoginPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:kButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: kTextSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center( // Center the "Forgot Password" button
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()), // Navigate to ForgotPassword
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: kTextColorLightTheme, // Keep the color consistent
                      fontSize: kTextSize,
                    ),
                  ),
                ),
              ),
              if (isFingerprintAvailable)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _authenticateWithBiometrics,
                        icon: Icon(Icons.fingerprint),
                        label: Text("Use Fingerprint"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: kButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: kTextColorLightTheme,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}