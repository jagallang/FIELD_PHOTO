import 'dart:convert';
import 'package:flutter/foundation.dart';

class FileUtils {
  /// Generate timestamp-based filename
  static String generateTimestampFilename({
    String prefix = 'photo',
    String extension = '.png',
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp$extension';
  }

  /// Convert bytes to base64 string
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Convert base64 string to bytes
  static Uint8List base64ToBytes(String base64String) {
    // Remove data URL prefix if present
    final cleanBase64 = base64String.contains(',') 
        ? base64String.split(',').last 
        : base64String;
    return base64Decode(cleanBase64);
  }

  /// Create data URL from bytes
  static String createDataUrl(Uint8List bytes, {String mimeType = 'image/png'}) {
    final base64String = bytesToBase64(bytes);
    return 'data:$mimeType;base64,$base64String';
  }

  /// Extract base64 from data URL
  static String? extractBase64FromDataUrl(String dataUrl) {
    if (dataUrl.startsWith('data:')) {
      final parts = dataUrl.split(',');
      if (parts.length == 2) {
        return parts[1];
      }
    }
    return null;
  }

  /// Check if string is a data URL
  static bool isDataUrl(String url) {
    return url.startsWith('data:image/');
  }

  /// Check if string is a network URL
  static bool isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Check if string is a local gradient ID
  static bool isLocalGradient(String source) {
    return source.startsWith('local_gradient_');
  }

  /// Validate image file extension
  static bool isValidImageExtension(String filename) {
    const validExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];
    final extension = filename.toLowerCase();
    return validExtensions.any((ext) => extension.endsWith(ext));
  }

  /// Get file size in human readable format
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Calculate aspect ratio from dimensions
  static double calculateAspectRatio(int width, int height) {
    if (height == 0) return 1.0;
    return width / height;
  }

  /// Resize dimensions maintaining aspect ratio
  static ({int width, int height}) resizeWithAspectRatio({
    required int originalWidth,
    required int originalHeight,
    required int maxWidth,
    required int maxHeight,
  }) {
    final aspectRatio = calculateAspectRatio(originalWidth, originalHeight);
    
    int newWidth = maxWidth;
    int newHeight = (newWidth / aspectRatio).round();
    
    if (newHeight > maxHeight) {
      newHeight = maxHeight;
      newWidth = (newHeight * aspectRatio).round();
    }
    
    return (width: newWidth, height: newHeight);
  }

  /// Create filename safe string
  static String createSafeFilename(String input) {
    // Remove or replace invalid characters
    return input
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Log file operations (only in debug mode)
  static void logFileOperation(String operation, String details) {
    if (kDebugMode) {
      debugPrint('File Operation: $operation - $details');
    }
  }
}