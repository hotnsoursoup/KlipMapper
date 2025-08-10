// lib/core/database/type_converters/services_json.dart
// Type converter for services JSON data used in legacy appointments and tickets tables. Handles conversion between Dart List<Map> and SQLite TEXT JSON format with error handling.
// Usage: ACTIVE - Used by appointments and tickets tables for backward compatibility during migration

import 'dart:convert';
import 'package:drift/drift.dart';
import '../../utils/logger.dart';

/// Converts services JSON string from SQLite to Map
class ServicesJsonConverter
    extends TypeConverter<List<Map<String, Object?>>, String> {
  const ServicesJsonConverter();

  @override
  List<Map<String, Object?>> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final dynamic decoded = json.decode(fromDb);
      if (decoded is List) {
        return decoded.whereType<Map<String, Object?>>().toList();
      }
      return [];
    } catch (e) {
      Logger.error('Error parsing services JSON: $fromDb', e);
      return [];
    }
  }

  @override
  String toSql(List<Map<String, Object?>> value) {
    if (value.isEmpty) return '[]';
    try {
      return json.encode(value);
    } catch (e) {
      Logger.error('Error encoding services to JSON', e);
      return '[]';
    }
  }
}
