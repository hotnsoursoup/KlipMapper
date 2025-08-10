// lib/core/database/tables/customers.dart
// Customer table definition with proper data types, Boolean columns, and foreign key constraints. Includes comprehensive customer data for POS operations and loyalty tracking.
// Usage: ACTIVE - Core table for customer management and relationship tracking

import 'package:drift/drift.dart';
import '../../../employees/data/tables/employees.dart';

@DataClassName('Customer')
class Customers extends Table {
  // Use non-nullable TEXT primary key (UUID recommended)
  TextColumn get id => text()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  
  DateTimeColumn get dateOfBirth => dateTime().named('date_of_birth').nullable()();
  TextColumn get gender => text().nullable()();
  
  // Address fields
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get zipCode => text().named('zip_code').nullable()();
  
  // Loyalty and visit tracking
  IntColumn get loyaltyPoints => integer().named('loyalty_points').withDefault(const Constant(0))();
  DateTimeColumn get lastVisit => dateTime().named('last_visit').nullable()();
  
  // Foreign key to employees table
  IntColumn get preferredTechnicianId => integer().named('preferred_technician_id').nullable()
      .references(Employees, #id, onDelete: KeyAction.setNull)();
  
  TextColumn get notes => text().nullable()();
  TextColumn get allergies => text().nullable()();
  
  // Use proper Boolean columns instead of INTEGER
  BoolColumn get emailOptIn => boolean().named('email_opt_in').withDefault(const Constant(false))();
  BoolColumn get smsOptIn => boolean().named('sms_opt_in').withDefault(const Constant(false))();
  
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
  
  // Add CHECK constraints for data integrity
  @override
  List<String> get customConstraints => [
    'CHECK (status IN (\'active\', \'inactive\', \'blocked\'))',
    'CHECK (gender IN (\'male\', \'female\', \'other\', \'prefer_not_to_say\') OR gender IS NULL)',
    'CHECK (loyalty_points >= 0)',
    'CHECK (length(phone) >= 10 OR phone IS NULL)', // Basic phone validation
    'UNIQUE(email) WHERE email IS NOT NULL', // Unique email when provided
  ];
}
