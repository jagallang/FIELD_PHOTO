import 'dart:typed_data';
import 'dart:convert';
// Conditional import for web/mobile
import '../../web_helper.dart' if (dart.library.io) '../../mobile_helper.dart' as platform_helper;

class PhotoLocalDataSource {
  Future<void> savePhotoWeb(Uint8List bytes, String filename) async {
    platform_helper.downloadImageOnWeb(bytes, filename);
  }
  
  Future<String> convertBytesToBase64(Uint8List bytes) async {
    return base64Encode(bytes);
  }
  
  Future<Uint8List> convertBase64ToBytes(String base64String) async {
    return base64Decode(base64String);
  }
}