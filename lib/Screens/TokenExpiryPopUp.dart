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
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _refreshAccessToken() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null && refreshToken.isNotEmpty) {
      String? newAccessToken = await ApiService.refreshAccessToken(refreshToken);

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await prefs.setString('access_token', newAccessToken);

        if (mounted) {
          Navigator.of(context).pop(); // Close the popup
        }
        widget.onSessionContinued();
        return;
      }
    }

    // If refresh token fails, show error
    setState(() {
      _isLoading = false;
      _errorMessage = "Session refresh failed. Please log in again.";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await ApiService.logout();

    if (mounted) {
      Navigator.of(context).pop(); // Close the popup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // Prevents back button dismissal
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text("Session Expiring"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage == null)
              const Text("Are you still using the app? Your session is about to expire."),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        actions: [
          if (_errorMessage == null) ...[
            TextButton(
              onPressed: _logout,
              child: const Text("Logout"),
            ),
            TextButton(
              onPressed: _isLoading ? null : _refreshAccessToken,
              child: const Text("Continue"),
            ),
          ],
          if (_errorMessage != null) ...[
            TextButton(
              onPressed: _logout,
              child: const Text("Retry Login"),
            ),
          ],
        ],
      ),
    );
  }
}

void showTokenExpiryPopup(BuildContext context, VoidCallback onSessionContinued, VoidCallback onLogout) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents tapping outside to dismiss
    builder: (context) => TokenExpiryPopup(
      onSessionContinued: onSessionContinued,
      onLogout: onLogout,
    ),
  );
}
