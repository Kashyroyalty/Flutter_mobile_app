import 'package:flutter/material.dart';

const kTextColorLightTheme = Color(0xFF101010);
const kTextColorDarkTheme  = Color(0xFFFFFFFF);
const kButtonText = Color(0xFFFFFFFF);
const kTopBar = Colors.blue;
const kWarningColor = Color(0xFFE80B0B);
const kErrorColor = Color(0xFFF03738);
const kBackgroundColor = Color(0xFFE8E6E6);
const kLinkColor = Color(0xFF5758C5);
const kHeadingColor = Color(0xFF151515);
const kBarColor = Color(0xFF2f3542);
const kButtonColor = Colors.blue;

const kCardColor = Colors.indigo;

const kOnBoardingColor_1 = Color(0xff333846);
const kOnBoardingColor_2 = Color(0xff2E3850);
const kOnBoardingColor_3 = Color(0xff333846);




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

// Main app widget
class ColorConstants extends StatelessWidget {
  const ColorConstants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system, // This makes the app follow system theme
      home: const MyHomePage(),
    );
  }
}

// Example page showing how to use the theme
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can check the current theme mode like this
    final isDark = AppTheme.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Theme: ${isDark ? "Dark" : "Light"}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Your button action
              },
              child: const Text('Test Button'),
            ),
          ],
        ),
      ),
    );
  }
}