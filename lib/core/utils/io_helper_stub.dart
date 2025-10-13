import 'dart:typed_data';

Future<String> ioResolveSaveDirectory(String? customPath) =>
    Future.error(UnsupportedError('File system access is not available on this platform'));

String ioJoinPath(String directory, String filename) => '$directory/$filename';

Future<void> ioWriteBytesToFile(Uint8List bytes, String filePath) =>
    Future.error(UnsupportedError('File system access is not available on this platform'));

Future<void> ioOpenSystemFolder(String path) =>
    Future.error(UnsupportedError('File system access is not available on this platform'));

bool get ioSupportsLocalFileSystem => false;
