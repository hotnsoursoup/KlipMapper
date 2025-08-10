// lib/core/services/window_service.dart
// Service for managing window properties like fullscreen mode, maximization, and window state on Windows desktop. Handles platform-specific window operations and state management.
// Usage: ACTIVE - Used for window control functionality throughout the app

import 'package:flutter/services.dart';
import '../utils/logger.dart';

/// Service to manage window properties like fullscreen mode
class WindowService {
  static const _methodChannel = MethodChannel('com.luxenails.pos/window');
  
  static WindowService? _instance;
  static WindowService get instance => _instance ??= WindowService._();
  
  WindowService._();
  
  bool _isFullscreen = false; // Start in maximized mode, not fullscreen
  bool _isMaximized = false;
  
  /// Get current fullscreen status
  bool get isFullscreen => _isFullscreen;
  
  /// Get current maximized status
  bool get isMaximized => _isMaximized;
  
  /// Toggle fullscreen mode
  /// Returns true if successfully toggled, false otherwise
  Future<bool> toggleFullscreen() async {
    try {
      final result = await _methodChannel.invokeMethod('toggleFullscreen');
      if (result == true) {
        _isFullscreen = !_isFullscreen;
        Logger.info('Fullscreen toggled to: $_isFullscreen');
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      Logger.error('Failed to toggle fullscreen', e);
      return false;
    }
  }
  
  /// Set fullscreen mode explicitly
  /// Returns true if successfully set, false otherwise
  Future<bool> setFullscreen(bool fullscreen) async {
    if (_isFullscreen == fullscreen) {
      return true; // Already in desired state
    }
    
    try {
      final result = await _methodChannel.invokeMethod('setFullscreen', {
        'fullscreen': fullscreen,
      });
      if (result == true) {
        _isFullscreen = fullscreen;
        Logger.info('Fullscreen set to: $_isFullscreen');
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      Logger.error('Failed to set fullscreen mode', e);
      return false;
    }
  }
  
  /// Maximize the window
  /// Returns true if successfully maximized, false otherwise
  Future<bool> maximizeWindow() async {
    try {
      final result = await _methodChannel.invokeMethod('maximizeWindow');
      if (result == true) {
        _isMaximized = true;
        _isFullscreen = false; // Not fullscreen when maximized
        Logger.info('Window maximized');
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      Logger.error('Failed to maximize window', e);
      return false;
    }
  }
  
  /// Initialize window state (call during app startup)
  Future<void> initializeWindow() async {
    try {
      // Start in maximized mode instead of fullscreen
      await maximizeWindow();
      Logger.info('Window initialized in maximized mode');
    } catch (e) {
      Logger.error('Failed to initialize window', e);
    }
  }
  
  /// Exit the application (useful for kiosk mode)
  Future<void> exitApp() async {
    try {
      // Use Flutter's built-in method to exit the app
      await SystemNavigator.pop();
      Logger.info('App exit requested');
    } catch (e) {
      Logger.error('Failed to exit app', e);
      // Fallback: try to exit using platform-specific method
      try {
        await _methodChannel.invokeMethod('exitApp');
      } on PlatformException catch (platformError) {
        Logger.error('Platform channel exit also failed', platformError);
      }
    }
  }
}