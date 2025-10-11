/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when photo operations fail
class PhotoException extends AppException {
  const PhotoException(super.message, {super.code});
  
  @override
  String toString() => 'PhotoException: $message';
}

/// Exception thrown when file operations fail
class FileException extends AppException {
  const FileException(super.message, {super.code});
  
  @override
  String toString() => 'FileException: $message';
}

/// Exception thrown when permission is denied
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
  
  @override
  String toString() => 'PermissionException: $message';
}

/// Exception thrown when network operations fail
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
  
  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when operations are cancelled by user
class CancelledException extends AppException {
  const CancelledException(super.message, {super.code});
  
  @override
  String toString() => 'CancelledException: $message';
}