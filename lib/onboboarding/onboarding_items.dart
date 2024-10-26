import 'package:ekumpas_beta/onboboarding/onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Welcome to E-Kumpas",
        descriptions: "Translating text into Filipino Sign Language",
        image: "assets/images/screen1.gif"),
    OnboardingInfo(
        title: "What is E-Kumpas?",
        descriptions:
            "It is a mobile application that helps individuals connect to people with varying hearing abilities and also to learn Filipino sign Language.",
        image: "assets/images/screen2.gif"),
    OnboardingInfo(
        title: "What is FSL?",
        descriptions:
            "Filipino Sign Language (FSL) is a sign language that originated in the Philippines. Like other sign languages such as ASL, ISL, BSL, etc. FSL is a unique language with its own grammar, syntax, and morphology; it is neither based on nor resembles Filipino or English.",
        image: "assets/images/screen3.gif"),
    OnboardingInfo(
        title: "How to use?",
        descriptions: "1. Choose Between Online Mode and Offline Mode.\n"
            "2. On the primary translation page, enter the translation you want.\n"
            "3. If unsure, navigate through our translations using the Floating Action Button or Categories Button.\n"
            "4. Use the sidebar to customize themes, save and access your favorites, provide feedback, learn more about the app, and view FAQs.\n",
        image: "assets/images/screen4.gif"),
  ];
}
