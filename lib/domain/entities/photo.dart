import 'dart:typed_data';

/// Photo entity representing a single photo in the editor
class Photo {
  final String id;
  final String source;
  final Uint8List? bytes;
  final DateTime? addedAt;
  final PhotoType type;
  final String? caption;
  final double scale; // 1.0 = 100%, 1.5 = 150%, etc.
  final double rotation; // 0~360 degrees
  final double offsetX; // Horizontal offset for positioning
  final double offsetY; // Vertical offset for positioning

  Photo({
    required this.id,
    required this.source,
    this.bytes,
    this.addedAt,
    this.type = PhotoType.userPhoto,
    this.caption,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
  });

  bool get isEmpty => source.startsWith('local_gradient_');
  bool get isDataUrl => source.startsWith('data:image/');
  bool get isNetworkUrl => source.startsWith('http');

  Photo copyWith({
    String? id,
    String? source,
    Uint8List? bytes,
    DateTime? addedAt,
    PhotoType? type,
    String? caption,
    double? scale,
    double? rotation,
    double? offsetX,
    double? offsetY,
  }) {
    return Photo(
      id: id ?? this.id,
      source: source ?? this.source,
      bytes: bytes ?? this.bytes,
      addedAt: addedAt ?? this.addedAt,
      type: type ?? this.type,
      caption: caption ?? this.caption,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
    );
  }
}

enum PhotoType {
  userPhoto,
  placeholder,
  gradient,
}