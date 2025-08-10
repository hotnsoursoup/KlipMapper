// lib/core/utils/logger.dart
// Simple debug logging utility with categorized log levels (error, warning, info, success). Only outputs in debug mode to avoid performance impact in production.
// Usage: ACTIVE - Used throughout the app for debugging, error tracking, and development logging, particularly in services and repositories
import 'package:flutter/foundation.dart';
import 'app_logger.dart';

class Logger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
  
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Delegate to AppLogger for unified logging (console + file)
    AppLogger.error(message, 'LOGGER', error, stackTrace);
  }
  
  static void success(String message) {
    if (kDebugMode) AppLogger.info('✅ $message', 'LOGGER');
  }
  
  static void warning(String message) {
    if (kDebugMode) AppLogger.warning(message, 'LOGGER');
  }
  
  static void info(String message) {
    if (kDebugMode) AppLogger.info(message, 'LOGGER');
  }
}
