import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';

import '../Constants/Strings.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Content (Illustration + Title & Subtitle)
            // Middle Content (Title & Subtitle centered)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the text vertically
                children: [
                  Text(
                    OnBoardingTitle_1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CustomFont2',
                      fontSize: kTextSizeTitles,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: kTextColorLightTheme,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    OnBoardingSubtitle_1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kTextSize,
                      color: kTextColorLightTheme,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    foregroundColor: kButtonText,
                    padding: EdgeInsets.symmetric(horizontal: 130, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Log In'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    foregroundColor: kButtonText,
                    padding: EdgeInsets.symmetric(horizontal: 130, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
