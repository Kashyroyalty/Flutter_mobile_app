import 'package:flutter/material.dart';
import 'package:online_banking_system/NotificationPage.dart';

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
      drawer: NavigationDrawer(children: [],),
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
                  children: cards.map((card) => buildCard(card)).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Balance Display
              Text(
                'Account Balance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '\$10,000.00',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 30),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Transfer',
                    onPressed: () {
                      // Navigate to transfer screen
                    },
                  ),
                  ActionButton(
                    icon: Icons.history,
                    label: 'Transactions',
                    onPressed: () {
                      // Navigate to transaction history screen
                    },
                  ),
                  ActionButton(
                    icon: Icons.add,
                    label: 'Deposit',
                    onPressed: () {
                      // Navigate to deposit screen
                    },
                  ),
                ],
              ),
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

  Widget buildCard(Map<String, String> card) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card['bank']!,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            card['number']!,
            style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 4),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    card['holder']!,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    card['expiry']!,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  ActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }
}
