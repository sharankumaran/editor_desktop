import 'package:editor_desktop/models/editor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_selector/file_selector.dart';

class LeftToolbar extends StatelessWidget {
  const LeftToolbar({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final XTypeGroup images = XTypeGroup(
      label: 'images',
      mimeTypes: ['image/*'],
      extensions: ['png', 'jpg', 'jpeg'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [images]);
    if (file == null) return;
    Provider.of<EditorProvider>(
      context,
      listen: false,
    ).addImageWidget(file.path);
  }

  Future<void> _pickVideo(BuildContext context) async {
    final XTypeGroup videos = XTypeGroup(
      label: 'videos',
      extensions: ['mp4', 'mov', 'avi'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [videos]);
    if (file == null) return;
    Provider.of<EditorProvider>(
      context,
      listen: false,
    ).addVideoWidget(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final editor = Provider.of<EditorProvider>(context);

    Widget sectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );

    return Container(
      width: 260,
      color: const Color(0xFFF7F8FB),
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Editor Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Page Layout
            sectionTitle('Page Layout'),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: editor.setSingleColumnLayout,
                    child: const Text('One Column'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: editor.setTwoColumnLayout,
                    child: const Text('Two Columns'),
                  ),
                ),
              ],
            ),

            // Text Tool
            sectionTitle('Text Tool'),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => editor.addText("Enter your text here..."),
                    child: const Text('Add Text'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => editor.changeFontFamily("DM Sans"),
                    child: const Text('DM Sans'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Font size and alignment
            Row(
              children: [
                IconButton(
                  onPressed: editor.decreaseFontSize,
                  icon: const Icon(Icons.remove),
                ),
                Text('${editor.currentFontSize.toInt()}'),
                IconButton(
                  onPressed: editor.increaseFontSize,
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => editor.changeTextAlign(TextAlign.left),
                  icon: const Icon(Icons.format_align_left),
                ),
                IconButton(
                  onPressed: () => editor.changeTextAlign(TextAlign.center),
                  icon: const Icon(Icons.format_align_center),
                ),
                IconButton(
                  onPressed: () => editor.changeTextAlign(TextAlign.right),
                  icon: const Icon(Icons.format_align_right),
                ),
              ],
            ),

            // Image section
            sectionTitle('Image'),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.image_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Import Image'),
                ),
              ),
            ),

            // Video section
            sectionTitle('Video'),
            // YouTube Video section
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final controller = TextEditingController();
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Add YouTube Video'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Paste YouTube link here',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            final link = controller.text.trim();
                            if (link.isNotEmpty) {
                              Provider.of<EditorProvider>(
                                context,
                                listen: false,
                              ).addVideoWidget(link);
                            }
                            Navigator.pop(ctx);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.ondemand_video_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Add YouTube Link'),
                ),
              ),
            ),

            // Live data
            sectionTitle('Live Data'),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => editor.addLiveData("Weather", "30°C Sunny"),
                icon: const Icon(Icons.wb_sunny_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Weather'),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Page ${editor.currentPageIndex + 1}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
