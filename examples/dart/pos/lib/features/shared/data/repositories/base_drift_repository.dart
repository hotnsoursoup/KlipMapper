// lib/features/shared/data/repositories/base_drift_repository.dart
// Abstract base repository class providing cached database initialization and shared functionality for all Drift repositories.
// Usage: ACTIVE - Base class inherited by all repository implementations
import '../../../../core/database/database.dart' as db;
import '../../../../core/utils/logger.dart';

/// Base class for Drift repositories to optimize initialization
abstract class BaseDriftRepository {
  static db.PosDatabase? _cachedDatabase;
  static bool _isInitialized = false;

  /// Get the database instance with cached initialization
  Future<db.PosDatabase> get database async {
    if (_cachedDatabase != null && _isInitialized) {
      return _cachedDatabase!;
    }
    
    await _initializeOnce();
    return _cachedDatabase!;
  }

  /// Initialize database once and cache it
  static Future<void> _initializeOnce() async {
    if (_isInitialized) return;
    
    try {
      _cachedDatabase = db.PosDatabase.instance;
      _isInitialized = true;
      Logger.info('Database initialized and cached for repositories');
    } catch (e, stack) {
      Logger.error('Failed to initialize database in repository', e, stack);
      rethrow;
    }
  }

  /// Check if database is ready without initializing
  bool get isDatabaseInitialized => _isInitialized && _cachedDatabase != null;

  /// Force re-initialization (useful for testing)
  static void resetCache() {
    _cachedDatabase = null;
    _isInitialized = false;
  }
}