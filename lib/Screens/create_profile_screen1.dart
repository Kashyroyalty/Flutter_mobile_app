import 'package:flutter/material.dart';

class CreateProfileScreen1 extends StatefulWidget {
  @override
  _CreateProfileScreen1State createState() => _CreateProfileScreen1State();
}

class _CreateProfileScreen1State extends State<CreateProfileScreen1> {
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Profile - Step 1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Country'),
              value: _selectedCountry,
              items: <String>['Kenya', 'Uganda', 'Tanzania', 'South Sudan']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedCountry != null) {
                  Navigator.pushNamed(context, '/createProfile2', arguments: _selectedCountry);
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}