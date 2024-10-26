import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:provider/provider.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FAQs'),
          centerTitle: true,
        ),
        body: ListView(
          children: const [
            ExpansionTile(
              title: Text('Question 1'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text('Answer 1'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Question 2'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text('Answer 2'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Question 2'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text('Answer 2'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Question 2'),
              leading: Icon(Icons.question_answer),
              children: [
                ListTile(
                  title: Text('Answer 2'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
