import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  int? _expandedTileIndex; // To track the currently expanded tile

  Future<List<Updates>> _fetchUpdates() async {
    final realmServices = RealmServices.instance;
    List<Updates> updates = await realmServices.getUpdates();

    // Sort updates from latest to recent based on updatedAt
    updates.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return updates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Updates>>(
        future: _fetchUpdates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No updates available.'));
          } else {
            final updates = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: updates.length,
              itemBuilder: (context, index) {
                final update = updates[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ExpansionTile(
                    key: Key(index.toString()),
                    tilePadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            update.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(update.updatedAt.toLocal()),
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    initiallyExpanded: _expandedTileIndex == index,
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        _expandedTileIndex = isExpanded ? index : null;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              update.description,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Download apk here:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.file_download,
                                      color: Colors.blue),
                                  tooltip: 'Download Update',
                                  onPressed: () {
                                    _downloadUpdate(update.link);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _downloadUpdate(String link) async {
    print('Attempting to launch: $link');
    try {
      await launchUrlString(link);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
