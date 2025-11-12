import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book_page.dart';
import '../models/widget_item.dart';
import 'video_widget.dart';

class ThumbnailPreview extends StatelessWidget {
  final BookPage page;
  const ThumbnailPreview({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    // We'll render a small column of widgets scaled down
    return Container(
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: page.widgets.take(3).map<Widget>((w) {
              switch (w.type) {
                case WidgetType.textblock:
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      w.props['text'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                case WidgetType.imageBlock:
                  final url = w.props['url'] as String;
                  final f = File(url);
                  if (f.existsSync()) {
                    return SizedBox(
                      height: 42,
                      child: Image.file(f, fit: BoxFit.cover),
                    );
                  } else {
                    return SizedBox(
                      height: 42,
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (Error, context, StackTrace) =>
                            const Icon(Icons.broken_image, size: 12),
                      ),
                    );
                  }
                case WidgetType.videoBlock:
                  return SizedBox(
                    height: 42,
                    child: VideoWidget(path: w.props['url'] as String),
                  );
                default:
                  return const SizedBox.shrink();
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}
