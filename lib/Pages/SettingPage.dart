import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/PasswardChangePage.dart';
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
            leading: Icon(Icons.account_balance),
            title: Text("Linked Accounts"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LinkedAccounts()));
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettings()));
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

class LinkedAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Linked Accounts")), body: Center(child: Text("Linked Accounts Page")));
  }
}

class LanguageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Language Settings")), body: Center(child: Text("Language Settings Page")));
  }
}
