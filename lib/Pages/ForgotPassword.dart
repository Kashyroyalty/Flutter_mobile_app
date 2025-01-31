import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  get http => null;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Clear any previous errors
      });

      final email = _emailController.text;

      try {
        final url = Uri.parse('YOUR_API_ENDPOINT_HERE'); // Replace with your actual API endpoint
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}), // Send email in the request body
        );

        if (response.statusCode == 200) {
          // Password reset request successful.  Typically, the API would send a reset link to the user's email.
          // You might navigate to a "check your email" screen here.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
          Navigator.pop(context); // Go back to the login screen or wherever appropriate

        } else {
          // Handle error responses from the API.
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message']?? 'Failed to send reset email. Please try again.'; // Extract error message or use a default.

          setState(() {
            _errorMessage = errorMessage;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage)),
          );
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'An error occurred. Please check your internet connection and try again.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage)),
        );
        print('Error: $error'); // Print error for debugging
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty ||!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _isLoading? null: _resetPassword, // Disable button while loading
                  child: _isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : const Text('Reset Password'),
                ),
                if (_errorMessage.isNotEmpty) // Display error message if any
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
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