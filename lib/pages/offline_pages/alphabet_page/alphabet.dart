import 'package:flutter/material.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/pages/offline_pages/categories_detail.dart';
import 'package:ekumpas_beta/services/realm_services.dart';

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
    try {
      final allSignLanguage = RealmServices.instance.getSignLanguage();
      final alphabets = allSignLanguage
          .where((word) => word.category == 'Alphabet')
          .toList()
        ..sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        signlanguage = alphabets;
      });
    } catch (e) {
      print("Error fetching data: $e"); // Debug line
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
          "Alphabets",
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
            final alphabet = signlanguage[index];
            return Card(
              color: const Color.fromRGBO(66, 87, 136, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(
                  alphabet.title,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                subtitle: Text(
                  alphabet.category,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                onTap: () {
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
  }
}
