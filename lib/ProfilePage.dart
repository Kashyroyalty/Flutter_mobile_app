import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the whole body
        child: ListView(
          children: [
            // Profile Picture
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
            ),
            SizedBox(height: 20),

            // Name
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Email
            Text(
              'Email: john.doe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),

            // Phone Number
            Text(
              'Phone: +1 (555) 123-4567',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),

            // Address
            Text(
              'Address: 123 Main St, Apartment 4B, City, Country',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),

            // Balance
            Text(
              'Balance: \$10,500.00',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 20),

            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editProfile');
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/logout');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
