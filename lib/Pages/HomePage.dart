import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/CardDesign.dart';
import 'LogoutPage.dart';
import 'ProfilePage.dart';
import 'SettingPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _obscureBalance = false;
  String? _selectedAccount;

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

  final List<Map<String, dynamic>> accounts = [
    {'name': 'Savings Account', 'balance': 10000.00},
    {'name': 'Checking Account', 'balance': 5000.50},
    {'name': 'Business Account', 'balance': 25000.75},
  ];

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("John Doe"),
              accountEmail: Text("johndoe@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cards.map((card) => CardDesign(card: card)).toList(),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Account',
                    border: InputBorder.none,
                  ),
                  value: _selectedAccount,
                  items: accounts.map((account) => DropdownMenuItem<String>(
                    value: account['name'],
                    child: Text(account['name']!),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccount = value;
                    });
                  },
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 20),
              if (_selectedAccount != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available on card'), _obscureBalance
                        ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text(
                        '\$${accounts.firstWhere((account) => account['name'] == _selectedAccount)['balance']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                        : Text(
                      '\$${accounts.firstWhere((account) => account['name'] == _selectedAccount)['balance']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(_obscureBalance ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureBalance = !_obscureBalance;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transfer Limit'),
                    _obscureBalance
                        ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text('\$12,000'),
                    )
                        : Text('\$12,000'),
                  ],
                ),
              ],
              SizedBox(height: 30),
              Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _obscureBalance
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction['amount']!.startsWith('-')
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaction['amount']!.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                    ),
                    title: Text(transaction['description']!),
                    subtitle: Text(transaction['date']!),
                    trailing: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text(
                        transaction['amount']!,
                        style: TextStyle(
                          color: transaction['amount']!.startsWith('-')
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction['amount']!.startsWith('-')
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaction['amount']!.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                    ),
                    title: Text(transaction['description']!),
                    subtitle: Text(transaction['date']!),
                    trailing: Text(
                      transaction['amount']!,
                      style: TextStyle(
                        color: transaction['amount']!.startsWith('-')
                            ? Colors.red
                            : Colors.green,
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
