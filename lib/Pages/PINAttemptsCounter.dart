import 'package:flutter/material.dart';
import 'dart:async';

// PIN Reset Page
class PinResetPage extends StatefulWidget {
  const PinResetPage({super.key});

  @override
  State<PinResetPage> createState() => _PinResetPageState();
}

class _PinResetPageState extends State<PinResetPage> with SingleTickerProviderStateMixin {
  String enteredPin = '';
  String newPin = '';
  bool isConfirmingPin = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (enteredPin.length >= 4) return;

    setState(() {
      enteredPin += digit;
      if (enteredPin.length == 4) {
        if (!isConfirmingPin) {
          newPin = enteredPin;
          enteredPin = '';
          isConfirmingPin = true;
        } else {
          if (enteredPin == newPin) {
            _showSuccessDialog();
          } else {
            _shakeController.forward(from: 0.0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PINs do not match. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            enteredPin = '';
            newPin = '';
            isConfirmingPin = false;
          }
        }
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        title: const Text('Success!'),
        content: const Text('PIN has been reset successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearPin() {
    setState(() {
      enteredPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset PIN"),
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
                          const Icon(
                            Icons.lock_reset,
                            size: 64,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Reset Your PIN',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isConfirmingPin
                                ? 'Confirm your new PIN'
                                : 'Enter your new PIN',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value, 0),
                                child: child,
                              );
                            },
                            child: Row(
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
                      const SizedBox(), // Empty space instead of 'R'
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

  Widget _buildKeypadButton(String label, {bool isSpecial = false}) {
    return Material(
      elevation: 2,
      color: isSpecial ? Colors.grey[100] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (isSpecial) {
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
              color: isSpecial ? Colors.grey[600] : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}

// Main Verification Page
class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({super.key});

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  static const int maxAttempts = 3;
  int remainingAttempts = 0;
  bool isLocked = true;
  Timer? lockTimer;
  int lockTimeRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startLockTimer();
  }

  @override
  void dispose() {
    lockTimer?.cancel();
    super.dispose();
  }

  void _startLockTimer() {
    lockTimeRemaining = 30;
    lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (lockTimeRemaining > 0) {
          lockTimeRemaining--;
        } else {
          isLocked = false;
          timer.cancel();
          remainingAttempts = maxAttempts;
        }
      });
    });
  }

  void _navigateToResetPin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PinResetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Status"),
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
                          color: isLocked ? Colors.red : Colors.green,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isLocked ? 'Account Locked' : 'Account Unlocked',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        if (isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Account locked for $lockTimeRemaining seconds',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _navigateToResetPin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Reset PIN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}