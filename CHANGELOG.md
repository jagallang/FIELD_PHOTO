# Changelog

All notable changes to POL PHOTO will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.33] - 2025-10-16

### Added
- **이미지 품질 설정 기능**: 저화질/중화질/고화질 선택 가능
  - 저화질 (기본값): 800x600 캐시, 메모리 사용량 97.6% 감소
  - 중화질: 1200x900 캐시, 메모리 사용량 94.6% 감소
  - 고화질: 2000x1500 캐시, 메모리 사용량 85% 감소
  - 설정 화면에서 언제든지 변경 가능하며 앱 재시작 후에도 유지
- 비동기 이미지 로딩으로 부드러운 페이드인 애니메이션 추가
- 웹 플랫폼 이미지 다운로드 지원 추가

### Fixed
- **UI 프리징 문제 해결**: 대용량 이미지 로드 시 커서가 멈추는 현상 수정
- 이미지 다운샘플링으로 메모리 사용량 최적화
- 선택 테두리가 PNG/PDF 저장 파일에 포함되는 버그 수정

### Technical
- SettingsRepository에 이미지 품질 설정 저장/로드 기능 추가
- SmartImage 위젯에 FutureBuilder를 사용한 동적 품질 설정 적용
- 웹/데스크톱 플랫폼 분기 처리 개선 (conditional imports)
- io_helper_stub.dart에 웹 다운로드 스텁 함수 추가

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
