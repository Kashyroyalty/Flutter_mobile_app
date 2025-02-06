import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Define supported locales
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('sw', ''), // Swahili
    Locale('fr', ''), // French
    Locale('rw', ''), // Kinyarwanda
  ];

  // Language keys and translations
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome to Card Management System',
      'select_language': 'Select Language',
    },
    'sw': {
      'welcome': 'Karibu kwenye Mfumo wa Usimamizi wa Kadi',
      'select_language': 'Chagua Lugha',
    },
    'fr': {
      'welcome': 'Bienvenue dans le système de gestion des cartes',
      'select_language': 'Choisissez la langue',
    },
    'rw': {
      'welcome': 'Murakaza neza muri sisitemu yo gucunga amakarita',
      'select_language': 'Hitamo ururimi',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

// Localization Delegate
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sw', 'fr', 'rw'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
