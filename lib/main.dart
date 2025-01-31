import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/RegistrationPage.dart';
import 'package:online_banking_system/Screens/WelcomePage.dart';
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
import 'Pages/CardPage.dart';
import 'Pages/StockPage.dart';
import 'Screens/language_screen.dart';
import 'Screens/privacy_screen.dart';
import 'Screens/account_summary_screen.dart';
import 'Screens/create_profile_screen1.dart';
import 'Screens/verification_screen.dart';
import 'Screens/password_creation_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('sw'),
        Locale('zh'),
        Locale('rw'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/account': (context) => AccountPage(),
        '/card': (context) => CardPage(),
        '/stock': (context) => StockPage(),
        '/language': (context) => LanguageScreen(),
        '/privacy': (context) => PrivacyScreen(),
        '/accounts': (context) => AccountSummaryScreen(),
        '/createProfile1': (context) => CreateProfileScreen1(),
        '/verification': (context) => VerificationScreen(),
        '/passwordCreation': (context) => PasswordCreationScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Example localized strings
  Map<String, String> _localizedStrings = {
    'hello': 'Hello',
    'welcome': 'Welcome to our app',
  };



  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'sw', 'zh', 'rw'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    AccountPage(),
    CardPage(),
    StockPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Stock',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
