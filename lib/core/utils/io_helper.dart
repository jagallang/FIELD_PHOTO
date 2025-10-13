import 'dart:typed_data';

import 'io_helper_stub.dart'
    if (dart.library.io) 'io_helper_io.dart';

/// Returns the directory path used for saving files.
Future<String> resolveSaveDirectory(String? customPath) =>
    ioResolveSaveDirectory(customPath);

/// Combines directory path with filename using platform-appropriate separator.
String joinPath(String directory, String filename) => ioJoinPath(directory, filename);

/// Writes raw bytes to the given file path.
Future<void> writeBytesToFile(Uint8List bytes, String filePath) =>
    ioWriteBytesToFile(bytes, filePath);

/// Opens the given folder in the host operating system file explorer.
Future<void> openSystemFolder(String path) => ioOpenSystemFolder(path);

/// Indicates whether the current platform supports local file system writes.
bool get supportsLocalFileSystem => ioSupportsLocalFileSystem;
