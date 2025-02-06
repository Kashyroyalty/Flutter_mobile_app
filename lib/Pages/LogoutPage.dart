import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';

import 'SettingPage.dart';
import 'ProfilePage.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to LoginPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}