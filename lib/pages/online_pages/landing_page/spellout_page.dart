import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:ekumpas_beta/pages/online_pages/landing_page/landingpage.dart';
import 'package:objectid/objectid.dart';

class SpellOutPage extends StatefulWidget {
  final String title;

  const SpellOutPage({Key? key, required this.title}) : super(key: key);

  @override
  _SpellOutPageState createState() => _SpellOutPageState();
}

class _SpellOutPageState extends State<SpellOutPage> {
  FlickManager? flickManager;
  late Directory tempDir;
  String? description;
  String? _currentLetter;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initializeTempDir();
  }

  Future<void> _initializeTempDir() async {
    tempDir = await getTemporaryDirectory();
    print("Temporary directory initialized: ${tempDir.path}");
  }

  Future<void> _fetchAndPlayVideo(String letter) async {
    setState(() {
      _loading = true;
    });

    final videoData = await fetchVideoAndDescription(letter);
    if (videoData != null) {
      final String videoFilename = videoData['videoPath']!;
      description = videoData['description'];

      final videoPath = '${tempDir.path}/$videoFilename';
      if (await File(videoPath).exists()) {
        await _initializeVideo(videoPath, letter);
      } else if (await _hasInternetConnection()) {
        final videoBytes =
            await RealmServices.instance.fetchVideoData(videoFilename);
        if (videoBytes.isNotEmpty) {
          final file = File(videoPath);
          await file.writeAsBytes(videoBytes);
          await _initializeVideo(videoPath, letter);
        } else {
          _showVideoNotFoundDialog(letter);
        }
      } else {
        _showOfflineAlert();
      }
    } else {
      _showVideoNotFoundDialog(letter);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _initializeVideo(String videoPath, String letter) async {
    if (flickManager != null) {
      await flickManager!.flickVideoManager?.videoPlayerController?.pause();
      await flickManager!.dispose();
      flickManager = null;
    }

    setState(() {
      _loading = true;
    });

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
      autoPlay: true,
    );

    setState(() {
      _currentLetter = letter;
      _loading = false;
    });
  }

  Future<Map<String, String>?> fetchVideoAndDescription(String letter) async {
    final signLanguages = RealmServices.instance.getSignLanguage();
    final signLanguage = signLanguages.firstWhere(
      (sl) => sl.title.toLowerCase() == letter.toLowerCase(),
      orElse: () => SignLanguage(
        ObjectId(),
        '',
        '',
        '',
        '',
        DateTime.now(),
        DateTime.now(),
        0,
      ),
    );
    return {
      'videoPath': signLanguage.video,
      'description': signLanguage.description,
    };
  }

  void _showVideoNotFoundDialog(String letter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Not Found'),
          content: Text('No video found for the letter: $letter.'),
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

  void _showOfflineAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Offline'),
          content:
              const Text('You need an internet connection to fetch the video.'),
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

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.title.toUpperCase().split(' ');

    return Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Spell Out'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust layout based on available height and width
            double videoHeight = constraints.maxHeight * 0.4;
            double padding = constraints.maxHeight * 0.05;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height:
                        padding), // Move video upwards by adding top padding
                Container(
                  height: videoHeight,
                  width: 400, // Adjust video height dynamically
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 18, 22, 60),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : flickManager != null
                            ? FlickVideoPlayer(
                                flickManager: flickManager!,
                                flickVideoWithControls:
                                    const FlickVideoWithControls(
                                  controls: SizedBox.shrink(),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'Video will be displayed here.',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                  ),
                ),
                const SizedBox(height: 20),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description!,
                      style: TextStyle(
                          color: notifier.isDark ? Colors.white : Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ...words.expand((word) {
                  final letters = word.split('');

                  List<List<String>> chunks = [];
                  for (int i = 0; i < letters.length; i += 4) {
                    chunks.add(letters.sublist(
                        i, i + 4 > letters.length ? letters.length : i + 4));
                  }

                  return chunks.map((chunk) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: chunk.map((letter) {
                        final isHighlighted = letter == _currentLetter;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isHighlighted
                                  ? notifier.isDark
                                      ? Colors.white
                                      : Colors.black
                                  : null,
                            ),
                            onPressed: () {
                              _fetchAndPlayVideo(letter);
                            },
                            child: Text(letter),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList();
                }).toList(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (flickManager != null) {
                          flickManager!.flickControlManager?.replay();
                        }
                      },
                      child: const Text('Replay Video'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token') ?? '';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingPage(token: token),
                          ),
                        );
                      },
                      child: const Text('Translate Another'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
