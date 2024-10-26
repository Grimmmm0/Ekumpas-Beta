import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/offline_pages/alphabet_page/alphabet.dart';
import 'package:ekumpas_beta/pages/offline_pages/commonwords_page/commonwords.dart';
import 'package:ekumpas_beta/pages/offline_pages/greetings_page/greetings.dart';
import 'package:ekumpas_beta/pages/offline_pages/questions_page/questions.dart';
import 'package:ekumpas_beta/pages/offline_pages/survivalsigns_page/survivalsigns.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double iconSize = mediaQuery.size.width * 0.15;
    final double fontSizeLarge = mediaQuery.size.width * 0.06;
    final double fontSizeMedium = mediaQuery.size.width * 0.045;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          "E-kumpas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(66, 87, 136, 0.3),
      ),
      backgroundColor: const Color.fromRGBO(18, 22, 60, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            double mainAxisSpacing = constraints.maxWidth > 600 ? 30 : 20;
            double crossAxisSpacing = constraints.maxWidth > 600 ? 30 : 20;

            return GridView.builder(
              itemCount: 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _navigateToPage(context, index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(66, 87, 136, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildGridItems(
                        index,
                        iconSize,
                        fontSizeLarge,
                        fontSizeMedium,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlphabetPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommonWordsPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuestionsPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GreetingsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SurvivalSignsPage()),
        );
        break;
    }
  }

  List<Widget> _buildGridItems(
      int index, double iconSize, double fontSizeLarge, double fontSizeMedium) {
    switch (index) {
      case 0:
        return [
          Icon(Icons.abc_rounded, size: iconSize, color: Colors.white),
          Text("Alphabet",
              style: TextStyle(color: Colors.white, fontSize: fontSizeLarge)),
        ];
      case 1:
        return [
          Icon(Icons.chat_rounded, size: iconSize, color: Colors.white),
          Text("Common",
              style: TextStyle(color: Colors.white, fontSize: fontSizeMedium)),
          Text("Words",
              style: TextStyle(color: Colors.white, fontSize: fontSizeMedium)),
        ];
      case 2:
        return [
          Icon(Icons.question_mark, size: iconSize, color: Colors.white),
          Text("Questions",
              style: TextStyle(color: Colors.white, fontSize: fontSizeLarge)),
        ];
      case 3:
        return [
          Icon(Icons.safety_divider_rounded,
              size: iconSize, color: Colors.white),
          Text("Greetings",
              style: TextStyle(color: Colors.white, fontSize: fontSizeLarge)),
        ];
      case 4:
        return [
          Icon(Icons.safety_check_rounded, size: iconSize, color: Colors.white),
          Text("Survival",
              style: TextStyle(color: Colors.white, fontSize: fontSizeMedium)),
          Text("Signs",
              style: TextStyle(color: Colors.white, fontSize: fontSizeMedium)),
        ];
      default:
        return [];
    }
  }
}
