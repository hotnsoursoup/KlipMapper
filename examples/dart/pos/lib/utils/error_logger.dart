// lib/utils/error_logger.dart
// DEPRECATED: This utility has been consolidated into AppLogger for better organization and reduced duplication.
// Please use AppLogger instead: AppLogger.logError(), AppLogger.logInfo(), AppLogger.logWarning(), etc.
// Usage: DEPRECATED - Use lib/utils/app_logger.dart instead

import '../core/utils/app_logger.dart' show AppLogger, LogLevel;

/// DEPRECATED: Enhanced error logger that writes to both console and file
/// Use AppLogger instead for new code
class ErrorLogger {
  
  // ========== DEPRECATED COMPATIBILITY METHODS ==========
  // These methods delegate to AppLogger for backwards compatibility
  
  /// DEPRECATED: Use AppLogger.initialize() instead
  static Future<void> initialize() async {
    await AppLogger.initialize();
  }
  
  /// DEPRECATED: Use AppLogger.logError() instead
  static void logError(String location, dynamic error, [StackTrace? stack]) {
    AppLogger.logError(location, error, stack);
  }

  /// DEPRECATED: Use AppLogger.logInfo() instead
  static void logInfo(String message) {
    AppLogger.logInfo(message);
  }

  /// DEPRECATED: Use AppLogger.logWarning() instead
  static void logWarning(String message) {
    AppLogger.logWarning(message);
  }

  /// DEPRECATED: Use AppLogger.logSuccess() instead
  static void logSuccess(String message) {
    AppLogger.logSuccess(message);
  }

  /// DEPRECATED: Use AppLogger.logDebug() instead
  static void logDebug(String message) {
    AppLogger.logDebug(message);
  }
  
  /// DEPRECATED: Use AppLogger.print() instead
  static void print(Object? object) {
    AppLogger.print(object);
  }
  
  /// DEPRECATED: Use AppLogger.writeToFile() - method kept for compatibility
  static Future<void> writeToFile(String message) async {
    AppLogger.log(LogLevel.info, 'FILE', message);
  }
  
  /// DEPRECATED: Use AppLogger.currentLogFile instead
  static String? get currentLogFile => AppLogger.currentLogFile;
  
  /// DEPRECATED: Use AppLogger.flush() instead
  static Future<void> flush() async {
    await AppLogger.flush();
  }
}
