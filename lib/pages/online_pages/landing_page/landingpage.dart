import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/alphabet_page/alphabet.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/commonwords_page/commonwords.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/greetings_page/greetings.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/questions_page/questions.dart';
import 'package:ekumpas_beta/pages/online_pages/module_pages/level_1_page/level_1_categories_pages/survivalsigns_page/survivalsigns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ekumpas_beta/pages/online_pages/home_page/home.dart';
import 'package:ekumpas_beta/pages/online_pages/favorite_page/favoritepage.dart';
import 'package:ekumpas_beta/pages/welcome_page/welcomepage.dart';
import 'package:ekumpas_beta/widgets/all_for_one_body.dart';
import 'package:ekumpas_beta/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  final String token;

  const LandingPage({required this.token, Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late String email = "";
  late int userLevel = 1;

  @override
  void initState() {
    super.initState();
    _storeEmail();
  }

  Future<void> _storeEmail() async {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    userLevel = jwtDecodedToken['level'];
    
    // Save email to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setInt('userLevel', userLevel);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userLevel');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, UiProvider notifier, child) {
        return Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            title: Text(
              "E-Kumpas",
              style: TextStyle(
                color: notifier.isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.auto_awesome_mosaic),
                onPressed: () {
                  Navigator.push(
                    context,
                   MaterialPageRoute(
                      builder: (context) => Home(userLevel: userLevel),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoritesPage(
                              email: email,
                            )),
                  );
                },
              ),
            ],
          ),
          drawer: Sidebar(email: email, logout: logout),
          body: const AllForOneBody(),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.view_list,
            backgroundColor:
                Theme.of(context).floatingActionButtonTheme.backgroundColor,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.question_mark_rounded),
                backgroundColor: Colors.purpleAccent,
                label: 'Questions',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: notifier.isDark ? Colors.white : Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuestionsPage()),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.sos_rounded),
                backgroundColor: Colors.redAccent,
                label: 'Survival',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: notifier.isDark ? Colors.white : Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SurvivalSignsPage()),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.question_answer_rounded),
                backgroundColor: Colors.greenAccent,
                label: 'Greetings',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: notifier.isDark ? Colors.white : Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GreetingsPage()),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.chat_rounded),
                backgroundColor: Colors.amberAccent,
                label: 'Common Words',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: notifier.isDark ? Colors.white : Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CommonWordsPage()),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.abc_rounded),
                backgroundColor: Colors.blueAccent,
                label: 'Alphabet',
                labelStyle: TextStyle(
                  fontSize: 24,
                  color: notifier.isDark ? Colors.white : Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AlphabetPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
