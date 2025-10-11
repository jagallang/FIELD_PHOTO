import 'package:flutter/material.dart';

/// 로컬 그라디언트 이미지 위젯
class LocalGradientImage extends StatelessWidget {
  final double width;
  final double height;
  final bool isForExport;

  const LocalGradientImage({
    super.key,
    required this.width,
    required this.height,
    this.isForExport = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isForExport
              ? [
                  Colors.blue[100]!,
                  Colors.purple[100]!,
                  Colors.pink[100]!,
                ]
              : [
                  Colors.grey[300]!,
                  Colors.grey[400]!,
                  Colors.grey[500]!,
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (!isForExport)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: width * 0.3,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '이미지를 추가하세요',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          if (isForExport)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}