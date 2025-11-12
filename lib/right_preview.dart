import 'package:editor_desktop/PREVIEW_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/editor_provider.dart';
import '../models/book.dart';
import '../widgets/thumbnail_preview.dart';

import '../services/storage_service.dart';

class RightPreview extends StatelessWidget {
  const RightPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = Provider.of<EditorProvider>(context);
    final storage = StorageService();

    return Container(
      width: 320,
      color: const Color(0xFFF7F8FB),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Export & Preview Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Export'),
                  onPressed: () async {
                    await storage.saveBookAsJson(
                      editor.book,
                      editor.book.title.replaceAll(' ', '_'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Book exported successfully!'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Preview'),
                onPressed: () {
                  if (editor.book.pages.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('⚠️ No pages to preview.')),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (_) => PreviewDialog(
                      book: editor.book,
                      initialIndex: editor.currentPageIndex,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          const Text(
            '📖 Pages',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // ✅ Pages list with thumbnails
          Expanded(
            child: ListView.builder(
              itemCount: editor.book.pages.length,
              itemBuilder: (context, index) {
                final page = editor.book.pages[index];
                final isSelected = editor.currentPageIndex == index;

                return GestureDetector(
                  onTap: () => editor.setCurrentPage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Thumbnail preview
                        SizedBox(
                          width: 80,
                          height: 100,
                          child: ThumbnailPreview(page: page),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                page.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${page.widgets.length} widgets',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ✅ Add Page Button
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => editor.addPage(),
            ),
          ),
        ],
      ),
    );
  }
}
