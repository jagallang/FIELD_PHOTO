import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/photo.dart';
import '../../../domain/entities/layout_config.dart';
import '../common/smart_image.dart';

/// Photo grid widget for displaying photos in a grid layout
class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;
  final LayoutConfig layoutConfig;
  final Function(int index)? onPhotoTap;
  final Function(int index)? onPhotoLongPress;
  final Function(int oldIndex, int newIndex)? onReorder;
  final Function(int index, String caption)? onCaptionChanged;
  final Function(int index, double offsetX, double offsetY)? onPhotoOffsetChanged;
  final bool showBorder;
  final int? selectedPhotoIndex;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.layoutConfig,
    this.onPhotoTap,
    this.onPhotoLongPress,
    this.onReorder,
    this.onCaptionChanged,
    this.onPhotoOffsetChanged,
    this.showBorder = true,
    this.selectedPhotoIndex,
  });

  @override
  Widget build(BuildContext context) {
    final photosPerPage = layoutConfig.photosPerPage;

    // 커스텀 레이아웃
    if (photosPerPage == 1) {
      // 1분할: 전체
      return _buildLayout1(context);
    } else if (photosPerPage == 2) {
      // 2분할: 위/아래
      return _buildLayout2(context);
    } else if (photosPerPage == 3) {
      // 3분할: 위 1장, 아래 2장
      return _buildLayout3(context);
    } else if (photosPerPage == 4) {
      // 4분할: 2x2
      return _buildLayout4(context);
    }

    // 기본 그리드 (fallback)
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutConfig.columns,
        crossAxisSpacing: layoutConfig.spacing,
        mainAxisSpacing: layoutConfig.spacing,
        childAspectRatio: 0.85,
      ),
      itemCount: layoutConfig.photosPerPage,
      itemBuilder: (context, index) {
        final photo = index < photos.length ? photos[index] : null;

        return PhotoGridItem(
          photo: photo,
          index: index,
          showBorder: showBorder,
          borderWidth: layoutConfig.borderWidth,
          onTap: () => onPhotoTap?.call(index),
          onLongPress: () => onPhotoLongPress?.call(index),
          onReorder: onReorder,
          onCaptionChanged: onCaptionChanged,
          onOffsetChanged: onPhotoOffsetChanged,
          captionFontSize: layoutConfig.captionFontSize,
        );
      },
    );
  }

  Widget _buildLayout1(BuildContext context) {
    // 1분할: 전체
    final photo = photos.isNotEmpty ? photos[0] : null;
    return PhotoGridItem(
      photo: photo,
      index: 0,
      showBorder: showBorder,
      borderWidth: layoutConfig.borderWidth,
      onTap: () => onPhotoTap?.call(0),
      onLongPress: () => onPhotoLongPress?.call(0),
      onReorder: onReorder,
      onCaptionChanged: onCaptionChanged,
      onOffsetChanged: onPhotoOffsetChanged,
      isSelected: selectedPhotoIndex == 0,
      captionFontSize: layoutConfig.captionFontSize,
    );
  }

  Widget _buildLayout2(BuildContext context) {
    // 2분할: 위/아래
    return Column(
      children: [
        Expanded(
          child: PhotoGridItem(
            photo: photos.isNotEmpty ? photos[0] : null,
            index: 0,
            showBorder: showBorder,
            borderWidth: layoutConfig.borderWidth,
            onTap: () => onPhotoTap?.call(0),
            onLongPress: () => onPhotoLongPress?.call(0),
            onReorder: onReorder,
            onCaptionChanged: onCaptionChanged,
            onOffsetChanged: onPhotoOffsetChanged,
            captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 0,
          ),
        ),
        SizedBox(height: layoutConfig.spacing),
        Expanded(
          child: PhotoGridItem(
            photo: photos.length > 1 ? photos[1] : null,
            index: 1,
            showBorder: showBorder,
            borderWidth: layoutConfig.borderWidth,
            onTap: () => onPhotoTap?.call(1),
            onLongPress: () => onPhotoLongPress?.call(1),
            onReorder: onReorder,
            onCaptionChanged: onCaptionChanged,
            onOffsetChanged: onPhotoOffsetChanged,
            captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLayout3(BuildContext context) {
    // 3분할: 위 1장, 아래 2장
    return Column(
      children: [
        Expanded(
          child: PhotoGridItem(
            photo: photos.isNotEmpty ? photos[0] : null,
            index: 0,
            showBorder: showBorder,
            borderWidth: layoutConfig.borderWidth,
            onTap: () => onPhotoTap?.call(0),
            onLongPress: () => onPhotoLongPress?.call(0),
            onReorder: onReorder,
            onCaptionChanged: onCaptionChanged,
            onOffsetChanged: onPhotoOffsetChanged,
            captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 0,
          ),
        ),
        SizedBox(height: layoutConfig.spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PhotoGridItem(
                  photo: photos.length > 1 ? photos[1] : null,
                  index: 1,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(1),
                  onLongPress: () => onPhotoLongPress?.call(1),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 1,
                ),
              ),
              SizedBox(width: layoutConfig.spacing),
              Expanded(
                child: PhotoGridItem(
                  photo: photos.length > 2 ? photos[2] : null,
                  index: 2,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(2),
                  onLongPress: () => onPhotoLongPress?.call(2),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayout4(BuildContext context) {
    // 4분할: 2x2
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PhotoGridItem(
                  photo: photos.isNotEmpty ? photos[0] : null,
                  index: 0,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(0),
                  onLongPress: () => onPhotoLongPress?.call(0),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 0,
                ),
              ),
              SizedBox(width: layoutConfig.spacing),
              Expanded(
                child: PhotoGridItem(
                  photo: photos.length > 1 ? photos[1] : null,
                  index: 1,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(1),
                  onLongPress: () => onPhotoLongPress?.call(1),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: layoutConfig.spacing),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PhotoGridItem(
                  photo: photos.length > 2 ? photos[2] : null,
                  index: 2,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(2),
                  onLongPress: () => onPhotoLongPress?.call(2),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 2,
                ),
              ),
              SizedBox(width: layoutConfig.spacing),
              Expanded(
                child: PhotoGridItem(
                  photo: photos.length > 3 ? photos[3] : null,
                  index: 3,
                  showBorder: showBorder,
                  borderWidth: layoutConfig.borderWidth,
                  onTap: () => onPhotoTap?.call(3),
                  onLongPress: () => onPhotoLongPress?.call(3),
                  onReorder: onReorder,
                  onCaptionChanged: onCaptionChanged,
                  captionFontSize: layoutConfig.captionFontSize,
            isSelected: selectedPhotoIndex == 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhotoGridItem extends StatefulWidget {
  final Photo? photo;
  final int index;
  final bool showBorder;
  final double borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(int oldIndex, int newIndex)? onReorder;
  final Function(int index, String caption)? onCaptionChanged;
  final Function(int index, double offsetX, double offsetY)? onOffsetChanged;
  final bool isSelected;
  final double captionFontSize;

  const PhotoGridItem({
    super.key,
    this.photo,
    required this.index,
    this.showBorder = true,
    this.borderWidth = 1.0,
    this.onTap,
    this.onLongPress,
    this.onReorder,
    this.onCaptionChanged,
    this.onOffsetChanged,
    this.isSelected = false,
    this.captionFontSize = 16.5,
  });

  @override
  State<PhotoGridItem> createState() => _PhotoGridItemState();
}

class _PhotoGridItemState extends State<PhotoGridItem> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.photo?.caption ?? '';
  }

  @override
  void didUpdateWidget(PhotoGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.photo?.caption != oldWidget.photo?.caption) {
      _captionController.text = widget.photo?.caption ?? '';
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photo == null) {
      return _EmptySlot(onTap: widget.onTap);
    }

    return Column(
      children: [
        // Photo with drag and drop
        Expanded(
          child: DragTarget<int>(
            onWillAcceptWithDetails: (details) {
              return details.data != widget.index;
            },
            onAcceptWithDetails: (details) {
              widget.onReorder?.call(details.data, widget.index);
            },
            builder: (context, candidateData, rejectedData) {
              return LongPressDraggable<int>(
                data: widget.index,
                feedback: Material(
                  elevation: 4.0,
                  child: Opacity(
                    opacity: 0.7,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SmartImage(
                        imageSource: widget.photo!.source,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: widget.showBorder
                        ? Border.all(
                            color: Colors.grey[400]!,
                            width: widget.borderWidth,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(Icons.drag_indicator, color: Colors.grey[600]),
                  ),
                ),
                child: GestureDetector(
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.blue[100]
                          : Colors.white,
                      border: widget.showBorder
                          ? Border.all(
                              color: widget.isSelected
                                  ? Colors.blue
                                  : (candidateData.isNotEmpty
                                      ? Colors.blue
                                      : Colors.black),
                              width: widget.isSelected ? 3.0 : widget.borderWidth,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.showBorder ? 3 : 4),
                      child: GestureDetector(
                        onPanUpdate: widget.isSelected
                            ? (details) {
                                final newOffsetX = widget.photo!.offsetX + details.delta.dx;
                                final newOffsetY = widget.photo!.offsetY + details.delta.dy;
                                widget.onOffsetChanged?.call(widget.index, newOffsetX, newOffsetY);
                              }
                            : null,
                        child: Transform.translate(
                          offset: Offset(widget.photo!.offsetX, widget.photo!.offsetY),
                          child: Transform.rotate(
                            angle: widget.photo!.rotation * 3.14159 / 180,
                            child: Transform.scale(
                              scale: widget.photo!.scale,
                              child: SmartImage(
                                imageSource: widget.photo!.source,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Caption input
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: TextField(
            controller: _captionController,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: widget.captionFontSize, fontWeight: FontWeight.w500),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'caption'.tr(),
              hintStyle: TextStyle(fontSize: widget.captionFontSize * 0.9, color: Colors.grey[400]),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onChanged: (value) {
              widget.onCaptionChanged?.call(widget.index, value);
            },
          ),
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final VoidCallback? onTap;

  const _EmptySlot({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Icon(
            Icons.add_photo_alternate,
            size: 40,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}