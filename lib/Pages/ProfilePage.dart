import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  File? _image;
  bool _showSuccess = false;

  // Form controllers
  final _firstNameController = TextEditingController(text: 'Arthur');
  final _lastNameController = TextEditingController(text: 'Nancy');
  final _emailController = TextEditingController(text: 'bradley.ortiz@gmail.com');
  final _phoneController = TextEditingController(text: '477-046-1827');
  final _addressController = TextEditingController(text: '116 Jaskolski Stravenue Suite 883');
  final _nationController = TextEditingController(text: 'Colombia');

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the data to a server
      setState(() {
        _isEditing = false;
        _showSuccess = true;
      });

      // Hide success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showSuccess = false;
          });
        }
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Reset form to original values
      _firstNameController.text = 'Arthur';
      _lastNameController.text = 'Nancy';
      _emailController.text = 'bradley.ortiz@gmail.com';
      _phoneController.text = '477-046-1827';
      _addressController.text = '116 Jaskolski Stravenue Suite 883';
      _nationController.text = 'Colombia';
    });
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Here you would typically send the new password to a server
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Colors.blueAccent,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_showSuccess)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'Profile updated successfully!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : const AssetImage('assets/default_profile.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        'First Name',
                        _firstNameController,
                        enabled: _isEditing,
                      ),
                      _buildTextField(
                        'Last Name',
                        _lastNameController,
                        enabled: _isEditing,
                      ),
                      _buildPasswordField(),
                      _buildTextField(
                        'Email',
                        _emailController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        'Phone',
                        _phoneController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextField(
                        'Address',
                        _addressController,
                        enabled: _isEditing,
                      ),
                      _buildTextField(
                        'Nation',
                        _nationController,
                        enabled: _isEditing,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (!_isEditing)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _toggleEdit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 25),

                          ),
                          child: const Text('Edit Profile'),

                        ),
                      ),
                    if (_isEditing) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: _cancelEdit,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        bool enabled = false,
        TextInputType? keyboardType,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          filled: !enabled,
          fillColor: !enabled ? const Color(0xFFF5F5F5) : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        enabled: false,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          suffixIcon: TextButton(
            onPressed: _changePassword,
            child: const Text(
              'CHANGE PASSWORD',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        initialValue: '••••••••',
      ),
    );
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