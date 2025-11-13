import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoWidget extends StatelessWidget {
  final String path; // Can be YouTube link or local file path
  const VideoWidget({super.key, required this.path});

  bool get isYouTubeLink =>
      path.contains('youtube.com') || path.contains('youtu.be');

  Future<void> _openVideo(BuildContext context) async {
    if (isYouTubeLink) {
      final Uri youtubeUrl = Uri.parse(path);
      try {
        final bool launched = await launchUrl(
          youtubeUrl,
          mode: LaunchMode.externalApplication, // Opens app or browser
        );
        if (!launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open YouTube video')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening video: $e')));
      }
    } else {
      // Optional: handle local videos later
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local video playback not yet added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = isYouTubeLink
        ? "YouTube Video"
        : File(path).uri.pathSegments.last;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InkWell(
        onTap: () => _openVideo(context),
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: isYouTubeLink
                    ? Image.network(
                        // YouTube Logo
                        'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg',
                        width: 120,
                        height: 50,
                      )
                    : Text(
                        fileName,
                        style: const TextStyle(color: Colors.black54),
                      ),
              ),
            ),
            // Play button overlay
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
