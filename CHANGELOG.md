# Changelog

All notable changes to POL PHOTO will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.32] - 2025-10-15

### Changed
- Updated project branding from FIELD PHOTO to POL PHOTO
- Improved README.md with comprehensive documentation
  - Added system requirements section
  - Added project structure explanation
  - Added technology stack section
  - Added troubleshooting section
  - Added clickable file references

### Fixed
- Replaced deprecated `withOpacity` API with `withValues(alpha:)` in photo_editor_screen.dart
- Removed unused methods in photo_editor_screen.dart:
  - `_onPhotoTap`
  - `_saveAsImage`
  - `_saveAsPdf`
  - `_clearAllPhotos`
- Removed unused imports in photo_editor_screen.dart and platform_file_saver.dart

### Removed
- Deleted backup files (main_old.dart, main_backup.dart, main_clean.dart)
- Updated .gitignore to prevent future backup file commits

### Added
- MIT License file
- CHANGELOG.md for tracking version history

## [1.1.0] - 2024

### Added
- Clean Architecture implementation with domain/data/presentation layers
- Photo layout editing functionality (1-4 photo divisions)
- PDF and PNG export capabilities
- Drag and drop support for photo management
- Title, caption, and page numbering features
- Custom save directory with persistent settings
- Internationalization support (Korean/English)
- Desktop platform support (Windows, macOS, Linux)
- Web platform support

### Technical
- State management using Provider + ChangeNotifier (BLoC pattern)
- Dependency injection with GetIt
- Repository pattern for data access
- Use Case pattern for business logic
- Comprehensive error handling and logging
- Platform-agnostic file system operations

## [1.0.0] - 2024

### Added
- Initial release of Field Photo
- Basic photo layout functionality
- PDF generation support
- Multi-platform support
