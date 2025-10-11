import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

/// Dialog for selecting photo source (camera/gallery)
class PhotoSourceDialog extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;

  const PhotoSourceDialog({
    super.key,
    required this.onSourceSelected,
  });

  bool get _isCameraAvailable {
    // Camera is not available on desktop platforms
    if (kIsWeb) return false;
    return !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('photo_source_select'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only show camera option on mobile platforms
          if (_isCameraAvailable) ...[
            _SourceOption(
              icon: Icons.camera_alt,
              title: 'camera'.tr(),
              onTap: () {
                Navigator.pop(context);
                onSourceSelected(ImageSource.camera);
              },
            ),
            const SizedBox(height: 16),
          ],
          _SourceOption(
            icon: Icons.photo_library,
            title: 'gallery'.tr(),
            onTap: () {
              Navigator.pop(context);
              onSourceSelected(ImageSource.gallery);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context,
    Function(ImageSource) onSourceSelected,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => PhotoSourceDialog(
        onSourceSelected: onSourceSelected,
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}