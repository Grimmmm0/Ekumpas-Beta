import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart';
import 'package:ekumpas_beta/pages/online_pages/login_page/login.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Password strength criteria
  bool _isStrongPassword(String password) {
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return password.length >= 8 &&
        hasUppercase &&
        hasDigits &&
        hasSpecialCharacters;
  }

  // Toast notification method
  void _showToastMessage(String message, IconData icon, Color color) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        leading: Icon(icon, size: 28, color: color),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }

  Future<void> resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = ''; // Reset message before checking
    });

    // Check if password fields are empty
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showToastMessage(
          'Please fill in all fields!', Icons.warning, Colors.orange);
      return;
    }

    // Check if the passwords match
    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        _isLoading = false;
      });
      _showToastMessage('Passwords do not match!', Icons.error, Colors.red);
      return;
    }

    // Check if the password is strong enough
    if (!_isStrongPassword(newPasswordController.text)) {
      setState(() {
        _isLoading = false;
      });
      _showToastMessage(
          'Password must be at least 8 characters long, including an uppercase letter, a lowercase letter, a number, and a special character.',
          Icons.warning,
          Colors.orange);
      return;
    }

    // Proceed with the password reset request if everything is valid
    var reqBody = {
      "email": widget.email,
      "newPassword": newPasswordController.text,
    };

    var response = await http.post(
      Uri.parse(setNewPassword), // Use the correct endpoint here
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    setState(() {
      _isLoading = false;
      _message = jsonResponse['message'];

      if (jsonResponse['status']) {
        // Show success toast and navigate to login page
        _showToastMessage(
            'Password successfully changed!', Icons.check_circle, Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        // Show error message in a toast if password change fails
        _showToastMessage(_message, Icons.error, Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 18, 22, 60),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // New Password Field
                  TextField(
                    controller: newPasswordController,
                    obscureText: _obscureNewPassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'New Password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Password Strength Indicator
                  if (newPasswordController.text.isNotEmpty)
                    Text(
                      _isStrongPassword(newPasswordController.text)
                          ? 'Strong Password'
                          : 'Weak Password',
                      style: TextStyle(
                        color: _isStrongPassword(newPasswordController.text)
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Confirm Password Field
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Confirm New Password',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Reset Password Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 18, 22, 80),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
