import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import '../../widgets/carddesign.dart'; // Ensure this import is correct

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _selectedCardIndex = 0;

  final List<Map<String, dynamic>> _cards = [
    {
  'bank': 'Flutter Bank',
  'number': '1234 **** **** 3456',
  'holder': 'John Doe',
  'expiry': '12/26',
  'cvv': '123',
  'signature': 'John Doe',
  'instructions': 'Authorized use only',
      'transactions': [
        {'date': '2025-01-23', 'description': 'Grocery Store', 'amount': '-\$50.00'},
        {'date': '2025-01-22', 'description': 'Electricity Bill', 'amount': '-\$120.00'},
        {'date': '2025-01-21', 'description': 'Salary Credit', 'amount': '+\$2,000.00'},
      ],
    },
    {
    'bank': 'Flutter Bank',
    'number': '1234 **** **** 3456',
    'holder': 'John Doe',
    'expiry': '12/26',
    'cvv': '123',
    'signature': 'John Doe',
    'instructions': 'Authorized use only',
      'transactions': [
        {'date': '2025-01-20', 'description': 'Online Purchase', 'amount': '-\$30.00'},
        {'date': '2025-01-18', 'description': 'Gym Membership', 'amount': '-\$40.00'},
      ],
    },
    {
    'bank': 'Flutter Bank',
    'number': '1234 **** **** 3456',
    'holder': 'John Doe',
    'expiry': '12/26',
    'cvv': '123',
    'signature': 'John Doe',
    'instructions': 'Authorized use only',
      'transactions': [
        {'date': '2025-01-20', 'description': 'Online Purchase', 'amount': '-\$30.00'},
        {'date': '2025-01-18', 'description': 'Gym Membership', 'amount': '-\$40.00'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
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
            if (_cards.isNotEmpty) // Ensure _cards is not empty before building UI
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
                      child: CardDesign(card: _cards[index]), // Call CardDesign widget
                    );
                  }),
                ),
              )
            else
              Center(
                child: Text(
                  "No cards available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 30),
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _cards.isNotEmpty
                  ? ListView.builder(
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
              )
                  : Center(
                child: Text(
                  "No transactions available",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
