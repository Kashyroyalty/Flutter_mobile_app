import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final Function(Locale) setLocale;

  LanguageSelectionScreen({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('English'),
            onTap: () {
              setLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Français'),
            onTap: () {
              setLocale(Locale('fr'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Swahili'),
            onTap: () {
              setLocale(Locale('sw'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('中文'),
            onTap: () {
              setLocale(Locale('zh'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Kinyarwanda'),
            onTap: () {
              setLocale(Locale('rw'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}