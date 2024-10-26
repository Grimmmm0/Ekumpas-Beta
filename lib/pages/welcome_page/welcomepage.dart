import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ekumpas_beta/pages/offline_pages/all_for_one_page/allforone_page.dart';
import 'package:ekumpas_beta/pages/online_pages/landing_page/landingpage.dart';
import 'package:ekumpas_beta/pages/online_pages/login_page/login.dart';
import 'package:ekumpas_beta/widgets/custom_scaffold.dart';
import 'package:ekumpas_beta/widgets/welcome_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late SharedPreferences prefs;

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> checkLoggedIn() async {
    String? token = prefs.getString('token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      // Check internet connection before redirecting to LandingPage
      bool isConnected = await checkInternetConnection();
      if (isConnected) {
        // Redirect to LandingPage if token is valid and internet is available
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(token: token),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        // Show a dialog if there's no internet connection
        showNoInternetDialog();
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none; // True if connected
  }

  void showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text(
              "Internet connection is required to access Online feature."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initSharedPref().then((_) => checkLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Dynamic text size based on screen height
              Flexible(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 30.0,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome!\n',
                            style: TextStyle(
                              fontSize: screenHeight * 0.05, // Adapt text size
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '\nEkumpas Connecting People',
                            style: TextStyle(
                              fontSize: screenHeight * 0.025, // Adapt text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Adjust button size based on screen width
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Offline',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllForOnePage(),
                              ),
                            );
                          },
                          color: Colors.transparent,
                          textColor: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Online',
                          onTap: () async {
                            bool isConnected = await checkInternetConnection();
                            if (isConnected) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } else {
                              showNoInternetDialog();
                            }
                          },
                          color: Colors.white,
                          textColor: const Color.fromARGB(255, 18, 22, 60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
