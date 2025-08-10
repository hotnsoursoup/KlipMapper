// lib/core/services/background_converter_service.dart
// Service for processing and converting background images with preview generation. Handles image optimization, format conversion, and thumbnail creation for background customization features.
// Usage: ACTIVE - Used for background image processing and optimization in settings

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../utils/error_logger.dart';

/// Service to handle background image conversion and preview generation
class BackgroundConverterService {
  static const String _processedDir = 'processed_backgrounds';
  static const String _previewsDir = 'background_previews';
  
  /// Initialize and process backgrounds on app startup
  static Future<void> initialize() async {
    try {
      ErrorLogger.logInfo('BackgroundConverterService: Starting initialization');
      
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final processedPath = '${appDir.path}/$_processedDir';
      final previewsPath = '${appDir.path}/$_previewsDir';
      
      // Create directories if they don't exist
      await Directory(processedPath).create(recursive: true);
      await Directory(previewsPath).create(recursive: true);
      
      // Process all backgrounds in assets
      await _processBackgroundAssets(processedPath, previewsPath);
      
      ErrorLogger.logInfo('BackgroundConverterService: Initialization complete');
    } catch (e, stack) {
      ErrorLogger.logError('BackgroundConverterService initialization failed', e, stack);
    }
  }
  
  /// Process all background assets
  static Future<void> _processBackgroundAssets(String processedPath, String previewsPath) async {
    // List of known backgrounds (we'll need to maintain this list)
    final backgrounds = [
      'sakura1',
      'sakura2', 
      'sakura3',
    ];
    
    for (final backgroundName in backgrounds) {
      try {
        // Check if already processed
        final processedFile = File('$processedPath/$backgroundName.png');
        final previewFile = File('$previewsPath/${backgroundName}_preview.png');
        
        if (processedFile.existsSync() && previewFile.existsSync()) {
          ErrorLogger.logInfo('Background $backgroundName already processed, skipping');
          continue;
        }
        
        // Try to load the asset (check for AVIF, PNG, JPG)
        Uint8List? imageData;
        String? originalFormat;
        
        // Try different formats
        for (final format in ['avif', 'png', 'jpg', 'jpeg']) {
          try {
            final assetPath = 'assets/backgrounds/$backgroundName.$format';
            imageData = (await rootBundle.load(assetPath)).buffer.asUint8List();
            originalFormat = format;
            ErrorLogger.logInfo('Found $backgroundName.$format');
            break;
          } catch (e) {
            // Asset doesn't exist in this format, try next
            continue;
          }
        }
        
        if (imageData == null) {
          ErrorLogger.logInfo('Background $backgroundName not found in any format');
          continue;
        }
        
        // Convert to PNG if needed (AVIF or other formats)
        if (originalFormat == 'avif' || originalFormat == 'jpeg' || originalFormat == 'jpg') {
          await _convertToPng(imageData, processedFile, backgroundName);
        } else if (originalFormat == 'png') {
          // Just copy PNG files
          await processedFile.writeAsBytes(imageData);
          ErrorLogger.logInfo('Copied $backgroundName.png to processed directory');
        }
        
        // Generate preview thumbnail
        if (processedFile.existsSync()) {
          await _generatePreview(processedFile, previewFile, backgroundName);
        }
        
      } catch (e, stack) {
        ErrorLogger.logError('Error processing background $backgroundName', e, stack);
      }
    }
  }
  
  /// Convert image data to PNG format
  static Future<void> _convertToPng(Uint8List imageData, File outputFile, String name) async {
    try {
      // Decode the image
      final image = img.decodeImage(imageData);
      if (image == null) {
        ErrorLogger.logError('Failed to decode image $name', null);
        return;
      }
      
      // Encode as PNG
      final pngBytes = img.encodePng(image);
      await outputFile.writeAsBytes(pngBytes);
      
      ErrorLogger.logInfo('Converted $name to PNG format');
    } catch (e, stack) {
      ErrorLogger.logError('Error converting $name to PNG', e, stack);
    }
  }
  
  /// Generate a small preview thumbnail
  static Future<void> _generatePreview(File sourceFile, File previewFile, String name) async {
    try {
      final sourceBytes = await sourceFile.readAsBytes();
      final sourceImage = img.decodeImage(sourceBytes);
      
      if (sourceImage == null) {
        ErrorLogger.logError('Failed to decode source image for preview $name', null);
        return;
      }
      
      // Resize to thumbnail size (400x240 for preview)
      final thumbnail = img.copyResize(
        sourceImage,
        width: 400,
        height: 240,
        interpolation: img.Interpolation.linear,
      );
      
      // Save preview
      final previewBytes = img.encodePng(thumbnail);
      await previewFile.writeAsBytes(previewBytes);
      
      ErrorLogger.logInfo('Generated preview for $name');
    } catch (e, stack) {
      ErrorLogger.logError('Error generating preview for $name', e, stack);
    }
  }
  
  /// Get the processed image path for a background
  static Future<String?> getProcessedImagePath(String backgroundName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final processedFile = File('${appDir.path}/$_processedDir/$backgroundName.png');
      
      if (processedFile.existsSync()) {
        return processedFile.path;
      }
      
      // Fallback to asset if processed doesn't exist
      return null;
    } catch (e) {
      ErrorLogger.logError('Error getting processed image path', e);
      return null;
    }
  }
  
  /// Get the preview image path for a background
  static Future<String?> getPreviewImagePath(String backgroundName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final previewFile = File('${appDir.path}/$_previewsDir/${backgroundName}_preview.png');
      
      if (previewFile.existsSync()) {
        return previewFile.path;
      }
      
      return null;
    } catch (e) {
      ErrorLogger.logError('Error getting preview image path', e);
      return null;
    }
  }
  
  /// Clean up old processed files
  static Future<void> cleanup() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final processedDir = Directory('${appDir.path}/$_processedDir');
      final previewsDir = Directory('${appDir.path}/$_previewsDir');
      
      if (processedDir.existsSync()) {
        await processedDir.delete(recursive: true);
      }
      
      if (previewsDir.existsSync()) {
        await previewsDir.delete(recursive: true);
      }
      
      ErrorLogger.logInfo('BackgroundConverterService: Cleanup complete');
    } catch (e, stack) {
      ErrorLogger.logError('Error during background cleanup', e, stack);
    }
  }
}