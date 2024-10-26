import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/images/team.gif',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'E-Kumpas',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Version 1.0.0 Beta',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'E-Kumpas is an application designed to translate text into Filipino Sign Language (FSL) through animations. It helps individuals learn and connect with the deaf and hard-of-hearing community. E-Kumpas targets both those with hearing impairments and hearing persons seeking to communicate effectively. It offers essential tools like the alphabet, common words, greetings, and survival signs. By bridging communication barriers, E-Kumpas promotes accessibility, opportunities, and appreciation of Filipino deaf culture through the educational use of FSL.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Follow Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      launchUrlString(
                          "https://github.com/XjorLml/E-Kumpas_Mobile_App/releases/tag/v1.0.0-beta");
                    },
                    icon: const Icon(LucideIcons.github, size: 30),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      launchUrlString("https://ekumpas.vercel.app/");
                    },
                    icon: const Icon(Icons.web, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: powerpupbois@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                'Phone: +69672059239',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    });
  }
}
