// lib/utils/app_logger.dart
// Consolidated professional logging system combining console and file output with configurable log levels, error tracking, and debug utilities.
// Features emoji-enhanced console output, structured file logging, developer tools integration, and debugPrint override for comprehensive logging.
// Usage: ACTIVE - Primary logging system used throughout the application for all logging, debugging, error tracking, and audit trails

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

/// Log levels for controlling output verbosity
enum LogLevel {
  debug(0, 'DEBUG', '🐛'),
  info(1, 'INFO', 'ℹ️'),
  warning(2, 'WARN', '⚠️'),
  error(3, 'ERROR', '🔴'),
  critical(4, 'CRITICAL', '💥');

  const LogLevel(this.value, this.name, this.emoji);
  final int value;
  final String name;
  final String emoji;
}

/// Professional logging utility that prints to console AND logs to file
/// This is a separate utility from ErrorLogger specifically for dual output
class AppLogger {
  static File? _logFile;
  static bool _initialized = false;
  static LogLevel _currentLevel = LogLevel.info;
  static bool _enableFileLogging = true;
  static bool _enableConsoleLogging = true;
  
  /// Initialize the file logger
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Create logs directory if it doesn't exist
      final logsDir = Directory('logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      
      // Create log file with timestamp
      final now = DateTime.now();
      final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      _logFile = File('logs/app_log_$timestamp.log');
      
      // Write header to log file
      await _writeToFile('=== App Log Started at ${now.toIso8601String()} ===');
      await _writeToFile('Log Level: ${_currentLevel.name}');
      await _writeToFile('===============================================\n');
      
      _initialized = true;
      
      // Override debugPrint to also write to file for comprehensive logging
      debugPrint = (String? message, {int? wrapWidth}) {
        final msg = message ?? '';
        // Write to console (original behavior)
        if (kDebugMode) {
          print(msg);  // Use regular print for console output
        }
        // Write to file
        _writeToFile(msg);
      };
      
      if (kDebugMode) {
        print('📁 AppLogger initialized: ${_logFile!.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize AppLogger: $e');
      }
    }
  }
  
  /// Write message to log file
  static Future<void> _writeToFile(String message) async {
    if (_logFile == null) return;
    
    try {
      await _logFile!.writeAsString('$message\n', mode: FileMode.append);
    } catch (e) {
      // Silently fail to avoid logging recursion
    }
  }
  
  /// Set the minimum log level (logs at this level and above will be output)
  static void setLogLevel(LogLevel level) {
    _currentLevel = level;
    log(LogLevel.info, 'Config', 'Log level set to ${level.name}');
  }
  
  /// Enable/disable file logging
  static void setFileLogging(bool enabled) {
    _enableFileLogging = enabled;
    log(LogLevel.info, 'Config', 'File logging ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Enable/disable console logging  
  static void setConsoleLogging(bool enabled) {
    _enableConsoleLogging = enabled;
    log(LogLevel.info, 'Config', 'Console logging ${enabled ? 'enabled' : 'disabled'}');
  }
  
  /// Main logging method - prints to console AND writes to file
  static void log(LogLevel level, String tag, String message) {
    // Check if this log level should be output
    if (level.value < _currentLevel.value) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final consoleMessage = '${level.emoji} [$tag] $message';
    final fileMessage = '$timestamp [${level.name.padRight(8)}] [$tag] $message';
    
    // Print to console if enabled
    if (_enableConsoleLogging && kDebugMode) {
      print(consoleMessage);
    }
    
    // Write to file if enabled
    if (_enableFileLogging) {
      _writeToFile(fileMessage);
    }
  }
  
  /// Convenience methods for different log levels
  
  /// Debug level logging (most verbose)
  static void debug(String message, [String? tag]) {
    log(LogLevel.debug, tag ?? 'DEBUG', message);
  }
  
  /// Info level logging (general information)
  static void info(String message, [String? tag]) {
    log(LogLevel.info, tag ?? 'INFO', message);
  }
  
  /// Warning level logging
  static void warning(String message, [String? tag]) {
    log(LogLevel.warning, tag ?? 'WARN', message);
  }
  
  /// Error level logging
  static void error(String message, [String? tag, dynamic errorObject, StackTrace? stackTrace]) {
    var fullMessage = message;
    if (errorObject != null) {
      fullMessage += '\n   Error: $errorObject';
    }
    if (stackTrace != null) {
      fullMessage += '\n   Stack trace:\n   ${stackTrace.toString().split('\n').take(10).join('\n   ')}';
    }
    log(LogLevel.error, tag ?? 'ERROR', fullMessage);
  }
  
  /// Critical level logging (highest priority)
  static void critical(String message, [String? tag]) {
    log(LogLevel.critical, tag ?? 'CRITICAL', message);
  }
  
  /// Simple print replacement that always prints and logs (backwards compatibility)
  static void printAndLog(Object? message) {
    final msg = message?.toString() ?? '';
    
    // Always print to console regardless of log level
    if (kDebugMode) {
      // Use dart:core print directly
      // ignore: avoid_print
      print(msg);
    }
    
    // Always write to file
    final timestamp = DateTime.now().toIso8601String();
    _writeToFile('$timestamp [PRINT   ] $msg');
  }
  
  /// Get current log level
  static LogLevel get currentLevel => _currentLevel;
  
  /// Check if file logging is enabled
  static bool get isFileLoggingEnabled => _enableFileLogging;
  
  /// Check if console logging is enabled  
  static bool get isConsoleLoggingEnabled => _enableConsoleLogging;
  
  /// Get the current log file path
  static String? get currentLogFile => _logFile?.path;
  
  // ========== ENHANCED ERROR LOGGING METHODS ==========
  
  /// Enhanced error logging with location context and stack traces
  static void logError(String location, dynamic error, [StackTrace? stack]) {
    var fullMessage = 'ERROR in $location:\n   $error';
    if (stack != null) {
      fullMessage += '\n   Stack trace:\n   ${stack.toString().split('\n').take(10).join('\n   ')}';
    }
    log(LogLevel.error, 'ERROR', fullMessage);
    
    // Also send to developer tools
    if (kDebugMode) {
      developer.log(fullMessage, name: location, error: error, stackTrace: stack);
    }
  }

  /// Info logging with developer tools integration
  static void logInfo(String message) {
    log(LogLevel.info, 'INFO', message);
    if (kDebugMode) {
      developer.log(message, name: 'INFO');
    }
  }

  /// Warning logging with developer tools integration
  static void logWarning(String message) {
    log(LogLevel.warning, 'WARN', message);
    if (kDebugMode) {
      developer.log(message, name: 'WARNING', level: 900);
    }
  }

  /// Success logging for positive outcomes
  static void logSuccess(String message) {
    log(LogLevel.info, 'SUCCESS', '✅ $message');
    if (kDebugMode) {
      developer.log(message, name: 'SUCCESS');
    }
  }

  /// Debug logging with developer tools integration
  static void logDebug(String message) {
    log(LogLevel.debug, 'DEBUG', message);
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG', level: 500);
    }
  }
  
  /// Custom print function that writes to both console and file
  /// Use this instead of regular print() to capture all output
  static void print(Object? object) {
    final message = object?.toString() ?? '';
    if (kDebugMode) {
      // Use stdout.writeln to ensure console output appears
      stdout.writeln(message);
    }
    _writeToFile(message);
  }
  
  /// Print and log combination (backwards compatibility with old ErrorLogger)
  static void printAndLogCompat(Object? message, [String? tag]) {
    info(message?.toString() ?? '', tag);
  }
  
  /// Flush any pending writes to ensure logs are saved
  static Future<void> flush() async {
    try {
      if (_logFile != null) {
        await _logFile!.writeAsString('', mode: FileMode.append, flush: true);
      }
    } catch (e) {
      // Silently fail
    }
  }
}