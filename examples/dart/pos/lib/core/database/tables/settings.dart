// lib/core/database/tables/settings.dart
// Settings table definition for application configuration storage with proper data type handling and category organization. Supports JSON configuration data for complex settings.
// Usage: ACTIVE - Core table for application settings and configuration management

import 'package:drift/drift.dart';

@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key => text()(); // Setting key (e.g., 'dashboard_font_size', 'store_hours_open')
  TextColumn get value => text()(); // Setting value (serialized as string/JSON)
  TextColumn get category => text().nullable()(); // Group settings: 'dashboard', 'store', 'general', etc.
  TextColumn get dataType => text().named('data_type').nullable()(); // 'string', 'boolean', 'integer', 'double', 'json'
  TextColumn get description => text().nullable()(); // Human-readable description
  BoolColumn get isSystem => boolean().named('is_system').withDefault(const Constant(false))(); // System vs user settings
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {key};
  
  // Add CHECK constraints for data integrity
  @override
  List<String> get customConstraints => [
    'CHECK (category IN (\'dashboard\', \'store\', \'general\', \'salon\') OR category IS NULL)',
    'CHECK (data_type IN (\'string\', \'boolean\', \'integer\', \'double\', \'json\') OR data_type IS NULL)',
    'CHECK (length("key") >= 2)', // Minimum key length; quote column name
  ];
}
