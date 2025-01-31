import 'package:flutter/material.dart';

class AccountSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Summary')),
      body: Center(
        child: Column(
          children: [
            Text('Account Balance: 999,999,999.99 KES'),
          ],
        ),
      ),
    );
  }
}