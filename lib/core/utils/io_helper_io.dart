import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> ioResolveSaveDirectory(String? customPath) async {
  if (customPath != null && customPath.isNotEmpty) {
    return customPath;
  }
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

String ioJoinPath(String directory, String filename) {
  if (directory.endsWith(Platform.pathSeparator)) {
    return '$directory$filename';
  }
  return '$directory${Platform.pathSeparator}$filename';
}

Future<void> ioWriteBytesToFile(Uint8List bytes, String filePath) async {
  final file = File(filePath);
  await file.writeAsBytes(bytes);
}

Future<void> ioOpenSystemFolder(String path) async {
  if (Platform.isWindows) {
    await Process.run('explorer', [path]);
  } else if (Platform.isMacOS) {
    await Process.run('open', [path]);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [path]);
  } else {
    throw UnsupportedError('Opening folders is not supported on this platform');
  }
}

bool get ioSupportsLocalFileSystem => true;
