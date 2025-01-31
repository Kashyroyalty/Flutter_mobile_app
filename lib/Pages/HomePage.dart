import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/LogoutPage.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/Pages/SettingPage.dart';
import '../widgets/CardDesign.dart';
import '../widgets/AccountBalanceDisplay.dart'; // Import the new widget

class HomePage extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'bank': 'Your Bank',
      'number': '**** **** **** 1234',
      'holder': 'John Doe',
      'expiry': '12/26'
    },
    {
      'bank': 'Your Bank',
      'number': '**** **** **** 5678',
      'holder': 'Jane Doe',
      'expiry': '05/28'
    },
    {
      'bank': 'Your Bank',
      'number': '**** **** **** 9101',
      'holder': 'Alice Smith',
      'expiry': '08/27'
    },
  ];

  final Map<String, double> accounts = {
    'Savings Account': 10000.00,
    'Checking Account': 5000.50,
    'Business Account': 25000.75,
  };

  final List<Map<String, String>> transactions = [
    {'date': '2025-01-23', 'description': 'Grocery Store', 'amount': '-\$50.00'},
    {'date': '2025-01-22', 'description': 'Electricity Bill', 'amount': '-\$120.00'},
    {'date': '2025-01-21', 'description': 'Salary Credit', 'amount': '+\$2,000.00'},
    {'date': '2025-01-20', 'description': 'Online Purchase', 'amount': '-\$30.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Banking System'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to NotificationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Cards Display
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cards.map((card) => CardDesign(card: card)).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Account Balance Display (Using AccountBalanceDisplay Widget)
              AccountBalanceDisplay(accounts: accounts),
              SizedBox(height: 30),

              // Recent Transactions
              Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction['amount']!.startsWith('-') ? Icons.arrow_downward : Icons.arrow_upward,
                      color: transaction['amount']!.startsWith('-') ? Colors.red : Colors.green,
                    ),
                    title: Text(transaction['description']!),
                    subtitle: Text(transaction['date']!),
                    trailing: Text(
                      transaction['amount']!,
                      style: TextStyle(
                        color: transaction['amount']!.startsWith('-') ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutPage()),
              );
              // Handle logout functionality
            },
          ),
        ],
      ),
    );
  }
}
