import 'package:editor_desktop/models/editor_provider.dart';
import 'package:editor_desktop/right_preview.dart';
import 'package:editor_desktop/screens/canvas_view.dart';
import 'package:editor_desktop/screens/left_toolbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BookEditorApp());
}

class BookEditorApp extends StatelessWidget {
  const BookEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Book Editor',
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF8F9FA)),
        home: const EditorHome(),
      ),
    );
  }
}

class EditorHome extends StatelessWidget {
  const EditorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          LeftToolbar(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 800,
                    height: 1000,
                    child: CanvasView(),
                  ),
                ),
              ),
            ),
          ),
          RightPreview(),
        ],
      ),
    );
  }
}
