import 'dart:convert';
import 'dart:io';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/online_pages/login_page/login.dart';
import 'package:ekumpas_beta/pages/online_pages/signup_page/signupverificationpage.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

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

  // Function to show Toast Messages
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

  // Function to handle user registration
  // Function to handle user registration
  void registerUser() async {
    if (_formSignupKey.currentState!.validate()) {
      if (!agreePersonalData) {
        _showToastMessage(
          'Please agree to the processing of personal data.',
          Icons.warning,
          Colors.orange,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        var regBody = {
          "email": emailController.text,
          "password": passwordController.text,
        };

        var response = await http
            .post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            setState(() {
              _isLoading = false;
            });
            _showToastMessage(
              'The request timed out. Please check your internet connection and try again.',
              Icons.error,
              Colors.red,
            );
            return http.Response('Error', 408);
          },
        );

        if (response.statusCode == 201) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SignUpVerificationPage(email: emailController.text),
              ),
            );
            _showToastMessage(
              'OTP was sent to your email',
              Icons.check_circle,
              Colors.green,
            );
          } else {
            _showToastMessage(
              jsonResponse['message'] ?? 'Registration failed',
              Icons.error,
              Colors.red,
            );
          }
        } else if (response.statusCode == 400) {
          _showToastMessage(
            'Invalid input data. Please check your email and password.',
            Icons.error,
            Colors.red,
          );
        } else if (response.statusCode == 409) {
          _showToastMessage(
            'Email already in use. Please try a different email.',
            Icons.error,
            Colors.red,
          );
        } else {
          _showToastMessage(
            'Server error: ${response.statusCode}. Please try again later.',
            Icons.error,
            Colors.red,
          );
        }
      } on SocketException catch (_) {
        _showToastMessage(
          'No Internet connection. Please check your connection and try again.',
          Icons.error,
          Colors.red,
        );
      } catch (e) {
        _showToastMessage(
          'Unexpected error: $e. Please try again.',
          Icons.error,
          Colors.red,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showToastMessage(
        'Please fill in all of the required fields properly.',
        Icons.warning,
        Colors.orange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 18, 22, 60),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      // Email
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('Email',
                              style: TextStyle(color: Colors.black)),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          if (!_isStrongPassword(value)) {
                            return '\tPassword must be at least 8 characters long,\n including an uppercase letter,a lowercase letter,\n a number, and a special character.';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('Password',
                              style: TextStyle(color: Colors.black)),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Password Strength Indicator
                      if (passwordController.text.isNotEmpty)
                        Text(
                          _isStrongPassword(passwordController.text)
                              ? 'Strong Password'
                              : 'Weak Password',
                          style: TextStyle(
                            color: _isStrongPassword(passwordController.text)
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 25.0),
                      // Confirm Password
                      TextFormField(
                        obscureText: _obscureConfirmPassword,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm Password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('Confirm Password',
                              style: TextStyle(color: Colors.black)),
                          hintText: 'Re-enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'I agree to the processing of personal data',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: agreePersonalData,
                        onChanged: (bool? value) {
                          setState(() {
                            agreePersonalData = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: 200.0,
                        height: 45.0,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 18,
                                      22, 80), // Constant blue background
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10), // Padding for the button
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  ),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 25.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color.fromARGB(255, 18, 22, 60),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
