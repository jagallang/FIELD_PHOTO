import 'package:web/web.dart' as web;
import 'dart:convert';
import 'package:flutter/foundation.dart';

void downloadImageOnWeb(Uint8List bytes, String filename) {
  final base64 = base64Encode(bytes);
  final dataUrl = 'data:image/png;base64,$base64';
  
  final anchor = web.HTMLAnchorElement()
    ..href = dataUrl
    ..download = filename
    ..style.display = 'none';
  
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
}