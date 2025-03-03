import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Constants/sizes.dart';
import 'package:online_banking_system/Screens/password_creation_screen.dart';
import 'RegistrationPage.dart';
import 'ForgotPassword.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  bool isBiometricAvailable = false;
  List<BiometricType> availableBiometrics = [];
  String biometricType = "biometric";
  bool isBiometricEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool canAuthenticate = await auth.isDeviceSupported();

      // Get available biometric types
      if (canCheckBiometrics && canAuthenticate) {
        List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

        setState(() {
          this.isBiometricAvailable = canCheckBiometrics && canAuthenticate;
          this.availableBiometrics = availableBiometrics;

          // Set biometric type for better UX messaging
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            biometricType = "fingerprint";
          } else if (availableBiometrics.contains(BiometricType.face)) {
            biometricType = "face recognition";
          }
        });

        // Check if biometrics are already enabled for any account
        await _checkBiometricEnabled();
      }
    } catch (e) {
      print("Error checking biometrics: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error checking biometrics: $e"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _checkBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> biometricUsers = {};

      // Get all stored keys
      final keys = prefs.getKeys();

      // Filter biometric keys
      for (String key in keys) {
        if (key.endsWith('_biometric_enabled')) {
          final email = key.replaceAll('_biometric_enabled', '');
          final isEnabled = prefs.getBool(key) ?? false;
          if (isEnabled) {
            biometricUsers[email] = true;
          }
        }
      }

      setState(() {
        // Check if there's at least one account with biometrics enabled
        isBiometricEnabled = biometricUsers.isNotEmpty;
      });
    } catch (e) {
      print("Error checking biometric status: $e");
    }
  }

  Future<bool> _isBiometricEnabledForUser(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('${email}_biometric_enabled') ?? false;
    } catch (e) {
      print("Error checking user biometric status: $e");
      return false;
    }
  }

  Future<void> _enableBiometricForUser(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store email and password securely for future biometric login
      await prefs.setString('${email}_secured_email', email);
      // In a real app, you would encrypt the password or use a more secure method
      // This is just for demonstration
      await prefs.setString('${email}_secured_password', _passwordController.text);

      // Mark biometrics as enabled for this user
      await prefs.setBool('${email}_biometric_enabled', true);

      setState(() {
        isBiometricEnabled = true;
      });
    } catch (e) {
      print("Error enabling biometrics: $e");
    }
  }

  Future<Map<String, String>> _getBiometricCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Find any user with biometrics enabled
      for (String key in keys) {
        if (key.endsWith('_biometric_enabled') && prefs.getBool(key) == true) {
          final email = key.replaceAll('_biometric_enabled', '');
          final storedEmail = prefs.getString('${email}_secured_email');
          final storedPassword = prefs.getString('${email}_secured_password');

          if (storedEmail != null && storedPassword != null) {
            return {
              'email': storedEmail,
              'password': storedPassword,
            };
          }
        }
      }
      return {};
    } catch (e) {
      print("Error retrieving biometric credentials: $e");
      return {};
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      // This will show the system dialog for fingerprint/face authentication
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate using your $biometricType to login',
        options: const AuthenticationOptions(
          stickyAuth: true, // Authentication dialog persists until completed/canceled
          biometricOnly: true, // Only use biometrics, no PIN/pattern fallback
          useErrorDialogs: true, // Display OS-provided error dialogs for better UX
        ),
      );

      if (isAuthenticated) {
        // If authenticated, check if we need to register biometrics or log in
        if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          // Check if this user already has biometrics enabled
          bool isEnabled = await _isBiometricEnabledForUser(_emailController.text);

          if (!isEnabled) {
            // Register biometrics for this user
            await _enableBiometricForUser(_emailController.text);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Biometric authentication registered successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ));
          }

          // Perform login
          _performLogin(_emailController.text, _passwordController.text);
        } else {
          // Get stored credentials for biometric login
          final credentials = await _getBiometricCredentials();

          if (credentials.isNotEmpty) {
            // Use the stored credentials to login
            _performLogin(credentials['email']!, credentials['password']!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No credentials found for biometric login. Please enter your email and password first."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ));
          }
        }
      }
    } on PlatformException catch (e) {
      String message;

      switch (e.code) {
        case auth_error.notEnrolled:
          message = "No $biometricType enrolled on this device. Please set up $biometricType in your device settings.";
          break;
        case auth_error.lockedOut:
          message = "$biometricType authentication temporarily locked. Please try again later.";
          break;
        case auth_error.permanentlyLockedOut:
          message = "$biometricType authentication permanently locked. Please use password to login.";
          break;
        case auth_error.notAvailable:
          message = "$biometricType authentication is not available on this device.";
          break;
        default:
          message = "Authentication error: ${e.message}";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Authentication failed: $e"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _performLogin(String email, String password) {
    // For a real app, verify credentials against your backend here
    // This is just a placeholder for demonstration

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Login successful!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PasswordCreationScreen()),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      _performLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: kTopBar,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Log in to continue to your account.",
                style: TextStyle(
                  fontSize: 20,
                  color: kTextColorLightTheme,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: kTextColorLightTheme),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: kTextColorLightTheme),
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onLoginPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: kButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: kTextSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: kTextColorLightTheme,
                      fontSize: kTextSize,
                    ),
                  ),
                ),
              ),
              if (isBiometricAvailable)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _authenticateWithBiometrics,
                        icon: Icon(
                          availableBiometrics.contains(BiometricType.fingerprint)
                              ? Icons.fingerprint
                              : Icons.face,
                          color: Colors.white,
                        ),
                        label: Text(
                          isBiometricEnabled
                              ? "Login with $biometricType"
                              : "Register $biometricType",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          backgroundColor: kButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    if (isBiometricEnabled)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Tip: You can login directly with $biometricType without entering credentials",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextColorLightTheme,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: kTextColorLightTheme,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}