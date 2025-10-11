import 'package:flutter/material.dart';
import '../../../core/utils/logger.dart';

/// Robust network image widget with error handling and retry functionality
class RobustNetworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int maxRetries;

  const RobustNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.maxRetries = 3,
  });

  @override
  State<RobustNetworkImage> createState() => _RobustNetworkImageState();
}

class _RobustNetworkImageState extends State<RobustNetworkImage> {
  int _retryCount = 0;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError && _retryCount >= widget.maxRetries) {
      return widget.errorWidget ?? _buildDefaultErrorWidget();
    }

    return Image.network(
      widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          _hasError = false;
          _retryCount = 0;
          return child;
        }
        return widget.placeholder ?? _buildDefaultPlaceholder(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        AppLogger.warning('Network image failed to load: ${widget.imageUrl}', 'RobustNetworkImage');
        _handleError(error);
        return widget.errorWidget ?? _buildDefaultErrorWidget();
      },
    );
  }

  void _handleError(Object error) {
    setState(() {
      _hasError = true;
    });

    if (_retryCount < widget.maxRetries) {
      _retryCount++;
      AppLogger.info('Retrying network image load (attempt $_retryCount/${widget.maxRetries})', 'RobustNetworkImage');
      
      Future.delayed(Duration(seconds: _retryCount), () {
        if (mounted) {
          setState(() {
            _hasError = false;
          });
        }
      });
    } else {
      AppLogger.error('Network image failed after ${widget.maxRetries} retries', error, null, 'RobustNetworkImage');
    }
  }

  Widget _buildDefaultPlaceholder(ImageChunkEvent? loadingProgress) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: loadingProgress?.expectedTotalBytes != null
                  ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
            const SizedBox(height: 8),
            const Text('Loading...', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          if (_retryCount >= widget.maxRetries) ...[
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {
                setState(() {
                  _retryCount = 0;
                  _hasError = false;
                });
              },
              child: const Text('Retry', style: TextStyle(fontSize: 10)),
            ),
          ],
        ],
      ),
    );
  }
}