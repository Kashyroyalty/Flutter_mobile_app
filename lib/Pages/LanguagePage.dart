import 'package:flutter/material.dart';
import '../Localization/AppLocalizations.dart';
import '../Screens/WelcomePage.dart';


class LanguagePage extends StatefulWidget {
  final Function(Locale) onLanguageChange;

  const LanguagePage({Key? key, required this.onLanguageChange}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguagePage> {
  String selectedLanguage = 'en';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'sw', 'name': 'Kiswahili', 'nativeName': 'Kiswahili'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate("Choose your language") ?? "Choose your language"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Selection Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.blue[500], size: 24),
                          const SizedBox(width: 8),
                          Text(
                            localizations?.translate("Select Language") ?? "Select Language",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // Language Options
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: languages.map((language) {
                          final bool isSelected = selectedLanguage == language['code'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedLanguage = language['code']!;
                              });
                              widget.onLanguageChange(Locale(language['code']!));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue[50] : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        language['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected ? Colors.blue[600] : Colors.black87,
                                        ),
                                      ),
                                      if (language['name'] != language['nativeName'])
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(
                                            '(${language['nativeName'] ?? 'Unknown'})',
                                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[500],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(), // Push the button to the bottom

              // Proceed Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    localizations?.translate("Proceed") ?? "Proceed",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
