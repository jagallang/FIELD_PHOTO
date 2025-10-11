import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Local gradient image widget for displaying sample images with gradients
class LocalGradientImage extends StatelessWidget {
  final String imageId;
  final BoxFit fit;
  final double? width;
  final double? height;

  const LocalGradientImage({
    super.key,
    required this.imageId,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'local_gradient_1':
        return [const Color(0xFF4CAF50), const Color(0xFF81C784)]; // Green
      case 'local_gradient_2':
        return [const Color(0xFF2196F3), const Color(0xFF64B5F6)]; // Blue
      case 'local_gradient_3':
        return [const Color(0xFFFF9800), const Color(0xFFFFB74D)]; // Orange
      case 'local_gradient_4':
        return [const Color(0xFFE91E63), const Color(0xFFF06292)]; // Pink
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }

  String _getImageText(String id, BuildContext context) {
    switch (id) {
      case 'local_gradient_1':
        return 'sample_nature'.tr();
      case 'local_gradient_2':
        return 'sample_city_night'.tr();
      case 'local_gradient_3':
        return 'sample_ocean_view'.tr();
      case 'local_gradient_4':
        return 'sample_food'.tr();
      default:
        return 'sample_image'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getGradientColors(imageId);
    final text = _getImageText(imageId, context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}