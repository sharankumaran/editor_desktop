import 'package:editor_desktop/right_preview.dart';
import 'package:editor_desktop/screens/canvas_view.dart';
import 'package:editor_desktop/screens/left_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorHome extends StatelessWidget {
  const EditorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Row(children: const [LeftToolbar(), CanvasView(), RightPreview()]),
    );
  }
}
