import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            // Implement logout functionality (e.g., clear session or token)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}