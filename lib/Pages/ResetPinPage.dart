import 'package:flutter/material.dart';

class PinResetPage extends StatefulWidget {
  const PinResetPage({super.key});

  @override
  State<PinResetPage> createState() => _PinResetPageState();
}

class _PinResetPageState extends State<PinResetPage> {
  String newPin = '';
  String confirmPin = '';
  bool isEnteringNewPin = true; // To track which PIN field is active

  void _addDigit(String digit) {
    setState(() {
      if (isEnteringNewPin) {
        if (newPin.length < 4) {
          newPin += digit;
          if (newPin.length == 4) {
            isEnteringNewPin = false; // Switch to confirm PIN when new PIN is complete
          }
        }
      } else {
        if (confirmPin.length < 4) {
          confirmPin += digit;
          if (confirmPin.length == 4) {
            _verifyPins(); // Verify PINs when both are complete
          }
        }
      }
    });
  }

  void _clearPin() {
    setState(() {
      if (isEnteringNewPin) {
        newPin = '';
      } else {
        confirmPin = '';
      }
    });
  }

  void _switchPinField() {
    setState(() {
      isEnteringNewPin = !isEnteringNewPin;
    });
  }

  void _resetBothPins() {
    setState(() {
      newPin = '';
      confirmPin = '';
      isEnteringNewPin = true;
    });
  }

  void _verifyPins() {
    if (newPin == confirmPin) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      _resetBothPins();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        title: const Text('Success!'),
        content: const Text('Your PIN has been reset successfully.'),
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
                children: [
                  // New PIN Card
                  _buildPinCard(
                    isNewPin: true,
                    pin: newPin,
                    isActive: isEnteringNewPin,
                  ),
                  const SizedBox(height: 16),
                  // Confirm PIN Card
                  _buildPinCard(
                    isNewPin: false,
                    pin: confirmPin,
                    isActive: !isEnteringNewPin,
                  ),
                  const SizedBox(height: 24),
                  // Keypad
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
                      _buildKeypadButton('↑', isSpecial: true, isSwitch: true),
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

  Widget _buildPinCard({
    required bool isNewPin,
    required String pin,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => setState(() {
        isEnteringNewPin = isNewPin;
      }),
      child: Card(
        elevation: isActive ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isActive
              ? BorderSide(color: Colors.blue.shade300, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: isActive ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                isNewPin ? 'Enter New PIN' : 'Confirm New PIN',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isActive ? Colors.blue : Colors.grey[600],
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
                      color: index < pin.length
                          ? isActive ? Colors.blue : Colors.grey
                          : Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, {bool isSpecial = false, bool isSwitch = false}) {
    return Material(
      elevation: 2,
      color: isSpecial ? Colors.grey[100] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (isSwitch) {
            _switchPinField();
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
              color: isSpecial ? Colors.grey[600] : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}