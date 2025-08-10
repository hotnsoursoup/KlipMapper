// lib/core/database/seeds/managers/seed_backup_manager.dart
// Backup and versioning system for seed data with rollback capabilities and audit trails
// Usage: ACTIVE - Manages seed data backups for safe imports and rollbacks

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import '../models/seed_models.dart';
import '../../../utils/logger.dart';

/// Manages backup and versioning of seed data
class SeedBackupManager {
  static const String backupDirName = 'seed_backups';
  static const String metadataFileName = 'backup_metadata.json';
  static const int maxBackupsPerType = 10;

  /// Create a backup before importing new seed data
  static Future<SeedBackup> createBackup({
    required String seedType,
    required Map<String, dynamic> currentData,
    String? description,
    String? createdBy,
  }) async {
    try {
      final backupDir = await _getBackupDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final backupId = _generateBackupId(seedType, timestamp);
      
      // Create backup file
      final backupFile = File('${backupDir.path}/${seedType}_$timestamp.json');
      await backupFile.writeAsString(jsonEncode({
        'backup_info': {
          'id': backupId,
          'type': seedType,
          'created_at': DateTime.now().toIso8601String(),
          'created_by': createdBy,
          'description': description,
          'version': _generateContentHash(currentData),
        },
        'data': currentData,
      }));

      // Create backup metadata
      final backup = SeedBackup(
        id: backupId,
        seedType: seedType,
        version: _generateContentHash(currentData),
        filePath: backupFile.path,
        createdAt: DateTime.now(),
        itemCount: _countItems(currentData),
        description: description,
        createdBy: createdBy,
      );

      // Update metadata index
      await _updateMetadataIndex(backup);

      // Clean up old backups
      await _cleanupOldBackups(seedType);

      Logger.success('Created backup for $seedType: ${backup.id}');
      return backup;
    } catch (e, stack) {
      Logger.error('Failed to create backup for $seedType', e);
      throw SeedBackupException('Failed to create backup: $e', stack);
    }
  }

  /// Restore data from a backup
  static Future<Map<String, dynamic>> restoreFromBackup(String backupId) async {
    try {
      final metadata = await getBackupMetadata();
      final backup = metadata.firstWhere(
        (b) => b.id == backupId,
        orElse: () => throw SeedBackupException('Backup not found: $backupId'),
      );

      final backupFile = File(backup.filePath);
      if (!await backupFile.exists()) {
        throw SeedBackupException('Backup file not found: ${backup.filePath}');
      }

      final backupContent = jsonDecode(await backupFile.readAsString());
      final data = backupContent['data'] as Map<String, dynamic>;

      Logger.success('Restored backup: ${backup.id}');
      return data;
    } catch (e, stack) {
      Logger.error('Failed to restore backup: $backupId', e);
      throw SeedBackupException('Failed to restore backup: $e', stack);
    }
  }

  /// Get all backup metadata
  static Future<List<SeedBackup>> getBackupMetadata() async {
    try {
      final backupDir = await _getBackupDirectory();
      final metadataFile = File('${backupDir.path}/$metadataFileName');
      
      if (!await metadataFile.exists()) {
        return [];
      }

      final metadataJson = jsonDecode(await metadataFile.readAsString());
      final backupsList = metadataJson['backups'] as List;
      
      return backupsList.map((json) => SeedBackup.fromJson(json)).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Latest first
    } catch (e) {
      Logger.error('Failed to load backup metadata', e);
      return [];
    }
  }

  /// Get backups for a specific seed type
  static Future<List<SeedBackup>> getBackupsForType(String seedType) async {
    final allBackups = await getBackupMetadata();
    return allBackups.where((backup) => backup.seedType == seedType).toList();
  }

  /// Delete a backup
  static Future<void> deleteBackup(String backupId) async {
    try {
      final metadata = await getBackupMetadata();
      final backup = metadata.firstWhere(
        (b) => b.id == backupId,
        orElse: () => throw SeedBackupException('Backup not found: $backupId'),
      );

      // Delete backup file
      final backupFile = File(backup.filePath);
      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      // Update metadata index
      final updatedMetadata = metadata.where((b) => b.id != backupId).toList();
      await _saveMetadataIndex(updatedMetadata);

      Logger.success('Deleted backup: $backupId');
    } catch (e, stack) {
      Logger.error('Failed to delete backup: $backupId', e);
      throw SeedBackupException('Failed to delete backup: $e', stack);
    }
  }

  /// Validate backup integrity
  static Future<bool> validateBackupIntegrity(String backupId) async {
    try {
      final data = await restoreFromBackup(backupId);
      final metadata = await getBackupMetadata();
      final backup = metadata.firstWhere((b) => b.id == backupId);
      
      final currentHash = _generateContentHash(data);
      return currentHash == backup.version;
    } catch (e) {
      Logger.error('Failed to validate backup integrity: $backupId', e);
      return false;
    }
  }

  /// Get backup directory
  static Future<Directory> _getBackupDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final backupDir = Directory('${appDir.path}/$backupDirName');
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    
    return backupDir;
  }

  /// Generate unique backup ID
  static String _generateBackupId(String seedType, String timestamp) {
    final random = DateTime.now().microsecondsSinceEpoch.toString().substring(8);
    return '${seedType}_${timestamp}_$random';
  }

  /// Generate content hash for versioning
  static String _generateContentHash(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 12); // First 12 characters
  }

  /// Count items in seed data
  static int _countItems(Map<String, dynamic> data) {
    var count = 0;
    
    // Count categories if present
    if (data['categories'] is List) {
      count += (data['categories'] as List).length;
    }
    
    // Count services if present
    if (data['services'] is List) {
      count += (data['services'] as List).length;
    }
    
    // Add other countable items as needed
    return count;
  }

  /// Update metadata index with new backup
  static Future<void> _updateMetadataIndex(SeedBackup backup) async {
    final metadata = await getBackupMetadata();
    metadata.add(backup);
    await _saveMetadataIndex(metadata);
  }

  /// Save metadata index to file
  static Future<void> _saveMetadataIndex(List<SeedBackup> backups) async {
    final backupDir = await _getBackupDirectory();
    final metadataFile = File('${backupDir.path}/$metadataFileName');
    
    final metadataJson = {
      'version': '1.0',
      'updated_at': DateTime.now().toIso8601String(),
      'backups': backups.map((backup) => backup.toJson()).toList(),
    };
    
    await metadataFile.writeAsString(jsonEncode(metadataJson));
  }

  /// Clean up old backups to maintain storage limits
  static Future<void> _cleanupOldBackups(String seedType) async {
    try {
      final typeBackups = await getBackupsForType(seedType);
      
      if (typeBackups.length > maxBackupsPerType) {
        // Sort by creation date (oldest first for deletion)
        typeBackups.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        
        // Delete excess backups
        final toDelete = typeBackups.take(typeBackups.length - maxBackupsPerType);
        for (final backup in toDelete) {
          await deleteBackup(backup.id);
        }
        
        Logger.info('Cleaned up ${toDelete.length} old $seedType backups');
      }
    } catch (e) {
      Logger.error('Failed to cleanup old backups for $seedType', e);
      // Don't throw - cleanup failure shouldn't block backup creation
    }
  }

  /// Export backup metadata as JSON for external storage
  static Future<String> exportMetadata() async {
    final metadata = await getBackupMetadata();
    final export = {
      'exported_at': DateTime.now().toIso8601String(),
      'backup_count': metadata.length,
      'backups': metadata.map((backup) => backup.toJson()).toList(),
    };
    return jsonEncode(export);
  }

  /// Get storage statistics
  static Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final backupDir = await _getBackupDirectory();
      final metadata = await getBackupMetadata();
      
      var totalSize = 0;
      final typeStats = <String, int>{};
      
      for (final backup in metadata) {
        final file = File(backup.filePath);
        if (await file.exists()) {
          final size = await file.length();
          totalSize += size;
          typeStats[backup.seedType] = (typeStats[backup.seedType] ?? 0) + 1;
        }
      }
      
      return {
        'total_backups': metadata.length,
        'total_size_bytes': totalSize,
        'total_size_mb': (totalSize / 1024 / 1024).toStringAsFixed(2),
        'backup_types': typeStats,
        'backup_directory': backupDir.path,
      };
    } catch (e) {
      Logger.error('Failed to get storage stats', e);
      return {'error': e.toString()};
    }
  }
}

/// Custom exception for backup operations
class SeedBackupException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  SeedBackupException(this.message, [this.stackTrace]);

  @override
  String toString() => 'SeedBackupException: $message';
}