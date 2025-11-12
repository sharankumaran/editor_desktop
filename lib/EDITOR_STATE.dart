import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../models/book_page.dart';
import '../models/widget_item.dart';

class EditorState extends ChangeNotifier {
  Book book = Book(title: 'Sample Book');
  int current = 0;
  final Uuid _uuid = const Uuid();

  EditorState() {
    // create sample page
    book.pages.add(BookPage(title: 'Page 1'));
  }

  BookPage get page => book.pages[current];

  WidgetItem? getWidgetById(String id) {
    try {
      return page.widgets.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  void addImageWidget(String filePath) {
    final w = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.imageBlock,
      props: {'url': filePath},
      left: 220, // center-ish
      top: 160,
      width: 360,
      height: 240,
    );
    page.widgets.add(w);

    // add a text block below the image
    final t = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.textblock,
      props: {
        'text': 'Architectural Brilliance',
        'fontSize': 18,
        'color': '#D81B60',
      },
      left: 80,
      top: 420,
      width: 640,
      height: 120,
    );
    page.widgets.add(t);

    notifyListeners();
  }

  void removeWidget(String id) {
    page.widgets.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void updateWidget(WidgetItem updated) {
    final idx = page.widgets.indexWhere((w) => w.id == updated.id);
    if (idx >= 0) {
      page.widgets[idx] = updated;
      notifyListeners();
    }
  }

  void addPage() {
    book.pages.add(BookPage(title: 'Page ${book.pages.length + 1}'));
    current = book.pages.length - 1;
    notifyListeners();
  }
}
