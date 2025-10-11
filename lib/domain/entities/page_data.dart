import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'shape_overlay.dart';

/// Page data entity containing all information for a single page layout
class PageData extends Equatable {
  final String title;
  final int layoutCount;
  final Map<int, String> photoData;
  final Map<int, String> photoTitles;
  final Map<int, double> photoRotations;
  final Map<int, Offset> photoOffsets;
  final Map<int, double> photoScales;
  final Map<int, int> photoZoomLevels;
  final List<ShapeOverlay> shapes;

  const PageData({
    required this.title,
    this.layoutCount = 4,
    Map<int, String>? photoData,
    Map<int, String>? photoTitles,
    Map<int, double>? photoRotations,
    Map<int, Offset>? photoOffsets,
    Map<int, double>? photoScales,
    Map<int, int>? photoZoomLevels,
    List<ShapeOverlay>? shapes,
  })  : photoData = photoData ?? const {},
        photoTitles = photoTitles ?? const {},
        photoRotations = photoRotations ?? const {},
        photoOffsets = photoOffsets ?? const {},
        photoScales = photoScales ?? const {},
        photoZoomLevels = photoZoomLevels ?? const {},
        shapes = shapes ?? const [];

  PageData copyWith({
    String? title,
    int? layoutCount,
    Map<int, String>? photoData,
    Map<int, String>? photoTitles,
    Map<int, double>? photoRotations,
    Map<int, Offset>? photoOffsets,
    Map<int, double>? photoScales,
    Map<int, int>? photoZoomLevels,
    List<ShapeOverlay>? shapes,
  }) {
    return PageData(
      title: title ?? this.title,
      layoutCount: layoutCount ?? this.layoutCount,
      photoData: photoData ?? this.photoData,
      photoTitles: photoTitles ?? this.photoTitles,
      photoRotations: photoRotations ?? this.photoRotations,
      photoOffsets: photoOffsets ?? this.photoOffsets,
      photoScales: photoScales ?? this.photoScales,
      photoZoomLevels: photoZoomLevels ?? this.photoZoomLevels,
      shapes: shapes ?? this.shapes,
    );
  }

  /// Create an empty page data with default values
  factory PageData.empty({String? title}) {
    return PageData(
      title: title ?? 'New Page',
      layoutCount: 4,
    );
  }

  /// Check if page has any photos
  bool get hasPhotos => photoData.isNotEmpty;

  /// Get count of photos in this page
  int get photoCount => photoData.length;

  /// Check if page has any shapes
  bool get hasShapes => shapes.isNotEmpty;

  @override
  List<Object?> get props => [
        title,
        layoutCount,
        photoData,
        photoTitles,
        photoRotations,
        photoOffsets,
        photoScales,
        photoZoomLevels,
        shapes,
      ];
}