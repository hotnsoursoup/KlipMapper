// lib/core/database/tables/employee_service_categories.dart
// Junction table linking employees to their service category specializations. Uses composite primary key for natural relationship without artificial ID.
// Usage: ACTIVE - Many-to-many relationship table for employee skill tracking

import 'package:drift/drift.dart';
import 'employees.dart';
import '../../../services/data/tables/service_categories.dart';

@DataClassName('EmployeeServiceCategory')
class EmployeeServiceCategories extends Table {
  // Foreign keys to create many-to-many relationship
  IntColumn get employeeId => integer().named('employee_id')
      .references(Employees, #id, onDelete: KeyAction.cascade)();
  
  IntColumn get categoryId => integer().named('category_id')
      .references(ServiceCategories, #id, onDelete: KeyAction.cascade)();
  
  // Optional: skill level or certification date
  DateTimeColumn get certifiedAt => dateTime().named('certified_at').nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  
  // Use composite primary key instead of artificial ID
  @override
  Set<Column> get primaryKey => {employeeId, categoryId};
  
  // Add uniqueness constraint to prevent duplicates
  @override
  List<String> get customConstraints => [
    'UNIQUE(employee_id, category_id)', // Prevent duplicate specializations
  ];
}
