import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Constants/Colors.dart';

import '../Constants/Strings.dart';
import '../Models/ApiService.dart';


class PasswordCreationScreen extends StatefulWidget {
  @override
  _PasswordCreationScreenState createState() => _PasswordCreationScreenState();
}

class _PasswordCreationScreenState extends State<PasswordCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String? _currentPassword;
  String? _newPassword;
  String? _confirmPassword;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Function to call the API and update password
  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await apiService.changePassword(
        _currentPassword!,
        _newPassword!,
        _confirmPassword!,
      );

      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully. Please log in with your new password.")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.toString() ?? "Password change failed.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current Password Field
                  TextFormField(
                    obscureText: _obscureCurrentPassword,
                    style: TextStyle(color: kTextColorLightTheme),
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      labelStyle: TextStyle(color: kTextColorLightTheme),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Current password is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _currentPassword = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // New Password Field
                  TextFormField(
                    obscureText: _obscureNewPassword,
                    style: TextStyle(color: kTextColorLightTheme),
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: TextStyle(color: kTextColorLightTheme),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "New password is required";
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
                    onChanged: (value) {
                      setState(() {
                        _newPassword = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Confirm Password Field
                  TextFormField(
                    obscureText: _obscureConfirmPassword,
                    style: TextStyle(color: kTextColorLightTheme),
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      labelStyle: TextStyle(color: kTextColorLightTheme),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your new password";
                      }
                      if (value != _newPassword) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                  ),
                  SizedBox(height: 24),

                  // Set Password Button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        changePassword();
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Set New Password'),
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
