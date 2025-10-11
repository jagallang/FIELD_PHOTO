import '../entities/layout_config.dart';
import '../entities/photo.dart';

/// Use case for calculating layout dimensions
class CalculateLayoutUseCase {
  List<List<Photo>> call({
    required List<Photo> photos,
    required LayoutConfig config,
  }) {
    final List<List<Photo>> pages = [];
    final photosPerPage = config.photosPerPage;
    
    for (int i = 0; i < photos.length; i += photosPerPage) {
      final end = (i + photosPerPage < photos.length) 
          ? i + photosPerPage 
          : photos.length;
      pages.add(photos.sublist(i, end));
    }
    
    return pages;
  }
}

/// Use case for validating layout configuration
class ValidateLayoutConfigUseCase {
  bool call(LayoutConfig config) {
    if (config.columns < 1 || config.columns > 4) return false;
    if (config.rows < 1 || config.rows > 4) return false;
    if (config.spacing < 0 || config.spacing > 20) return false;
    if (config.borderWidth < 0 || config.borderWidth > 5) return false;
    return true;
  }
}