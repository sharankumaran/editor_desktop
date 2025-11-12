import 'widget_item.dart';

class BookPage {
  String title;
  double pageSizeX;
  double pageSizeY;
  String orientation;
  bool twoColumn;
  List<WidgetItem> widgets;

  BookPage({
    required this.title,
    this.pageSizeX = 800,
    this.pageSizeY = 1000,
    this.orientation = 'portrait',
    this.twoColumn = true,
    List<WidgetItem>? widgets,
  }) : widgets = widgets ?? [];

  Map<String, dynamic> toJson() => {
    'pageTitle': title,
    'page_size_X': pageSizeX.toInt(),
    'page_size_Y': pageSizeY.toInt(),
    'orientation': orientation,
    'twoColumn': twoColumn,
    'widgets': widgets.map((w) => w.toJson()).toList(),
  };

  static BookPage fromJson(Map<String, dynamic> j) {
    return BookPage(
      title: j['pageTitle'] ?? 'Page',
      pageSizeX: (j['page_size_X'] ?? 800).toDouble(),
      pageSizeY: (j['page_size_Y'] ?? 1000).toDouble(),
      orientation: j['orientation'] ?? 'portrait',
      twoColumn: j['twoColumn'] ?? false,
      widgets: (j['widgets'] as List? ?? [])
          .map((e) => WidgetItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
