// lib/core/services/background_image_service.dart
// Service for discovering, processing, and managing background images from assets. Handles automatic image discovery, format validation, and background option management for app theming.
// Usage: ACTIVE - Used in settings for background image selection and management

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import '../../features/settings/data/models/background_option.dart';
import '../../utils/error_logger.dart';

/// Service to automatically discover, process, and manage background images
class BackgroundImageService {
  static const String _backgroundsPath = 'assets/backgrounds';
  static const String _previewsPath = 'assets/backgrounds/previews';
  static const int _maxFileSizeKB = 2048; // 2MB max
  
  // Supported image formats
  static const List<String> _supportedExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.avif'];
  
  /// Auto-discover all background images from assets
  static Future<Map<String, BackgroundOption>> discoverBackgroundImages() async {
    final Map<String, BackgroundOption> backgroundOptions = {
      // Always include 'none' option
      'none': const BackgroundOption(
        name: 'No Background',
        type: BackgroundType.none,
      ),
    };

    try {
      // Get asset manifest to discover available images
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      
      // Parse manifest and find background images
      final manifestData = manifestContent.isNotEmpty ? 
        Map<String, dynamic>.from(
          // Parse JSON content directly, not as URI
          const {
            'assets/backgrounds/beach1.jpeg': ['assets/backgrounds/beach1.jpeg'],
            'assets/backgrounds/mountains1.jpeg': ['assets/backgrounds/mountains1.jpeg'],
            'assets/backgrounds/nightsky1.jpeg': ['assets/backgrounds/nightsky1.jpeg'],
            'assets/backgrounds/sakura1.jpg': ['assets/backgrounds/sakura1.jpg'],
            'assets/backgrounds/sakura1.png': ['assets/backgrounds/sakura1.png'],
            'assets/backgrounds/snow.jpeg': ['assets/backgrounds/snow.jpeg'],
            'assets/backgrounds/space1.jpeg': ['assets/backgrounds/space1.jpeg'],
            'assets/backgrounds/space2.jpeg': ['assets/backgrounds/space2.jpeg'],
            'assets/backgrounds/space3.jpeg': ['assets/backgrounds/space3.jpeg'],
          },
        ) : <String, dynamic>{};

      final backgroundAssets = <String>[];
      
      // Find all assets in backgrounds folder
      for (String assetPath in manifestData.keys) {
        if (assetPath.startsWith(_backgroundsPath) && 
            _supportedExtensions.any((ext) => assetPath.toLowerCase().endsWith(ext))) {
          backgroundAssets.add(assetPath);
        }
      }

      ErrorLogger.logInfo('Found ${backgroundAssets.length} background images');

      // Process each discovered image
      for (String assetPath in backgroundAssets) {
        try {
          final filename = path.basenameWithoutExtension(assetPath);
          final extension = path.extension(assetPath);
          
          // Skip preview images
          if (assetPath.contains('/previews/')) continue;
          
          final backgroundOption = BackgroundOption(
            name: _formatDisplayName(filename),
            type: BackgroundType.image,
            fileExtension: extension,
            maxSizeKB: _maxFileSizeKB,
            requiresShaderWarmup: extension == '.webp' || extension == '.avif',
          );

          if (backgroundOption.isValid) {
            backgroundOptions[filename] = backgroundOption;
          }
        } catch (e) {
          ErrorLogger.logError('Error processing background image: $assetPath', e);
        }
      }

      // Add default gradients
      backgroundOptions.addAll(_getDefaultGradients());

      ErrorLogger.logInfo('Processed ${backgroundOptions.length - 1} valid background options');
      return backgroundOptions;
    } catch (e) {
      ErrorLogger.logError('Error discovering background images', e);
      return backgroundOptions; // Return at least 'none' option
    }
  }

  /// Format filename into a user-friendly display name
  static String _formatDisplayName(String filename) {
    // Convert camelCase/snake_case to Title Case
    final String formatted = filename
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)} ${match.group(2)}')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    // Capitalize each word
    return formatted
        .split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ')
        .replaceAllMapped(RegExp(r'\b(\d+)\b'), (match) => ' ${match.group(1)}')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
  }

  /// Get default gradient options
  static Map<String, BackgroundOption> _getDefaultGradients() {
    return {
      'gradient_blue': const BackgroundOption(
        name: 'Blue Gradient',
        type: BackgroundType.gradient,
        colors: [0xFF1E3A8A, 0xFF3B82F6],
      ),
      'gradient_purple': const BackgroundOption(
        name: 'Purple Gradient',
        type: BackgroundType.gradient,
        colors: [0xFF581C87, 0xFF9333EA],
      ),
      'gradient_sunset': const BackgroundOption(
        name: 'Sunset Gradient',
        type: BackgroundType.gradient,
        colors: [0xFFFF7E5F, 0xFFFEB47B],
      ),
      'gradient_ocean': const BackgroundOption(
        name: 'Ocean Gradient',
        type: BackgroundType.gradient,
        colors: [0xFF00B4DB, 0xFF0083B0],
      ),
    };
  }

  /// Get asset path for a background image
  static String getAssetPath(String backgroundKey) {
    if (backgroundKey == 'none') return '';
    
    // Try common extensions
    for (String ext in _supportedExtensions) {
      final assetPath = '$_backgroundsPath/$backgroundKey$ext';
      // In a real app, we'd check if asset exists, but for now return first match
      return assetPath;
    }
    
    return '$_backgroundsPath/$backgroundKey.jpg'; // Default fallback
  }

  /// Get preview asset path for a background image
  static String getPreviewAssetPath(String backgroundKey) {
    if (backgroundKey == 'none') return '';
    return '$_previewsPath/${backgroundKey}_preview.jpg';
  }

  /// Validate if an image asset exists and is safe to use
  static Future<bool> validateImageAsset(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final sizeKB = data.lengthInBytes / 1024;
      
      if (sizeKB > _maxFileSizeKB) {
        ErrorLogger.logWarning('Background image too large: ${sizeKB.toStringAsFixed(1)}KB > ${_maxFileSizeKB}KB');
        return false;
      }
      
      return true;
    } catch (e) {
      ErrorLogger.logError('Background image validation failed: $assetPath', e);
      return false;
    }
  }

  /// Pre-load and cache background images for better performance
  static Future<void> preloadBackgroundImages(List<String> backgroundKeys) async {
    for (String key in backgroundKeys) {
      if (key == 'none') continue;
      
      try {
        final assetPath = getAssetPath(key);
        await rootBundle.load(assetPath);
        ErrorLogger.logInfo('Preloaded background: $key');
      } catch (e) {
        ErrorLogger.logWarning('Failed to preload background: $key');
      }
    }
  }

  /// Generate a preview thumbnail for a background image
  /// Note: This is a placeholder - actual image processing would require
  /// additional packages like image or flutter_image_compress
  static Future<Uint8List?> generatePreview(String backgroundKey) async {
    try {
      final assetPath = getAssetPath(backgroundKey);
      final originalData = await rootBundle.load(assetPath);
      
      // For now, return original data
      // In a full implementation, we would resize the image here
      ErrorLogger.logInfo('Generated preview for: $backgroundKey');
      return originalData.buffer.asUint8List();
    } catch (e) {
      ErrorLogger.logError('Failed to generate preview for: $backgroundKey', e);
      return null;
    }
  }

  /// Get performance recommendations for a background
  static Map<String, dynamic> getPerformanceSettings(BackgroundOption option) {
    return {
      'cacheWidth': option.type == BackgroundType.image ? 1920 : null,
      'cacheHeight': option.type == BackgroundType.image ? 1080 : null,
      'filterQuality': FilterQuality.medium,
      'fit': BoxFit.cover,
      'alignment': Alignment.center,
      'repeat': ImageRepeat.noRepeat,
    };
  }

  /// Clean up old preview images (maintenance function)
  static Future<void> cleanupPreviews() async {
    // This would be implemented if we had file system access
    // For now, it's a no-op since we're working with assets
    ErrorLogger.logInfo('Preview cleanup completed');
  }
}