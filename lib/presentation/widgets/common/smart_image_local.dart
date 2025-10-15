import 'dart:io';

import 'package:flutter/material.dart';

Widget buildLocalFileImage({
  required String path,
  required BoxFit fit,
  double? width,
  double? height,
  int? cacheWidth,
  int? cacheHeight,
  String quality = 'low', // 품질 설정: 'low', 'medium', 'high'
  required Widget errorWidget,
}) {
  // 품질별 다운샘플링 설정
  int effectiveCacheWidth;
  int effectiveCacheHeight;

  switch (quality) {
    case 'high':
      effectiveCacheWidth = cacheWidth ?? 2000;
      effectiveCacheHeight = cacheHeight ?? 1500;
      break;
    case 'medium':
      effectiveCacheWidth = cacheWidth ?? 1200;
      effectiveCacheHeight = cacheHeight ?? 900;
      break;
    case 'low':
    default:
      effectiveCacheWidth = cacheWidth ?? 800;
      effectiveCacheHeight = cacheHeight ?? 600;
      break;
  }

  return Image.file(
    File(path),
    fit: fit,
    width: width,
    height: height,
    cacheWidth: effectiveCacheWidth,
    cacheHeight: effectiveCacheHeight,
    // 비동기 로딩 처리로 UI 프리징 방지
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) return child;
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    },
    errorBuilder: (context, error, stackTrace) => errorWidget,
  );
}
