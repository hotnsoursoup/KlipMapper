// lib/core/database/tables/service_categories.dart
// Service category table definition with non-nullable primary key and proper constraints. Used for organizing services into logical groups with visual styling.
// Usage: ACTIVE - Core table for service organization and categorization system

import 'package:drift/drift.dart';

@DataClassName('ServiceCategory')
class ServiceCategories extends Table {
  // Integer auto-incrementing primary key for categories
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()(); // Hex color like '#4A90E2'
  TextColumn get icon => text().nullable()(); // Icon name like 'pan_tool', 'brush'

  // Add constraints for data integrity
  @override
  List<String> get customConstraints => [
    'CHECK (length(name) >= 2)', // Minimum category name length
    "CHECK (color IS NULL OR (color LIKE '#%' AND length(color) = 7))", // Valid hex color
    'UNIQUE(name)', // Category names must be unique
  ];
}
