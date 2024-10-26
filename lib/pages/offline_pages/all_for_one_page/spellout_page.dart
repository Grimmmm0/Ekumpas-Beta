import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ekumpas_beta/pages/offline_pages/all_for_one_page/allforone_page.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ekumpas_beta/services/realm_services.dart';
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
      } else {
        if (await _hasInternetConnection()) {
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
      }
    } else {
      _showVideoNotFoundDialog(letter);
    }

    setState(() {
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

  Future<void> _initializeVideo(String videoPath, String letter) async {
    if (flickManager != null) {
      await flickManager!.flickVideoManager?.videoPlayerController?.pause();
      await flickManager!.dispose();
      flickManager = null;
    }

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
      autoPlay: true,
    );

    setState(() {
      _currentLetter = letter;
      _loading = false;
    });
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Spell Out', style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        backgroundColor: const Color.fromRGBO(66, 87, 136, 0.3),
      ),
      backgroundColor: const Color.fromRGBO(18, 22, 60, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust layout based on available height and width
          double videoHeight = constraints.maxHeight * 0.4;
          double padding = constraints.maxHeight * 0.05;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height:
                        padding), // Move video upwards by adding top padding
                Container(
                  height: videoHeight,
                  width: 400, // Responsive video width
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(66, 87, 136, 1),
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
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Letters Row (Limited to 4 letters per row)
                ...words.map((word) {
                  final letters = word.split('');
                  List<List<String>> chunks = [];
                  for (int i = 0; i < letters.length; i += 4) {
                    chunks.add(letters.sublist(
                        i, i + 4 > letters.length ? letters.length : i + 4));
                  }

                  return Column(
                    children: chunks.map((chunk) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: chunk.map((letter) {
                          final isHighlighted = letter == _currentLetter;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isHighlighted ? Colors.amberAccent : null,
                              ),
                              onPressed: () {
                                _fetchAndPlayVideo(letter);
                              },
                              child: Text(letter),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  );
                }).toList(),

                const SizedBox(height: 20),

                // Replay and Translate Another buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(66, 87, 136, 1)),
                      onPressed: () {
                        if (flickManager != null) {
                          flickManager!.flickControlManager?.replay();
                        }
                      },
                      child: const Text(
                        'Replay Video',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(66, 87, 136, 1)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllForOnePage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Translate Another',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
