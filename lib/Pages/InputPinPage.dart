import 'package:flutter/material.dart';
import 'dart:async';

class PinInputPage extends StatefulWidget {
  const PinInputPage({super.key});

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  String enteredPin = '';
  static const String correctPin = '1234'; // Replace with actual PIN
  static const int maxAttempts = 3;
  int remainingAttempts = 3;
  bool isLocked = false;
  Timer? lockTimer;
  int lockTimeRemaining = 30;

  @override
  void dispose() {
    lockTimer?.cancel();
    super.dispose();
  }

  void _startLockTimer() {
    setState(() {
      isLocked = true;
      lockTimeRemaining = 30;
    });

    lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (lockTimeRemaining > 0) {
          lockTimeRemaining--;
        } else {
          isLocked = false;
          remainingAttempts = maxAttempts;
          timer.cancel();
        }
      });
    });
  }

  void _addDigit(String digit) {
    if (enteredPin.length >= 4 || isLocked) return;

    setState(() {
      enteredPin += digit;
    });
  }

  void _clearPin() {
    if (isLocked) return;

    setState(() {
      enteredPin = '';
    });
  }

  void _verifyPin() {
    if (isLocked) return;

    if (enteredPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 4-digit PIN'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (enteredPin == correctPin) {
      _showSuccessDialog();
    } else {
      setState(() {
        remainingAttempts--;
        enteredPin = '';

        if (remainingAttempts <= 0) {
          _startLockTimer();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            remainingAttempts > 0
                ? 'Incorrect PIN. $remainingAttempts attempts remaining.'
                : 'Account locked for 30 seconds due to too many attempts.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        title: const Text('Success!'),
        content: const Text('PIN verified successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Add navigation logic here if needed
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter PIN"),
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            isLocked ? Icons.lock_outline : Icons.lock_open,
                            size: 64,
                            color: isLocked ? Colors.red : Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isLocked ? 'Account Locked' : 'Enter PIN',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          if (isLocked)
                            Text(
                              'Locked for $lockTimeRemaining seconds',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Text(
                              'Please enter your 4-digit PIN',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                                  (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < enteredPin.length
                                      ? Colors.blue
                                      : Colors.grey[200],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!isLocked)
                            Text(
                              'Attempts remaining: $remainingAttempts',
                              style: TextStyle(
                                color: remainingAttempts == 1 ? Colors.red : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      ...List.generate(
                        9,
                            (index) => _buildKeypadButton('${index + 1}'),
                      ),
                      _buildKeypadButton('C', isSpecial: true),
                      _buildKeypadButton('0'),
                      _buildKeypadButton('OK', isSpecial: true, isVerify: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, {bool isSpecial = false, bool isVerify = false}) {
    return Material(
      elevation: 2,
      color: isVerify
          ? Colors.blue
          : isSpecial
          ? Colors.grey[100]
          : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLocked
            ? null
            : () {
          if (isVerify) {
            _verifyPin();
          } else if (isSpecial) {
            if (label == 'C') {
              _clearPin();
            }
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
              color: isVerify
                  ? Colors.white
                  : isSpecial
                  ? Colors.grey[600]
                  : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}