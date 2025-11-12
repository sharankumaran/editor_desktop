import 'book_page.dart';

class Book {
  String title;
  List<BookPage> pages;

  Book({required this.title, List<BookPage>? pages}) : pages = pages ?? [];

  Map<String, dynamic> toJson() => {
    'bookTitle': title,
    'pages': pages.map((p) => p.toJson()).toList(),
  };

  static Book fromJson(Map<String, dynamic> j) {
    return Book(
      title: j['bookTitle'] ?? 'Book',
      pages: (j['pages'] as List? ?? [])
          .map((p) => BookPage.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
    );
  }
}
