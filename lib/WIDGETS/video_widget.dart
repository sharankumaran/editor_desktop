import 'dart:io';
import 'package:flutter/material.dart';

class VideoWidget extends StatelessWidget {
  final String path;
  const VideoWidget({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final fileName = File(path).uri.pathSegments.last;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // Empty background or placeholder
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                fileName,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ),
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
    );
  }
}
