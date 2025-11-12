import 'dart:io';
import 'package:flutter/material.dart';
import '../models/widget_item.dart';
import '../models/book.dart';
import '../models/book_page.dart';

class PreviewDialog extends StatefulWidget {
  final Book book;
  final int initialIndex;

  const PreviewDialog({
    super.key,
    required this.book,
    required this.initialIndex,
  });

  @override
  State<PreviewDialog> createState() => _PreviewDialogState();
}

class _PreviewDialogState extends State<PreviewDialog> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  // 🧠 Helper — load image correctly for preview
  Widget _buildImage(String url, double width, double height) {
    if (url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, color: Colors.red),
      );
    }

    // If it’s a network image
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.broken_image, color: Colors.red),
      );
    }

    // If it’s a local file
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.broken_image, color: Colors.red),
      );
    }

    // If file doesn’t exist — fallback
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.red, size: 40),
      ),
    );
  }

  // 🔧 Build each widget block
  List<Widget> _renderWidgets(BookPage page) {
    return page.widgets.map((w) {
      switch (w.type) {
        case WidgetType.textblock:
          return Positioned(
            left: w.left,
            top: w.top,
            child: Text(
              w.props['text'] ?? '',
              style: TextStyle(
                fontSize: (w.props['fontSize'] ?? 16).toDouble(),
                color: Colors.black87,
              ),
            ),
          );

        case WidgetType.imageBlock:
          return Positioned(
            left: w.left,
            top: w.top,
            child: _buildImage(w.props['url'] ?? '', w.width, w.height),
          );

        case WidgetType.videoBlock:
          return Positioned(
            left: w.left,
            top: w.top,
            child: Container(
              width: w.width,
              height: w.height,
              color: Colors.black12,
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 48,
                  color: Colors.black54,
                ),
              ),
            ),
          );

        case WidgetType.liveData:
          return Positioned(
            left: w.left,
            top: w.top,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Text(
                '${w.props['label'] ?? ''}: ${w.props['value'] ?? ''}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = widget.book.pages[currentIndex];

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        width: 850,
        height: 1100,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Canvas background
            Container(width: 800, height: 1000, color: Colors.grey.shade100),

            // All widgets
            ..._renderWidgets(currentPage),

            // 🧭 Navigation buttons
            Positioned(
              bottom: 16,
              right: 16,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    onPressed: currentIndex > 0
                        ? () => setState(() => currentIndex--)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    onPressed: currentIndex < widget.book.pages.length - 1
                        ? () => setState(() => currentIndex++)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 📄 Page indicator
            Positioned(
              top: 8,
              right: 16,
              child: Text(
                'Page ${currentIndex + 1} / ${widget.book.pages.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
