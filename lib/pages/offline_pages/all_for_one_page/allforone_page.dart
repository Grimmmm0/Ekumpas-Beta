// ignore_for_file: avoid_print, use_super_parameters, use_build_context_synchronously

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// ignore: depend_on_referenced_packages
import 'package:objectid/objectid.dart';
import 'package:ekumpas_beta/pages/offline_pages/all_for_one_page/spellout_page.dart';
import 'package:ekumpas_beta/pages/offline_pages/home_page/home.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:ekumpas_beta/services/realm_services.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class AllForOnePage extends StatefulWidget {
  const AllForOnePage({Key? key}) : super(key: key);

  @override
  State<AllForOnePage> createState() => _AllForOnePageState();
}

class _AllForOnePageState extends State<AllForOnePage> {
  late TextEditingController _typeAheadController;
  String _description = '';
  String _selectedTitle = ''; // New state to store selected title
  FlickManager? flickManager;
  bool _isLoading = false;
  bool _dataLoaded = false;
  bool _isVideoDisplayed = false;
  late Directory tempDir;
  bool _isSpellOutMode = false; // New state to track spell out mode

  @override
  void initState() {
    super.initState();
    _typeAheadController = TextEditingController();
    _initializeTempDir();
  }

  Future<void> _initializeTempDir() async {
    tempDir = await getTemporaryDirectory();
  }

  @override
  void dispose() {
    _typeAheadController.dispose();
    flickManager?.dispose();
    flickManager = null;
    super.dispose();
  }

  Future<List<String>> _getSuggestions(String query) async {
    final signLanguages = RealmServices.instance.getSignLanguage();
    return signLanguages
        .where((sl) => sl.title.toLowerCase().contains(query.toLowerCase()))
        .map((sl) => sl.title)
        .toList()
      ..sort();
  }

  Future<void> _fetchData(String title) async {
    setState(() {
      _isLoading = true;
      _dataLoaded = false;
      _isVideoDisplayed = false; // Reset video displayed state
      _isSpellOutMode = false; // Reset spell out mode
    });

    await RealmServices.instance.updateFrequency(title);

    final signLanguages = RealmServices.instance.getSignLanguage();
    final signLanguage = signLanguages.firstWhere(
      (sl) => sl.title.toLowerCase() == title.toLowerCase(),
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

    if (signLanguage.title.isNotEmpty) {
      _description = signLanguage.description;
      _selectedTitle = signLanguage.title; // Store selected title
      await _fetchAndPlayVideo(signLanguage.video);
    } else {
      _description = 'No description was found';
      _selectedTitle = title; // Store the user input as the title
      flickManager?.dispose();
      flickManager = null;

      // Show a Dialog informing the user that the input was not found
      _showDataNotFoundDialog(title);

      // Set spell out mode to true since no valid object was found
      setState(() {
        _isSpellOutMode = true; // Enable spell out mode
      });
    }

    setState(() {
      _isLoading = false;
      _dataLoaded = true;
      _isVideoDisplayed = true; // Set video displayed state
    });
  }

  void _showDataNotFoundDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FSL not Found!'),
          content: Text('Would you like to spell it out?: $title'),
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

  void _showInvalidInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter a valid word using only alphabetic characters and spaces, with a maximum of 20 characters.'),
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

  Future<void> _fetchAndPlayVideo(String filename) async {
    final videoPath = '${tempDir.path}/$filename';

    if (await File(videoPath).exists()) {
      // If the video is cached, play it
      _initializeVideo(videoPath);
    } else {
      // Check internet connectivity
      if (await _hasInternetConnection()) {
        // Fetch video data and cache it
        final videoData = await RealmServices.instance.fetchVideoData(filename);

        if (videoData.isNotEmpty) {
          final file = File(videoPath);
          await file.writeAsBytes(videoData);

          // Initialize and play video
          _initializeVideo(videoPath);
        }
      } else {
        // Show a message to the user about the need for internet connection
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
    flickManager?.dispose(); // Dispose of the old FlickManager
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
      autoPlay: true,
    );
    setState(() {
      print('Video initialized: $videoPath');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          "E-kumpas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(66, 87, 136, 0.3),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.auto_awesome_mosaic,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(18, 22, 60, 1),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double availableHeight = constraints.maxHeight;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: availableHeight * 0.4,
                        width: 400,
                        color: const Color.fromRGBO(66, 87, 136, 1),
                        child: flickManager != null
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
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Description: $_description',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display selected title instead of text field
                  if (_dataLoaded)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Title: $_selectedTitle',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 300,
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _typeAheadController,
                            enabled: !_isVideoDisplayed,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 3),
                              ),
                              hintText: 'Enter Text',
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return await _getSuggestions(pattern);
                          },
                          itemBuilder: (context, String suggestion) {
                            return ListTile(title: Text(suggestion));
                          },
                          onSuggestionSelected: (String suggestion) {
                            _typeAheadController.text = suggestion;
                          },
                          noItemsFoundBuilder: (context) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No suggestions found'),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Conditionally display the "Translate" button
                  if (!_isVideoDisplayed &&
                      _typeAheadController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(66, 87, 136, 1)),
                        onPressed: () {
                          String inputText = _typeAheadController.text.trim();

                          // Validation to check if the input is not empty, contains only letters and spaces, and has a maximum of 20 characters
                          if (inputText.isEmpty ||
                              !RegExp(r'^[a-zA-Z\s]+$').hasMatch(inputText) ||
                              inputText.length > 20) {
                            _showInvalidInputDialog();
                          } else {
                            _fetchData(inputText);
                          }
                        },
                        child: const Text(
                          'Translate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Conditional display for buttons based on state
                  if (_dataLoaded && _isSpellOutMode) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(66, 87, 136, 1)),
                          onPressed: () {
                            // Implement the logic to navigate to the spell out page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpellOutPage(
                                        title: _selectedTitle,
                                      )),
                            );
                          },
                          child: const Text(
                            'Spell Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(66, 87, 136, 1)),
                          onPressed: () {
                            setState(() {
                              _dataLoaded = false;
                              _description = '';
                              flickManager?.dispose();
                              flickManager = null;
                              _typeAheadController.clear();
                              _isVideoDisplayed = false;
                              _isSpellOutMode = false; // Reset spell out mode
                            });
                          },
                          child: const Text(
                            'Translate Another',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_dataLoaded) ...[
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
                            setState(() {
                              _dataLoaded = false;
                              _description = '';
                              flickManager?.dispose();
                              flickManager = null;
                              _typeAheadController.clear();
                              _isVideoDisplayed = false;
                            });
                          },
                          child: const Text(
                            'Translate Another',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Spacer(flex: 15),
                ],
              );
            },
          ),
          if (_isLoading)
            Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: false,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
