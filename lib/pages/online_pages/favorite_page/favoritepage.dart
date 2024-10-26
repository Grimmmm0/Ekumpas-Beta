import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:ekumpas_beta/pages/online_pages/online_categories_detail.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FavoritesPage extends StatefulWidget {
  final String email;

  const FavoritesPage({Key? key, required this.email}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<SignLanguage> favorites = [];
  FlickManager? flickManager;
  late Directory tempDir;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _initializeTempDir();
  }

  Future<void> _initializeTempDir() async {
    tempDir = await getTemporaryDirectory();
  }

  void _loadFavorites() {
    setState(() {
      favorites = RealmServices.instance.getFavorites(widget.email)
        ..sort((a, b) => a.title.compareTo(b.title));
    });
  }

  Future<void> _playVideo(String filename) async {
    final videoPath = '${tempDir.path}/$filename';
    if (await File(videoPath).exists()) {
      _initializeVideo(videoPath);
    } else {
      if (await _hasInternetConnection()) {
        final videoData = await RealmServices.instance.fetchVideoData(filename);
        if (videoData.isNotEmpty) {
          final file = File(videoPath);
          await file.writeAsBytes(videoData);
          _initializeVideo(videoPath);
        }
      } else {
        _showOfflineAlert();
      }
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _showOfflineAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Offline'),
          content: const Text(
              'This video is not available offline. Please connect to the internet to download it.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _initializeVideo(String videoPath) {
    flickManager?.dispose();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
      autoPlay: true,
    );
    setState(() {});
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
            "Favorites",
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: favorites.isEmpty
                    ? Center(
                        child: Text(
                          'No favorites yet.',
                          style: TextStyle(
                            fontSize: constraints.maxWidth > 600 ? 24 : 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = favorites[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Text(
                                favorite.title,
                                style: TextStyle(
                                  fontSize:
                                      constraints.maxWidth > 600 ? 20 : 16,
                                ),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignLanguageDetailPage(
                                            signLanguage: favorite),
                                  ),
                                );
                                _loadFavorites();
                              },
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
        bottomNavigationBar: flickManager != null
            ? Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FlickVideoPlayer(
                        flickManager: flickManager!,
                        flickVideoWithControls: const FlickVideoWithControls(
                          controls: SizedBox.shrink(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        flickManager!.flickControlManager?.replay();
                      },
                      child: Text(
                        'Replay Video',
                        style: TextStyle(
                          color: notifier.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      );
    });
  }
}
