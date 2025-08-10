// lib/core/database/tables/employees.dart
// Employee table definition with proper data types, foreign key constraints, and PIN authentication. Uses BoolColumn consistently and proper DateTime handling for clock in/out tracking.
// Usage: ACTIVE - Core table for staff management and time tracking system

import 'package:drift/drift.dart';

@DataClassName('Employee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  
  // Encrypted/secure field - store as hashed value with salt
  TextColumn get socialSecurityNumber => 
      text().named('social_security_number').nullable()();
  
  TextColumn get role => text().withDefault(const Constant('technician'))();
  
  // Currency as integer cents instead of REAL
  IntColumn get commissionRateCents => 
      integer().named('commission_rate_cents').nullable()(); // e.g., 1500 = 15.00%
  IntColumn get hourlyRateCents => 
      integer().named('hourly_rate_cents').nullable()(); // e.g., 2000 = $20.00
  
  DateTimeColumn get hireDate => dateTime().named('hire_date')();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  
  // Clock in/out tracking fields
  DateTimeColumn get clockedInAt => dateTime().named('clocked_in_at').nullable()();
  DateTimeColumn get clockedOutAt => dateTime().named('clocked_out_at').nullable()();
  BoolColumn get isClockedIn => boolean().named('is_clocked_in').withDefault(const Constant(false))();
  
  // PIN authentication - store hashed with salt (never store raw PIN)
  TextColumn get pinHash => text().named('pin_hash').nullable()();
  TextColumn get pinSalt => text().named('pin_salt').nullable()();
  DateTimeColumn get pinCreatedAt => dateTime().named('pin_created_at').nullable()();
  DateTimeColumn get pinLastUsedAt => dateTime().named('pin_last_used_at').nullable()();
  
  // Add CHECK constraints for role enum
  @override
  List<String> get customConstraints => [
    'CHECK (role IN (\'technician\', \'manager\', \'admin\', \'receptionist\'))',
    'CHECK (commission_rate_cents >= 0 AND commission_rate_cents <= 10000)', // 0-100%
    'CHECK (hourly_rate_cents >= 0)', // Non-negative hourly rate
  ];
}