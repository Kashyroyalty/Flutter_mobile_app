import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfRegistration extends StatefulWidget {
  const SelfRegistration({super.key});

  @override
  State<SelfRegistration> createState() => _SelfRegistrationState();
}

class _SelfRegistrationState extends State<SelfRegistration> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _nationController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _nationController = TextEditingController();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newUserData = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "nation": _nationController.text,
    };

    await _saveDataToLocal(newUserData);

    String oneTimePassword = _generateOneTimePassword();
    print("Registered Email: ${newUserData['email']}");
    print("One-Time Password: $oneTimePassword");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful. Check the console for login details.")));
      Navigator.pop(context);
    }
  }

  Future<void> _saveDataToLocal(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', data['first_name']!);
    await prefs.setString('last_name', data['last_name']!);
    await prefs.setString('email', data['email']!);
    await prefs.setString('phone', data['phone']!);
    await prefs.setString('address', data['address']!);
    await prefs.setString('nation', data['nation']!);
  }

  String _generateOneTimePassword() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Registration"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("First Name", _firstNameController),
                  _buildTextField("Last Name", _lastNameController),
                  _buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
                  _buildTextField("Phone", _phoneController, keyboardType: TextInputType.phone),
                  _buildTextField("Address", _addressController),
                  _buildTextField("Nation", _nationController),
                  const SizedBox(height: 20),
                  _isSaving
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(_getIconForLabel(label)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Please enter $label" : null,
      ),
    );
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
      case "Address":
        return Icons.location_on;
      case "Nation":
        return Icons.flag;
      default:
        return Icons.text_fields;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nationController.dispose();
    super.dispose();
  }
}
