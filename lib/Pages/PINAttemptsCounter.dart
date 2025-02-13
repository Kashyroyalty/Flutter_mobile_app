import 'package:flutter/material.dart';
import 'dart:async';

class PinVerificationPage extends StatefulWidget {
  const PinVerificationPage({super.key});

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> with SingleTickerProviderStateMixin {
  static const int maxAttempts = 3;
  int remainingAttempts = maxAttempts;
  String enteredPin = '';
  final String correctPin = '1234';
  bool isLocked = false;
  Timer? lockTimer;
  int lockTimeRemaining = 30;
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

  void _addDigit(String digit) {
    if (isLocked || enteredPin.length >= 4) return;

    setState(() {
      enteredPin += digit;
    });
  }

  void _verifyPin() {
    if (enteredPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 4-digit PIN'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      if (enteredPin == correctPin) {
        _showSuccessDialog();
        remainingAttempts = maxAttempts;
      } else {
        remainingAttempts--;
        _shakeController.forward(from: 0.0);

        if (remainingAttempts <= 0) {
          isLocked = true;
          _startLockTimer();
        }
      }
      enteredPin = '';
    });
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
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearPin() {
    if (isLocked) return;
    setState(() {
      enteredPin = '';
    });
  }

  void _resetAttempts() {
    setState(() {
      remainingAttempts = maxAttempts;
      isLocked = false;
      lockTimer?.cancel();
      enteredPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("insert your pin"),
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
                          const Icon(Icons.shield_outlined,
                            size: 64,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Security Verification',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your 4-digit PIN',
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
                          const SizedBox(height: 16),
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
                            )
                          else if (remainingAttempts < maxAttempts)
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
                                '$remainingAttempts attempts remaining',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
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
                      _buildKeypadButton('R', isSpecial: true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLocked ? null : _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'OK',
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
        onTap: isLocked
            ? null
            : () {
          if (isSpecial) {
            if (label == 'C') {
              _clearPin();
            } else if (label == 'R') {
              _resetAttempts();
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
              color: isLocked
                  ? Colors.grey
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