import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart';
import 'package:ekumpas_beta/pages/online_pages/forgot_password_page/resetpasswordpage.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class OTPConfirmationPage extends StatefulWidget {
  final String email;

  const OTPConfirmationPage({super.key, required this.email});

  @override
  _OTPConfirmationPageState createState() => _OTPConfirmationPageState();
}

class _OTPConfirmationPageState extends State<OTPConfirmationPage> {
  final _otpControllers = List.generate(6, (index) => TextEditingController());
  bool _isLoading = false;
  String _message = '';

  // Method to show toast messages
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

  String getOtp() {
    return _otpControllers.map((controller) => controller.text).join('');
  }

  Future<void> verifyOTP() async {
    final otp = getOtp();
    if (otp.length < 6) {
      _showToastMessage(
          'Please enter a 6-digit OTP', Icons.warning, Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    var reqBody = {
      "email": widget.email,
      "otp": otp,
    };

    var response = await http.post(
      Uri.parse(verifyResetOTP), // Define this in config.dart
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    setState(() {
      _isLoading = false;
      _message = jsonResponse['message'];
      if (jsonResponse['status']) {
        _showToastMessage(
            'OTP Verified! Redirecting...', Icons.check_circle, Colors.green);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: widget.email),
          ),
        );
      } else {
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
                    const SizedBox(height: 20),
                    Expanded(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'OTP Confirmation',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 18, 22, 60),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: Image.asset(
                                'assets/images/otpgif.gif',
                                height: screenSize.height * 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // OTP Input Boxes (6 digits)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: screenSize.width * 0.12,
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: '0',
                                      hintStyle: const TextStyle(
                                          color: Colors.black26),
                                      counterText: '',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (value) {
                                      if (value.length == 1 && index < 5) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                      if (value.isEmpty && index > 0) {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 30),
                            // Submit OTP Button
                            _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: verifyOTP,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 18, 22, 80),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Submit OTP',
                                      style: TextStyle(color: Colors.white),
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
