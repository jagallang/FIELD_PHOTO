import 'package:flutter/foundation.dart';

/// Application logger utility
class AppLogger {
  static const String _tag = 'POL_PHOTO';
  
  /// Log debug message
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('[$_tag${tag != null ? ':$tag' : ''}] DEBUG: $message');
    }
  }
  
  /// Log info message
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('[$_tag${tag != null ? ':$tag' : ''}] INFO: $message');
    }
  }
  
  /// Log warning message
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('[$_tag${tag != null ? ':$tag' : ''}] WARNING: $message');
    }
  }
  
  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      debugPrint('[$_tag${tag != null ? ':$tag' : ''}] ERROR: $message');
      if (error != null) {
        debugPrint('Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }
  
  /// Log network request/response
  static void network(String method, String url, [int? statusCode, String? tag]) {
    if (kDebugMode) {
      String status = statusCode != null ? ' [$statusCode]' : '';
      debugPrint('[$_tag${tag != null ? ':$tag' : ''}] NETWORK: $method $url$status');
    }
  }
}