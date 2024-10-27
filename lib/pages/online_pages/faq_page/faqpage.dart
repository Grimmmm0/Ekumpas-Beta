import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FAQs'),
          centerTitle: true,
        ),
        body: ListView(
          children: const [
            ExpansionTile(
              title: Text(
                  'What makes Filipino Sign Language (FSL) unique?What makes Filipino Sign Language (FSL) unique?'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text(
                      'FSL has its own grammar, syntax, and morphology. It’s not directly based on Filipino or English, so learning FSL is crucial for effectively communicating with those who use it.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How do I use the text-to-sign feature?'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text(
                      'Simply type the text you want to convert into sign language, and the app will display animated signs in FSL for each word. This helps you understand and learn sign language in real-time.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Can I download the app on multiple devices?'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text(
                      'Yes, you can download E-Kumpas on any supported device. Your app activity and progress can be synced if you use the same login credentials across devices.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How accurate are the FSL animations?'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text(
                      'We work closely with FSL experts to ensure the animations are accurate and culturally appropriate, but we are continually improving based on user feedback.'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
