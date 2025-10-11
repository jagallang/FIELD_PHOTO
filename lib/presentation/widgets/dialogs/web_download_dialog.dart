import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

/// Web download dialog for file downloads in web platform
class WebDownloadDialog extends StatefulWidget {
  final Uint8List bytes;
  final String initialFilename;
  final Function(Uint8List bytes, String filename) onDownload;

  const WebDownloadDialog({
    super.key,
    required this.bytes,
    required this.initialFilename,
    required this.onDownload,
  });

  @override
  State<WebDownloadDialog> createState() => _WebDownloadDialogState();
}

class _WebDownloadDialogState extends State<WebDownloadDialog> {
  late TextEditingController _filenameController;
  String _selectedFormat = 'PNG';
  final List<String> _formats = ['PNG', 'PDF'];

  @override
  void initState() {
    super.initState();
    _filenameController = TextEditingController(text: widget.initialFilename);
  }

  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.download, color: Colors.blue),
          const SizedBox(width: 8),
          Text('download_file'.tr()),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'download_description'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'filename_label'.tr(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _filenameController,
              decoration: InputDecoration(
                hintText: 'enter_filename'.tr(),
                prefixIcon: const Icon(Icons.insert_drive_file),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'file_format'.tr(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedFormat,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _formats.map((format) {
                return DropdownMenuItem(
                  value: format,
                  child: Row(
                    children: [
                      Icon(
                        format == 'PNG' ? Icons.image : Icons.picture_as_pdf,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(format),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFormat = value!;
                  _updateFilenameExtension();
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'web_download_info'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton.icon(
          onPressed: _isValidFilename() ? _handleDownload : null,
          icon: const Icon(Icons.download),
          label: Text('download'.tr()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  bool _isValidFilename() {
    final filename = _filenameController.text.trim();
    return filename.isNotEmpty && filename.length >= 3;
  }

  void _updateFilenameExtension() {
    final currentFilename = _filenameController.text;
    final baseName = currentFilename.contains('.')
        ? currentFilename.substring(0, currentFilename.lastIndexOf('.'))
        : currentFilename;
    
    final extension = _selectedFormat.toLowerCase();
    _filenameController.text = '$baseName.$extension';
  }

  void _handleDownload() {
    final filename = _filenameController.text.trim();
    if (!_isValidFilename()) return;

    try {
      widget.onDownload(widget.bytes, filename);
      Navigator.of(context).pop();
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('download_error'.tr()),
          content: Text('download_error_message'.tr(namedArgs: {'error': e.toString()})),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ok'.tr()),
            ),
          ],
        ),
      );
    }
  }
}