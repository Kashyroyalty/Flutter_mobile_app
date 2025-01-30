import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Overview'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              '\$36,790.00',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  WalletCard('**** 5473', 15895.00, 'Visa'),
                  WalletCard('**** 0180', 11200.00, 'Visa'),
                  WalletCard('**** 8832', 8846.00, 'Mastercard'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(icon: Icons.arrow_downward, label: 'Deposit'),
                ActionButton(icon: Icons.arrow_upward, label: 'Withdraw'),
                ActionButton(icon: Icons.swap_horiz, label: 'Transfer'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final String cardNumber;
  final double balance;
  final String cardType;

  WalletCard(this.cardNumber, this.balance, this.cardType);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.credit_card, color: Colors.teal),
        title: Text(cardNumber),
        subtitle: Text(cardType),
        trailing: Text(
          '\$${balance.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;


  ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.teal,
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

