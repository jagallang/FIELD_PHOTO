import 'dart:typed_data';

void downloadImageOnWeb(Uint8List bytes, String filename) {
  // This function is not used on mobile platforms
  throw UnsupportedError('Web download is not supported on mobile platforms');
}