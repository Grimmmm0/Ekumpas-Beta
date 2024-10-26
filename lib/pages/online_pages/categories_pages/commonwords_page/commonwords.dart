import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/online_pages/online_categories_detail.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:provider/provider.dart';

class CommonWordsPage extends StatefulWidget {
  const CommonWordsPage({super.key});

  @override
  State<CommonWordsPage> createState() => _CommonWordsPageState();
}

class _CommonWordsPageState extends State<CommonWordsPage> {
  List<SignLanguage> signlanguage = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final allSignLanguage = RealmServices.instance.getSignLanguage();
    final words = allSignLanguage
        .where((word) => word.category == 'Common Words')
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    setState(() {
      signlanguage = words;
    });
    if (kDebugMode) {
      print(words);
    }
  }

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
          title: const Text(
            "Common Words",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: signlanguage.length,
            itemBuilder: (context, index) {
              final word = signlanguage[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    word.title,
                  ),
                  subtitle: Text(
                    word.category,
                  ),
                  onTap: () async {
                    await RealmServices.instance.updateFrequency(word.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignLanguageDetailPage(
                          signLanguage: word,
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
    });
  }
}
