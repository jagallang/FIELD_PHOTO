import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'logger.dart';

/// Utility class for saving files on different platforms
class PlatformFileSaver {
  /// Save bytes to the user's Documents directory on desktop platforms
  /// Returns the full path of the saved file
  static Future<String> saveToDocuments(Uint8List bytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}${Platform.pathSeparator}$filename';
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      AppLogger.info('File saved successfully: $filePath', 'PlatformFileSaver');

      return filePath;
    } catch (e) {
      AppLogger.error('Failed to save file', e, null, 'PlatformFileSaver');
      rethrow;
    }
  }

  /// Save bytes to a custom directory
  static Future<String> saveToDirectory(
    Uint8List bytes,
    String filename,
    String directoryPath,
  ) async {
    try {
      final directory = Directory(directoryPath);

      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '$directoryPath${Platform.pathSeparator}$filename';
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      AppLogger.info('File saved to custom directory: $filePath', 'PlatformFileSaver');

      return filePath;
    } catch (e) {
      AppLogger.error('Failed to save file to custom directory', e, null, 'PlatformFileSaver');
      rethrow;
    }
  }

  /// Check if the platform supports file system operations
  static bool get isFileSystemSupported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Get the default save directory for the current platform
  static Future<String> getDefaultSaveDirectory() async {
    if (!isFileSystemSupported) {
      throw UnsupportedError('File system operations not supported on this platform');
    }

    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
