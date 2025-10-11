import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Shape overlay entity for drawing shapes on the photo layout
class ShapeOverlay extends Equatable {
  final String type;
  final Offset position;
  final Size size;
  final Color color;
  final double strokeWidth;

  const ShapeOverlay({
    required this.type,
    required this.position,
    required this.size,
    this.color = Colors.red,
    this.strokeWidth = 2.0,
  });

  ShapeOverlay copyWith({
    String? type,
    Offset? position,
    Size? size,
    Color? color,
    double? strokeWidth,
  }) {
    return ShapeOverlay(
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  List<Object?> get props => [type, position, size, color, strokeWidth];
}