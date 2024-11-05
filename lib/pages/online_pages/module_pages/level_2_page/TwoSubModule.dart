// ignore_for_file: avoid_unnecessary_containers, sort_child_properties_last

import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/alphabet_page/alphabet.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/commonwords_page/commonwords.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/greetings_page/greetings.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/questions_page/questions.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/survivalsigns_page/survivalsigns.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';

class TwoSubModulePage extends StatelessWidget {
  const TwoSubModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          title: Text(
            "Level 2",
            style: TextStyle(
              color: notifier.isDark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: GridView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlphabetPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 18, 22, 60),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.abc_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                        Text(
                          "Alphabet",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommonWordsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 18, 22, 60),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          "Common",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Words",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuestionsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 18, 22, 60),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.question_mark,
                          size: 80,
                          color: Colors.white,
                        ),
                        Text(
                          "Questions",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GreetingsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 18, 22, 60),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.safety_divider_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                        Text(
                          "Greetings",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SurvivalSignsPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 18, 22, 60),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.safety_check_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          "Survival",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Signs",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 40,
                crossAxisSpacing: 40,
              ),
            ),
          ),
        ),
      );
    });
  }
}
