import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserImage extends StatefulWidget {
  final String imagePath;

  const UserImage({super.key, required this.imagePath});

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ApiService _apiService = ApiService();
  String? _prediction;
  bool _isLoading = false;

  // Map predictions to playlists
  final Map<String, String> _playlists = {
    'Happy':
        'https://open.spotify.com/playlist/0jrlHA5UmxRxJjoykf7qRY?si=I4rWzI-VQFCPVzQQXmndBA',
    'Sad':
        'https://open.spotify.com/playlist/25ZzkJkOuYir9kHr2CqwPQ?si=IOjI03Z-TdilUO46fJnLJw',
    'Neutral':
        'https://open.spotify.com/playlist/1NIlouPwHi81SPIfHf213T?si=w49j5-BqSW-Rh5TomCIoKg',
  };

  Future<void> _detectEmotion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prediction =
          await _apiService.detectEmotion(File(widget.imagePath));
      setState(() {
        _prediction = prediction;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openPlaylist(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No application found to open the URL")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selected Image',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Alata',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF008AD7),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imagePath.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(widget.imagePath),
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_prediction != null)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        "Prediction: $_prediction",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Alata',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_playlists.containsKey(_prediction!))
                      GestureDetector(
                        onTap: () {
                          final playlistUrl = _playlists[_prediction!];
                          if (playlistUrl != null) {
                            _openPlaylist(playlistUrl);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.green, Colors.lightGreenAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Open Playlist",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              else
                GestureDetector(
                  onTap: _detectEmotion,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Detect Emotion",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
