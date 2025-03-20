import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/ApiService.dart';
import '../Pages/LoginPage.dart';


class TokenExpiryPopup extends StatefulWidget {
  final VoidCallback onSessionContinued;
  final VoidCallback onLogout;

  const TokenExpiryPopup({
    super.key,
    required this.onSessionContinued,
    required this.onLogout,
  });

  @override
  _TokenExpiryPopupState createState() => _TokenExpiryPopupState();
}

class _TokenExpiryPopupState extends State<TokenExpiryPopup> {

  Future<void> _refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token'); // Retrieve stored refresh token

    if (refreshToken != null && refreshToken.isNotEmpty) {
      String? newAccessToken = await ApiService.refreshAccessToken(refreshToken); // Use refresh token to get new access token
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await prefs.setString('access_token', newAccessToken); // Store the new access token

        if (mounted) {
          Navigator.of(context).pop(); // Dismiss the popup
        }
        widget.onSessionContinued();
        return;
      }
    }

    // If token refresh fails, force logout
    _logout();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // Remove access token
    await prefs.remove('refresh_token'); // Remove refresh token if stored
    await ApiService.logout();

    if (mounted) {
      Navigator.of(context).pop(); // Dismiss the popup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login page
      );
    }
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Session Expiring"),
      content: const Text("Are you still using the app? Your session is about to expire."),
      actions: [
        TextButton(
          onPressed: _logout,
          child: const Text("Logout"),
        ),
        TextButton(
          onPressed: _refreshAccessToken,
          child: const Text("Continue"),
        ),
      ],
    );
  }
}

void showTokenExpiryPopup(BuildContext context, VoidCallback onSessionContinued, VoidCallback onLogout) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => TokenExpiryPopup(
      onSessionContinued: onSessionContinued,
      onLogout: onLogout,
    ),
  );
}
