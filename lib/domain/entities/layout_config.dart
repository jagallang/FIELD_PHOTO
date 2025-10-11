/// Layout type enum for explicit layout control
enum LayoutType {
  layout1, // 1분할: 전체
  layout2, // 2분할: 위/아래
  layout3, // 3분할: 위 1장, 아래 2장
  layout4, // 4분할: 2x2
}

/// Layout configuration for photo grid
class LayoutConfig {
  final int columns;
  final int rows;
  final double spacing;
  final double borderWidth;
  final bool showPageNumbers;
  final int startingPageNumber;
  final PageNumberPosition pageNumberPosition;
  final double pageNumberFontSize;
  final LayoutType layoutType;
  final String? title;
  final bool showTitle;
  final double titleFontSize;
  final double captionFontSize;

  const LayoutConfig({
    this.columns = 2,
    this.rows = 2,
    this.spacing = 4.0,
    this.borderWidth = 1.0,
    this.showPageNumbers = false,
    this.startingPageNumber = 1,
    this.pageNumberPosition = PageNumberPosition.bottomRight,
    this.pageNumberFontSize = 12.0,
    this.layoutType = LayoutType.layout4,
    this.title,
    this.showTitle = false,
    this.titleFontSize = 20.0,
    this.captionFontSize = 16.5,
  });

  int get photosPerPage {
    switch (layoutType) {
      case LayoutType.layout1:
        return 1;
      case LayoutType.layout2:
        return 2;
      case LayoutType.layout3:
        return 3;
      case LayoutType.layout4:
        return 4;
    }
  }

  LayoutConfig copyWith({
    int? columns,
    int? rows,
    double? spacing,
    double? borderWidth,
    bool? showPageNumbers,
    int? startingPageNumber,
    PageNumberPosition? pageNumberPosition,
    double? pageNumberFontSize,
    LayoutType? layoutType,
    String? title,
    bool? showTitle,
    double? titleFontSize,
    double? captionFontSize,
  }) {
    return LayoutConfig(
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      spacing: spacing ?? this.spacing,
      borderWidth: borderWidth ?? this.borderWidth,
      showPageNumbers: showPageNumbers ?? this.showPageNumbers,
      startingPageNumber: startingPageNumber ?? this.startingPageNumber,
      pageNumberPosition: pageNumberPosition ?? this.pageNumberPosition,
      pageNumberFontSize: pageNumberFontSize ?? this.pageNumberFontSize,
      layoutType: layoutType ?? this.layoutType,
      title: title ?? this.title,
      showTitle: showTitle ?? this.showTitle,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      captionFontSize: captionFontSize ?? this.captionFontSize,
    );
  }
}

enum PageNumberPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}