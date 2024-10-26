import 'package:flutter/material.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignLanguageDetailPage extends StatefulWidget {
  final SignLanguage signLanguage;

  const SignLanguageDetailPage({Key? key, required this.signLanguage})
      : super(key: key);

  @override
  State<SignLanguageDetailPage> createState() => _SignLanguageDetailPageState();
}

class _SignLanguageDetailPageState extends State<SignLanguageDetailPage> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndPlayVideo();
  }

  Future<void> _fetchAndPlayVideo() async {
    final tempDir = await getTemporaryDirectory();
    final videoPath = '${tempDir.path}/${widget.signLanguage.video}';

    if (await File(videoPath).exists()) {
      _initializeAndPlay(videoPath);
    } else {
      if (await _hasInternetConnection()) {
        final videoData = await RealmServices.instance
            .fetchVideoData(widget.signLanguage.video);
        if (videoData.isNotEmpty) {
          final file = File(videoPath);
          await file.writeAsBytes(videoData);
          _initializeAndPlay(videoPath);
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

  void _initializeAndPlay(String videoPath) {
    _controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
          18, 22, 60, 1), // Updated background color to match FavoritesPage
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        backgroundColor: const Color.fromRGBO(66, 87, 136,
            0.3), // Updated background color to match FavoritesPage
        title: Text(
          widget.signLanguage.title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Spacer to push content down
                Center(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15), // Match card border radius
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: const Color.fromRGBO(66, 87, 136,
                          1), // Updated color to match FavoritesPage card
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.signLanguage.description,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.seekTo(Duration.zero);
                    _controller.play();
                  },
                  child: const Text(
                    'Replay Video',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(66, 87, 136,
                        1), // Updated button color to match FavoritesPage card
                  ),
                ),
              ],
            ),
    );
  }
}
