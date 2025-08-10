// lib/core/services/background_preview_generator.dart
// Service for generating preview thumbnails for background images with caching and optimization. Creates resized preview images for background selection UI with efficient memory management.
// Usage: ACTIVE - Used in background selection interface for thumbnail generation

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/error_logger.dart';
import 'background_image_service.dart';

/// Generates preview thumbnails for background images
class BackgroundPreviewGenerator {
  static const int _previewWidth = 400;
  static const int _previewHeight = 225;
  
  // Cache for generated previews
  static final Map<String, ui.Image> _previewCache = {};
  
  /// Generate a preview image for a background
  static Future<ui.Image?> generatePreview(String backgroundKey) async {
    // Check cache first
    if (_previewCache.containsKey(backgroundKey)) {
      return _previewCache[backgroundKey];
    }
    
    try {
      final assetPath = BackgroundImageService.getAssetPath(backgroundKey);
      if (assetPath.isEmpty) return null;
      
      // Load the original image
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: _previewWidth,
        targetHeight: _previewHeight,
      );
      
      final frame = await codec.getNextFrame();
      final previewImage = frame.image;
      
      // Cache the preview
      _previewCache[backgroundKey] = previewImage;
      
      ErrorLogger.logInfo('Generated preview for background: $backgroundKey');
      return previewImage;
    } catch (e) {
      ErrorLogger.logError('Failed to generate preview for: $backgroundKey', e);
      return null;
    }
  }
  
  /// Generate preview widget for display in UI
  static Widget buildPreviewWidget(String backgroundKey, {
    double width = 120,
    double height = 67.5, // Maintains 16:9 aspect ratio
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    if (backgroundKey == 'none') {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: borderRadius,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Icon(
          Icons.not_interested,
          color: Colors.grey[400],
          size: 24,
        ),
      );
    }
    
    // Check if it's a gradient
    if (backgroundKey.startsWith('gradient_')) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: _getGradient(backgroundKey),
          borderRadius: borderRadius,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
      );
    }
    
    // Image background
    final assetPath = BackgroundImageService.getAssetPath(backgroundKey);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: (width * 2).toInt(), // 2x for high-DPI screens
          cacheHeight: (height * 2).toInt(),
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) {
            ErrorLogger.logError('Failed to load background preview: $assetPath', error, stackTrace);
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: Icon(
                Icons.broken_image,
                color: Colors.grey[500],
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }
  
  /// Build a full-size background widget for dashboard
  static Widget buildBackgroundWidget(String backgroundKey, {
    double opacity = 1.0,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    if (backgroundKey == 'none') {
      return const SizedBox.expand();
    }
    
    // Check if it's a gradient
    if (backgroundKey.startsWith('gradient_')) {
      return Container(
        decoration: BoxDecoration(
          gradient: _getGradient(backgroundKey),
        ),
        child: opacity < 1.0
            ? Container(
                color: Colors.white.withValues(alpha: 1.0 - opacity),
              )
            : null,
      );
    }
    
    // Image background
    final assetPath = BackgroundImageService.getAssetPath(backgroundKey);
    
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        assetPath,
        fit: fit,
        alignment: alignment,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 1920, // Full HD width
        cacheHeight: 1080, // Full HD height
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          ErrorLogger.logError('Failed to load background: $assetPath', error, stackTrace);
          return Container(
            color: Colors.grey[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Background failed to load',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// Get gradient decoration for gradient backgrounds
  static LinearGradient? _getGradient(String backgroundKey) {
    switch (backgroundKey) {
      case 'gradient_blue':
        return const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'gradient_purple':
        return const LinearGradient(
          colors: [Color(0xFF581C87), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'gradient_sunset':
        return const LinearGradient(
          colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'gradient_ocean':
        return const LinearGradient(
          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return null;
    }
  }
  
  /// Pre-generate all preview images for better performance
  static Future<void> pregenerateAllPreviews(Map<String, dynamic> backgrounds) async {
    for (String key in backgrounds.keys) {
      if (key != 'none' && !key.startsWith('gradient_')) {
        await generatePreview(key);
      }
    }
    
    ErrorLogger.logInfo('Pre-generated ${_previewCache.length} background previews');
  }
  
  /// Clear preview cache to free memory
  static void clearPreviewCache() {
    for (final image in _previewCache.values) {
      image.dispose();
    }
    _previewCache.clear();
    ErrorLogger.logInfo('Cleared background preview cache');
  }
  
  /// Get cache statistics
  static Map<String, int> getCacheStats() {
    return {
      'cachedPreviews': _previewCache.length,
      'memoryEstimateMB': (_previewCache.length * _previewWidth * _previewHeight * 4) ~/ (1024 * 1024),
    };
  }
}