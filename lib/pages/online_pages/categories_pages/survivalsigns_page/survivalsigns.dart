import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/online_pages/online_categories_detail.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:provider/provider.dart';

class SurvivalSignsPage extends StatefulWidget {
  const SurvivalSignsPage({super.key});

  @override
  State<SurvivalSignsPage> createState() => _SurvivalSignsPageState();
}

class _SurvivalSignsPageState extends State<SurvivalSignsPage> {
  List<SignLanguage> signlanguage = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final allSignLanguage = RealmServices.instance.getSignLanguage();
    final survivalsigns = allSignLanguage
        .where((word) => word.category == 'Survival Signs')
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    setState(() {
      signlanguage = survivalsigns;
    });
    if (kDebugMode) {
      print(survivalsigns);
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
            "Survival Signs",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: signlanguage.length,
            itemBuilder: (context, index) {
              final survivalsign = signlanguage[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    survivalsign.title,
                  ),
                  subtitle: Text(
                    survivalsign.category,
                  ),
                  onTap: () async {
                    await RealmServices.instance
                        .updateFrequency(survivalsign.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignLanguageDetailPage(
                          signLanguage: survivalsign,
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
