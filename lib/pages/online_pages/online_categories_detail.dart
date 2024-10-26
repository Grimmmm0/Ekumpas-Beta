import 'package:flutter/material.dart';
import 'package:ekumpas_beta/provider/provider.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchAndPlayVideo();
    _checkIfFavorite();
  }

  // Fetch and play video either from cache or download it if online
  Future<void> _fetchAndPlayVideo() async {
    final tempDir = await getTemporaryDirectory();
    final videoPath = '${tempDir.path}/${widget.signLanguage.video}';

    if (await File(videoPath).exists()) {
      _initializeAndPlay(videoPath); // Play cached video
    } else {
      if (await _hasInternetConnection()) {
        final videoData = await RealmServices.instance
            .fetchVideoData(widget.signLanguage.video);
        if (videoData.isNotEmpty) {
          final file = File(videoPath);
          await file.writeAsBytes(videoData); // Cache downloaded video
          _initializeAndPlay(videoPath);
        }
      } else {
        _showOfflineAlert(); // Show alert if offline
      }
    }
  }

  // Check if there is an active internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Show an alert dialog when offline
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

  // Initialize and play the video
  void _initializeAndPlay(String videoPath) {
    _controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _controller.play();
        });
      });
  }

  // Check if the current sign language is marked as favorite
  Future<void> _checkIfFavorite() async {
    final email = await _getUserEmail();
    if (email != null) {
      final favorites = RealmServices.instance.getFavorites(email);
      final isFavorite = favorites.any((sl) => sl.id == widget.signLanguage.id);
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  // Toggle favorite status of the current sign language
  Future<void> _toggleFavorite() async {
    final email = await _getUserEmail();
    if (email != null) {
      print('Toggling favorite for: ${widget.signLanguage.title}');
      await RealmServices.instance.toggleFavorite(widget.signLanguage, email);
      _checkIfFavorite(); // Update favorite status
    }
  }

  // Get the user's email from SharedPreferences
  Future<String?> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    print('Retrieved email: $email'); // Debug print
    return email;
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose video controller when the widget is removed from the tree
    super.dispose();
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
          title: Text(
            widget.signLanguage.title,
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.signLanguage.description,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                    },
                    child: Text(
                      'Replay Video',
                      style: TextStyle(
                        color: notifier.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(),
                  ),
                ],
              ),
      );
    });
  }
}
