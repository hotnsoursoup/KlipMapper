// lib/utils/debug_utils.dart
// Specialized debug utilities for development and production troubleshooting. Provides widget tree inspection, performance monitoring, and development-only debugging helpers.
// Usage: ACTIVE - Development and debugging utilities used throughout the application for troubleshooting and performance analysis

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/utils/app_logger.dart' show AppLogger, LogLevel;

/// Specialized debug utilities for development and troubleshooting
class DebugUtils {
  
  // ========== DEVELOPMENT HELPERS ==========
  
  /// Log widget build information for debugging render issues
  static void logWidgetBuild(String widgetName, {String? context}) {
    if (kDebugMode) {
      final message = context != null 
        ? 'Widget $widgetName built in $context'
        : 'Widget $widgetName built';
      AppLogger.logDebug(message);
    }
  }
  
  /// Log performance measurements
  static void logPerformance(String operation, Duration duration, {String? details}) {
    if (kDebugMode) {
      var message = '⚡ Performance: $operation took ${duration.inMilliseconds}ms';
      if (details != null) {
        message += ' ($details)';
      }
      AppLogger.info(message, 'PERF');
    }
  }
  
  /// Log memory usage information
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      // Note: More detailed memory profiling would require additional packages
      AppLogger.logDebug('Memory check at $context');
    }
  }
  
  /// Assert and log condition failures
  static void assertAndLog(bool condition, String message) {
    if (!condition) {
      AppLogger.error('Assertion failed: $message', 'ASSERT');
    }
    assert(condition, message);
  }
  
  /// Log provider state changes for debugging
  static void logProviderStateChange(String providerName, dynamic oldState, dynamic newState) {
    if (kDebugMode) {
      AppLogger.logDebug('Provider $providerName: $oldState → $newState');
    }
  }
  
  // ========== UI DEBUGGING HELPERS ==========
  
  /// Wrap widget with debugging overlay (development only)
  static Widget debugWrap(Widget child, String label) {
    if (kDebugMode) {
      return Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              color: Colors.red.withValues(alpha: 0.7),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }
  
  /// Log widget tree information
  static void logWidgetTree(BuildContext context, {int depth = 2}) {
    if (kDebugMode) {
      final treeInfo = _buildWidgetTreeString(context, depth);
      AppLogger.logDebug('Widget Tree:\n$treeInfo');
    }
  }
  
  static String _buildWidgetTreeString(BuildContext context, int depth) {
    final buffer = StringBuffer();
    
    void visitElement(Element element, int currentDepth, String prefix) {
      if (currentDepth > depth) return;
      
      buffer.writeln('$prefix${element.widget.runtimeType}');
      
      if (currentDepth < depth) {
        element.visitChildren((child) {
          visitElement(child, currentDepth + 1, '$prefix  ');
        });
      }
    }
    
    visitElement(context as Element, 0, '');
    return buffer.toString();
  }
  
  // ========== PERFORMANCE MONITORING ==========
  
  /// Measure and log execution time of a function
  static T measureExecution<T>(String operationName, T Function() operation) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = operation();
      stopwatch.stop();
      logPerformance(operationName, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.logError('DebugUtils.measureExecution($operationName)', e);
      logPerformance(operationName, stopwatch.elapsed, details: 'FAILED');
      rethrow;
    }
  }
  
  /// Measure and log async execution time
  static Future<T> measureAsyncExecution<T>(String operationName, Future<T> Function() operation) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      logPerformance(operationName, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.logError('DebugUtils.measureAsyncExecution($operationName)', e);
      logPerformance(operationName, stopwatch.elapsed, details: 'FAILED');
      rethrow;
    }
  }
  
  // ========== BACKWARDS COMPATIBILITY ==========
  
  /// Backwards compatibility with old DebugLogger API
  static void debug(String message, [String? tag]) {
    AppLogger.debug(message, tag);
  }
  
  static void info(String message, [String? tag]) {
    AppLogger.info(message, tag);
  }
  
  static void warning(String message, [String? tag]) {
    AppLogger.warning(message, tag);
  }
  
  static void error(String message, [String? tag]) {
    AppLogger.error(message, tag);
  }
  
  static void critical(String message, [String? tag]) {
    AppLogger.critical(message, tag);
  }
  
  static void printAndLog(Object? message, [String? tag]) {
    AppLogger.printAndLog(message);
  }
  
  // ========== CONFIGURATION ==========
  
  /// Configure logging behavior (delegates to AppLogger)
  static void setLogLevel(LogLevel level) {
    AppLogger.setLogLevel(level);
    AppLogger.info('Debug log level set to ${level.name}', 'DEBUG');
  }
  
  static void setFileLogging(bool enabled) {
    AppLogger.setFileLogging(enabled);
  }
  
  static void setConsoleLogging(bool enabled) {
    AppLogger.setConsoleLogging(enabled);
  }
}
