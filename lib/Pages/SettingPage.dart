import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/CardContractStatusPage.dart';
import 'package:online_banking_system/Pages/ClientIdentifierPage.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/PINAttemptsCounter.dart';
import 'package:online_banking_system/Pages/PasswardChangePage.dart';
import 'package:online_banking_system/Pages/LanguagePage.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Security"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordResetPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: () {
              // Navigate to NotificationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            onTap: () {
              // Navigate to LanguagePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguagePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Placeholder pages
class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Profile Settings")), body: Center(child: Text("Profile Settings Page")));
  }
}

class SecuritySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Security Settings")), body: Center(child: Text("Security Settings Page")));
  }
}

class NotificationSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Notification Settings")), body: Center(child: Text("Notification Settings Page")));
  }
}

class OnlinePinAttemptsCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Online Pin Attempts Counter")), body: Center(child: Text("Online Pin Attempts Counter Page")));
  }
}

class ClientIdentifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Client Identifier")), body: Center(child: Text("Client Identifier Page")));
  }
}

class ChangeclientIdentifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Change Client Identifier")), body: Center(child: Text("Change Client Identifier Page")));
  }
}

class LanguageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Language Settings")), body: Center(child: Text("Language Settings Page")));
  }
}
