import 'dart:io';
import 'package:editor_desktop/models/editor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/widget_item.dart';

class CanvasView extends StatelessWidget {
  const CanvasView({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = Provider.of<EditorProvider>(context);
    final page = editor.currentPage;

    return Expanded(
      child: Center(
        child: Container(
          width: 800,
          height: 1000,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Stack(
            children: page.widgets.map((w) => _buildWidget(w)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWidget(WidgetItem item) {
    switch (item.type) {
      case WidgetType.textblock:
        return Positioned(
          left: item.left,
          top: item.top,
          child: SizedBox(
            width: item.width,
            child: TextField(
              controller: TextEditingController(text: item.props['text']),
              style: TextStyle(
                fontSize: (item.props['fontSize'] ?? 16).toDouble(),
                color: Colors.black,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              maxLines: null,
              onChanged: (val) => item.props['text'] = val,
            ),
          ),
        );

      case WidgetType.imageBlock:
        return Positioned(
          left: item.left,
          top: item.top,
          child: SizedBox(
            width: item.width,
            height: item.height,
            child: Image.file(File(item.props['url']), fit: BoxFit.contain),
          ),
        );

      case WidgetType.videoBlock:
        return Positioned(
          left: item.left,
          top: item.top,
          child: Container(
            width: item.width,
            height: item.height,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Icon(
              Icons.play_circle_fill,
              size: 64,
              color: Colors.black54,
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }
}
