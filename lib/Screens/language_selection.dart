import 'package:flutter/material.dart';
import 'package:online_banking_system/Screens/WelcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'I10n.dart';


class LanguageSelectionScreen extends StatelessWidget {
  final Function(String) onLanguageSelected;

  LanguageSelectionScreen({required this.onLanguageSelected});

  final Map<String, String> languages = {
    "English": "en",
    "Swahili": "sw",
    "French": "fr",
    "Kinyarwanda": "rw"
  };

  Future<void> _selectLanguage(BuildContext context, String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);
    onLanguageSelected(langCode);

    // Navigate to onboarding screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('select_language'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: languages.keys.map((lang) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _selectLanguage(context, languages[lang]!),
                child: Text(lang),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
