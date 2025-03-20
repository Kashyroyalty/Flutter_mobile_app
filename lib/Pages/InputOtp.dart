import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/ApiService.dart';
import '../main.dart';

class InputOtp extends StatefulWidget {
  @override
  _InputOtpState createState() => _InputOtpState();
}

class _InputOtpState extends State<InputOtp> {
  String otpCode = '';
  int? currentOtp; // Nullable int for better handling
  bool isLoading = false;

  String get refreshToken => refreshToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAndFetchOtp();
  }

  /// Loads saved email and fetches OTP from API
  Future<void> _loadAndFetchOtp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('saved_email');

      if (email == null || email.isEmpty) {
        print("❌ Error: No logged-in email found.");
        return;
      }

      await _fetchOtp(email);
    } catch (e) {
      print("❌ Error loading email: $e");
    }
  }

  /// Fetches OTP from API
  Future<void> _fetchOtp(String email) async {
    try {
      if (email.isEmpty) {
        print("❌ Error: No email provided.");
        return;
      }

      int? fetchedOtp = await ApiService.fetchOtp(email);

      setState(() {
        currentOtp = fetchedOtp;
      });

      print("✅ Fetched OTP: $currentOtp"); // Debugging output
    } catch (e) {
      print("❌ Error fetching OTP: $e");
    }
  }

  /// Adds a digit to OTP input
  void _addDigit(String digit) {
    if (otpCode.length < 6) {
      setState(() {
        otpCode += digit;
      });
    }
  }

  /// Clears OTP input
  void _clearOtp() {
    setState(() {
      otpCode = '';
    });
  }

  void _verifyOtp() async {
    if (otpCode.length < 6) {
      _showSnackBar('OTP must be 6 digits', Colors.red);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('saved_email');

    if (email == null || email.isEmpty) {
      _showSnackBar('No saved email found', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.verifyOTP(email, otpCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String? accessToken = data['access_token'];
        String? refreshToken = data['refresh_token']; // Fetch from response, not SharedPreferences

        if (accessToken != null && accessToken.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
          await prefs.setString('access_token', accessToken);
          await prefs.setString('refresh_token', refreshToken); // Store updated refresh token

          print("✅ Access Token Updated: $accessToken");
          print("🔄 Refresh Token Updated: $refreshToken");

          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          setState(() {
            isLoading = false;
          });

          _showSnackBar('Invalid response from server. No token received.', Colors.red);
        }
      } else if (response.statusCode == 401) {
        print("🔄 Access token expired. Attempting to refresh...");

        String? oldRefreshToken = prefs.getString('refresh_token');
        if (oldRefreshToken != null) {
          String? newAccessToken = await ApiService.refreshAccessToken(oldRefreshToken);

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await prefs.setString('access_token', newAccessToken); // Store updated access token
            print("🔄 New Access Token: $newAccessToken");

            _verifyOtp(); // Retry OTP verification with refreshed token
          } else {
            _showSnackBar('Session expired. Please log in again.', Colors.red);
          }
        } else {
          _showSnackBar('Session expired. Please log in again.', Colors.red);
        }
      } else {
        setState(() {
          isLoading = false;
        });

        _showSnackBar('Invalid OTP, please try again.', Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("❌ Error verifying OTP: $e");
      _showSnackBar('Something went wrong. Please try again.', Colors.red);
    }
  }

  /// Displays a snackbar message
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter the OTP sent to your phone",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  _buildOtpDisplay(),
                  SizedBox(height: 16),
                  _buildKeypad(),
                  SizedBox(height: 18),
                  isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDisplay() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < otpCode.length ? Colors.blue : Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        ...List.generate(9, (index) => _buildKeypadButton('${index + 1}')),
        _buildKeypadButton('C', isSpecial: true),
        _buildKeypadButton('0'),
        _buildKeypadButton('⌫', isSpecial: true, isBackspace: true),
      ],
    );
  }

  Widget _buildKeypadButton(String label, {bool isSpecial = false, bool isBackspace = false}) {
    return Material(
      elevation: 2,
      color: isSpecial ? Colors.grey[100] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (isBackspace && otpCode.isNotEmpty) {
            setState(() {
              otpCode = otpCode.substring(0, otpCode.length - 1);
            });
          } else if (label == 'C') {
            _clearOtp();
          } else {
            _addDigit(label);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSpecial ? Colors.grey[600] : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}
