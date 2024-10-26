import 'dart:convert';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart';
import 'package:ekumpas_beta/pages/online_pages/forgot_password_page/forgotpasswordpage.dart';
import 'package:ekumpas_beta/pages/online_pages/landing_page/landingpage.dart';
import 'package:ekumpas_beta/pages/online_pages/signup_page/signup.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:ekumpas_beta/pages/online_pages/signup_page/signupverificationpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;
  bool _isLoading = false;
  bool _obscureText = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    initSharedPref();
    checkLoggedIn();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> checkLoggedIn() async {
    String? token = prefs.getString('token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(token: token),
        ),
      );
    }
  }

  // Function to show a toast message
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

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous error message
    });

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (response.statusCode == 200 && jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          await prefs.setString('token', myToken); // Save the token

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(token: myToken),
            ),
          );

          // Show success toast
          _showToastMessage(
              'Login successful!', Icons.check_circle, Colors.green);
        } else {
          // Handle unauthorized login (wrong email or password)
          if (response.statusCode == 401) {
            String message =
                jsonResponse['message'] ?? 'Incorrect email or password';
            _setErrorMessage(response.statusCode, message);

            // Show the error toast message
            _showToastMessage(message, Icons.error, Colors.red);
          } else if (response.statusCode == 403) {
            String message = jsonResponse['message'] ??
                'User is not verified. Please check your email.';
            _setErrorMessage(response.statusCode, message);
          } else if (response.statusCode == 404) {
            String message = jsonResponse['message'] ?? 'User does not exist.';
            _setErrorMessage(response.statusCode, message);
          } else {
            // Handle other error statuses
            String message = jsonResponse['message'] ??
                'An unexpected error occurred. Please try again.';
            _setErrorMessage(response.statusCode, message);

            // Show the error toast message
            _showToastMessage(message, Icons.error, Colors.red);
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Could not connect to the server. Please check your internet connection or try again later.';
        });

        // Show network error toast
        _showToastMessage('Network error: $e', Icons.error, Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
        _errorMessage =
            'Please fill in all fields'; // Set error message for validation
      });

      // Show validation error toast
      _showToastMessage(
          'Please fill in all fields', Icons.warning, Colors.orange);
    }
  }

  void _setErrorMessage(int statusCode, String message) {
    setState(() {
      if (statusCode == 400) {
        _errorMessage = 'Invalid input data';
      } else if (statusCode == 403) {
        _errorMessage = 'Account not verified. Please verify your email.';

        // Redirect to OTP verification page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SignUpVerificationPage(email: emailController.text),
          ),
        );
      } else if (statusCode == 401 || statusCode == 404) {
        _errorMessage = message;
      } else {
        _errorMessage =
            'An unexpected error occurred. Please try again later. (Error code: $statusCode)';
      }
      _showToastMessage(message, Icons.error, Colors.red);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context); // Navigates to the previous screen
    return false; // Prevents the default back navigation
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 18, 22, 60),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Image.asset(
                        "assets/images/loginsc.gif",
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('Email',
                              style: TextStyle(color: Colors.black)),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
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
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        obscuringCharacter: '*',
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('Password',
                              style: TextStyle(color: Colors.black)),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      // Display the error message
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 18, 22, 60),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    setState(() {
                                      _isNotValidate = true;
                                    });
                                    _showToastMessage(
                                        'Please fill in all fields',
                                        Icons.warning,
                                        Colors.orange);
                                  } else {
                                    loginUser();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 18, 22, 60),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 25.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Don’t have an account? Sign Up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 18, 22, 60),
                            fontWeight: FontWeight.bold,
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
