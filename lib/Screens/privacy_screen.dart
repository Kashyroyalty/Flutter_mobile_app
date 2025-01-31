import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Center(
          child: Column(
            children: [
              Text('Privacy Policy Text Goes Here'),
              ElevatedButton(onPressed: () {}, child: Text('Agree')),
              ElevatedButton(onPressed: () {}, child: Text('Disagree')),
            ],
          )
      ),
    );
  }
}