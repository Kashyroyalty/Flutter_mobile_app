import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("Change Password"),
              leading: Icon(Icons.lock),
              onTap: () {
                // Implement change password functionality
              },
            ),
            ListTile(
              title: Text("Update Profile"),
              leading: Icon(Icons.edit),
              onTap: () {
                // Implement update profile functionality
              },
            ),
            ListTile(
              title: Text("Notification Settings"),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Implement notification settings functionality
              },
            ),
            ListTile(
              title: Text("Language Settings"),
              leading: Icon(Icons.language),
              onTap: () {
                // Implement language settings functionality
              },
            ),
            ListTile(
              title: Text("Privacy Settings"),
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                // Implement privacy settings functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}