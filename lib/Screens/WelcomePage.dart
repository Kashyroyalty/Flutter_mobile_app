import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';

import '../Constants/Strings.dart';
import '../Localization/AppLocalizations.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo or Banner
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 100,
                    color: kButtonColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    localizations?.translate("manage_cards_title") ?? "Manage Your Cards Effortlessly",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kTextSizeTitles,
                      fontWeight: FontWeight.bold,
                      color: kButtonColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    localizations?.translate("manage_cards_subtitle") ?? "Track transactions, update limits, and secure your finances.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kTextSize,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(localizations?.translate("login") ?? "Access Your Account"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kButtonColor,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: kButtonColor),
                    ),
                  ),
                  child: Text(localizations?.translate("register") ?? "Create an Account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
