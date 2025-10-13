import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/utils/io_helper.dart';
import 'smart_image_local_stub.dart'
    if (dart.library.io) 'smart_image_local.dart';

/// Smart image widget that handles various image sources
class SmartImage extends StatelessWidget {
  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const SmartImage({
    super.key,
    required this.imageSource,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Handle empty photo slots
    if (imageSource.startsWith('local_gradient_')) {
      return _EmptyPhotoSlot(width: width, height: height);
    }
    
    // Handle Data URL (base64 encoded images)
    if (imageSource.startsWith('data:image/')) {
      return _Base64Image(
        imageSource: imageSource,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
    
    // Handle network images
    if (imageSource.startsWith('http')) {
      return _NetworkImageWidget(
        url: imageSource,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
    
    // Handle local file images
    return _LocalFileImage(
      path: imageSource,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}

class _EmptyPhotoSlot extends StatelessWidget {
  final double? width;
  final double? height;

  const _EmptyPhotoSlot({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'photo_add'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _Base64Image extends StatelessWidget {
  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const _Base64Image({
    required this.imageSource,
    required this.fit,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final base64String = imageSource.split(',').last;
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stackTrace) => _ErrorWidget(
          width: width,
          height: height,
        ),
      );
    } catch (e) {
      return _ErrorWidget(width: width, height: height);
    }
  }
}

class _NetworkImageWidget extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const _NetworkImageWidget({
    required this.url,
    required this.fit,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _LoadingWidget(
          width: width,
          height: height,
          progress: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        );
      },
      errorBuilder: (context, error, stackTrace) => _ErrorWidget(
        width: width,
        height: height,
      ),
    );
  }
}

class _LocalFileImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const _LocalFileImage({
    required this.path,
    required this.fit,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // On IO-capable platforms, use Image.file for local file paths
    if (!kIsWeb && supportsLocalFileSystem) {
      return buildLocalFileImage(
        path: path,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorWidget: _ErrorWidget(
          width: width,
          height: height,
        ),
      );
    }

    // Fallback to Image.asset for asset paths
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (context, error, stackTrace) => _ErrorWidget(
        width: width,
        height: height,
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? progress;

  const _LoadingWidget({this.width, this.height, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const _ErrorWidget({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.broken_image,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}
