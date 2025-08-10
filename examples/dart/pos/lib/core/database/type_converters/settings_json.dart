// lib/core/database/type_converters/settings_json.dart
// Type converter for settings JSON data used in settings table. Handles conversion between Dart Map and SQLite TEXT JSON format for complex configuration objects.
// Usage: ACTIVE - Used by settings table for storing structured configuration data like store hours

import 'dart:convert';
import 'package:drift/drift.dart';
import '../../utils/logger.dart';

/// Converts settings JSON string from SQLite to Map
class SettingsJsonConverter
    extends TypeConverter<Map<String, dynamic>, String> {
  const SettingsJsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    if (fromDb.isEmpty) return {};
    try {
      final dynamic decoded = json.decode(fromDb);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (e) {
      Logger.error('Error parsing settings JSON: $fromDb', e);
      return {};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) {
    if (value.isEmpty) return '{}';
    try {
      return json.encode(value);
    } catch (e) {
      Logger.error('Error encoding settings to JSON', e);
      return '{}';
    }
  }
}