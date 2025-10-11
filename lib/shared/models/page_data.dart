import 'dart:typed_data';
import 'dart:ui';

/// 페이지 데이터 모델
class PageData {
  String title;
  List<Uint8List?> photos = [];
  List<String> photoTitles = [];
  List<double> photoRotations = [];
  List<Offset> photoOffsets = [];
  List<double> photoScales = [];
  List<double> photoZoomLevels = [];
  Map<String, dynamic> backupData = {};

  PageData({required this.title}) {
    for (int i = 0; i < 4; i++) {
      photos.add(null);
      photoTitles.add('');
      photoRotations.add(0.0);
      photoOffsets.add(Offset.zero);
      photoScales.add(1.0);
      photoZoomLevels.add(1.0);
    }
  }
}