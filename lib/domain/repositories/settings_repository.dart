/// Repository interface for app settings
abstract class SettingsRepository {
  /// Get the custom save path for PDFs and photos
  /// Returns null if using default (Documents folder)
  Future<String?> getSavePath();

  /// Set the custom save path
  Future<void> setSavePath(String path);

  /// Clear the custom save path (revert to default)
  Future<void> clearSavePath();
}
