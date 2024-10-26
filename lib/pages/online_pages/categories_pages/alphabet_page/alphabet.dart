import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/pages/online_pages/online_categories_detail.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:provider/provider.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  @override
  State<AlphabetPage> createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  List<SignLanguage> signlanguage = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final allSignLanguage = RealmServices.instance.getSignLanguage();
    final alphabets = allSignLanguage
        .where((word) => word.category == 'Alphabet')
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    setState(() {
      signlanguage = alphabets;
    });
    if (kDebugMode) {
      print(alphabets);
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
            "Alphabets",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: signlanguage.length,
            itemBuilder: (context, index) {
              final alphabet = signlanguage[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    alphabet.title,
                  ),
                  subtitle: Text(
                    alphabet.category,
                  ),
                  onTap: () async {
                    await RealmServices.instance
                        .updateFrequency(alphabet.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignLanguageDetailPage(
                          signLanguage: alphabet,
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
