import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Pages/LanguagePage.dart';

import 'WelcomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    });


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.15, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 230,
            left: 40,
            right: 40,
            child: Text(
              "Experience seamless financial management\n"
                  "making managing your finances easy and intuitive",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 17,
                color: kTextColorLightTheme,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(_slideAnimation.value + 20, -10),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildCard(0.02),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(_slideAnimation.value + 10, -5),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildCard(-0.02),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(_slideAnimation.value, 0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: _buildCard(-0.05, true),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kButtonColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 130,
                  vertical: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: () {
                // Ensure it navigates to LanguagePage manually if user presses the button early
                Navigator.pushReplacementNamed(context, '/language');
              },
              child: Text(
                "Get Started",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double rotation, [bool showDetails = false]) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 330,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6F61),
              Color(0xFFFFA726),
              Color(0xFF8E24AA),
              Color(0xFF00BCD4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: showDetails
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.credit_card, color: Colors.white, size: 30),
                Icon(Icons.wifi, color: Colors.white, size: 24),
              ],
            ),
            Text(
              '1234 5678 9000 0000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NICK OHMY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '05/24',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
              ],
            ),
          ],
        )
            : null,
      ),
    );
  }
}
