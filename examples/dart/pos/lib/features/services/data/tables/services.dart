// lib/core/database/tables/services.dart
// Service table definition with proper foreign key constraints to service categories and integer cents pricing. Includes duration tracking and active status management.
// Usage: ACTIVE - Core table for service catalog management with proper relationships

import 'package:drift/drift.dart';
import 'service_categories.dart';

@DataClassName('Service')
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  // Foreign key to service_categories table - non-nullable for data integrity
  IntColumn get categoryId => integer().named('category_id')
      .references(ServiceCategories, #id, onDelete: KeyAction.cascade)();

  IntColumn get durationMinutes => integer().named('duration_minutes')();

  // Store price as integer cents instead of REAL to avoid floating point issues
  IntColumn get basePriceCents => integer().named('base_price_cents')(); // e.g., 2500 = $25.00

  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Add CHECK constraints for business rules
  @override
  List<String> get customConstraints => [
    'CHECK (duration_minutes > 0 AND duration_minutes <= 480)', // 1 min to 8 hours
    'CHECK (base_price_cents >= 0)', // Non-negative pricing
    'CHECK (length(name) >= 2)', // Minimum service name length
  ];
}
