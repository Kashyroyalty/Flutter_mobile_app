import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/RegistrationPage.dart';
import 'package:online_banking_system/Screens/SplashScreen.dart';
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
import 'Pages/CardPage.dart';
import 'Pages/LanguagePage.dart';
import 'Pages/StockPage.dart';
import 'Screens/privacy_screen.dart';
import 'Screens/account_summary_screen.dart';
import 'Screens/create_profile_screen1.dart';
import 'Screens/verification_screen.dart';
import 'Screens/password_creation_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Management Mobile App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('sw', ''),
        Locale('fr', ''),
        Locale('es', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Start with SplashScreen, then navigate to LanguagePage
      home: SplashScreen(),

      initialRoute: '/',
      routes: {
        '/language': (context) => LanguagePage(onLanguageChange: _changeLanguage),
        '/splashscreen': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/account': (context) => AccountPage(),
        '/card': (context) => CardPage(cardData: {},),
        //'/stock': (context) => StatisticsPage(),
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
  final Map<String, String> _localizedStrings = {
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
    CardPage(cardData: {},),
    //StatisticsPage(),
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
            icon: Icon(Icons.account_balance), // Alternative: Icons.account_box, Icons.supervised_user_circle,
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card), // Represents a card
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
            //icon: Icon(Icons.storage),
            //label: 'Statistics',
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

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: kTopBar,
      scaffoldBackgroundColor: kBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: kTopBar,
        iconTheme: IconThemeData(color: kButtonText),
        titleTextStyle: TextStyle(
          color: kButtonText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: kTextColorLightTheme,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: kTextColorLightTheme,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: kHeadingColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: kButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          foregroundColor: kButtonText,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: kButtonColor,
        error: kErrorColor,
        onError: kWarningColor,
        background: kBackgroundColor,
        onBackground: kTextColorLightTheme,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: kBarColor,
      scaffoldBackgroundColor: kOnBoardingColor_2,
      appBarTheme: const AppBarTheme(
        backgroundColor: kBarColor,
        iconTheme: IconThemeData(color: kButtonText),
        titleTextStyle: TextStyle(
          color: kButtonText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: kTextColorDarkTheme,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: kTextColorDarkTheme,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: kTextColorDarkTheme,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: kButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          foregroundColor: kButtonText,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: kButtonColor,
        error: kErrorColor,
        onError: kWarningColor,
        background: kOnBoardingColor_2,
        onBackground: kTextColorDarkTheme,
      ),
    );
  }

  // Helper method to get current theme mode
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
}


