import 'dart:ui';

/// 도형 오버레이 데이터 모델
class ShapeOverlay {
  final String type; // 'arrow', 'rectangle', 'circle', 'text'
  final Offset position;
  final Offset? endPosition; // 화살표용
  final double? width; // 사각형/원용
  final double? height; // 사각형용
  final String? text; // 텍스트용
  final Color color;
  final double strokeWidth;

  ShapeOverlay({
    required this.type,
    required this.position,
    this.endPosition,
    this.width,
    this.height,
    this.text,
    this.color = const Color(0xFFFF0000),
    this.strokeWidth = 3.0,
  });
}