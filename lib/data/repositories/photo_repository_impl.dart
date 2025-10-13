import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/photo_local_datasource.dart';
import '../../core/utils/logger.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/io_helper.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoLocalDataSource localDataSource;
  final ImagePicker _picker = ImagePicker();

  PhotoRepositoryImpl({required this.localDataSource});

  @override
  Future<Photo?> pickPhoto({required ImageSource source}) async {
    try {
      AppLogger.debug('Attempting to pick photo from source: $source', 'PhotoRepository');
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final bytes = await image.readAsBytes();
        AppLogger.info('Photo picked successfully, size: ${bytes.length} bytes', 'PhotoRepository');
        return Photo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: kIsWeb ? 'data:image/jpeg;base64,${base64Encode(bytes)}' : image.path,
          bytes: bytes,
          addedAt: DateTime.now(),
        );
      }
      AppLogger.warning('No photo was selected', 'PhotoRepository');
      return null;
    } catch (e) {
      AppLogger.error('Failed to pick photo', e, null, 'PhotoRepository');
      throw PhotoException('Failed to pick photo: ${e.toString()}');
    }
  }

  @override
  Future<List<Photo>> pickMultiplePhotos() async {
    try {
      AppLogger.debug('Attempting to pick multiple photos', 'PhotoRepository');
      final List<XFile> images = await _picker.pickMultiImage();
      final List<Photo> photos = [];
      
      for (final image in images) {
        final bytes = await image.readAsBytes();
        photos.add(Photo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: kIsWeb ? 'data:image/jpeg;base64,${base64Encode(bytes)}' : image.path,
          bytes: bytes,
          addedAt: DateTime.now(),
        ));
      }
      
      AppLogger.info('Successfully picked ${photos.length} photos', 'PhotoRepository');
      return photos;
    } catch (e) {
      AppLogger.error('Failed to pick multiple photos', e, null, 'PhotoRepository');
      throw PhotoException('Failed to pick multiple photos: ${e.toString()}');
    }
  }

  @override
  Future<bool> savePhoto(Uint8List bytes, String filename) async {
    try {
      AppLogger.debug('Attempting to save photo: $filename', 'PhotoRepository');
      if (kIsWeb) {
        await localDataSource.savePhotoWeb(bytes, filename);
      } else if (supportsLocalFileSystem) {
        final directoryPath = await resolveSaveDirectory(null);
        final filePath = joinPath(directoryPath, filename);
        await writeBytesToFile(bytes, filePath);
        AppLogger.info('Photo saved to: $filePath', 'PhotoRepository');
      } else {
        // Mobile platforms (Android/iOS) - not supported in Windows build
        throw UnsupportedError('Mobile photo saving not supported in this build');
      }
      AppLogger.info('Photo saved successfully: $filename', 'PhotoRepository');
      return true;
    } catch (e) {
      AppLogger.error('Failed to save photo: $filename', e, null, 'PhotoRepository');
      throw FileException('Failed to save photo: ${e.toString()}');
    }
  }

  @override
  Future<bool> savePhotosAsPdf(
    List<Uint8List> images,
    String filename, {
    String? title,
    double? titleFontSize,
  }) async {
    try {
      AppLogger.debug('Creating PDF with ${images.length} images: $filename', 'PhotoRepository');
      final pdf = pw.Document();

      for (final imageBytes in images) {
        final image = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // Title section
                  if (title != null && title.isNotEmpty) ...[
                    pw.Text(
                      title,
                      style: pw.TextStyle(
                        fontSize: titleFontSize ?? 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 16),
                  ],
                  // Image
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Image(image, fit: pw.BoxFit.contain),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();

      // Save directly to file system on desktop platforms
      if (!kIsWeb && supportsLocalFileSystem) {
        final directoryPath = await resolveSaveDirectory(null);
        final filePath = joinPath(directoryPath, filename);
        await writeBytesToFile(pdfBytes, filePath);
        AppLogger.info('PDF saved to: $filePath', 'PhotoRepository');
      } else {
        // Fallback to sharing for web or mobile
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: filename,
        );
      }

      AppLogger.info('PDF created successfully: $filename', 'PhotoRepository');
      return true;
    } catch (e) {
      AppLogger.error('Failed to create PDF: $filename', e, null, 'PhotoRepository');
      throw FileException('Failed to create PDF: ${e.toString()}');
    }
  }

  @override
  Future<void> sharePhoto(Uint8List bytes, String filename) async {
    try {
      AppLogger.debug('Sharing photo: $filename', 'PhotoRepository');
      final pdf = pw.Document();
      final image = pw.MemoryImage(bytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          ),
        ),
      );

      final pdfBytes = await pdf.save();

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: filename.toLowerCase().endsWith('.pdf') ? filename : '$filename.pdf',
      );
      AppLogger.info('Photo shared successfully: $filename', 'PhotoRepository');
    } catch (e) {
      AppLogger.error('Failed to share photo: $filename', e, null, 'PhotoRepository');
      throw FileException('Failed to share photo: ${e.toString()}');
    }
  }
}
