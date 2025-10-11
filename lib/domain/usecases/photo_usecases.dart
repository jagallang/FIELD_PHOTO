import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../entities/photo.dart';
import '../repositories/photo_repository.dart';

/// Use case for picking a photo from camera or gallery
class PickPhotoUseCase {
  final PhotoRepository repository;

  PickPhotoUseCase(this.repository);

  Future<Photo?> call({required ImageSource source}) async {
    return await repository.pickPhoto(source: source);
  }
}

/// Use case for picking multiple photos
class PickMultiplePhotosUseCase {
  final PhotoRepository repository;

  PickMultiplePhotosUseCase(this.repository);

  Future<List<Photo>> call() async {
    return await repository.pickMultiplePhotos();
  }
}

/// Use case for saving a photo to device
class SavePhotoUseCase {
  final PhotoRepository repository;

  SavePhotoUseCase(this.repository);

  Future<bool> call(Uint8List bytes, String filename) async {
    return await repository.savePhoto(bytes, filename);
  }
}

/// Use case for saving photos as PDF
class SavePhotosAsPdfUseCase {
  final PhotoRepository repository;

  SavePhotosAsPdfUseCase(this.repository);

  Future<bool> call(
    List<Uint8List> images,
    String filename, {
    String? title,
    double? titleFontSize,
  }) async {
    return await repository.savePhotosAsPdf(
      images,
      filename,
      title: title,
      titleFontSize: titleFontSize,
    );
  }
}

/// Use case for sharing a photo
class SharePhotoUseCase {
  final PhotoRepository repository;

  SharePhotoUseCase(this.repository);

  Future<void> call(Uint8List bytes, String filename) async {
    await repository.sharePhoto(bytes, filename);
  }
}