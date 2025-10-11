import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:easy_localization/easy_localization.dart';
// Refactored imports
import 'presentation/widgets/dialogs/photo_source_dialog.dart';
import 'core/constants/app_constants.dart';

// Conditional import for web/mobile
import 'web_helper.dart' if (dart.library.io) 'mobile_helper.dart' as platform_helper;

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
            ),
          ],
        ),
      ),
    );
  }
}

class RobustNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const RobustNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  State<RobustNetworkImage> createState() => _RobustNetworkImageState();
}

class SmartImage extends StatelessWidget {
  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  const SmartImage({
    super.key,
    required this.imageSource,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 로컬 그라데이션 이미지인지 확인
    if (imageSource.startsWith('local_gradient_')) {
      // local_gradient 이미지들을 빈 슬롯으로 처리
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'photo_add'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    
    // Data URL (base64 인코딩된 이미지) 처리
    if (imageSource.startsWith('data:image/')) {
      try {
        final base64String = imageSource.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.error,
            size: 50,
            color: Colors.red,
          ),
        );
      }
    }
    
    // 네트워크 이미지 처리
    return RobustNetworkImage(
      url: imageSource,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}

class _RobustNetworkImageState extends State<RobustNetworkImage> {
  int _retryCount = 0;
  
  List<String> _getFallbackUrls(String originalUrl) {
    return [
      originalUrl,
      'https://via.placeholder.com/400x300/9E9E9E/FFFFFF?text=Loading...',
      'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgdmlld0JveD0iMCAwIDQwMCAzMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iMzAwIiBmaWxsPSIjRjVGNUY1Ii8+Cjx0ZXh0IHg9IjIwMCIgeT0iMTUwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmaWxsPSIjOTk5OTk5IiBmb250LXNpemU9IjE4Ij7sgJjslZzsnbQ8L3RleHQ+Cjwvc3ZnPgo=',
    ];
  }

  void _retry() {
    setState(() {
      _retryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final urls = _getFallbackUrls(widget.url);
    final currentUrl = _retryCount < urls.length ? urls[_retryCount] : urls.last;
    
    return Image.network(
      currentUrl,
      key: ValueKey('${widget.url}_$_retryCount'),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (_retryCount < urls.length - 1) {
          // 다음 URL로 자동 재시도
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _retry();
          });
          return Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? double.infinity,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        
        // 모든 URL 실패시 최종 오류 UI
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                '이미지 로딩 실패',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  setState(() {
                    _retryCount = 0;
                  });
                },
                child: const Text('다시 시도', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShapeOverlay {
  final String type;
  Offset position;
  double size;
  Color color;
  double rotation;
  
  ShapeOverlay({
    required this.type,
    required this.position,
    this.size = 50.0,
    this.color = Colors.red,
    this.rotation = 0.0,
  });
}

class PageData {
  String title;
  int layoutCount; // 페이지별 레이아웃 (1, 2, 3, 4장)
  Map<int, String> photoData;
  Map<int, String> photoTitles;
  Map<int, double> photoRotations;
  Map<int, Offset> photoOffsets;
  Map<int, double> photoScales;
  Map<int, int> photoZoomLevels;
  List<ShapeOverlay> shapes;
  
  PageData({
    required this.title,
    this.layoutCount = 4,
    Map<int, String>? photoData,
    Map<int, String>? photoTitles,
    Map<int, double>? photoRotations,
    Map<int, Offset>? photoOffsets,
    Map<int, double>? photoScales,
    Map<int, int>? photoZoomLevels,
    List<ShapeOverlay>? shapes,
  }) : photoData = photoData ?? {},
       photoTitles = photoTitles ?? {},
       photoRotations = photoRotations ?? {},
       photoOffsets = photoOffsets ?? {},
       photoScales = photoScales ?? {},
       photoZoomLevels = photoZoomLevels ?? {},
       shapes = shapes ?? [];
}


void main() async {
  // 세로모드로 고정
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ko'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko'),
      child: const PhotoLayoutApp(),
    ),
  );
}

class PhotoLayoutApp extends StatelessWidget {
  const PhotoLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PhotoEditorScreen(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({super.key});

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  String pageTitle = '2024년 가족 여행 앨범 ✈️';
  bool isEditingTitle = false;
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  
  int photoCount = 4;
  bool isPortrait = true;
  int? selectedSlot;
  String currentEditMode = 'select';
  
  // 멀티페이지 관련 변수들
  int currentPageIndex = 0;
  List<PageData> pages = [];
  
  // 페이지 번호 관련 변수들
  bool showPageNumbers = false;
  int startPageNumber = 1;

  // 스크린샷 컨트롤러
  final ScreenshotController _screenshotController = ScreenshotController();
  
  // 저장 모드 플래그 (저장 시에만 true로 설정)
  bool isForExport = false;
  
  // 모바일 웹 감지 플래그 (전역적으로 사용)
  bool get isMobileWeb => kIsWeb && MediaQuery.of(context).size.width < 768;
  
  final List<ShapeOverlay> shapes = [];
  int? selectedShapeIndex;
  
  final Map<int, Offset> photoOffsets = {};
  final Map<int, double> photoScales = {};
  final Map<int, int> photoZoomLevels = {};
  
  final Map<int, String> photoData = {};
  
  final Map<int, String> photoTitles = {};
  
  final Map<int, double> photoRotations = {};

  @override
  void initState() {
    super.initState();
    titleController.text = pageTitle;
    
    // 포커스 리스너 추가
    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus && isEditingTitle) {
        setState(() {
          pageTitle = titleController.text;
          isEditingTitle = false;
        });
      }
    });
    
    // 샘플 사진으로 초기화
    _initializeWithSamplePhotos();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  // 웹에서 이미지 다운로드 함수
  void _downloadImageOnWeb(Uint8List bytes, String filename) {
    if (kIsWeb) {
      _showWebDownloadDialog(bytes, filename);
    }
  }

  // 웹 다운로드 폴더 선택 모달
  void _showWebDownloadDialog(Uint8List bytes, String filename) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WebDownloadDialog(
          bytes: bytes,
          initialFilename: filename,
          onDownload: _performWebDownload,
        );
      },
    );
  }

  // 실제 웹 다운로드 수행
  void _performWebDownload(Uint8List bytes, String filename) {
    try {
      // 플랫폼별 헬퍼 함수 사용
      platform_helper.downloadImageOnWeb(bytes, filename);
      
      // 다운로드 완료 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📥 $filename 다운로드 시작'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 웹 다운로드 실패시 에러 처리
      debugPrint('웹 다운로드 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('다운로드 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 페이지 관리 메소드들
  PageData get currentPage => pages[currentPageIndex];
  
  void _saveCurrentPageData() {
    if (pages.isNotEmpty && currentPageIndex < pages.length) {
      pages[currentPageIndex] = PageData(
        title: pageTitle,
        layoutCount: photoCount,
        photoData: Map<int, String>.from(photoData),
        photoTitles: Map<int, String>.from(photoTitles),
        photoRotations: Map<int, double>.from(photoRotations),
        photoOffsets: Map<int, Offset>.from(photoOffsets),
        photoScales: Map<int, double>.from(photoScales),
        photoZoomLevels: Map<int, int>.from(photoZoomLevels),
        shapes: List<ShapeOverlay>.from(shapes),
      );
    }
  }
  
  void _loadPageData(int pageIndex) {
    if (pageIndex < pages.length) {
      final page = pages[pageIndex];
      setState(() {
        currentPageIndex = pageIndex;
        pageTitle = page.title;
        titleController.text = page.title;
        photoCount = page.layoutCount; // 페이지별 레이아웃 로드
        photoData.clear();
        photoData.addAll(page.photoData);
        photoTitles.clear();
        photoTitles.addAll(page.photoTitles);
        photoRotations.clear();
        photoRotations.addAll(page.photoRotations);
        photoOffsets.clear();
        photoOffsets.addAll(page.photoOffsets);
        photoScales.clear();
        photoScales.addAll(page.photoScales);
        photoZoomLevels.clear();
        photoZoomLevels.addAll(page.photoZoomLevels);
        shapes.clear();
        shapes.addAll(page.shapes);
        selectedSlot = null;
        selectedShapeIndex = null;
        currentEditMode = 'select';
      });
    }
  }

  void _showMultiPhotoAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📷 갤러리에서 사진 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('현재 분할: $photoCount장'),
            const SizedBox(height: 16),
            const Text('갤러리에서 여러장의 사진을 선택하세요.'),
            const SizedBox(height: 8),
            const Text('선택된 사진 수에 따라 자동으로 페이지가 생성됩니다.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickMultipleImagesFromGallery();
            },
            child: const Text('갤러리 열기'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMultipleImagesFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        final List<String> imageDataUrls = [];
        final List<String> imageNames = [];
        
        // 로딩 인디케이터 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이미지를 처리하고 있습니다...'),
              duration: Duration(milliseconds: 500),
            ),
          );
        }
        
        for (int i = 0; i < images.length; i++) {
          try {
            final XFile image = images[i];
            final Uint8List bytes = await image.readAsBytes();
            
            if (bytes.isNotEmpty) {
              final String base64String = base64Encode(bytes);
              final String extension = image.name.split('.').last.toLowerCase();
              final String mimeType = _getMimeType(extension);
              final String dataUrl = 'data:$mimeType;base64,$base64String';
              
              imageDataUrls.add(dataUrl);
              imageNames.add(image.name);
              
              // 이미지 처리 완료
            } else {
              // 빈 이미지 파일
            }
          } catch (imageError) {
            // 개별 이미지 처리 실패
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('이미지 "${images[i].name}" 처리 실패'),
                  duration: const Duration(milliseconds: 100),
                ),
              );
            }
          }
        }
        
        if (imageDataUrls.isNotEmpty) {
          _addMultiplePhotosFromPathsWithNames(imageDataUrls, imageNames);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${imageDataUrls.length}장의 사진이 추가되었습니다'),
                duration: const Duration(milliseconds: 200),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('처리 가능한 이미지가 없습니다'),
                duration: Duration(milliseconds: 100),
              ),
            );
          }
        }
      }
    } catch (e) {
      // 갤러리 이미지 선택 오류
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 가져오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
  
  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg'; // 기본값
    }
  }

  void _addEmptyPage() {
    // 현재 페이지 데이터 저장 (기존 페이지 보호)
    _saveCurrentPageData();
    
    // 새로운 빈 페이지 생성 - 현재 페이지의 레이아웃 사용
    final currentPageLayout = pages.isNotEmpty ? pages[currentPageIndex].layoutCount : 2;
    final newPage = PageData(
      title: '${'page_number'.tr()} ${pages.length + 1}',
      layoutCount: currentPageLayout, // 현재 페이지의 레이아웃 사용
      photoData: {}, // 빈 사진 슬롯들
      photoTitles: {}, // 빈 제목들
      photoRotations: {}, // 기본 회전값
    );
    
    setState(() {
      // 기존 페이지들은 그대로 유지하고 새 페이지만 추가
      pages.add(newPage);
      currentPageIndex = pages.length - 1; // 새 페이지로 이동
    });
    
    // 새 페이지 데이터 로드
    _loadPageData(currentPageIndex);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$currentPageLayout분할의 빈 페이지가 추가되었습니다 (기존 페이지는 유지됨)')),
    );
  }

  void _addEmptyPhotoSlot(int slotIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📷 사진 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('슬롯 ${slotIndex + 1}에 사진을 추가하시겠습니까?'),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickSingleImageForSlot(slotIndex);
            },
            child: const Text('갤러리에서 선택'),
          ),
        ],
      ),
    );
  }

  String _truncateFileName(String fileName, {int maxLength = 15}) {
    // 확장자 제거
    final nameWithoutExt = fileName.split('.').first;
    
    // 길이가 maxLength보다 길면 잘라서 표시
    if (nameWithoutExt.length > maxLength) {
      return '${nameWithoutExt.substring(0, maxLength)}...';
    }
    return nameWithoutExt;
  }

  Future<void> _pickSingleImageForSlot(int slotIndex) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );
      
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        final String base64String = base64Encode(bytes);
        final String dataUrl = 'data:image/${image.name.split('.').last};base64,$base64String';
        
        // 파일명을 텍스트 필드에 표시 (길이 제한)
        final String displayName = _truncateFileName(image.name);
        
        // 먼저 사진 데이터를 추가
        photoData[slotIndex] = dataUrl;
        photoTitles[slotIndex] = displayName;
        photoRotations[slotIndex] = 0;
        
        // 사진 추가 후 빈 슬롯을 자동으로 채움 (setState 포함됨)
        _reorganizePhotos();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('슬롯 ${slotIndex + 1}에 사진이 추가되었습니다')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진을 가져오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _addMultiplePhotosFromPathsWithNames(List<String> imagePaths, List<String> imageNames) {
    final totalPhotos = imagePaths.length;
    
    _saveCurrentPageData();
    
    final requiredPages = (totalPhotos / photoCount).ceil();
    
    // 새로운 페이지들을 생성
    final newPages = <PageData>[];
    
    for (int pageNum = 0; pageNum < requiredPages; pageNum++) {
      final startIndex = pageNum * photoCount;
      final endIndex = math.min(startIndex + photoCount, totalPhotos);
      
      final pagePhotoData = <int, String>{};
      final pagePhotoTitles = <int, String>{};
      final pagePhotoRotations = <int, double>{};
      
      for (int i = startIndex; i < endIndex; i++) {
        final slotIndex = i - startIndex;
        pagePhotoData[slotIndex] = imagePaths[i];
        // 파일명을 텍스트로 사용 (길이 제한)
        pagePhotoTitles[slotIndex] = _truncateFileName(imageNames[i]);
        pagePhotoRotations[slotIndex] = 0;
      }
      
      newPages.add(PageData(
        title: '${'page_number'.tr()} ${pageNum + 1}',
        layoutCount: photoCount,
        photoData: pagePhotoData,
        photoTitles: pagePhotoTitles,
        photoRotations: pagePhotoRotations,
      ));
    }
    
    setState(() {
      pages.clear();
      pages.addAll(newPages);
      currentPageIndex = 0;
    });
    
    _loadPageData(0);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$totalPhotos장의 사진으로 $requiredPages개 페이지를 생성했습니다')),
    );
  }



  void selectSlot(int index) {
    // local_gradient_로 시작하거나 데이터가 없는 경우 빈 슬롯으로 처리
    final hasRealPhoto = photoData.containsKey(index) && 
                        photoData[index] != null && 
                        !photoData[index]!.startsWith('local_gradient_');
    
    // 빈 슬롯인 경우 선택 상태 변경 없이 바로 사진 추가 다이얼로그 표시
    if (!hasRealPhoto) {
      _addEmptyPhotoSlot(index);
      return; // 선택 상태 변경 없이 리턴
    }
    
    // 실제 사진이 있는 슬롯인 경우에만 선택 상태 변경
    setState(() {
      selectedSlot = index;
      if (currentEditMode == 'photo') {
        addPhotoToSlot(index);
      }
    });
  }

  void _resetPhotoPosition(int index) {
    setState(() {
      photoOffsets.remove(index);
      photoScales.remove(index);
      photoZoomLevels.remove(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('사진 ${index + 1}이 원본 위치로 복원되었습니다'),
        duration: const Duration(milliseconds: 100),
      ),
    );
  }

  void _zoomPhoto(int index) {
    final currentLevel = photoZoomLevels[index] ?? 0;
    if (currentLevel < 10) {
      photoZoomLevels[index] = currentLevel + 1;
    } else {
      photoZoomLevels[index] = 0;
    }
    
    setState(() {});
    
    // 매우 짧은 피드백만 제공
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentLevel < 10 
            ? '${currentLevel + 1}단계 확대 (${_getScaleFromZoomLevel(currentLevel + 1).toStringAsFixed(1)}x)' 
            : '원본 크기 (1.0x)'),
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  double _getScaleFromZoomLevel(int zoomLevel) {
    switch (zoomLevel) {
      case 0: return 1.0;   // 원본
      case 1: return 1.2;   // 1단계
      case 2: return 1.4;   // 2단계  
      case 3: return 1.6;   // 3단계
      case 4: return 1.8;   // 4단계
      case 5: return 2.0;   // 5단계
      case 6: return 2.2;   // 6단계
      case 7: return 2.4;   // 7단계
      case 8: return 2.6;   // 8단계
      case 9: return 2.8;   // 9단계
      case 10: return 3.0;  // 10단계 (최대 확대)
      default: return 1.0;
    }
  }

  void addPhotoToSlot(int index) {
    setState(() {
      if (!photoData.containsKey(index)) {
        photoData[index] = 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=200&fit=crop';
        photoRotations[index] = 0;
      }
    });
  }

  void removePhoto(int index) {
    setState(() {
      photoData.remove(index);
      photoRotations[index] = 0;
      photoTitles.remove(index);
    });
  }

  void rotatePhoto(int index) {
    setState(() {
      photoRotations[index] = ((photoRotations[index] ?? 0) + 90) % 360;
    });
  }

  void setEditMode(String mode) {
    setState(() {
      if (mode == 'select' && currentEditMode == 'select') {
        // 이미 선택 모드인 상태에서 다시 선택 버튼을 누르면 모든 선택 해제하고 선택 모드도 비활성화
        selectedSlot = null;
        selectedShapeIndex = null;
        currentEditMode = '';  // 선택 모드 비활성화
      } else {
        currentEditMode = mode;
        if (mode == 'select') {
          // 선택 모드로 전환시 모든 선택 해제
          selectedSlot = null;
          selectedShapeIndex = null;
        } else if (mode != 'select') {
          selectedSlot = null;
        }
      }
    });
  }

  void showZoomModal(int slotIndex) {
    if (!photoData.containsKey(slotIndex)) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📷 사진 확대 보기',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(20),
                  child: Transform.rotate(
                    angle: (photoRotations[slotIndex] ?? 0) * 3.14159 / 180,
                    child: SmartImage(
                      imageSource: photoData[slotIndex]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.rotate_right),
                      label: const Text('회전'),
                      onPressed: () {
                        rotatePhoto(slotIndex);
                        Navigator.pop(context);
                        showZoomModal(slotIndex);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('제목 수정'),
                      onPressed: () {
                        Navigator.pop(context);
                        editPhotoTitle(slotIndex);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('삭제'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        removePhoto(slotIndex);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editPhotoTitle(int index) {
    final controller = TextEditingController(text: photoTitles[index] ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사진 제목 수정'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '사진 제목을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                photoTitles[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }



  void _editPhotoTitleInline(int index) {
    final controller = TextEditingController(text: photoTitles[index] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('사진 ${index + 1} 제목 편집'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '사진 제목을 입력하세요',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                photoTitles[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showLayoutChangeWarning(int newPhotoCount) {
    if (_hasAnyContent()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 분할 변경 경고'),
          content: const Text(
            '⚠️ 현재 페이지의 분할을 변경합니다.\n\n• 현재 페이지만 새로운 분할로 변경됩니다\n• 현재 페이지의 편집 내용(회전, 확대/축소, 도형)이 삭제됩니다\n• 현재 페이지의 사진들이 새 레이아웃에 맞게 재배치됩니다\n• 다른 페이지들은 영향을 받지 않습니다\n\n계속하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _changeLayoutForCurrentPage(newPhotoCount);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        photoCount = newPhotoCount;
        _saveCurrentPageData(); // 레이아웃 변경 저장
      });
    }
  }

  void _showOrientationChangeWarning(bool newIsPortrait) {
    if (_hasAnyContent()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 방향 변경 경고'),
          content: const Text(
            '방향을 변경하면 현재 편집 중인 모든 사진, 도형, 텍스트가 삭제됩니다.\n\n계속하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetAllContent();
                setState(() {
                  isPortrait = newIsPortrait;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('방향이 ${newIsPortrait ? "세로" : "가로"}로 변경되고 모든 내용이 초기화되었습니다')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        isPortrait = newIsPortrait;
      });
    }
  }

  bool _hasAnyContent() {
    return photoData.isNotEmpty || shapes.isNotEmpty || pageTitle != '2024년 가족 여행 앨범 ✈️';
  }

  // 빈 슬롯을 자동으로 채우는 함수
  void _reorganizePhotos() {
    final currentPhotos = Map<int, String>.from(photoData);
    final currentPhotoTitles = Map<int, String>.from(photoTitles);
    final currentPhotoRotations = Map<int, double>.from(photoRotations);
    
    // 빈 슬롯 제거하고 순서대로 재배치
    final redistributedPhotos = <int, String>{};
    final redistributedTitles = <int, String>{};
    final redistributedRotations = <int, double>{};
    
    int newSlotIndex = 0;
    
    // 기존 순서대로 사진들을 앞쪽 슬롯부터 채움
    for (int i = 0; i < photoCount; i++) {
      if (currentPhotos.containsKey(i)) {
        redistributedPhotos[newSlotIndex] = currentPhotos[i]!;
        redistributedTitles[newSlotIndex] = currentPhotoTitles[i] ?? '사진 ${newSlotIndex + 1}';
        redistributedRotations[newSlotIndex] = currentPhotoRotations[i] ?? 0.0;
        newSlotIndex++;
      }
    }
    
    // 데이터 업데이트
    setState(() {
      photoData.clear();
      photoData.addAll(redistributedPhotos);
      photoTitles.clear();
      photoTitles.addAll(redistributedTitles);
      photoRotations.clear();
      photoRotations.addAll(redistributedRotations);
    });
    
    _saveCurrentPageData();
  }

  void _changeLayoutForCurrentPage(int newPhotoCount) {
    // 현재 페이지 데이터 저장
    _saveCurrentPageData();
    
    // 현재 페이지의 사진들만 수집
    List<Map<String, String>> currentPagePhotos = [];
    
    final currentPage = pages[currentPageIndex];
    for (int i = 0; i < currentPage.layoutCount; i++) {
      if (currentPage.photoData.containsKey(i) && currentPage.photoData[i]!.isNotEmpty) {
        currentPagePhotos.add({
          'data': currentPage.photoData[i]!,
          'title': currentPage.photoTitles[i] ?? '사진${currentPagePhotos.length + 1}',
        });
      }
    }
    
    // 현재 페이지만 새 레이아웃으로 초기화
    final newPageData = <int, String>{};
    final newPageTitles = <int, String>{};
    final newPageRotations = <int, double>{};
    
    // 기존 사진들을 새 레이아웃에 맞게 재배치 (넘치는 사진은 제외)
    for (int i = 0; i < currentPagePhotos.length && i < newPhotoCount; i++) {
      newPageData[i] = currentPagePhotos[i]['data']!;
      newPageTitles[i] = currentPagePhotos[i]['title']!;
      newPageRotations[i] = 0.0;
    }
    
    // 현재 페이지만 업데이트
    pages[currentPageIndex] = PageData(
      title: currentPage.title,
      layoutCount: newPhotoCount,
      photoData: newPageData,
      photoTitles: newPageTitles,
      photoRotations: newPageRotations,
      photoOffsets: {},
      photoScales: {},
      photoZoomLevels: {},
      shapes: [],
    );
    
    setState(() {
      // 현재 페이지의 photoCount를 업데이트하고 UI를 새로고침
      _loadPageData(currentPageIndex);
      
      // 현재 페이지의 편집 상태만 초기화
      selectedSlot = -1;
      selectedShapeIndex = -1;
      currentEditMode = 'select';
      shapes.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('현재 페이지가 $newPhotoCount분할로 변경되었습니다.'))
    );
  }


  void _resetAllContent() {
    setState(() {
      photoData.clear();
      photoTitles.clear();
      photoRotations.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
      shapes.clear();
      selectedSlot = null;
      selectedShapeIndex = null;
      currentEditMode = 'select';
      pageTitle = '2024년 가족 여행 앨범 ✈️';
      titleController.text = pageTitle;
      
      // 페이지도 초기화
      pages.clear();
      pages.add(PageData(title: pageTitle));
      currentPageIndex = 0;
    });
  }

  void _showCoverPageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('cover_page'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('원하는 템플릿을 선택하세요.\n내용은 미리보기에서 편집할 수 있습니다.', 
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTemplateOption('없음', 'none', setDialogState),
                      _buildTemplateOption('보고서', 'report', setDialogState),
                      _buildTemplateOption('제안서', 'proposal', setDialogState),
                      _buildTemplateOption('앨범', 'album', setDialogState),
                      _buildTemplateOption('레포트', 'document', setDialogState),
                      _buildTemplateOption('견적서(영문)', 'quotation', setDialogState),
                      _buildTemplateOption('견적서(한글)', 'quotation_ko', setDialogState),
                      _buildTemplateOption('인보이스(영문)', 'invoice', setDialogState),
                      _buildTemplateOption('비용청구서', 'invoice_ko', setDialogState),
                      _buildTemplateOption('사진+텍스트', 'photo_text', setDialogState),
                      _buildTemplateOption('텍스트전용', 'text_only', setDialogState),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // 겉표지가 설정되었으면 미리보기 표시
                      if (coverPage != null && coverPage!.template != 'none') {
                        showCoverInPreview = true;
                      } else {
                        showCoverInPreview = false;
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildTemplateOption(String label, String value, StateSetter setDialogState) {
    final isSelected = coverPage?.template == value;
    return InkWell(
      onTap: () {
        // Template option tapped - value: $value
        setDialogState(() {
          if (value == 'none') {
            coverPage = null;
            // Cover page cleared
          } else {
            coverPage ??= CoverPageData();
            coverPage!.template = value;
            // Cover page template set to: $value
            // 템플릿별 기본값 설정
            switch (value) {
              case 'report':
                coverPage!.title = '업무 보고서';
                coverPage!.subtitle = '2025년 1분기';
                coverPage!.author = '홍길동';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.organization = '○○회사';
                coverPage!.primaryColor = Colors.blue;
                break;
              case 'proposal':
                coverPage!.title = '프로젝트 제안서';
                coverPage!.subtitle = '신규 사업 계획';
                coverPage!.author = '김철수';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.organization = '△△기업';
                coverPage!.primaryColor = Colors.teal;
                break;
              case 'album':
                coverPage!.title = '추억의 앨범';
                coverPage!.subtitle = '소중한 순간들';
                coverPage!.author = '우리 가족';
                coverPage!.date = DateTime.now().year.toString();
                coverPage!.primaryColor = Colors.pink;
                break;
              case 'document':
                coverPage!.title = '사진 레포트';
                coverPage!.subtitle = '상세 보고서';
                coverPage!.author = '작성자';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.organization = '부서명';
                coverPage!.primaryColor = Colors.indigo;
                break;
              case 'quotation':
                coverPage!.title = 'ESTIMATE';
                coverPage!.subtitle = 'Photo Service';
                coverPage!.author = 'Manager';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.customerName = 'Company Name';
                coverPage!.projectName = 'Project Name';
                coverPage!.totalAmount = '';
                coverPage!.primaryColor = Colors.green;
                break;
              case 'quotation_ko':
                coverPage!.title = '견적서';
                coverPage!.subtitle = '사진 촬영 서비스';
                coverPage!.author = '담당자';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.customerName = '고객사명';
                coverPage!.projectName = '프로젝트명';
                coverPage!.totalAmount = '₩ 10,000,000';
                coverPage!.primaryColor = Colors.green;
                break;
              case 'invoice':
                coverPage!.title = 'INVOICE';
                coverPage!.subtitle = 'Photo Service';
                coverPage!.author = 'Manager';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.customerName = 'Company Name';
                coverPage!.projectName = 'Project Name';
                coverPage!.totalAmount = '';
                coverPage!.primaryColor = Colors.blue;
                coverPage!.paymentNoticeLines = [
                  '입금은행',
                  '',
                  ''
                ];
                break;
              case 'invoice_ko':
                coverPage!.title = '비용 청구서';
                coverPage!.subtitle = '사진 촬영 서비스';
                coverPage!.author = '담당자';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.customerName = '고객사명';
                coverPage!.projectName = '프로젝트명';
                coverPage!.totalAmount = '';
                coverPage!.primaryColor = Colors.blue;
                coverPage!.paymentNoticeLines = [
                  '입금은행',
                  '',
                  ''
                ];
                break;
              case 'photo_text':
                coverPage!.title = '사진 표지';
                coverPage!.subtitle = '';
                coverPage!.author = '';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.textLines = List.filled(10, '');
                coverPage!.primaryColor = Colors.orange;
                break;
              case 'text_only':
                coverPage!.title = '텍스트 표지';
                coverPage!.subtitle = '';
                coverPage!.author = '';
                coverPage!.date = DateTime.now().toString().split(' ')[0];
                coverPage!.textLines = [
                  '첫 번째 줄',
                  '두 번째 줄',
                  '세 번째 줄',
                  '', '', '', '', '', '', ''
                ];
                coverPage!.primaryColor = Colors.deepPurple;
                break;
            }
            // Template setup completed - title: ${coverPage!.title}
          }
        });
        // 메인 앱 상태도 즉시 업데이트
        setState(() {
          if (coverPage != null && coverPage!.template != 'none') {
            showCoverInPreview = true;
            // Cover page selected - template: ${coverPage!.template}, showCoverInPreview: $showCoverInPreview
          } else {
            showCoverInPreview = false;
            // Cover page cleared - showCoverInPreview: $showCoverInPreview
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 겉표지 필드 편집 관련 메소드들
  void _startEditingCoverField(String fieldType, {int? textLineIndex}) {
    String currentValue = '';
    
    switch (fieldType) {
      case 'title':
        currentValue = coverPage?.title ?? '';
        break;
      case 'subtitle':
        currentValue = coverPage?.subtitle ?? '';
        break;
      case 'author':
        currentValue = coverPage?.author ?? '';
        break;
      case 'date':
        currentValue = coverPage?.date ?? '';
        break;
      case 'organization':
        currentValue = coverPage?.organization ?? '';
        break;
      case 'customerName':
        currentValue = coverPage?.customerName ?? '';
        break;
      case 'projectName':
        currentValue = coverPage?.projectName ?? '';
        break;
      case 'totalAmount':
        currentValue = coverPage?.totalAmount ?? '';
        break;
      case 'supplierCompany':
        currentValue = coverPage?.supplierCompany ?? '';
        break;
      case 'supplierEmail':
        currentValue = coverPage?.supplierEmail ?? '';
        break;
      case 'supplierContact':
        currentValue = coverPage?.supplierContact ?? '';
        break;
      case 'supplierTel':
        currentValue = coverPage?.supplierTel ?? '';
        break;
      case 'customerCompany':
        currentValue = coverPage?.customerCompany ?? '';
        break;
      case 'customerAddress':
        currentValue = coverPage?.customerAddress ?? '';
        break;
      case 'customerTel':
        currentValue = coverPage?.customerTel ?? '';
        break;
      case 'customerEmail':
        currentValue = coverPage?.customerEmail ?? '';
        break;
      case 'estNo':
        currentValue = coverPage?.estNo ?? '';
        break;
      case 'logo':
        // 로고는 이미지 선택 다이얼로그를 표시
        _handleLogoSelection();
        return;
      case 'textLine':
        if (textLineIndex != null && textLineIndex < (coverPage?.textLines.length ?? 0)) {
          currentValue = coverPage!.textLines[textLineIndex];
        }
        break;
      case 'paymentNotice':
        if (textLineIndex != null && textLineIndex < (coverPage?.paymentNoticeLines?.length ?? 0)) {
          currentValue = coverPage!.paymentNoticeLines![textLineIndex];
        }
        break;
      case 'taxIncluded':
        // 세금 포함 선택
        setState(() {
          coverPage!.taxIncluded = true;
        });
        return;
      case 'taxExcluded':
        // 세금 미포함 선택
        setState(() {
          coverPage!.taxIncluded = false;
        });
        return;
      default:
        // 테이블 셀 데이터 처리
        if (fieldType.startsWith('description_') || fieldType.startsWith('specification_') ||
            fieldType.startsWith('unit_') || fieldType.startsWith('qty_') ||
            fieldType.startsWith('price_') || fieldType.startsWith('remarks_')) {
          currentValue = coverPage?.tableData[fieldType] ?? '';
        }
        break;
    }
    
    setState(() {
      isEditingCoverField = true;
      editingFieldType = fieldType;
      editingTextLineIndex = textLineIndex ?? -1;
      coverEditController.text = currentValue;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coverEditFocusNode.requestFocus();
    });
  }
  
  void _saveCoverFieldEdit() {
    if (coverPage == null) return;
    
    final newValue = coverEditController.text;
    
    switch (editingFieldType) {
      case 'title':
        coverPage!.title = newValue;
        break;
      case 'subtitle':
        coverPage!.subtitle = newValue;
        break;
      case 'author':
        coverPage!.author = newValue;
        break;
      case 'date':
        coverPage!.date = newValue;
        break;
      case 'organization':
        coverPage!.organization = newValue;
        break;
      case 'customerName':
        coverPage!.customerName = newValue;
        break;
      case 'projectName':
        coverPage!.projectName = newValue;
        break;
      case 'totalAmount':
        coverPage!.totalAmount = newValue;
        break;
      case 'supplierCompany':
        coverPage!.supplierCompany = newValue;
        break;
      case 'supplierEmail':
        coverPage!.supplierEmail = newValue;
        break;
      case 'supplierContact':
        coverPage!.supplierContact = newValue;
        break;
      case 'supplierTel':
        coverPage!.supplierTel = newValue;
        break;
      case 'customerCompany':
        coverPage!.customerCompany = newValue;
        break;
      case 'customerAddress':
        coverPage!.customerAddress = newValue;
        break;
      case 'customerTel':
        coverPage!.customerTel = newValue;
        break;
      case 'customerEmail':
        coverPage!.customerEmail = newValue;
        break;
      case 'estNo':
        coverPage!.estNo = newValue;
        break;
      case 'textLine':
        if (editingTextLineIndex >= 0 && editingTextLineIndex < coverPage!.textLines.length) {
          coverPage!.textLines[editingTextLineIndex] = newValue;
        }
        break;
      case 'paymentNotice':
        if (editingTextLineIndex >= 0) {
          // paymentNoticeLines가 null이면 초기화
          if (coverPage!.paymentNoticeLines == null) {
            coverPage!.paymentNoticeLines = List.filled(3, '');
          }
          // 인덱스가 범위를 벗어나면 리스트 확장
          while (coverPage!.paymentNoticeLines!.length <= editingTextLineIndex) {
            coverPage!.paymentNoticeLines!.add('');
          }
          coverPage!.paymentNoticeLines![editingTextLineIndex] = newValue;
        }
        break;
      default:
        // 테이블 셀 데이터 저장
        if (editingFieldType.startsWith('description_') || editingFieldType.startsWith('specification_') ||
            editingFieldType.startsWith('unit_') || editingFieldType.startsWith('qty_') ||
            editingFieldType.startsWith('price_') || editingFieldType.startsWith('remarks_')) {
          coverPage!.tableData[editingFieldType] = newValue;
        }
        break;
    }
    
    setState(() {
      isEditingCoverField = false;
      editingFieldType = '';
      editingTextLineIndex = -1;
    });
  }
  
  void _cancelCoverFieldEdit() {
    setState(() {
      isEditingCoverField = false;
      editingFieldType = '';
      editingTextLineIndex = -1;
    });
  }

  void _handleLogoSelection() async {
    try {
      await PhotoSourceDialog.show(
        context,
        (ImageSource source) async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: source,
            maxWidth: 300,
            maxHeight: 300,
            imageQuality: 85,
          );

          if (image != null) {
            final bytes = await image.readAsBytes();
            final base64String = base64Encode(bytes);
            
            setState(() {
              coverPage?.logoImage = base64String;
            });
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ 로고 이미지가 업로드되었습니다!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 선택 중 오류가 발생했습니다: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getFieldLabel(String fieldType) {
    switch (fieldType) {
      case 'title':
        return '제목';
      case 'subtitle':
        return '부제목';
      case 'author':
        return '작성자';
      case 'date':
        return '날짜';
      case 'organization':
        return '기관명';
      case 'additionalInfo':
        return '추가정보';
      case 'customerName':
        return '고객명';
      case 'projectName':
        return '프로젝트명';
      case 'totalAmount':
        return 'Total Amount';
      case 'supplierCompany':
        return 'Company';
      case 'supplierEmail':
        return 'Email';
      case 'supplierContact':
        return 'Contact';
      case 'supplierTel':
        return 'Tel';
      case 'customerCompany':
        return 'Company';
      case 'customerAddress':
        return 'Address';
      case 'customerTel':
        return 'Tel';
      case 'customerEmail':
        return 'Email';
      case 'estNo':
        return 'Est. No.';
      case 'textLine':
        return '텍스트';
      case 'paymentNotice':
        return '결제 안내사항';
      default:
        // 테이블 셀 필드명 처리
        if (fieldType.startsWith('description_')) {
          return 'Description';
        } else if (fieldType.startsWith('specification_')) {
          return 'Specification';
        } else if (fieldType.startsWith('unit_')) {
          return 'Unit';
        } else if (fieldType.startsWith('qty_')) {
          return 'Qty';
        } else if (fieldType.startsWith('price_')) {
          return 'Price';
        } else if (fieldType.startsWith('remarks_')) {
          return 'Remarks';
        }
        return '내용';
    }
  }

  void _showPageNumberDialog() {
    final TextEditingController pageNumberController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('페이지 번호 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('현재 페이지의 시작 번호를 입력하세요'),
              const SizedBox(height: 16),
              TextField(
                controller: pageNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '시작 페이지 번호',
                  hintText: '예: 5',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '예시: 5를 입력하면 현재 페이지가 5번이 되고,\n다음 페이지들은 6, 7, 8... 순서로 번호가 매겨집니다.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final inputText = pageNumberController.text.trim();
                final pageNumber = int.tryParse(inputText);
                
                if (pageNumber != null && pageNumber > 0) {
                  Navigator.of(context).pop();
                  _applyPageNumbers(pageNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('올바른 숫자를 입력해주세요 (1 이상)')),
                  );
                }
              },
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }

  void _applyPageNumbers(int startNumber) {
    setState(() {
      showPageNumbers = true;
      // 현재 페이지가 입력한 번호가 되도록 startPageNumber를 계산
      startPageNumber = startNumber - currentPageIndex;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('현재 페이지가 $startNumber번으로 설정되었습니다')),
    );
  }

  void _deleteCurrentPage() {
    if (pages.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마지막 페이지는 삭제할 수 없습니다')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⚠️ 페이지 삭제 확인'),
          content: Text('현재 페이지 ${currentPageIndex + 1}을(를) 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteCurrentPage();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCurrentPage() {
    setState(() {
      // 현재 페이지 삭제
      pages.removeAt(currentPageIndex);
      
      // 삭제 후 페이지 인덱스 조정
      if (currentPageIndex >= pages.length) {
        currentPageIndex = pages.length - 1;
      }
      
      // 새로운 현재 페이지 로드
      _loadPageData(currentPageIndex);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('페이지가 삭제되었습니다. 현재 페이지: ${currentPageIndex + 1}')),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('초기화 확인'),
            ],
          ),
          content: const Text('모든 데이터가 삭제되고 처음 상태로 초기화됩니다.\n정말로 초기화하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resetToInitialState();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _resetToInitialState() {
    setState(() {
      // 모든 데이터 초기화
      photoData.clear();
      photoTitles.clear();
      photoRotations.clear();
      photoOffsets.clear();
      photoScales.clear();
      photoZoomLevels.clear();
      shapes.clear();
      
      // 페이지 관련 초기화
      pages.clear();
      currentPageIndex = 0;
      
      // 편집 모드 초기화
      selectedSlot = null;
      selectedShapeIndex = null;
      currentEditMode = 'select';
      
      // 페이지 번호 초기화
      showPageNumbers = false;
      startPageNumber = 1;
      
      // 제목 편집 모드 초기화
      isEditingTitle = false;
    });
    
    // 샘플 사진으로 초기화
    _initializeWithSamplePhotos();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 데이터가 초기화되었습니다')),
    );
  }

  void _initializeWithSamplePhotos() {
    // 빈 페이지로 초기화 (샘플 이미지 없이)
    final pagePhotoData = <int, String>{};
    final pagePhotoTitles = <int, String>{};
    final pagePhotoRotations = <int, double>{};

    setState(() {
      pages.add(PageData(
        title: '페이지 1',
        layoutCount: 4,
        photoData: pagePhotoData,
        photoTitles: pagePhotoTitles,
        photoRotations: pagePhotoRotations,
      ));
    });

    _loadPageData(0);
  }

  // 햄버거 메뉴 표시
  void _showHamburgerMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 헤더
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REphoto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '사진을 예술로 만드는 앱',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 메뉴 아이템들
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildMenuTile(
                      icon: Icons.privacy_tip_outlined,
                      title: '개인정보처리방침',
                      subtitle: '개인정보 보호 정책 확인',
                      onTap: () {
                        Navigator.pop(context);
                        _showPrivacyPolicy();
                      },
                    ),
                    const Divider(),
                    _buildMenuTile(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      subtitle: '버전 및 개발자 정보',
                      onTap: () {
                        Navigator.pop(context);
                        _showAppInfo();
                      },
                    ),
                    const Divider(),
                    _buildMenuTile(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      subtitle: 'REphoto v${AppConstants.appVersion}',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog();
                      },
                    ),
                    const Divider(),
                    _buildMenuTile(
                      icon: Icons.help_outline,
                      title: '도움말',
                      subtitle: '앱 사용법 및 FAQ',
                      onTap: () {
                        Navigator.pop(context);
                        _showHelpDialog();
                      },
                    ),
                    const Divider(),
                    _buildMenuTile(
                      icon: Icons.feedback_outlined,
                      title: '피드백',
                      subtitle: '의견 및 개선사항 제안',
                      onTap: () {
                        Navigator.pop(context);
                        _showFeedbackDialog();
                      },
                    ),
                    const SizedBox(height: 20),
                    // 앱 정보 푸터
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '© 2024 REphoto',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Made with ❤️',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFF1976D2),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('REphoto 정보'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('버전: ${AppConstants.appVersion}'),
              SizedBox(height: 8),
              Text('사진을 예술로 만드는 폴라로이드 프레임 앱'),
              SizedBox(height: 16),
              Text('기능:'),
              Text('• 사진에 폴라로이드 프레임 추가'),
              Text('• 다양한 레이아웃 제공'),
              Text('• 사진 확대/축소/회전'),
              Text('• PDF 생성 및 공유'),
              Text('• 고품질 이미지 저장'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '사용법:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. 빈 슬롯을 터치하여 사진 선택'),
              Text('2. 사진을 터치하여 확대/축소/회전'),
              Text('3. 제목을 터치하여 편집'),
              Text('4. 저장 버튼을 눌러 갤러리에 저장'),
              SizedBox(height: 16),
              Text(
                'FAQ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Q: 사진이 저장되지 않아요'),
              Text('A: 저장소 권한을 확인해 주세요'),
              SizedBox(height: 8),
              Text('Q: 사진 품질이 낮아요'),
              Text('A: 설정에서 저장 품질을 높음으로 변경하세요'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('피드백'),
        content: const Text('Google Play 스토어의 REphoto 앱 페이지에서 리뷰를 남겨주세요.\n\n여러분의 소중한 의견이 앱 개선에 큰 도움이 됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('개인정보처리방침'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REphoto 개인정보처리방침',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text('1. 개인정보의 처리목적'),
              Text('REphoto 앱은 사용자의 사진 편집 및 저장 기능을 제공하기 위해 최소한의 권한만을 요청합니다.'),
              SizedBox(height: 12),
              Text('2. 개인정보의 처리 및 보유기간'),
              Text('REphoto는 사용자의 개인정보를 수집하지 않습니다. 모든 사진 편집은 기기 내에서만 이루어집니다.'),
              SizedBox(height: 12),
              Text('3. 개인정보의 제3자 제공'),
              Text('REphoto는 사용자의 개인정보를 제3자에게 제공하지 않습니다.'),
              SizedBox(height: 12),
              Text('4. 개인정보처리의 위탁'),
              Text('REphoto는 개인정보 처리를 위탁하지 않습니다.'),
              SizedBox(height: 12),
              Text('5. 정보주체의 권리·의무 및 행사방법'),
              Text('사용자는 언제든지 앱을 삭제하여 모든 데이터를 제거할 수 있습니다.'),
              SizedBox(height: 12),
              Text('6. 개인정보의 안전성 확보조치'),
              Text('모든 데이터는 사용자의 기기에만 저장되며, 외부로 전송되지 않습니다.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 정보'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REphoto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('버전: ${AppConstants.appVersion}'),
              Text('빌드: 7'),
              SizedBox(height: 16),
              Text('사진을 예술로 만드는 폴라로이드 프레임 앱'),
              SizedBox(height: 16),
              Text(
                '주요 기능:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 다양한 폴라로이드 프레임 제공'),
              Text('• 10단계 확대/축소 기능'),
              Text('• 사진 회전 및 배치 조정'),
              Text('• 고품질 이미지 저장'),
              Text('• PDF 문서 생성'),
              Text('• 웹 버전 지원'),
              SizedBox(height: 16),
              Text(
                '개발자: REphoto Team',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // 왼쪽: 햄버거 메뉴 (웹에서는 숨김)
                  if (!kIsWeb)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                      onPressed: () {
                        _showHamburgerMenu();
                      },
                    ),
                  // 웹에서는 햄버거 메뉴 표시
                  if (kIsWeb) 
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                      onPressed: () {
                        _showHamburgerMenu();
                      },
                    ),
                  
                  // REphoto 텍스트 (웹과 모바일 모두 표시)
                  const Text(
                    'REphoto',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.0,
                    ),
                  ),
                  
                  // 공간을 채워서 버튼들을 우측으로 밀어내기
                  const Spacer(),
                  
                  // 오른쪽: 기능 버튼들
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          _showMultiPhotoAddDialog();
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.white, size: 20),
                            SizedBox(height: 2),
                            Text(
                              '추가',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(40, 40),
                        ),
                        onPressed: () {
                          _showSaveConfirmationDialog();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.save, color: Colors.white, size: 20),
                            const SizedBox(height: 2),
                            Text(
                              'save'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // 1. 방향
                  const Text('방향:', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          onTap: () {
                            if (!isPortrait) {
                              _showOrientationChangeWarning(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPortrait ? Colors.blue : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.smartphone,
                              size: 20,
                              color: isPortrait ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, height: 32, color: Colors.grey[300]),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          onTap: () {
                            if (isPortrait) {
                              _showOrientationChangeWarning(false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: !isPortrait ? Colors.blue : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.stay_current_landscape,
                              size: 20,
                              color: !isPortrait ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 2. 분할
                const Text('분할:', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                DropdownButton<int>(
                  value: photoCount,
                  items: [1, 2, 3, 4].map((count) => DropdownMenuItem(
                    value: count,
                    child: Text('$count장'),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null && value != photoCount) {
                      _showLayoutChangeWarning(value);
                    }
                  },
                ),
                const SizedBox(width: 8),
                // 3. 페이지 추가
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _addEmptyPage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_box, color: Colors.blue, size: 24),
                            const SizedBox(height: 2),
                            Text(
                              'page_number'.tr(),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // 4. 쪽번호
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (showPageNumbers) {
                          setState(() {
                            showPageNumbers = false;
                          });
                        } else {
                          _showPageNumberDialog();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: showPageNumbers ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: showPageNumbers ? Colors.blue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              showPageNumbers ? Icons.check_box : Icons.check_box_outline_blank,
                              color: showPageNumbers ? Colors.blue : Colors.grey[600],
                              size: 24,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '쪽번호',
                              style: TextStyle(
                                color: showPageNumbers ? Colors.blue : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // 5. 겉표지
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _showCoverPageDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: coverPage != null && coverPage!.template != 'none' 
                            ? Colors.purple.withValues(alpha: 0.1) 
                            : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: coverPage != null && coverPage!.template != 'none'
                              ? Colors.purple.withValues(alpha: 0.3) 
                              : Colors.grey.withValues(alpha: 0.3)
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: coverPage != null && coverPage!.template != 'none'
                                ? Colors.purple 
                                : Colors.grey[600],
                              size: 24,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '겉표지',
                              style: TextStyle(
                                color: coverPage != null && coverPage!.template != 'none'
                                  ? Colors.purple 
                                  : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                  // 화면 크기에 완전히 반응하는 동적 계산
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;
                  
                  // 여백을 화면 크기에 비례하여 설정 - 내보내기 시 여백 축소  
                  final horizontalMargin = (isForExport && isMobileWeb) 
                    ? (screenWidth * 0.02).clamp(4.0, 10.0) // 모바일웹 내보내기 시 매우 축소
                    : isForExport 
                      ? (screenWidth * 0.04).clamp(8.0, 20.0) // 일반 내보내기 시 여백 축소 
                      : (screenWidth * 0.08).clamp(16.0, 40.0); // 일반 여백
                  final verticalMargin = (isForExport && isMobileWeb) 
                    ? (screenHeight * 0.002).clamp(1.0, 3.0) // 모바일웹 내보내기 시 매우 축소 
                    : isForExport 
                      ? (screenHeight * 0.005).clamp(2.0, 6.0) // 일반 내보내기 시 여백 축소 
                      : (screenHeight * 0.01).clamp(4.0, 12.0); // 일반 여백
                  
                  // 최소 사용 가능한 공간 보장
                  final availableWidth = (screenWidth - (horizontalMargin * 2)).clamp(200.0, double.infinity);
                  final availableHeight = (screenHeight - (verticalMargin * 2)).clamp(200.0, double.infinity);
                  
                  double containerWidth, containerHeight;
                  
                  // A4 용지 비율 기반 최적화 (1:1.414)
                  const double a4Ratio = 1.414; // A4 세로/가로 비율
                  
                  if (screenWidth < 600) {
                    // 모바일 (소형 화면)
                    if (isPortrait) {
                      // 세로 모드: 세로가 더 긴 A4 (width × 1.414 = height)
                      // 내보내기 모드에서는 더 큰 컨테이너 사용 (사진 품질 개선)
                      containerWidth = availableWidth * (isForExport && isMobileWeb ? 0.98 : isForExport ? 0.95 : 0.85);
                      final minHeight = containerWidth * 1.2;
                      final maxHeight = availableHeight * 0.95;
                      final idealHeight = containerWidth * a4Ratio;
                      
                      if (minHeight <= maxHeight) {
                        containerHeight = idealHeight.clamp(minHeight, maxHeight);
                      } else {
                        // 제약이 모순되는 경우 이상적인 높이 사용
                        containerHeight = idealHeight;
                      }
                    } else {
                      // 가로 모드: 가로가 더 긴 A4 - 크기 최대화
                      // 가용 공간에 맞춰 안전하게 계산
                      final maxPossibleHeight = availableHeight * (isForExport && isMobileWeb ? 0.99 : isForExport ? 0.98 : 0.96);
                      final maxPossibleWidth = availableWidth * (isForExport && isMobileWeb ? 0.98 : isForExport ? 0.95 : 0.90);
                      final idealWidth = maxPossibleHeight * a4Ratio;
                      
                      if (idealWidth <= maxPossibleWidth) {
                        // 이상적인 A4 비율 적용 가능
                        containerHeight = maxPossibleHeight;
                        containerWidth = idealWidth;
                      } else {
                        // 화면 너비에 맞춰 조정
                        containerWidth = maxPossibleWidth;
                        containerHeight = containerWidth / a4Ratio;
                      }
                    }
                  } else {
                    // 태블릿/데스크톱 (대형 화면)
                    if (isPortrait) {
                      // 세로 모드: 세로가 더 긴 A4 (width × 1.414 = height)
                      containerWidth = availableWidth.clamp(350.0, 500.0);
                      final minHeight = 500.0;
                      final maxHeight = availableHeight * 0.95;
                      final idealHeight = containerWidth * a4Ratio;
                      
                      if (minHeight <= maxHeight) {
                        containerHeight = idealHeight.clamp(minHeight, maxHeight);
                      } else {
                        containerHeight = idealHeight;
                      }
                    } else {
                      // 가로 모드: 가로가 더 긴 A4 - 크기 최적화
                      // 가용 공간에 맞춰 안전하게 계산
                      final maxPossibleHeight = availableHeight * 0.9; // 0.8 -> 0.9로 증가
                      final maxPossibleWidth = availableWidth * 0.95; // 0.9 -> 0.95로 증가
                      final idealWidth = maxPossibleHeight * a4Ratio;
                      
                      if (idealWidth <= maxPossibleWidth) {
                        // 이상적인 A4 비율 적용 가능
                        containerHeight = maxPossibleHeight;
                        containerWidth = idealWidth;
                      } else {
                        // 화면 너비에 맞춰 조정
                        containerWidth = maxPossibleWidth;
                        containerHeight = containerWidth / a4Ratio;
                      }
                    }
                  }
                  
                  // 겉표지가 있고 미리보기 표시 옵션이 켜져있으면 겉표지 보여주기
                  if (coverPage != null && coverPage!.template != 'none' && showCoverInPreview) {
                    // Rendering cover page - template: ${coverPage!.template}
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 겉표지 미리보기
                          Container(
                            width: containerWidth.clamp(100.0, double.infinity),
                            height: containerHeight.clamp(100.0, double.infinity),
                            margin: EdgeInsets.symmetric(
                              horizontal: horizontalMargin,
                              vertical: verticalMargin,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CoverPageWidget(
                                    coverData: coverPage!,
                                    isForExport: false,
                                    onFieldTap: _startEditingCoverField,
                                  ),
                                ),
                              // 편집 중일 때 TextField 오버레이
                              if (isEditingCoverField)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    child: Center(
                                      child: Container(
                                        width: 300,
                                        padding: const EdgeInsets.all(20),
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${_getFieldLabel(editingFieldType)} 편집',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                              controller: coverEditController,
                                              focusNode: coverEditFocusNode,
                                              decoration: InputDecoration(
                                                labelText: _getFieldLabel(editingFieldType),
                                                border: const OutlineInputBorder(),
                                              ),
                                              maxLines: editingFieldType == 'textLine' ? 3 : 1,
                                              onSubmitted: (_) => _saveCoverFieldEdit(),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: _cancelCoverFieldEdit,
                                                  child: const Text('취소'),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: _saveCoverFieldEdit,
                                                  child: const Text('저장'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 왼쪽 화살표 (비활성화)
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: null, // 겉표지에서는 뒤로 갈 수 없음
                            color: Colors.grey,
                          ),
                        ),
                        // 오른쪽 화살표 (겉표지에서 사진페이지로)
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            onPressed: () {
                              setState(() {
                                showCoverInPreview = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    );
                  }
                  
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 사진 페이지 (중앙)
                      Screenshot(
                        controller: _screenshotController,
                        child: Container(
                          width: containerWidth.clamp(100.0, double.infinity),
                          height: containerHeight.clamp(100.0, double.infinity),
                          margin: EdgeInsets.symmetric(
                            horizontal: horizontalMargin,
                            vertical: verticalMargin,
                          ),
                          padding: EdgeInsets.all((isForExport && isMobileWeb) 
                            ? (horizontalMargin * 0.1).clamp(1.0, 4.0) // 모바일웹 내보내기 시 패딩 최소화
                            : isForExport 
                              ? (horizontalMargin * 0.3).clamp(3.0, 8.0) // 일반 내보내기 시 패딩 축소
                              : (horizontalMargin * 0.6).clamp(6.0, 12.0)), // 일반 패딩
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingTitle = true;
                        });
                        // 다음 프레임에서 포커스 요청
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          titleFocusNode.requestFocus();
                        });
                      },
                      child: Container(
                        height: isPortrait ? 35 : 30, // 가로모드에서 높이 축소
                        padding: EdgeInsets.only(bottom: isPortrait ? 10 : 5), // 가로모드에서 패딩 축소
                        alignment: Alignment.center, // 중앙 정렬
                        child: isEditingTitle
                            ? SizedBox(
                                height: isPortrait ? 25 : 20, // 가로모드에서 TextField 높이 축소
                                child: TextField(
                                  controller: titleController,
                                  focusNode: titleFocusNode,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 12 : 10, // 가로모드에서 더 작게
                                    fontWeight: FontWeight.normal,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '페이지 제목을 입력하세요',
                                    contentPadding: EdgeInsets.zero, // 패딩 제거
                                    isDense: true, // 컴팩트한 TextField
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      pageTitle = value;
                                      isEditingTitle = false;
                                    });
                                  },
                                  onTapOutside: (event) {
                                    setState(() {
                                      pageTitle = titleController.text;
                                      isEditingTitle = false;
                                    });
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      pageTitle = titleController.text;
                                      isEditingTitle = false;
                                    });
                                  },
                                ),
                              )
                            : Text(
                                pageTitle,
                                style: TextStyle(
                                  fontSize: isPortrait ? 12 : 10, // 가로모드에서 더 작게
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: isPortrait ? 5 : 2), // 가로모드에서 간격 최소화
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: isPortrait ? 40 : 15), // 가로모드에서 하단 여백 더 축소
                        child: GestureDetector(
                        onTapDown: (details) => _handleCanvasTap(details.localPosition),
                        child: Stack(
                          children: [
                            _buildPhotoLayout(),
                            ..._buildShapeOverlays(),
                          ],
                        ),
                        ),
                      ),
                    ),
                      ],
                    ),
                    // 페이지 번호 표시
                    if (showPageNumbers)
                      Positioned(
                        bottom: 3,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            '${startPageNumber + currentPageIndex}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                          ],
                        ),
                      ),
                    ),
                    // 왼쪽 화살표
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () {
                          setState(() {
                            if (currentPageIndex == 0 && coverPage != null && coverPage!.template != 'none') {
                              // 첫 페이지에서 겉표지로
                              showCoverInPreview = true;
                            } else if (currentPageIndex > 0) {
                              // 이전 페이지로
                              _saveCurrentPageData();
                              currentPageIndex--;
                              _loadPageData(currentPageIndex);
                            }
                          });
                        },
                      ),
                    ),
                    // 오른쪽 화살표
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: (currentPageIndex < pages.length - 1) ? () {
                          setState(() {
                            _saveCurrentPageData();
                            currentPageIndex++;
                            _loadPageData(currentPageIndex);
                          });
                        } : null,
                      ),
                    ),
                  ],
                  );
                  },
                ),
              ),
            ),
            // 페이지 네비게이션 - 미리보기 하단
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    icon: Icon(
                      Icons.chevron_left, 
                      color: currentPageIndex > 0 ? Colors.blue : Colors.grey[400],
                      size: 28,
                    ),
                    onPressed: currentPageIndex > 0 ? () {
                      _saveCurrentPageData();
                      _loadPageData(currentPageIndex - 1);
                    } : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${currentPageIndex + 1} / ${pages.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    icon: Icon(
                      Icons.chevron_right,
                      color: currentPageIndex < pages.length - 1 ? Colors.blue : Colors.grey[400],
                      size: 28,
                    ),
                    onPressed: currentPageIndex < pages.length - 1 ? () {
                      _saveCurrentPageData();
                      _loadPageData(currentPageIndex + 1);
                    } : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FA)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              _buildNavButton(
                icon: Icons.touch_app,
                label: '선택',
                isActive: currentEditMode == 'select',
                onTap: () => setEditMode('select'),
              ),
              _buildNavButton(
                icon: Icons.zoom_in,
                label: selectedSlot != null && photoZoomLevels[selectedSlot!] != null && photoZoomLevels[selectedSlot!]! > 0
                    ? '확대 ${photoZoomLevels[selectedSlot!]}/10'
                    : '확대',
                onTap: () {
                  if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    _zoomPhoto(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('확대할 사진을 먼저 선택해주세요'),
                        duration: Duration(milliseconds: 100),
                      ),
                    );
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.center_focus_strong,
                label: '원본',
                onTap: () {
                  if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    _resetPhotoPosition(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('사진을 먼저 선택해주세요'),
                        duration: Duration(milliseconds: 100),
                      ),
                    );
                  }
                },
              ),
              Container(width: 1, height: 40, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 6)),
              _buildNavButton(
                icon: Icons.circle_outlined,
                label: '원',
                isActive: currentEditMode == 'circle',
                onTap: () => setEditMode('circle'),
              ),
              _buildNavButton(
                icon: Icons.crop_square,
                label: '네모',
                isActive: currentEditMode == 'rectangle',
                onTap: () => setEditMode('rectangle'),
              ),
              _buildNavButton(
                icon: Icons.arrow_upward,
                label: '화살',
                isActive: currentEditMode == 'arrow',
                onTap: () => setEditMode('arrow'),
              ),
              Container(width: 1, height: 40, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 6)),
              _buildNavButton(
                icon: Icons.rotate_right,
                label: '회전',
                onTap: () {
                  if (selectedShapeIndex != null) {
                    // 선택된 도형(화살표 포함) 회전
                    setState(() {
                      shapes[selectedShapeIndex!].rotation += 90;
                      shapes[selectedShapeIndex!].rotation = shapes[selectedShapeIndex!].rotation % 360;
                    });
                  } else if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    // 선택된 사진 회전
                    rotatePhoto(selectedSlot!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회전할 사진이나 도형을 먼저 선택해주세요')),
                    );
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.delete,
                label: '지우기',
                onTap: () {
                  if (selectedShapeIndex != null) {
                    setState(() {
                      shapes.removeAt(selectedShapeIndex!);
                      selectedShapeIndex = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('도형이 삭제되었습니다')),
                    );
                  } else if (selectedSlot != null && photoData.containsKey(selectedSlot)) {
                    removePhoto(selectedSlot!);
                  } else {
                    // 선택된 항목이 없으면 페이지 삭제 확인
                    _deleteCurrentPage();
                  }
                },
              ),
              _buildNavButton(
                icon: Icons.refresh,
                label: '초기화',
                onTap: () {
                  _showResetDialog();
                },
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoLayout() {
    switch (photoCount) {
      case 1:
        return _buildSinglePhotoLayout();
      case 2:
        return _buildTwoPhotoLayout();
      case 3:
        return _buildThreePhotoLayout();
      case 4:
      default:
        return _buildFourPhotoLayout();
    }
  }

  Widget _buildSinglePhotoLayout() {
    return _buildPhotoSlot(0);
  }

  Widget _buildTwoPhotoLayout() {
    if (isPortrait) {
      // 세로 모드: 위아래로 배치
      return Column(
        children: [
          Expanded(child: _buildPhotoSlot(0)),
          const SizedBox(height: 8),
          Expanded(child: _buildPhotoSlot(1)),
        ],
      );
    } else {
      // 가로 모드: 좌우로 배치 (세로 모드를 90도 회전한 효과)
      return Row(
        children: [
          Expanded(child: _buildPhotoSlot(0)),
          const SizedBox(width: 8),
          Expanded(child: _buildPhotoSlot(1)),
        ],
      );
    }
  }

  Widget _buildThreePhotoLayout() {
    if (isPortrait) {
      // 세로 모드: 위에 큰 사진, 아래에 작은 사진 2개
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildPhotoSlot(0),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _buildPhotoSlot(1)),
                const SizedBox(width: 8),
                Expanded(child: _buildPhotoSlot(2)),
              ],
            ),
          ),
        ],
      );
    } else {
      // 가로 모드: 왼쪽에 큰 사진, 오른쪽에 작은 사진 2개 (세로 모드를 90도 회전한 효과)
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildPhotoSlot(0),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(child: _buildPhotoSlot(1)),
                const SizedBox(height: 8),
                Expanded(child: _buildPhotoSlot(2)),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFourPhotoLayout() {
    // 세로/가로 모드 모두 2x2 격자 (동일하지만 가로모드에서 공간 활용 개선)
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPhotoSlot(0)),
              const SizedBox(width: 8),
              Expanded(child: _buildPhotoSlot(1)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPhotoSlot(2)),
              const SizedBox(width: 8),
              Expanded(child: _buildPhotoSlot(3)),
            ],
          ),
        ),
      ],
    );
  }

  // 모바일 웹 export용 위젯 생성
  Widget _buildMobileWebExportWidget(PageData pageData) {
    return Material(
      color: Colors.white,
      child: Container(
        width: 595, // A4 width in points
        height: 842, // A4 height in points
        color: Colors.white,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // 페이지 타이틀
            Text(
              pageData.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // 사진 레이아웃
            Expanded(
              child: _buildExportPhotoLayout(pageData),
            ),
          ],
        ),
      ),
    );
  }
  
  // Export용 사진 레이아웃 생성
  Widget _buildExportPhotoLayout(PageData pageData) {
    switch (pageData.layoutCount) {
      case 1:
        return _buildExportPhotoSlot(pageData, 0);
      case 2:
        return Column(
          children: [
            Expanded(child: _buildExportPhotoSlot(pageData, 0)),
            const SizedBox(height: 15),
            Expanded(child: _buildExportPhotoSlot(pageData, 1)),
          ],
        );
      case 3:
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: _buildExportPhotoSlot(pageData, 0),
            ),
            const SizedBox(height: 15),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _buildExportPhotoSlot(pageData, 1)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildExportPhotoSlot(pageData, 2)),
                ],
              ),
            ),
          ],
        );
      case 4:
      default:
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildExportPhotoSlot(pageData, 0)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildExportPhotoSlot(pageData, 1)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildExportPhotoSlot(pageData, 2)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildExportPhotoSlot(pageData, 3)),
                ],
              ),
            ),
          ],
        );
    }
  }
  
  // Export용 개별 사진 슬롯 생성
  Widget _buildExportPhotoSlot(PageData pageData, int index) {
    final hasPhoto = pageData.photoData.containsKey(index) && 
                    pageData.photoData[index] != null && 
                    !pageData.photoData[index]!.startsWith('local_gradient_');
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasPhoto)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Transform.translate(
                offset: pageData.photoOffsets[index] ?? Offset.zero,
                child: Transform.scale(
                  scale: _getScaleFromZoomLevel(pageData.photoZoomLevels[index] ?? 0),
                  child: Transform.rotate(
                    angle: (pageData.photoRotations[index] ?? 0) * 3.14159 / 180,
                    child: SmartImage(
                      imageSource: pageData.photoData[index]!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            )
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    '사진추가',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          if (hasPhoto && pageData.photoTitles[index] != null && pageData.photoTitles[index]!.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  border: const Border(
                    top: BorderSide(color: Colors.black, width: 1),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Text(
                  pageData.photoTitles[index]!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoSlot(int index) {
    // local_gradient_로 시작하는 것은 빈 슬롯으로 처리
    final hasPhoto = photoData.containsKey(index) && 
                    photoData[index] != null && 
                    !photoData[index]!.startsWith('local_gradient_');
    final isSelected = selectedSlot == index;
    final offset = photoOffsets[index] ?? Offset.zero;
    final zoomLevel = photoZoomLevels[index] ?? 0;
    final scale = _getScaleFromZoomLevel(zoomLevel);
    
    return GestureDetector(
      onTap: () => selectSlot(index),
      onLongPress: () {
        if (hasPhoto) {
          showZoomModal(index);
        }
      },
      onPanUpdate: currentEditMode == 'select' && hasPhoto && isSelected
          ? (details) {
              setState(() {
                // 자유로운 드래그 이동 - 제한 없음
                final newOffset = offset + details.delta;
                photoOffsets[index] = newOffset;
              });
            }
          : null,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 100, // 최소 높이 보장
          minWidth: 100,  // 최소 너비 보장
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.red
                : Colors.black, // 모든 슬롯에 검은 테두리
            width: isSelected ? 3 : 1, // 선택된 경우 더 두껍게
            style: BorderStyle.solid, // 항상 테두리 표시
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Stack(
          children: [
            if (hasPhoto)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Transform.translate(
                          offset: offset,
                          child: Transform.scale(
                            scale: scale,
                            child: Transform.rotate(
                              angle: (photoRotations[index] ?? 0) * 3.14159 / 180,
                              child: Center(
                                child: SmartImage(
                                  imageSource: photoData[index]!,
                                  fit: BoxFit.contain, // 가로세로 비율 유지
                                  width: double.infinity,
                                  height: double.infinity,
                                  cacheWidth: 800,
                                  cacheHeight: 600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'photo_add'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (hasPhoto)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _editPhotoTitleInline(index),
                  child: Container(
                    height: 20, // 텍스트 영역 최대 높이 제한
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      border: const Border(
                        top: BorderSide(color: Colors.black, width: 1), // 상단 구분선
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 슬롯 크기에 따라 폰트 크기 동적 조정
                        double fontSize = 9;
                        if (constraints.maxWidth < 80) {
                          fontSize = 7; // 매우 작은 슬롯
                        } else if (constraints.maxWidth < 120) {
                          fontSize = 8; // 작은 슬롯
                        }
                        
                        return Text(
                          photoTitles[index] ?? 'photo_title'.tr(),
                          style: TextStyle(
                            fontSize: fontSize,
                            color: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                                ? Colors.grey 
                                : Colors.black,
                            fontStyle: (photoTitles[index] == null || photoTitles[index]!.isEmpty) 
                                ? FontStyle.italic 
                                : FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (zoomLevel > 0 && hasPhoto && isSelected)
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '확대 $zoomLevel단계 (${scale.toStringAsFixed(1)}x)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (currentEditMode == 'select' && hasPhoto && isSelected)
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '드래그하여 이동',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleCanvasTap(Offset position) {
    if (currentEditMode == 'circle' || currentEditMode == 'rectangle' || currentEditMode == 'arrow') {
      setState(() {
        shapes.add(ShapeOverlay(
          type: currentEditMode,
          position: position,
        ));
        // 도형 추가 후 선택 모드로 자동 전환
        currentEditMode = 'select';
      });
    }
  }

  List<Widget> _buildShapeOverlays() {
    return shapes.asMap().entries.map((entry) {
      final index = entry.key;
      final shape = entry.value;
      final isSelected = selectedShapeIndex == index;
      
      return Positioned(
        left: shape.position.dx - shape.size / 2,
        top: shape.position.dy - shape.size / 2,
        child: GestureDetector(
          onTap: () {
            // 단일 탭은 무시 (더블탭만 처리)
          },
          onDoubleTap: () {
            setState(() {
              selectedShapeIndex = isSelected ? null : index;
              selectedSlot = null; // 도형 선택시 사진 선택 해제
            });
          },
          onPanUpdate: isSelected ? (details) {
            setState(() {
              shape.position = Offset(
                shape.position.dx + details.delta.dx,
                shape.position.dy + details.delta.dy,
              );
            });
          } : null,
          child: Transform.rotate(
            angle: shape.rotation * 3.14159 / 180,
            child: Container(
              width: shape.size,
              height: shape.size,
              decoration: shape.type == 'arrow' 
                  ? null
                  : BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Colors.red : shape.color,
                        width: 2,
                      ),
                      shape: shape.type == 'circle' ? BoxShape.circle : BoxShape.rectangle,
                    ),
              child: shape.type == 'arrow'
                  ? Stack(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: shape.size,
                          color: isSelected ? Colors.red : shape.color,
                        ),
                        if (isSelected) ...[
                          // 크기 조절 핸들
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  shape.size += details.delta.dx;
                                  if (shape.size < 20) shape.size = 20;
                                  if (shape.size > 200) shape.size = 200;
                                });
                              },
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.zoom_in,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : isSelected
                      ? Stack(
                          children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    shape.size += details.delta.dx;
                                    if (shape.size < 20) shape.size = 20;
                                    if (shape.size > 200) shape.size = 200;
                                  });
                                },
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.drag_indicator,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: isActive 
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                )
              : null,
            color: isActive ? null : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.transparent : const Color(0xFFE0E0E0),
              width: 1,
            ),
            boxShadow: isActive 
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : const Color(0xFF424242),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.file_download, color: Colors.blue),
              SizedBox(width: 8),
              Text('내보내기 형식 선택'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${pages.length}개의 페이지를 어떤 형식으로 저장하시겠습니까?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // 이미지 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _exportPagesToGallery();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.image, size: 20),
                  label: Text(
                    'save_as_image'.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // PDF 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _exportPagesToPdf();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf, size: 20),
                  label: Text(
                    'save_as_pdf'.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportPagesToGallery() async {
    // 현재 상태 백업
    final originalCurrentPageIndex = currentPageIndex;
    final originalShowCoverInPreview = showCoverInPreview;
    
    try {
      // 권한 확인 및 요청
      if (!kIsWeb) {
        if (!await Gal.hasAccess()) {
          await Gal.requestAccess();
          if (!await Gal.hasAccess()) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('갤러리 저장을 위해 권한이 필요합니다.')),
              );
            }
            return;
          }
        }
      }

      _saveCurrentPageData(); // 현재 페이지 저장
      
      // 겉표지 미리보기 비활성화 (사진 페이지 캡처를 위해)
      setState(() {
        showCoverInPreview = false;
      });
      
      // 겉표지 비활성화 후 UI 업데이트 대기
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('페이지를 갤러리에 저장하는 중...')),
        );
      }
      
      int savedCount = 0;
      
      // 겉표지가 있으면 먼저 저장
      if (coverPage != null && coverPage!.template != 'none') {
        // 겉표지 위젯을 스크린샷으로 캡처
        final coverWidget = Material(
          child: SizedBox(
            width: 595, // A4 width in points 
            height: 842, // A4 height in points (595 * 1.414)
            child: CoverPageWidget(
              coverData: coverPage!,
              isForExport: true,
            ),
          ),
        );
        
        // 겉표지를 이미지로 캡처 (MediaQuery 컨텍스트 제공)
        if (!mounted) return;
        final mediaQueryData = MediaQuery.of(context);
        final coverBytes = await ScreenshotController().captureFromWidget(
          MediaQuery(
            data: mediaQueryData, // 현재 컨텍스트의 MediaQuery 제공
            child: Material(
              child: coverWidget, // 완전한 머티리얼 컨텍스트 제공
            ),
          ),
          pixelRatio: 5.0, // A4 고해상도 캡처 (모바일웹 호환)
        );
        
        // coverBytes is always non-null after successful capture
        {
          if (kIsWeb) {
            // 웹에서 겉표지 다운로드
            _downloadImageOnWeb(
              coverBytes,
              'REphoto_Cover_${DateTime.now().millisecondsSinceEpoch}.png',
            );
            savedCount++;
          } else {
            try {
              await Gal.putImageBytes(
                coverBytes,
                name: 'REphoto_Cover_${DateTime.now().millisecondsSinceEpoch}',
              );
              savedCount++;
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('겉표지 저장 완료'),
                    duration: Duration(milliseconds: 600),
                  ),
                );
              }
            } catch (saveError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('겉표지 저장 실패: $saveError'),
                    duration: const Duration(milliseconds: 100),
                  ),
                );
              }
            }
          }
        }
      }
      
      for (int pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        // 이미지 저장: 페이지 ${pageIndex + 1}/${pages.length} 처리 시작
        
        // 페이지 로드 및 상태 업데이트
        setState(() {
          currentPageIndex = pageIndex;
          isForExport = true; // 저장 모드로 전환
        });
        _loadPageData(pageIndex);
        
        // UI 업데이트를 위한 충분한 대기
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 스크린샷 캡처 (고해상도)
        try {
          // 화면 크기 미리 확인
          if (!mounted) return;
          final mediaQueryData = MediaQuery.of(context);
          final isMobileWeb = kIsWeb && mediaQueryData.size.width < 768;
          
          debugPrint('🔍 Screenshot Debug - 페이지 ${pageIndex + 1}:');
          debugPrint('  - isForExport: $isForExport');
          debugPrint('  - isMobileWeb: $isMobileWeb');  
          debugPrint('  - 화면크기: ${mediaQueryData.size}');
          debugPrint('  - 템플릿: ${coverPage?.template ?? "없음"}');
          
          Uint8List? imageBytes;
          
          // 모바일 웹에서는 captureFromWidget 사용
          if (isMobileWeb && pageIndex == currentPageIndex) {
            debugPrint('🔍 모바일 웹 - captureFromWidget 사용');
            
            // 현재 페이지 데이터 저장
            _saveCurrentPageData();
            final pageData = pages[pageIndex];
            
            // 큰 위젯 생성 후 캡처
            final widget = _buildMobileWebExportWidget(pageData);
            imageBytes = await _screenshotController.captureFromWidget(
              widget,
              pixelRatio: 3.0, // 고해상도
              context: mounted ? context : null,
              targetSize: const Size(595, 842), // A4 크기
            );
          } else {
            // 데스크톱 웹이나 다른 페이지는 기존 방식
            debugPrint('🔍 일반 레이아웃 - Screenshot 위젯 사용');
            
            imageBytes = await _screenshotController.capture(
              delay: Duration(milliseconds: isMobileWeb ? 1000 : 500),
              pixelRatio: kIsWeb ? 4.0 : 5.0,
            );
          }
          
          debugPrint('🔍 Screenshot 결과: ${imageBytes != null ? "${imageBytes.length} bytes" : "null"}');
          
          if (imageBytes != null) {
            // 이미지 저장: 페이지 ${pageIndex + 1} 스크린샷 캡처 성공 (${imageBytes.length} bytes)
            
            if (kIsWeb) {
              // 웹에서 페이지 다운로드
              _downloadImageOnWeb(
                imageBytes,
                'REphoto_Page_${pageIndex + 1}_${DateTime.now().millisecondsSinceEpoch}.png',
              );
              savedCount++;
            } else {
              // 모바일에서 갤러리에 저장
              try {
                await Gal.putImageBytes(
                  imageBytes,
                  name: 'REphoto_Page_${pageIndex + 1}_${DateTime.now().millisecondsSinceEpoch}',
                );
                
                savedCount++;
                // 이미지 저장: 페이지 ${pageIndex + 1} 갤러리 저장 완료
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('페이지 ${pageIndex + 1} 저장 완료'),
                      duration: const Duration(milliseconds: 100),
                    ),
                  );
                }
              } catch (saveError) {
                // 이미지 저장: 페이지 ${pageIndex + 1} 갤러리 저장 실패: $saveError
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('페이지 ${pageIndex + 1} 저장 실패: $saveError'),
                      duration: const Duration(milliseconds: 100),
                    ),
                  );
                }
              }
            }
          } else {
            // 이미지 저장: 페이지 ${pageIndex + 1} 스크린샷 캡처 실패 - imageBytes가 null
          }
        } catch (captureError) {
          // 이미지 저장: 페이지 ${pageIndex + 1} 스크린샷 캡처 중 오류: $captureError
        }
        
        // 다음 페이지 처리 전 짧은 대기
        if (pageIndex < pages.length - 1) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
      
      // 원래 상태로 복원
      // 이미지 저장: 원래 페이지 ${originalCurrentPageIndex + 1}로 복원
      setState(() {
        currentPageIndex = originalCurrentPageIndex;
        showCoverInPreview = originalShowCoverInPreview;
      });
      _loadPageData(originalCurrentPageIndex);
      
      // 저장 완료 후 미리보기 모드로 복원
      setState(() {
        isForExport = false;
      });
      
      // 최종 결과 메시지
      if (mounted) {
        final message = kIsWeb 
          ? '✅ $savedCount개 페이지가 다운로드되었습니다!'
          : '✅ $savedCount개 페이지가 갤러리에 저장되었습니다!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 오류 발생 시에도 원래 상태로 복원
      // 이미지 저장: 오류 발생, 원래 페이지 ${originalCurrentPageIndex + 1}로 복원
      setState(() {
        currentPageIndex = originalCurrentPageIndex;
        showCoverInPreview = originalShowCoverInPreview;
        isForExport = false; // 미리보기 모드로 복원
      });
      _loadPageData(originalCurrentPageIndex);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('갤러리 저장 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportPagesToPdf() async {
    try {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('PDF 생성 중...'),
              ],
            ),
          );
        },
      );

      // PDF 문서 생성
      final pdf = pw.Document();
      
      // 겉표지가 있으면 먼저 추가
      if (coverPage != null && coverPage!.template != 'none') {
        // 겉표지 위젯을 스크린샷으로 캡처
        final coverWidget = Screenshot(
          controller: ScreenshotController(),
          child: IntrinsicHeight( // 자연스러운 높이로 조정
            child: SizedBox(
              width: 595.28, // A4 width in points (PDF용)
              child: CoverPageWidget(
                coverData: coverPage!,
                isForExport: true,
              ),
            ),
          ),
        );
        
        // 겉표지를 이미지로 캡처
        final coverBytes = await ScreenshotController().captureFromWidget(
          coverWidget,
          pixelRatio: 6.0, // 초고해상도 캡처 (모바일웹 호환 강화)
        );
        
        // coverBytes is always non-null after successful capture
        {
          final coverImage = pw.MemoryImage(coverBytes);
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.zero,
              clip: false,
              build: (pw.Context context) {
                const double a4Width = 595.28;
                const double a4Height = 841.89;
                
                return pw.Image(
                  coverImage,
                  width: a4Width,
                  height: a4Height,
                  fit: pw.BoxFit.fill,
                  dpi: 300,
                );
              },
            ),
          );
        }
      }
      
      // 현재 페이지 데이터 먼저 저장
      _saveCurrentPageData();
      
      debugPrint('PDF 생성: 현재 페이지 저장 완료. pages.length=${pages.length}, currentPageIndex=$currentPageIndex');
      
      // pages가 비어있다면 현재 상태로 임시 페이지 생성
      if (pages.isEmpty) {
        debugPrint('PDF 생성: pages가 비어있음. 현재 상태로 페이지 생성');
        pages.add(PageData(
          title: pageTitle,
          layoutCount: photoCount,
          photoData: Map<int, String>.from(photoData),
          photoTitles: Map<int, String>.from(photoTitles),
          photoRotations: Map<int, double>.from(photoRotations),
          photoOffsets: Map<int, Offset>.from(photoOffsets),
          photoScales: Map<int, double>.from(photoScales),
          photoZoomLevels: Map<int, int>.from(photoZoomLevels),
          shapes: List<ShapeOverlay>.from(shapes),
        ));
        currentPageIndex = 0;
        debugPrint('PDF 생성: 임시 페이지 생성 완료. pages.length=${pages.length}');
      }
      
      // 현재 편집 상태 백업
      final originalCurrentPageIndex = currentPageIndex;
      final originalPhotoData = Map<int, String>.from(photoData);
      final originalPhotoTitles = Map<int, String>.from(photoTitles);
      final originalPhotoRotations = Map<int, double>.from(photoRotations);
      final originalPhotoOffsets = Map<int, Offset>.from(photoOffsets);
      final originalPhotoScales = Map<int, double>.from(photoScales);
      final originalPhotoZoomLevels = Map<int, int>.from(photoZoomLevels);
      final originalShapes = List<ShapeOverlay>.from(shapes);
      
      // 겉표지 상태 백업 및 비활성화
      final originalShowCoverInPreview = showCoverInPreview;
      debugPrint('PDF 생성: 겉표지 상태 백업 (showCoverInPreview: $originalShowCoverInPreview)');
      
      // PDF 생성 동안 겉표지 숨기기
      setState(() {
        showCoverInPreview = false;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      
      debugPrint('PDF 생성: ${pages.length}개 페이지 처리 시작');
      
      // 각 페이지를 PDF로 변환
      for (int pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        debugPrint('PDF 생성: 페이지 ${pageIndex + 1}/${pages.length} 처리 중');
        
        // 모든 페이지에 대해 페이지 데이터를 로드
        setState(() {
          currentPageIndex = pageIndex;
          isForExport = true; // PDF 저장 모드로 전환
        });
        _loadPageData(pageIndex);
        
        // UI 업데이트 완료 대기
        await Future.delayed(const Duration(milliseconds: 300));
        
        try {
          // 화면 크기 미리 확인
          if (!mounted) return;
          final mediaQueryData = MediaQuery.of(context);
          final isMobileWeb = kIsWeb && mediaQueryData.size.width < 768;
          
          final Uint8List? imageBytes = await _screenshotController.capture(
            pixelRatio: kIsWeb 
              ? (isMobileWeb ? 6.0 : 6.0) // 모바일 웹도 고해상도: 6.0, 데스크톱 웹: 6.0
              : 6.0, // 모바일 앱: 6.0
            delay: Duration(milliseconds: isMobileWeb ? 200 : 50),
          );
          
          if (imageBytes != null) {
            debugPrint('PDF 생성: 페이지 ${pageIndex + 1} 스크린샷 캡처 성공 (${imageBytes.length} bytes)');
            final image = pw.MemoryImage(imageBytes);
            
            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat.a4,
                margin: pw.EdgeInsets.zero, // 여백 완전 제거
                clip: false, // 클리핑 비활성화
                build: (pw.Context context) {
                  // A4 크기 (포인트 단위)
                  const double a4Width = 595.28; // A4 width in points
                  const double a4Height = 841.89; // A4 height in points
                  
                  return pw.Image(
                    image,
                    width: a4Width,
                    height: a4Height,
                    fit: pw.BoxFit.fill, // 비율 무시하고 전체 채우기
                    dpi: 300, // 고해상도 설정
                  );
                },
              ),
            );
            debugPrint('PDF 생성: 페이지 ${pageIndex + 1} PDF에 추가 완료');
          } else {
            debugPrint('PDF 생성: 페이지 ${pageIndex + 1} 스크린샷 캡처 실패');
          }
        } catch (e) {
          debugPrint('PDF 생성: 페이지 ${pageIndex + 1} 오류 - $e');
        }
      }
      
      // 원래 페이지와 편집 상태로 완전 복원
      setState(() {
        currentPageIndex = originalCurrentPageIndex;
        photoData.clear();
        photoData.addAll(originalPhotoData);
        photoTitles.clear();
        photoTitles.addAll(originalPhotoTitles);
        photoRotations.clear();
        photoRotations.addAll(originalPhotoRotations);
        photoOffsets.clear();
        photoOffsets.addAll(originalPhotoOffsets);
        photoScales.clear();
        photoScales.addAll(originalPhotoScales);
        photoZoomLevels.clear();
        photoZoomLevels.addAll(originalPhotoZoomLevels);
        shapes.clear();
        shapes.addAll(originalShapes);
        // 겉표지 상태 복원
        showCoverInPreview = originalShowCoverInPreview;
        isForExport = false; // 미리보기 모드로 복원
      });
      _loadPageData(originalCurrentPageIndex);
      
      debugPrint('PDF 생성: 모든 상태 복원 완료 (showCoverInPreview: $originalShowCoverInPreview)');
      
      // 로딩 다이얼로그 닫기
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // PDF를 Uint8List로 저장
      final Uint8List pdfBytes = await pdf.save();
      
      // PDF 인쇄/공유 다이얼로그 표시
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ PDF가 생성되었습니다!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 로딩 다이얼로그가 열려있다면 닫기
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF 생성 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

  

// 웹 다운로드 모달 다이얼로그
class WebDownloadDialog extends StatefulWidget {
  final Uint8List bytes;
  final String initialFilename;
  final Function(Uint8List, String) onDownload;

  const WebDownloadDialog({
    super.key,
    required this.bytes,
    required this.initialFilename,
    required this.onDownload,
  });

  @override
  State<WebDownloadDialog> createState() => _WebDownloadDialogState();
}

class _WebDownloadDialogState extends State<WebDownloadDialog> {
  late TextEditingController _filenameController;
  late FocusNode _filenameFocusNode;

  @override
  void initState() {
    super.initState();
    // 초기 파일명에서 확장자 제거
    final nameWithoutExtension = widget.initialFilename.replaceAll('.png', '');
    _filenameController = TextEditingController(text: nameWithoutExtension);
    _filenameFocusNode = FocusNode();
    
    // 텍스트 전체 선택
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filenameFocusNode.requestFocus();
      _filenameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _filenameController.text.length,
      );
    });
  }

  @override
  void dispose() {
    _filenameController.dispose();
    _filenameFocusNode.dispose();
    super.dispose();
  }

  void _handleDownload() {
    String filename = _filenameController.text.trim();
    if (filename.isEmpty) {
      filename = 'REphoto_Image';
    }
    
    // .png 확장자가 없으면 추가
    if (!filename.toLowerCase().endsWith('.png')) {
      filename = '$filename.png';
    }
    
    Navigator.of(context).pop();
    widget.onDownload(widget.bytes, filename);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.download, color: Colors.blue),
          SizedBox(width: 8),
          Text('💾 이미지 다운로드'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '파일명을 입력하세요:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _filenameController,
            focusNode: _filenameFocusNode,
            decoration: InputDecoration(
              hintText: 'REphoto_Image',
              suffixText: '.png',
              suffixStyle: TextStyle(color: Colors.grey[600]),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => _handleDownload(),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          const Text(
            '다운로드 위치:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            '📁 브라우저 기본 다운로드 폴더',
            style: TextStyle(fontSize: 13),
          ),
          const Text(
            '   (일반적으로 Downloads 폴더)',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.keyboard, size: 16, color: Colors.green),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Enter 키를 누르면 바로 다운로드됩니다',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton.icon(
          onPressed: _handleDownload,
          icon: const Icon(Icons.download),
          label: const Text('다운로드'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}