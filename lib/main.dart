import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ekumpas_beta/onboboarding/onboarding_view.dart';
import 'package:ekumpas_beta/pages/online_pages/landing_page/landingpage.dart';
import 'package:ekumpas_beta/pages/welcome_page/welcomepage.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences prefs;

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    print("Failed to initialize SharedPreferences: $e");
    return;
  }

  // Initialize Realm
  try {
    await RealmServices.instance.initializeRealm();
  } catch (e) {
    print("Failed to initialize Realm: $e");
  }

  String? token = prefs.getString('token');
  final onBoarding = prefs.getBool('onBoarding') ?? true;

  // Check for internet connectivity
  bool isConnected = false;
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    }
  } catch (e) {
    print("Failed to check connectivity: $e");
  }

  runApp(MyApp(
    token: token,
    onBoarding: onBoarding,
    isConnected: isConnected,
  ));
}

class MyApp extends StatelessWidget {
  final bool onBoarding;
  final String? token;
  final bool isConnected;

  const MyApp({
    required this.token,
    required this.onBoarding,
    required this.isConnected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String? localToken = token; // Local variable for token

    // Debug prints for tracking state
    print("Local Token: $localToken");
    print("Is Connected: $isConnected");
    print(
        "Is Token Expired: ${localToken != null ? JwtDecoder.isExpired(localToken) : true}");

    return ChangeNotifierProvider(
      create: (context) => UiProvider()..init(),
      child: Consumer<UiProvider>(builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: notifier.darkTheme,
          theme: notifier.lightTheme,
          home: onBoarding
              ? const OnBoardingView()
              : (localToken == null || !isConnected)
                  ? const WelcomePage()
                  : LandingPage(token: localToken),
        );
      }),
    );
  }
}
