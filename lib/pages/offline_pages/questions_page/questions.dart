import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/offline_pages/categories_detail.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  List<SignLanguage> signlanguage = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final allSignLanguage = RealmServices.instance.getSignLanguage();
    final questions = allSignLanguage
        .where((word) => word.category == 'Questions')
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    setState(() {
      signlanguage = questions;
    });
    if (kDebugMode) {
      print(questions);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Questions",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(66, 87, 136, 0.3),
      ),
      backgroundColor: const Color.fromRGBO(18, 22, 60, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: signlanguage.length,
          itemBuilder: (context, index) {
            final question = signlanguage[index];
            return Card(
              color: const Color.fromRGBO(66, 87, 136, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(
                  question.title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: Text(
                  question.category,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignLanguageDetailPage(
                        signLanguage: question,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
