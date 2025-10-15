import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/io_helper.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../domain/repositories/settings_repository.dart';
import '../../bloc/photo_editor_bloc.dart';
import '../../widgets/editor/photo_grid.dart';
import '../../widgets/dialogs/photo_source_dialog.dart';
import '../../widgets/dialogs/layout_settings_dialog.dart';
import '../settings/settings_screen.dart';
import '../../../web_helper.dart' if (dart.library.io) '../../../core/utils/io_helper_stub.dart';

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({super.key});

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  final List<GlobalKey> _repaintBoundaryKeys = [];
  String? _customSavePath;
  SettingsRepository? _settingsRepository;

  @override
  void initState() {
    super.initState();
    if (supportsLocalFileSystem) {
      _settingsRepository = di.sl<SettingsRepository>();
      _loadSavedPath();
    }
  }

  Future<void> _loadSavedPath() async {
    try {
      final savedPath = await _settingsRepository?.getSavePath();
      if (!mounted || savedPath == null || savedPath.isEmpty) return;
      setState(() {
        _customSavePath = savedPath;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoEditorBloc>(
      builder: (context, bloc, child) {
        return Scaffold(
          key: const Key('photo_editor_screen'),
          backgroundColor: AppTheme.grey50,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, bloc),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.mediumPadding),
                  child: Column(
                    children: [
                      _buildActionButtons(context, bloc),
                      const SizedBox(height: AppConstants.mediumPadding),
                      _buildPhotoGrid(context, bloc),
                      const SizedBox(height: AppConstants.mediumPadding),
                      _buildBottomActions(context, bloc),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, PhotoEditorBloc bloc) {
    return SliverAppBar(
      expandedHeight: AppConstants.appBarHeight,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'app_title'.tr(),
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open, color: AppTheme.white),
                    onPressed: () => _showFolderOptionsDialog(context),
                    tooltip: 'folder_options'.tr(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppTheme.white),
                    onPressed: () => _navigateToSettings(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PhotoEditorBloc bloc) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showPhotoSourceDialog(context, bloc),
                icon: const Icon(Icons.add_photo_alternate, size: 20),
                label: Text('add_photo'.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showLayoutSettingsDialog(context, bloc),
                icon: const Icon(Icons.grid_view, size: 20),
                label: Text('layout_settings'.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: bloc.photoPages.isNotEmpty && !bloc.isLoading
                    ? () => _showSaveLayoutDialog(context, bloc)
                    : null,
                icon: const Icon(Icons.save, size: 20),
                label: Text('save_layout'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: bloc.isLoading ? null : () => _createBulkPdf(context, bloc),
                icon: const Icon(Icons.merge_type, size: 20),
                label: Text('merge_pdfs'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, PhotoEditorBloc bloc) {
    if (bloc.photoPages.isEmpty) {
      return _buildEmptyState(context);
    }

    // Ensure we have enough GlobalKeys for all pages
    while (_repaintBoundaryKeys.length < bloc.photoPages.length) {
      _repaintBoundaryKeys.add(GlobalKey());
    }
    // Remove excess keys if pages were deleted
    if (_repaintBoundaryKeys.length > bloc.photoPages.length) {
      _repaintBoundaryKeys.removeRange(bloc.photoPages.length, _repaintBoundaryKeys.length);
    }

    return Column(
      children: bloc.photoPages.asMap().entries.map((entry) {
        final pageIndex = entry.key;
        final photos = entry.value;

        return Column(
          children: [
            if (pageIndex > 0)
              const SizedBox(height: AppConstants.largePadding),
            // A4 Portrait aspect ratio container (1:1.414)
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  maxHeight: MediaQuery.of(context).size.height * 0.70, // 70% of screen height - allows bottom controls to be visible
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1.414, // A4 portrait ratio
                  child: RepaintBoundary(
                    key: _repaintBoundaryKeys[pageIndex],
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.mediumPadding),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title section
                          if (bloc.layoutConfig.showTitle) ...[
                            Text(
                              bloc.layoutConfig.title ?? '',
                              style: TextStyle(
                                fontSize: bloc.layoutConfig.titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.mediumPadding),
                          ],
                          // Photo grid
                          Expanded(
                            child: PhotoGrid(
                              photos: photos,
                              layoutConfig: bloc.layoutConfig,
                              selectedPhotoIndex: bloc.selectedPhotoIndex != null &&
                                      bloc.selectedPhotoIndex! >= pageIndex * bloc.layoutConfig.photosPerPage &&
                                      bloc.selectedPhotoIndex! < (pageIndex + 1) * bloc.layoutConfig.photosPerPage
                                  ? bloc.selectedPhotoIndex! - (pageIndex * bloc.layoutConfig.photosPerPage)
                                  : null,
                              onPhotoTap: (index) {
                                final globalIndex = pageIndex * bloc.layoutConfig.photosPerPage + index;
                                // If empty slot, show photo picker
                                if (globalIndex >= bloc.photos.length) {
                                  _showPhotoSourceDialog(context, bloc);
                                } else {
                                  // If photo exists, select it
                                  bloc.selectPhoto(globalIndex);
                                }
                              },
                              onPhotoLongPress: (index) => _onPhotoLongPress(
                                context,
                                bloc,
                                pageIndex * bloc.layoutConfig.photosPerPage + index,
                              ),
                              onReorder: (oldIndex, newIndex) {
                                final globalOldIndex = pageIndex * bloc.layoutConfig.photosPerPage + oldIndex;
                                final globalNewIndex = pageIndex * bloc.layoutConfig.photosPerPage + newIndex;
                                bloc.movePhoto(globalOldIndex, globalNewIndex);
                              },
                              onCaptionChanged: (index, caption) {
                                final globalIndex = pageIndex * bloc.layoutConfig.photosPerPage + index;
                                bloc.updatePhotoCaption(globalIndex, caption);
                              },
                              onPhotoOffsetChanged: (index, offsetX, offsetY) {
                                final globalIndex = pageIndex * bloc.layoutConfig.photosPerPage + index;
                                bloc.updatePhotoOffset(globalIndex, offsetX, offsetY);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
            if (bloc.layoutConfig.showPageNumbers)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.smallPadding),
                child: Text(
                  (bloc.layoutConfig.startingPageNumber + pageIndex).toString(),
                  style: TextStyle(
                    fontSize: bloc.layoutConfig.pageNumberFontSize,
                    color: AppTheme.grey600,
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppTheme.grey400,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Text(
              'no_photos_added'.tr(),
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'tap_add_photo_to_start'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, PhotoEditorBloc bloc) {
    if (bloc.photos.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Zoom and Rotation Controls
        Card(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardBorderRadius)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'controls'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Zoom Controls
                      Column(
                        children: [
                          Text('zoom'.tr(), style: const TextStyle(fontSize: 12, color: AppTheme.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              IconButton(
                                onPressed: bloc.selectedPhotoIndex != null ? () => bloc.zoomOut() : null,
                                icon: const Icon(Icons.zoom_out, color: AppTheme.white),
                                tooltip: 'zoom_out'.tr(),
                              ),
                              IconButton(
                                onPressed: bloc.selectedPhotoIndex != null ? () => bloc.resetZoom() : null,
                                icon: const Icon(Icons.fit_screen, color: AppTheme.white),
                                tooltip: 'fit_screen'.tr(),
                              ),
                              IconButton(
                                onPressed: bloc.selectedPhotoIndex != null ? () => bloc.zoomIn() : null,
                                icon: const Icon(Icons.zoom_in, color: AppTheme.white),
                                tooltip: 'zoom_in'.tr(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      VerticalDivider(width: 1, color: AppTheme.white.withValues(alpha: 0.3)),
                      // Rotation Controls
                      Column(
                        children: [
                          Text('rotate'.tr(), style: const TextStyle(fontSize: 12, color: AppTheme.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              IconButton(
                                onPressed: bloc.selectedPhotoIndex != null ? () => bloc.rotateLeft() : null,
                                icon: const Icon(Icons.rotate_left, color: AppTheme.white),
                                tooltip: 'rotate_left'.tr(),
                              ),
                              IconButton(
                                onPressed: bloc.selectedPhotoIndex != null ? () => bloc.rotateRight() : null,
                                icon: const Icon(Icons.rotate_right, color: AppTheme.white),
                                tooltip: 'rotate_right'.tr(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      VerticalDivider(width: 1, color: AppTheme.white.withValues(alpha: 0.3)),
                      // Delete Control
                      Column(
                        children: [
                          Text('delete_selected'.tr(), style: const TextStyle(fontSize: 12, color: AppTheme.white)),
                          const SizedBox(height: 4),
                          IconButton(
                            onPressed: bloc.selectedPhotoIndex != null ? () => bloc.deleteSelected() : null,
                            icon: const Icon(Icons.delete_outline, color: AppTheme.white),
                            tooltip: 'delete_selected'.tr(),
                          ),
                        ],
                      ),
                      VerticalDivider(width: 1, color: AppTheme.white.withValues(alpha: 0.3)),
                      // Delete All Photos Control
                      Column(
                        children: [
                          Text('delete_all'.tr(), style: const TextStyle(fontSize: 12, color: AppTheme.white)),
                          const SizedBox(height: 4),
                          IconButton(
                            onPressed: bloc.photos.isNotEmpty ? () => _showDeleteAllDialog(context, bloc) : null,
                            icon: const Icon(Icons.delete_sweep, color: AppTheme.white),
                            tooltip: 'delete_all'.tr(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoSourceDialog(BuildContext context, PhotoEditorBloc bloc) {
    PhotoSourceDialog.show(
      context,
      (source) => bloc.pickPhoto(source),
    );
  }

  void _showDeleteAllDialog(BuildContext context, PhotoEditorBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_delete_title'.tr()),
        content: Text('clear_all_photos_warning'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              bloc.clearPhotos();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('clear_all'.tr()),
          ),
        ],
      ),
    );
  }

  void _showFolderOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('folder_options'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'current_save_location'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              _customSavePath ?? 'Documents',
              style: const TextStyle(color: AppTheme.grey600, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _openSaveFolder(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.folder_open, size: 18),
                const SizedBox(width: 4),
                Text('open_folder'.tr()),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _changeSaveLocation(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_location, size: 18),
                const SizedBox(width: 4),
                Text('change_location'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSaveFolder(BuildContext context) async {
    try {
      if (!supportsLocalFileSystem) {
        throw UnsupportedError('File system access is not supported on this platform');
      }

      final folderPath = await resolveSaveDirectory(_customSavePath);
      await openSystemFolder(folderPath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('folder_opened'.tr()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('folder_open_failed'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changeSaveLocation(BuildContext context) async {
    try {
      if (!supportsLocalFileSystem) {
        throw UnsupportedError('File system access is not supported on this platform');
      }

      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        setState(() {
          _customSavePath = selectedDirectory;
        });
        await _settingsRepository?.setSavePath(selectedDirectory);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('save_location_changed'.tr()),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('location_change_failed'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSaveLayoutDialog(BuildContext context, PhotoEditorBloc bloc) {
    // 부모 context를 저장 (다이얼로그가 닫혀도 유효함)
    final scaffoldContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('save_layout'.tr()),
        content: Text('save_as_image_or_pdf'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _saveLayoutAsImage(scaffoldContext, bloc);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.image, size: 18),
                const SizedBox(width: 4),
                Text('save_as_image'.tr()),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _saveLayoutAsPdf(scaffoldContext, bloc);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf, size: 18),
                const SizedBox(width: 4),
                Text('save_as_pdf'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLayoutAsImage(BuildContext context, PhotoEditorBloc bloc) async {
    // 현재 선택 상태 저장
    final previousSelection = bloc.selectedPhotoIndex;

    try {
      // 저장 전 선택 상태 해제하여 테두리가 포함되지 않도록 함
      bloc.selectPhoto(null);

      // UI 렌더링이 완료될 때까지 충분히 대기
      await Future.delayed(const Duration(milliseconds: 200));

      if (_repaintBoundaryKeys.isEmpty) {
        throw Exception('No pages to save');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      int savedCount = 0;

      // Capture all pages
      for (int i = 0; i < _repaintBoundaryKeys.length; i++) {
        final boundary = _repaintBoundaryKeys[i].currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) continue;

        final pngBytes = byteData.buffer.asUint8List();
        final filename = 'layout_page${i + 1}_$timestamp.png';

        // 웹과 데스크톱 분기 처리
        if (kIsWeb) {
          // 웹: 브라우저 다운로드
          downloadImageOnWeb(pngBytes, filename);
          savedCount++;
        } else if (supportsLocalFileSystem) {
          // 데스크톱: 파일 시스템 저장
          final directoryPath = await resolveSaveDirectory(_customSavePath);
          final filePath = joinPath(directoryPath, filename);
          await writeBytesToFile(pngBytes, filePath);
          savedCount++;
        } else {
          throw UnsupportedError('File saving is not supported on this platform');
        }
      }

      // 이전 선택 상태 복원
      bloc.selectPhoto(previousSelection);

      if (context.mounted) {
        if (savedCount > 0) {
          // 성공 알림 다이얼로그 표시
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black54,
            builder: (dialogContext) => Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 48),
                      const SizedBox(width: 20),
                      Text(
                        'save_success'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          // 2초 후 자동으로 닫기
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        } else {
          throw Exception('no_pages_captured'.tr());
        }
      }
    } catch (e) {
      // 오류 발생 시에도 이전 선택 상태 복원
      bloc.selectPhoto(previousSelection);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_save_failed'.tr()}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveLayoutAsPdf(BuildContext context, PhotoEditorBloc bloc) async {
    // 현재 선택 상태 저장
    final previousSelection = bloc.selectedPhotoIndex;

    try{
      // 저장 전 선택 상태 해제하여 테두리가 포함되지 않도록 함
      bloc.selectPhoto(null);

      // UI 렌더링이 완료될 때까지 충분히 대기
      await Future.delayed(const Duration(milliseconds: 200));

      if (_repaintBoundaryKeys.isEmpty) {
        throw Exception('No pages to save');
      }

      final pdf = pw.Document();
      int capturedCount = 0;

      // Capture all pages and add them to PDF
      for (int i = 0; i < _repaintBoundaryKeys.length; i++) {
        final boundary = _repaintBoundaryKeys[i].currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) continue;

        final pngBytes = byteData.buffer.asUint8List();
        final pdfImage = pw.MemoryImage(pngBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            ),
          ),
        );
        capturedCount++;
      }

      if (capturedCount == 0) {
        throw Exception('No pages captured');
      }

      final pdfBytes = await pdf.save();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'layout_$timestamp.pdf';

      // 웹과 데스크톱 분기 처리
      if (kIsWeb) {
        // 웹: 브라우저 다운로드
        downloadImageOnWeb(pdfBytes, filename);
      } else if (supportsLocalFileSystem) {
        // 데스크톱: 파일 시스템 저장
        final directoryPath = await resolveSaveDirectory(_customSavePath);
        final filePath = joinPath(directoryPath, filename);
        await writeBytesToFile(pdfBytes, filePath);
      } else {
        throw UnsupportedError('File saving is not supported on this platform');
      }

      // 이전 선택 상태 복원
      bloc.selectPhoto(previousSelection);

      if (context.mounted) {
        // 성공 알림 다이얼로그 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          builder: (dialogContext) => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 48),
                    const SizedBox(width: 20),
                    Text(
                      'save_success'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        // 2초 후 자동으로 닫기
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      // 오류 발생 시에도 이전 선택 상태 복원
      bloc.selectPhoto(previousSelection);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_save_failed'.tr()}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showLayoutSettingsDialog(BuildContext context, PhotoEditorBloc bloc) {
    LayoutSettingsDialog.show(
      context,
      bloc.layoutConfig,
      (config) => bloc.updateLayoutConfig(config),
    );
  }

  void _onPhotoLongPress(BuildContext context, PhotoEditorBloc bloc, int index) {
    if (index < bloc.photos.length) {
      _showPhotoOptions(context, bloc, index);
    }
  }

  void _showPhotoOptions(BuildContext context, PhotoEditorBloc bloc, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('replace_photo'.tr()),
              onTap: () {
                Navigator.pop(context);
                PhotoSourceDialog.show(
                  context,
                  (source) => bloc.pickPhoto(source, replaceIndex: index),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text('remove_photo'.tr()),
              onTap: () {
                Navigator.pop(context);
                bloc.removePhoto(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _createBulkPdf(BuildContext context, PhotoEditorBloc bloc) async {
    final success = await bloc.createPdfFromSelection();

    if (!mounted) return;

    if (success) {
      // 성공 알림 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (dialogContext) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.success,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 48),
                  const SizedBox(width: 20),
                  Text(
                    'save_success'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      // 2초 후 자동으로 닫기
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    } else if (bloc.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bloc.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
