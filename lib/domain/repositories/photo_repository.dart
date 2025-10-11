import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../entities/photo.dart';

/// Repository interface for photo operations
abstract class PhotoRepository {
  Future<Photo?> pickPhoto({required ImageSource source});
  Future<List<Photo>> pickMultiplePhotos();
  Future<bool> savePhoto(Uint8List bytes, String filename);
  Future<bool> savePhotosAsPdf(
    List<Uint8List> images,
    String filename, {
    String? title,
    double? titleFontSize,
  });
  Future<void> sharePhoto(Uint8List bytes, String filename);
}