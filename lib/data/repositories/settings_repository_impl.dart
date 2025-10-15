import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../core/utils/logger.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _savePathKey = 'custom_save_path';
  static const String _imageQualityKey = 'image_quality';

  @override
  Future<String?> getSavePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString(_savePathKey);
      AppLogger.debug('Retrieved save path: $path', 'SettingsRepository');
      return path;
    } catch (e) {
      AppLogger.error('Failed to get save path', e, null, 'SettingsRepository');
      return null;
    }
  }

  @override
  Future<void> setSavePath(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_savePathKey, path);
      AppLogger.info('Save path set to: $path', 'SettingsRepository');
    } catch (e) {
      AppLogger.error('Failed to set save path', e, null, 'SettingsRepository');
      rethrow;
    }
  }

  @override
  Future<void> clearSavePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savePathKey);
      AppLogger.info('Save path cleared', 'SettingsRepository');
    } catch (e) {
      AppLogger.error('Failed to clear save path', e, null, 'SettingsRepository');
      rethrow;
    }
  }

  @override
  Future<String> getImageQuality() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quality = prefs.getString(_imageQualityKey) ?? 'low'; // 기본값: 저화질
      AppLogger.debug('Retrieved image quality: $quality', 'SettingsRepository');
      return quality;
    } catch (e) {
      AppLogger.error('Failed to get image quality', e, null, 'SettingsRepository');
      return 'low'; // 오류 시에도 저화질 반환
    }
  }

  @override
  Future<void> setImageQuality(String quality) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imageQualityKey, quality);
      AppLogger.info('Image quality set to: $quality', 'SettingsRepository');
    } catch (e) {
      AppLogger.error('Failed to set image quality', e, null, 'SettingsRepository');
      rethrow;
    }
  }
}
