import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';

class PasswordCreationScreen extends StatefulWidget {
  @override
  _PasswordCreationScreenState createState() => _PasswordCreationScreenState();
}

class _PasswordCreationScreenState extends State<PasswordCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _newPassword;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevents taking full height
                mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
                children: [
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
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters long";
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter";
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "Password must contain at least one lowercase letter";
                    }
                    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return "Password must contain at least one special character";
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
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Perform password update logic here, e.g., API call
                        Navigator.pushNamed(context, '/otp');
                      }
                    },
                    child: Text('Set Password'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
