class AppConstants {
  // App Info
  static const String appName = 'POL_PHOTO';
  static const String appVersion = '1.2.28';
  
  // Layout Defaults
  static const int defaultColumns = 2;
  static const int defaultRows = 2;
  static const double defaultSpacing = 4.0;
  static const double defaultBorderWidth = 1.0;
  
  // Layout Limits
  static const int minColumns = 1;
  static const int maxColumns = 4;
  static const int minRows = 1;
  static const int maxRows = 4;
  static const double minSpacing = 0.0;
  static const double maxSpacing = 20.0;
  static const double minBorderWidth = 0.0;
  static const double maxBorderWidth = 5.0;
  
  // Image Settings
  static const int maxImageCacheWidth = 1024;
  static const int maxImageCacheHeight = 1024;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  
  // PDF Settings
  static const String defaultPdfFilename = 'photo_layout.pdf';
  static const double pdfPageMargin = 20.0;

  // Export Settings
  static const double exportImagePixelRatio = 3.0;
  static const double exportMaxHeightRatio = 0.75; // 75% of screen height for A4 preview

  // A4 Paper Dimensions
  static const double a4AspectRatio = 1.0 / 1.414; // A4 Portrait (210mm x 297mm)
  
  // Local Gradient IDs
  static const String gradientId1 = 'local_gradient_1';
  static const String gradientId2 = 'local_gradient_2';
  static const String gradientId3 = 'local_gradient_3';
  static const String gradientId4 = 'local_gradient_4';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Dimensions
  static const double appBarHeight = 56.0;  // Standard Material AppBar height
  static const double buttonHeight = 48.0;
  static const double cardBorderRadius = 8.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  
  // File Extensions
  static const String pngExtension = '.png';
  static const String jpgExtension = '.jpg';
  static const String pdfExtension = '.pdf';
}