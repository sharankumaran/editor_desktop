import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import '../models/book.dart';

class StorageService {
  Future<void> saveBookAsJson(Book book, String suggestedName) async {
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(book.toJson());

    // JSON file type group for the save dialog
    final XTypeGroup jsonTypeGroup = XTypeGroup(
      label: 'JSON Files',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    // Try to open Save dialog
    final saveLocation = await getSaveLocation(
      suggestedName: '$suggestedName.json',
      acceptedTypeGroups: [jsonTypeGroup],
    );

    if (saveLocation == null) return;

    // Ensure the filename ends with .json
    String path = saveLocation.path;
    if (!path.toLowerCase().endsWith('.json')) {
      path = '$path.json';
    }

    final file = File(path);
    await file.writeAsString(jsonString);

    print('✅ Book saved as: $path');
  }

  Future<Book?> loadBookFromPath(String path) async {
    final f = File(path);
    if (!await f.exists()) return null;
    final s = await f.readAsString();
    final m = jsonDecode(s);
    return Book.fromJson(Map<String, dynamic>.from(m));
  }
}
