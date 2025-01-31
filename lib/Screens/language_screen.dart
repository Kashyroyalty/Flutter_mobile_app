import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: Center(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Language'),
          value: _selectedLanguage,
          items: <String>['English', 'Swahili', 'French'] // Example languages
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedLanguage = value;
            });
          },
        ),
      ),
    );
  }
}