import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Help & Support', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help you?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'If you have any issues or inquiries regarding your card management, feel free to contact us through the following methods:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email Support'),
              subtitle: Text('support@cardapp.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue),
              title: Text('Phone Support'),
              subtitle: Text('+123 456 7890'),
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.blue),
              title: Text('Live Chat'),
              subtitle: Text('Available 24/7 in the app'),
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.blue),
              title: Text('FAQs'),
              subtitle: Text('Find answers to common questions'),
              onTap: () {
                // Navigate to FAQs page (implement this separately)
              },
            ),
            Spacer(),
            Center(
              child: Text(
                '© 2025 Card Management App',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
