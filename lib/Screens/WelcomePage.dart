import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';

import '../Constants/Strings.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Key change: spaceBetween
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Content (Title, Slogan, Illustration)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Text(
                    OnBoardingTitle_1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:kTextSizeTitles,
                      fontWeight: FontWeight.bold,
                      color: kTextColorLightTheme,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  OnBoardingSubtitle_1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: kTextSize,
                    color:kTextColorLightTheme,
                  ),
                ),
                SizedBox(height: 40),

                SizedBox(height: 80),
              ],
            ),

            // Bottom Buttons
            Column( // Use a Column for vertical arrangement
              mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
              children: [
                ElevatedButton( // Removed Expanded
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:kButtonColor,
                    foregroundColor: kButtonText,
                    padding: EdgeInsets.symmetric(horizontal: 130, vertical: 16), // Added horizontal padding
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Log In'),
                ),
                SizedBox(height: 20), // Space between buttons
                ElevatedButton( // Removed Expanded
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:kButtonColor,
                    foregroundColor:kButtonText,
                    padding: EdgeInsets.symmetric(horizontal:130, vertical: 16), // Added horizontal padding
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