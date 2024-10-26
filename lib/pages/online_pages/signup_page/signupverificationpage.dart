import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ekumpas_beta/config.dart';
import 'package:ekumpas_beta/pages/online_pages/login_page/login.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class SignUpVerificationPage extends StatefulWidget {
  final String email;

  const SignUpVerificationPage({super.key, required this.email});

  @override
  State<SignUpVerificationPage> createState() => _SignUpVerificationPageState();
}

class _SignUpVerificationPageState extends State<SignUpVerificationPage> {
  final _otpControllers = List.generate(6, (index) => TextEditingController());
  String _errorMessage = '';
  bool _isLoading = false;

  // Function to display toast notifications
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

  Future<void> verifyOtp() async {
    final otp = getOtp();

    if (otp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit OTP';
      });
      _showToastMessage(
          'Please enter a valid 6-digit OTP!', Icons.warning, Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var response = await http.post(
        Uri.parse(verifyOTP), // assuming verifyOTP is the correct endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': widget.email,
          'otp': otp,
        }),
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status']) {
        // OTP is valid, show success toast and navigate to login page
        _showToastMessage(
            'OTP Verified Successfully!', Icons.check_circle, Colors.green);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("OTP Verified Successfully!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _errorMessage = jsonResponse['message'] ?? 'Invalid OTP';
        });
        _showToastMessage(_errorMessage, Icons.error, Colors.red);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
      });
      _showToastMessage('Network error: $e', Icons.wifi_off, Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 18, 22, 60),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Image.asset(
                                'assets/images/otpgif.gif',
                                height: screenSize.height * 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width:
                                      screenSize.width * 0.12, // Adjust width
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
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: verifyOtp,
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
                                        'Verify OTP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                            ),
                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _errorMessage,
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
