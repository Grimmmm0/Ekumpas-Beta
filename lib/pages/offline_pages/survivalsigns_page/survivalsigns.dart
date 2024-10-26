import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ekumpas_beta/pages/offline_pages/categories_detail.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';

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
        .toList();
    setState(() {
      signlanguage = survivalsigns;
    });
    if (kDebugMode) {
      print(survivalsigns);
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
          "Survival Signs",
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
            final survivalsign = signlanguage[index];
            return Card(
              color: const Color.fromRGBO(66, 87, 136, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(
                  survivalsign.title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: Text(
                  survivalsign.category,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                onTap: () {
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
  }
}
