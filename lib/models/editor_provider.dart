import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../models/book_page.dart';
import '../models/widget_item.dart';

class EditorProvider extends ChangeNotifier {
  final Book book = Book(title: 'Sample Book');
  int currentPageIndex = 0;
  final Uuid _uuid = const Uuid();

  // Editor style states
  double currentFontSize = 18.0;
  String currentFontFamily = 'DM Sans';
  Color currentColor = Colors.black;
  TextAlign currentAlign = TextAlign.left;

  EditorProvider() {
    // Initialize with a single blank page
    book.pages.add(BookPage(title: 'Page 1'));
  }

  BookPage get currentPage => book.pages[currentPageIndex];

  // -------------------- PAGE MANAGEMENT --------------------

  void addPage() {
    book.pages.add(BookPage(title: 'Page ${book.pages.length + 1}'));
    currentPageIndex = book.pages.length - 1;
    notifyListeners();
  }

  void nextPage() {
    if (currentPageIndex < book.pages.length - 1) {
      currentPageIndex++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (currentPageIndex > 0) {
      currentPageIndex--;
      notifyListeners();
    }
  }

  void setCurrentPage(int index) {
    if (index < 0 || index >= book.pages.length) return;
    currentPageIndex = index;
    notifyListeners();
  }

  // -------------------- TEXT MANAGEMENT --------------------

  void addText(String text) {
    // Place below last widget automatically
    double topOffset = 24;
    if (currentPage.widgets.isNotEmpty) {
      final lastWidget = currentPage.widgets.last;
      topOffset = lastWidget.top + lastWidget.height + 24;
    }

    final item = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.textblock,
      props: {
        'text': text,
        'fontSize': currentFontSize,
        'color': '#${currentColor.value.toRadixString(16)}',
        'fontFamily': currentFontFamily,
        'align': currentAlign.name,
      },
      left: 24,
      top: topOffset,
      width: 752,
      height: 80,
    );
    currentPage.widgets.add(item);
    notifyListeners();
  }

  void increaseFontSize() {
    currentFontSize += 2;
    notifyListeners();
  }

  void decreaseFontSize() {
    if (currentFontSize > 8) currentFontSize -= 2;
    notifyListeners();
  }

  void changeFontFamily(String font) {
    currentFontFamily = font;
    notifyListeners();
  }

  void changeTextAlign(TextAlign align) {
    currentAlign = align;
    notifyListeners();
  }

  void changeTextColor(Color color) {
    currentColor = color;
    notifyListeners();
  }

  // -------------------- IMAGE MANAGEMENT --------------------

  void addImageWidget(String path) {
    // Place image below the last widget
    double topOffset = 24;
    if (currentPage.widgets.isNotEmpty) {
      final lastWidget = currentPage.widgets.last;
      topOffset = lastWidget.top + lastWidget.height + 24;
    }

    final item = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.imageBlock,
      props: {'url': path},
      left: 24,
      top: topOffset,
      width: 752,
      height: 300,
    );

    currentPage.widgets.add(item);
    notifyListeners();
  }

  // -------------------- VIDEO MANAGEMENT --------------------

  void addVideoWidget(String path) {
    double topOffset = 24;
    if (currentPage.widgets.isNotEmpty) {
      final lastWidget = currentPage.widgets.last;
      topOffset = lastWidget.top + lastWidget.height + 24;
    }

    final item = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.videoBlock,
      props: {'url': path},
      left: 24,
      top: topOffset,
      width: 752,
      height: 320,
    );

    currentPage.widgets.add(item);
    notifyListeners();
  }

  // -------------------- LIVE DATA --------------------

  void addLiveData(String label, String value) {
    double topOffset = 24;
    if (currentPage.widgets.isNotEmpty) {
      final lastWidget = currentPage.widgets.last;
      topOffset = lastWidget.top + lastWidget.height + 24;
    }

    final item = WidgetItem(
      id: _uuid.v4(),
      type: WidgetType.liveData,
      props: {'label': label, 'value': value},
      left: 24,
      top: topOffset,
      width: 360,
      height: 80,
    );

    currentPage.widgets.add(item);
    notifyListeners();
  }

  // -------------------- UPDATE / REMOVE --------------------

  void updateWidget(WidgetItem updated) {
    final index = currentPage.widgets.indexWhere((w) => w.id == updated.id);
    if (index != -1) {
      currentPage.widgets[index] = updated;
      notifyListeners();
    }
  }

  void removeWidget(String id) {
    currentPage.widgets.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  // -------------------- LAYOUT PLACEHOLDERS --------------------

  void setSingleColumnLayout() {
    // Future logic for 1-column layout
    notifyListeners();
  }

  void setTwoColumnLayout() {
    // Future logic for 2-column layout
    notifyListeners();
  }
}
