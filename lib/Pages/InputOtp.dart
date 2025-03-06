import 'package:flutter/material.dart';
import '../main.dart';
 // Import the MainScreen page

class InputOtp extends StatefulWidget {
  @override
  _InputOtpState createState() => _InputOtpState();
}

class _InputOtpState extends State<InputOtp> {
  String otp = '';
  bool isLoading = false;

  void _addDigit(String digit) {
    if (otp.length < 6) {
      setState(() {
        otp += digit;
      });
    }
  }

  void _clearOtp() {
    setState(() {
      otp = '';
    });
  }

  void _verifyOtp() {
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP must be 6 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
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
                color: index < otp.length ? Colors.blue : Colors.grey[300],
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
          if (isBackspace && otp.isNotEmpty) {
            setState(() {
              otp = otp.substring(0, otp.length - 1);
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
