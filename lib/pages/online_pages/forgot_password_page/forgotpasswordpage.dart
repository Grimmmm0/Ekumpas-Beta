import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart'; // Adjust your config import
import 'forgotpasswordverificationpage.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  // Method to show toast message
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

  Future<void> requestPasswordReset() async {
    setState(() {
      _isLoading = true;
    });

    var reqBody = {
      "email": emailController.text,
    };

    var response = await http.post(
      Uri.parse(forgotPassword), // Define this in config.dart
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    setState(() {
      _isLoading = false;
      _message = jsonResponse['message'];

      if (jsonResponse['status']) {
        // Success message
        _showToastMessage(
            'Password reset link sent!', Icons.check_circle, Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPConfirmationPage(email: emailController.text),
          ),
        );
      } else {
        // Error message
        _showToastMessage(_message, Icons.error, Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CustomScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(height: 10),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          screenSize.width * 0.05, // 5% left/right padding
                          screenSize.height * 0.05, // 5% top padding
                          screenSize.width * 0.05,
                          screenSize.height * 0.03, // 3% bottom padding
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 18, 22, 60),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Centered GIF
                            Center(
                              child: Image.asset(
                                'assets/images/fpassword.gif',
                                height:
                                    screenSize.height * 0.2, // Responsive size
                                width: screenSize.height * 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Email Label
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 18, 22, 60),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Email Input
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Enter your email',
                                hintStyle:
                                    const TextStyle(color: Colors.black26),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Request Password Reset Button
                            SizedBox(
                              width: double.infinity,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: requestPasswordReset,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 18, 22, 80),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Request Password Reset',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
