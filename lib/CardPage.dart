import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _selectedCardIndex = 0;

  final List<Map<String, dynamic>> _cards = [
    {
      'bank': 'Your Bank',
      'number': '**** **** **** 1234',
      'holder': 'John Doe',
      'expiry': '12/26',
      'balance': '\$10,000.00',
      'transactions': [
        {'date': '2025-01-23', 'description': 'Grocery Store', 'amount': '-\$50.00'},
        {'date': '2025-01-22', 'description': 'Electricity Bill', 'amount': '-\$120.00'},
        {'date': '2025-01-21', 'description': 'Salary Credit', 'amount': '+\$2,000.00'},
      ],
    },
    {
      'bank': 'Your Bank',
      'number': '**** **** **** 5678',
      'holder': 'Jane Doe',
      'expiry': '05/28',
      'balance': '\$8,500.00',
      'transactions': [
        {'date': '2025-01-20', 'description': 'Online Purchase', 'amount': '-\$30.00'},
        {'date': '2025-01-18', 'description': 'Gym Membership', 'amount': '-\$40.00'},
      ],
    },
    {
      'bank': 'New Bank',
      'number': '**** **** **** 8765',
      'holder': 'Alice Smith',
      'expiry': '09/30',
      'balance': '\$5,000.00',
      'transactions': [
        {'date': '2025-01-19', 'description': 'Restaurant', 'amount': '-\$70.00'},
        {'date': '2025-01-15', 'description': 'Book Purchase', 'amount': '-\$15.00'},
        {'date': '2025-01-10', 'description': 'Refund', 'amount': '+\$30.00'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Cards",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_cards.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCardIndex = index;
                      });
                    },
                    child: buildCard(_cards[index]),
                  );
                }),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _cards[_selectedCardIndex]['transactions'].length,
                itemBuilder: (context, index) {
                  final transaction = _cards[_selectedCardIndex]['transactions'][index];
                  return ListTile(
                    leading: Icon(
                      transaction['amount'].startsWith('-') ? Icons.arrow_downward : Icons.arrow_upward,
                      color: transaction['amount'].startsWith('-') ? Colors.red : Colors.green,
                    ),
                    title: Text(transaction['description']),
                    subtitle: Text(transaction['date']),
                    trailing: Text(
                      transaction['amount'],
                      style: TextStyle(
                        color: transaction['amount'].startsWith('-') ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> card) {
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
            card['bank'],
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            card['number'],
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
                    card['holder'],
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
                    card['expiry'],
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
