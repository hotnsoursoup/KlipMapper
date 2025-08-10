// lib/core/database/drift_database.dart
// Main Drift database configuration defining all tables, type converters, and database operations for the POS system. Manages SQLite connections, migrations, and provides centralized data access layer.
// Usage: ACTIVE - Core database singleton used by all repository classes and data operations

import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:flutter/services.dart';
import '../utils/logger.dart';
import '../utils/date_formatter.dart';

// Import table definitions
part 'drift_database.g.dart';

// ============================================
// TYPE CONVERTERS
// ============================================

/// Converts services JSON string from SQLite to Map
class ServicesJsonConverter
    extends TypeConverter<List<Map<String, dynamic>>, String> {
  const ServicesJsonConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final dynamic decoded = json.decode(fromDb);
      if (decoded is List) {
        // Filter out non-Map items and only keep valid service objects
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
      return [];
    } catch (e) {
      Logger.error('Error parsing services JSON', e);
      return [];
    }
  }

  @override
  String toSql(List<Map<String, dynamic>> value) {
    if (value.isEmpty) return '[]';
    return json.encode(value);
  }
}

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
      Logger.error('Error parsing settings JSON', e);
      return {};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) {
    if (value.isEmpty) return '{}';
    return json.encode(value);
  }
}

// ============================================
// TABLE DEFINITIONS
// ============================================

@DataClassName('Employee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get socialSecurityNumber => text()
      .named('social_security_number')
      .nullable()(); // Encrypted/secure field
  TextColumn get role => text()();
  RealColumn get commissionRate => real().named('commission_rate').nullable()();
  RealColumn get hourlyRate => real().named('hourly_rate').nullable()();
  TextColumn get hireDate => text().named('hire_date')(); // TEXT in SQLite
  BoolColumn get isActive =>
      boolean().named('is_active').nullable()(); // Boolean in SQLite
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite
  // Clock in/out tracking fields
  DateTimeColumn get clockedInAt => dateTime()
      .named('clocked_in_at')
      .nullable()(); // DateTime when clocked in
  DateTimeColumn get clockedOutAt => dateTime()
      .named('clocked_out_at')
      .nullable()(); // DateTime when clocked out
  BoolColumn get isClockedIn => boolean()
      .named('is_clocked_in')
      .nullable()
      .withDefault(const Constant(false))(); // Boolean

  // PIN authentication fields
  TextColumn get pin => text().nullable()(); // 4-6 digit PIN (hashed)
  TextColumn get pinSalt =>
      text().named('pin_salt').nullable()(); // Salt for PIN hashing
  TextColumn get pinCreatedAt =>
      text().named('pin_created_at').nullable()(); // When PIN was created
  TextColumn get pinLastUsedAt =>
      text().named('pin_last_used_at').nullable()(); // When PIN was last used
}

@DataClassName('Customer')
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get dateOfBirth =>
      text().named('date_of_birth').nullable()(); // TEXT in SQLite
  TextColumn get gender => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get zipCode => text().named('zip_code').nullable()();
  IntColumn get loyaltyPoints =>
      integer().named('loyalty_points').nullable()(); // INTEGER in SQLite
  TextColumn get lastVisit =>
      text().named('last_visit').nullable()(); // TEXT in SQLite
  TextColumn get preferredTechnician =>
      text().named('preferred_technician').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get allergies => text().nullable()();
  IntColumn get emailOptIn => integer().named('email_opt_in').nullable()();
  IntColumn get smsOptIn => integer().named('sms_opt_in').nullable()();
  TextColumn get status => text().nullable()();
  IntColumn get isActive =>
      integer().named('is_active').nullable()(); // INTEGER in SQLite
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Ticket')
class Tickets extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().named('customer_id').nullable()();
  IntColumn get employeeId => integer().named('employee_id')();
  IntColumn get ticketNumber => integer().named('ticket_number')();
  TextColumn get customerName => text().named('customer_name')();
  TextColumn get services =>
      text().map(const ServicesJsonConverter())(); // JSON converter
  IntColumn get priority => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().nullable()(); // Add status field
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite
  TextColumn get businessDate =>
      text().named('business_date')(); // TEXT in SQLite
  TextColumn get checkInTime => text().named('check_in_time').nullable()();
  IntColumn get assignedTechnicianId =>
      integer().named('assigned_technician_id').nullable()();
  RealColumn get totalAmount => real().named('total_amount').nullable()();
  TextColumn get paymentStatus => text().named('payment_status').nullable()();
  IntColumn get isGroupService =>
      integer().named('is_group_service').nullable()();
  IntColumn get groupSize => integer().named('group_size').nullable()();
  TextColumn get appointmentId => text().named('appointment_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Service')
class Services extends Table {
  IntColumn get id =>
      integer().autoIncrement()(); // INTEGER PRIMARY KEY in database
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId =>
      integer().named('category_id').nullable()(); // Category reference
  IntColumn get durationMinutes => integer().named('duration_minutes')();
  RealColumn get basePrice =>
      real().named('base_price')(); // base_price in SQLite
  IntColumn get isActive =>
      integer().named('is_active').nullable()(); // INTEGER in SQLite
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite
}

@DataClassName('Invoice')
class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber =>
      text().named('invoice_number')(); // Human-readable invoice number
  TextColumn get ticketIds =>
      text().named('ticket_ids')(); // JSON array of ticket IDs
  TextColumn get customerName =>
      text().named('customer_name').nullable()(); // Main customer name
  RealColumn get subtotal => real()();
  RealColumn get taxAmount => real().named('tax_amount')();
  RealColumn get tipAmount => real().named('tip_amount')();
  RealColumn get discountAmount => real().named('discount_amount')();
  RealColumn get totalAmount => real().named('total_amount')();
  TextColumn get paymentMethod => text().named('payment_method')();
  TextColumn get discountType => text().named('discount_type').nullable()();
  TextColumn get discountCode => text().named('discount_code').nullable()();
  TextColumn get discountReason => text().named('discount_reason').nullable()();
  TextColumn get cardType => text().named('card_type').nullable()();
  TextColumn get lastFourDigits =>
      text().named('last_four_digits').nullable()();
  TextColumn get transactionId => text().named('transaction_id').nullable()();
  TextColumn get authorizationCode =>
      text().named('authorization_code').nullable()();
  TextColumn get processedAt => text().named('processed_at')();
  TextColumn get processedBy => text().named('processed_by')();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Payment')
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get ticketId => text().named('ticket_id')();
  TextColumn get invoiceId => text()
      .named('invoice_id')
      .nullable()(); // Links to invoice for multi-ticket payments
  TextColumn get paymentMethod => text().named('payment_method')();
  RealColumn get amount => real()();
  RealColumn get tipAmount => real().named('tip_amount').nullable()();
  RealColumn get taxAmount => real().named('tax_amount').nullable()();
  RealColumn get discountAmount => real().named('discount_amount').nullable()();
  RealColumn get totalAmount => real().named('total_amount').nullable()();
  TextColumn get discountType => text().named('discount_type').nullable()();
  TextColumn get discountCode => text().named('discount_code').nullable()();
  TextColumn get discountReason => text().named('discount_reason').nullable()();
  TextColumn get cardType => text().named('card_type').nullable()();
  TextColumn get lastFourDigits =>
      text().named('last_four_digits').nullable()();
  TextColumn get transactionId => text().named('transaction_id').nullable()();
  TextColumn get authorizationCode =>
      text().named('authorization_code').nullable()();
  TextColumn get processedAt =>
      text().named('processed_at').nullable()(); // TEXT in SQLite
  TextColumn get processedBy => text().named('processed_by').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Appointment')
class Appointments extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().named('customer_id')();
  IntColumn get employeeId => integer().named('employee_id')();

  // Datetime fields (stored as TEXT in SQLite)
  TextColumn get appointmentStartDateTime => text().named('start_datetime')();
  TextColumn get appointmentEndDateTime => text().named('end_datetime')();

  TextColumn get services =>
      text().map(const ServicesJsonConverter())(); // JSON converter
  TextColumn get status => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get isGroupBooking =>
      integer().named('is_group_booking').nullable()();
  IntColumn get groupSize => integer().named('group_size').nullable()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
  TextColumn get lastModifiedBy =>
      text().named('last_modified_by').nullable()();
  TextColumn get lastModifiedDevice =>
      text().named('last_modified_device').nullable()();

  // Confirmation tracking fields
  TextColumn get confirmedAt => text().named('confirmed_at').nullable()();
  TextColumn get confirmationType =>
      text().named('confirmation_type').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ServiceCategory')
class ServiceCategories extends Table {
  TextColumn get id => text().nullable()(); // nullable in SQLite
  TextColumn get name => text()();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text()
      .nullable()(); // Store icon name as string (e.g., 'pan_tool', 'brush')

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EmployeeServiceCategory')
class EmployeeServiceCategories extends Table {
  TextColumn get id => text().nullable()(); // nullable in SQLite
  IntColumn get employeeId => integer().named('employee_id')();
  TextColumn get categoryName => text().named('category_name').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key =>
      text()(); // Setting key (e.g., 'dashboard_font_size', 'store_hours_open')
  TextColumn get value => text()(); // Setting value (serialized as string/JSON)
  TextColumn get category => text()
      .nullable()(); // Group settings: 'dashboard', 'store', 'general', etc.
  TextColumn get dataType => text()
      .named('data_type')
      .nullable()(); // 'string', 'boolean', 'integer', 'double', 'json'
  TextColumn get description =>
      text().nullable()(); // Human-readable description
  IntColumn get isSystem => integer()
      .named('is_system')
      .nullable()(); // 1 for system settings, 0 for user settings
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get updatedAt => text().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('TechnicianSchedule')
class TechnicianSchedules extends Table {
  TextColumn get id => text()(); // Primary key - UUID/unique ID
  IntColumn get employeeId =>
      integer().named('employee_id')(); // Foreign key to employees
  TextColumn get dayOfWeek =>
      text().named('day_of_week')(); // monday, tuesday, etc.
  IntColumn get isScheduledOff =>
      integer().named('is_scheduled_off')(); // 0/1 - is this day scheduled off
  IntColumn get startTime => integer()
      .named('start_time')
      .nullable()(); // Minutes since midnight (e.g., 540 = 9:00 AM)
  IntColumn get endTime => integer()
      .named('end_time')
      .nullable()(); // Minutes since midnight (e.g., 1080 = 6:00 PM)
  TextColumn get effectiveDate => text()
      .named('effective_date')
      .nullable()(); // ISO8601 - when this schedule takes effect
  TextColumn get notes =>
      text().nullable()(); // Optional notes about the schedule
  IntColumn get isActive =>
      integer().named('is_active')(); // 0/1 - is this schedule record active
  TextColumn get createdAt =>
      text().named('created_at').nullable()(); // TEXT in SQLite
  TextColumn get updatedAt =>
      text().named('updated_at').nullable()(); // TEXT in SQLite

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TimeEntry')
class TimeEntries extends Table {
  TextColumn get id => text()(); // Primary key - UUID/unique ID
  IntColumn get employeeId =>
      integer().named('employee_id')(); // Foreign key to employees
  TextColumn get clockIn =>
      text().named('clock_in')(); // ISO8601 timestamp when clocked in
  TextColumn get clockOut => text()
      .named('clock_out')
      .nullable()(); // ISO8601 timestamp when clocked out (null if still clocked in)
  IntColumn get breakMinutes => integer()
      .named('break_minutes')
      .withDefault(const Constant(0))(); // Total break time in minutes
  RealColumn get totalHours =>
      real().named('total_hours').nullable()(); // Calculated total hours worked
  TextColumn get status => text().withDefault(
    const Constant('active'),
  )(); // 'active', 'completed', 'edited'
  TextColumn get editedBy => text()
      .named('edited_by')
      .nullable()(); // Employee ID who edited this entry
  TextColumn get editReason =>
      text().named('edit_reason').nullable()(); // Reason for editing
  TextColumn get createdAt =>
      text().named('created_at')(); // ISO8601 timestamp when record was created
  TextColumn get updatedAt => text().named(
    'updated_at',
  )(); // ISO8601 timestamp when record was last updated

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================
// DATABASE CLASS
// ============================================

@DriftDatabase(
  tables: [
    Employees,
    Customers,
    Tickets,
    Services,
    Invoices,
    Payments,
    Appointments,
    ServiceCategories,
    EmployeeServiceCategories,
    Settings,
    TechnicianSchedules,
    TimeEntries,
  ],
)
class PosDatabase extends _$PosDatabase {
  static PosDatabase? _instance;
  static PosDatabase get instance => _instance ??= PosDatabase._();

  PosDatabase._() : super(_openConnection());

  // Constructor for testing with custom connection
  PosDatabase.withConnection(super.connection);

  @override
  int get schemaVersion => 16; // Added time_entries table for clock tracking

  static bool _isInitialized = false;

  /// Ensure database is initialized before use
  static Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      _instance ??= PosDatabase._();
      _isInitialized = true;
      Logger.info('PosDatabase initialized');

      // TODO: Remove after migration to new database structure
      // Seeding is handled by the new database structure
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createPerformanceIndexes(m);
      Logger.info('Database tables and performance indexes created');

      // TODO: Remove after migration to new database structure
      // Seeding is handled by the new database structure
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle future migrations here
      if (from < 2) {
        await _createPerformanceIndexes(m);
      }
      if (from < 3) {
        // Migration for column name changes in appointments table
        await _migrateAppointmentColumns(m);
      }
      if (from < 4) {
        // Migration for adding SSN field to employees table
        await _addEmployeeSsnField(m);
      }
      if (from < 5) {
        // Migration for adding Settings table
        await _addSettingsTable(m);
      }
      if (from < 6) {
        // Migration for updating Settings table with StoreSettings structure
        await _updateSettingsForStoreSettings(m);
      }
      if (from < 7) {
        // Migration for adding status column to tickets table
        await _addTicketStatusColumn(m);
      }
      if (from < 8) {
        // Migration for adding appointment confirmation tracking
        await _addAppointmentConfirmationFields(m);
      }
      if (from < 9) {
        // Migration for changing assigned_technician_id from TEXT to INTEGER
        await _changeAssignedTechnicianIdToInteger(m);
      }
      if (from < 10) {
        // Migration for adding TechnicianSchedules table
        await _addTechnicianSchedulesTable(m);
      }
      if (from < 11) {
        // Migration for adding TimeEntries table
        await _addTimeEntriesTable(m);
      }
      if (from < 12) {
        // Migration for adding PIN authentication fields to employees table
        await _addEmployeePinFields(m);
      }
      if (from < 13) {
        // Migration for adding Invoices table and updating Payments table
        await _addInvoicesTable(m);
      }
      if (from < 14) {
        // Migration for adding icon column to service_categories table
        await _addIconColumnToServiceCategories(m);
      }
      if (from < 15) {
        // Migration for adding appointment_id column to tickets table
        await _addAppointmentIdToTickets(m);
      }
      if (from < 16) {
        // Migration for adding time_entries table (re-run if needed)
        await _ensureTimeEntriesTableExists(m);
      }
      Logger.info('Database upgraded from version $from to $to');
    },
    beforeOpen: (details) async {
      // Enable foreign key constraints for better data integrity
      await customStatement('PRAGMA foreign_keys = ON;');

      // Enable Write-Ahead Logging for better performance
      await customStatement('PRAGMA journal_mode = WAL;');

      // Optimize SQLite performance settings
      await customStatement('PRAGMA cache_size = -16000;'); // 16MB cache
      await customStatement('PRAGMA temp_store = memory;');
      await customStatement('PRAGMA synchronous = NORMAL;');

      Logger.info('Database opened, version: ${details.versionNow}');
    },
  );

  /// Creates performance-critical database indexes
  Future<void> _createPerformanceIndexes(Migrator m) async {
    try {
      // Customer indexes for search operations
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_customers_first_name ON customers(first_name);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_customers_last_name ON customers(last_name);',
      );

      // Ticket indexes for common queries
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_customer_id ON tickets(customer_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_assigned_technician_id ON tickets(assigned_technician_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_payment_status ON tickets(payment_status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_status ON tickets(status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_check_in_time ON tickets(check_in_time);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_updated_at ON tickets(updated_at);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_business_date ON tickets(business_date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_tech_date_status ON tickets(assigned_technician_id, business_date, status);',
      );

      // Appointment indexes for calendar and scheduling operations
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_appointments_start_datetime ON appointments(start_datetime);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_appointments_employee_id ON appointments(employee_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_appointments_customer_id ON appointments(customer_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_appointments_date_status ON appointments(start_datetime, status);',
      );

      // Employee indexes for staff management
      // await customStatement('CREATE INDEX IF NOT EXISTS idx_employees_location_id ON employees(location_id);');
      // await customStatement('CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);');

      // Service indexes for service management
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_services_category_id ON services(category_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_services_active ON services(is_active);',
      );

      // Payment indexes for financial operations
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_ticket_id ON payments(ticket_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at);',
      );

      Logger.info('Performance indexes created successfully');
    } catch (e) {
      Logger.error('Error creating performance indexes', e);
      // Don't fail database creation if indexes fail
    }
  }

  Future<void> _migrateAppointmentColumns(Migrator m) async {
    try {
      // Check if old columns exist before attempting migration
      final result = await customSelect(
        'PRAGMA table_info(appointments)',
      ).get();
      final columns = result.map((row) => row.data['name'] as String).toList();

      if (columns.contains('appointment_start_datetime')) {
        Logger.info('Migrating appointment table columns...');

        // Rename the columns using ALTER TABLE
        await customStatement(
          'ALTER TABLE appointments RENAME COLUMN appointment_start_datetime TO start_datetime;',
        );
        await customStatement(
          'ALTER TABLE appointments RENAME COLUMN appointment_end_datetime TO end_datetime;',
        );

        Logger.info('Appointment table column migration completed');
      } else {
        Logger.info('Appointment table already has new column names');
      }
    } catch (e) {
      Logger.error('Error migrating appointment columns', e);
      // Don't fail migration if column rename fails
    }
  }

  Future<void> _addEmployeeSsnField(Migrator m) async {
    try {
      Logger.info('Adding social_security_number field to employees table...');

      // Add the new column (will be null for existing records)
      await customStatement(
        'ALTER TABLE employees ADD COLUMN social_security_number TEXT;',
      );

      Logger.info('SSN field added to employees table successfully');
    } catch (e) {
      Logger.error('Error adding SSN field to employees table', e);
      // Don't fail migration if column addition fails
    }
  }

  /// Add Settings table (v4 to v5)
  Future<void> _addSettingsTable(Migrator m) async {
    try {
      Logger.info('Creating settings table...');

      // Create the settings table
      await m.createTable(settings);

      // Insert default nail salon settings
      await _insertDefaultSettings();

      Logger.info('Settings table created successfully with defaults');
    } catch (e) {
      Logger.error('Error creating settings table', e);
      // Don't fail migration if table creation fails
    }
  }

  /// Insert default settings for nail salon POS
  Future<void> _insertDefaultSettings() async {
    final now = AppDateFormatter.toIso8601String(DateTime.now());

    // Dashboard Settings
    final dashboardSettings = [
      "('dashboard_show_customer_phone', 'true', 'dashboard', 'boolean', 'Display customer phone numbers on tickets', 0, '$now', '$now')",
      "('dashboard_enable_checkout_notifications', 'true', 'dashboard', 'boolean', 'Show notifications when tickets are ready for checkout', 0, '$now', '$now')",
      "('dashboard_service_display_mode', 'Pills', 'dashboard', 'string', 'Display mode for services: Pills or Icons', 0, '$now', '$now')",
      "('dashboard_font_size', 'medium', 'dashboard', 'string', 'Font size for dashboard elements', 0, '$now', '$now')",
      "('dashboard_technician_layout', 'grid2', 'dashboard', 'string', 'Layout for technician cards display', 0, '$now', '$now')",
    ];

    // Store Settings - times stored as integers (minutes since midnight: 60*h)
    // 9:00 AM = 9 * 60 = 540 minutes, 6:00 PM = 18 * 60 = 1080 minutes
    const defaultStoreHours =
        '{"hours":{"monday":{"isOpen":true,"openTime":540,"closeTime":1080},"tuesday":{"isOpen":true,"openTime":540,"closeTime":1080},"wednesday":{"isOpen":true,"openTime":540,"closeTime":1080},"thursday":{"isOpen":true,"openTime":540,"closeTime":1080},"friday":{"isOpen":true,"openTime":540,"closeTime":1080},"saturday":{"isOpen":true,"openTime":540,"closeTime":1080},"sunday":{"isOpen":false}}}';
    final storeSettings = [
      "('store_hours_configuration', '$defaultStoreHours', 'store', 'string', 'Store hours configuration for each day of the week', 0, '$now', '$now')",
      "('store_online_booking', 'false', 'store', 'boolean', 'Allow customers to book appointments online', 0, '$now', '$now')",
      "('store_location', 'Main Location', 'store', 'string', 'Current store location', 0, '$now', '$now')",
      "('store_timezone', 'America/New_York', 'store', 'string', 'Store timezone for appointments', 1, '$now', '$now')",
      "('store_appointment_buffer', '15', 'store', 'integer', 'Minutes between appointments', 0, '$now', '$now')",
      "('store_walk_ins_enabled', 'true', 'store', 'boolean', 'Accept walk-in customers', 0, '$now', '$now')",
      "('store_max_daily_appointments', '50', 'store', 'integer', 'Maximum appointments per day', 0, '$now', '$now')",
    ];

    // General Settings
    final generalSettings = [
      "('general_theme', 'light', 'general', 'string', 'App theme appearance', 0, '$now', '$now')",
      "('general_sound_effects', 'true', 'general', 'boolean', 'Play sounds for notifications and actions', 0, '$now', '$now')",
      "('general_animations', 'true', 'general', 'boolean', 'Enable smooth transitions and animations', 0, '$now', '$now')",
      "('general_language', 'en', 'general', 'string', 'App language', 0, '$now', '$now')",
      "('general_currency', 'USD', 'general', 'string', 'Currency for pricing', 1, '$now', '$now')",
      "('general_date_format', 'MM/dd/yyyy', 'general', 'string', 'Date format for display', 0, '$now', '$now')",
      "('general_time_format', '12h', 'general', 'string', '12 or 24 hour time format', 0, '$now', '$now')",
    ];

    // Nail Salon Specific Settings
    final salonSettings = [
      "('salon_service_duration_buffer', '5', 'salon', 'integer', 'Extra minutes added to service duration', 0, '$now', '$now')",
      "('salon_require_technician_specialization', 'false', 'salon', 'boolean', 'Only allow technicians to perform services they specialize in', 0, '$now', '$now')",
      "('salon_auto_checkout_completed', 'false', 'salon', 'boolean', 'Automatically move completed services to checkout', 0, '$now', '$now')",
      "('salon_loyalty_points_enabled', 'true', 'salon', 'boolean', 'Enable customer loyalty points system', 0, '$now', '$now')",
      "('salon_loyalty_points_ratio', '1.0', 'salon', 'double', 'Points earned per dollar spent', 0, '$now', '$now')",
      "('salon_require_appointment_confirmation', 'true', 'salon', 'boolean', 'Require customer confirmation for appointments', 0, '$now', '$now')",
      "('salon_reminder_hours_before', '24', 'salon', 'integer', 'Hours before appointment to send reminder', 0, '$now', '$now')",
      "('salon_group_booking_enabled', 'true', 'salon', 'boolean', 'Allow group bookings for parties', 0, '$now', '$now')",
      "('salon_max_group_size', '8', 'salon', 'integer', 'Maximum people in a group booking', 0, '$now', '$now')",
      "('salon_price_display_mode', 'individual', 'salon', 'string', 'How to display service prices: individual, package, both', 0, '$now', '$now')",
      "('salon_collect_customer_address', 'true', 'salon', 'boolean', 'Collect customer address information during registration', 0, '$now', '$now')",
      "('salon_collect_customer_dob', 'true', 'salon', 'boolean', 'Collect customer date of birth during registration', 0, '$now', '$now')",
      "('salon_collect_customer_gender', 'true', 'salon', 'boolean', 'Collect customer gender during registration', 0, '$now', '$now')",
      "('salon_collect_customer_allergies', 'true', 'salon', 'boolean', 'Collect customer allergies information during registration', 0, '$now', '$now')",
    ];

    // Insert all settings
    final allSettings = [
      ...dashboardSettings,
      ...storeSettings,
      ...generalSettings,
      ...salonSettings,
    ];

    for (final setting in allSettings) {
      try {
        await customStatement(
          'INSERT OR IGNORE INTO settings (key, value, category, data_type, description, is_system, created_at, updated_at) VALUES $setting',
        );
      } catch (e) {
        Logger.error('Error inserting default setting: $setting', e);
      }
    }
  }

  /// Update Settings table for StoreSettings structure (v5 to v6)
  Future<void> _updateSettingsForStoreSettings(Migrator m) async {
    try {
      Logger.info('Updating settings for StoreSettings structure...');

      // Remove old unwanted settings
      final oldSettings = [
        'dashboard_show_completed_tickets',
        'dashboard_auto_assignment',
        'dashboard_enable_notifications',
        'store_hours_open',
        'store_hours_close',
      ];

      for (final settingKey in oldSettings) {
        await customStatement('DELETE FROM settings WHERE key = ?', [
          settingKey,
        ]);
      }

      // Insert new StoreSettings structure
      final now = AppDateFormatter.toIso8601String(DateTime.now());

      // Add checkout notifications setting
      await customStatement(
        'INSERT OR REPLACE INTO settings (key, value, category, data_type, description, is_system, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          'dashboard_enable_checkout_notifications',
          'true',
          'dashboard',
          'boolean',
          'Show notifications when tickets are ready for checkout',
          0,
          now,
          now,
        ],
      );

      // Add service display mode setting
      await customStatement(
        'INSERT OR REPLACE INTO settings (key, value, category, data_type, description, is_system, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          'dashboard_service_display_mode',
          'Pills',
          'dashboard',
          'string',
          'Display mode for services: Pills or Icons',
          0,
          now,
          now,
        ],
      );

      // Add comprehensive store hours configuration - times as integers (minutes since midnight)
      // 9:00 AM = 9 * 60 = 540 minutes, 6:00 PM = 18 * 60 = 1080 minutes
      const defaultStoreHours =
          '{"hours":{"monday":{"isOpen":true,"openTime":540,"closeTime":1080},"tuesday":{"isOpen":true,"openTime":540,"closeTime":1080},"wednesday":{"isOpen":true,"openTime":540,"closeTime":1080},"thursday":{"isOpen":true,"openTime":540,"closeTime":1080},"friday":{"isOpen":true,"openTime":540,"closeTime":1080},"saturday":{"isOpen":true,"openTime":540,"closeTime":1080},"sunday":{"isOpen":false}}}';

      await customStatement(
        'INSERT OR REPLACE INTO settings (key, value, category, data_type, description, is_system, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          'store_hours_configuration',
          defaultStoreHours,
          'store',
          'string',
          'Store hours configuration for each day of the week',
          0,
          now,
          now,
        ],
      );

      Logger.info('Settings updated for StoreSettings structure successfully');
    } catch (e) {
      Logger.error('Error updating settings for StoreSettings structure', e);
      // Don't fail migration if settings update fails
    }
  }

  /// Add status column to tickets table
  Future<void> _addTicketStatusColumn(Migrator m) async {
    try {
      Logger.info('Adding status column to tickets table...');

      // Add the status column
      await customStatement(
        "ALTER TABLE tickets ADD COLUMN status TEXT DEFAULT 'queued';",
      );

      // Update existing tickets to have appropriate status based on their payment_status
      await customStatement("""
        UPDATE tickets 
        SET status = CASE 
          WHEN payment_status = 'paid' THEN 'paid'
          WHEN payment_status = 'completed' THEN 'completed'
          WHEN payment_status IN ('in-progress', 'processing') THEN 'in-service'
          WHEN assigned_technician_id IS NOT NULL THEN 'assigned'
          ELSE 'queued'
        END
        WHERE status IS NULL;
      """);

      Logger.success('Successfully added status column to tickets table');
    } catch (e) {
      // If column already exists, just log and continue
      Logger.warning('Status column may already exist or error occurred: $e');
    }
  }

  /// Migration to add appointment confirmation tracking fields
  Future<void> _addAppointmentConfirmationFields(Migrator m) async {
    try {
      Logger.info(
        'Adding confirmation tracking fields to appointments table...',
      );

      // Add the confirmation fields
      await customStatement(
        'ALTER TABLE appointments ADD COLUMN confirmed_at TEXT;',
      );
      await customStatement(
        'ALTER TABLE appointments ADD COLUMN confirmation_type TEXT;',
      );

      // Update existing 'confirmed' appointments to have confirmation data
      await customStatement("""
        UPDATE appointments 
        SET confirmed_at = datetime('now'), confirmation_type = 'phone'
        WHERE status = 'confirmed' AND confirmed_at IS NULL;
      """);

      // Update problematic statuses: 'in-progress' and 'not-confirmed' to 'scheduled'
      await customStatement(
        "UPDATE appointments SET status = 'scheduled' WHERE status = 'in-progress';",
      );
      await customStatement(
        "UPDATE appointments SET status = 'scheduled' WHERE status = 'not-confirmed';",
      );

      Logger.success(
        'Successfully added appointment confirmation fields and updated statuses',
      );
    } catch (e) {
      // If columns already exist, just log and continue
      Logger.warning(
        'Confirmation fields may already exist or error occurred: $e',
      );
    }
  }

  /// Migration to change assigned_technician_id from TEXT to INTEGER (v8 to v9)
  Future<void> _changeAssignedTechnicianIdToInteger(Migrator m) async {
    try {
      Logger.info('Migrating assigned_technician_id from TEXT to INTEGER...');

      // SQLite doesn't support ALTER COLUMN TYPE directly, so we need to:
      // 1. Create a temporary column
      // 2. Copy data with conversion
      // 3. Drop old column
      // 4. Rename new column

      // Step 1: Add new integer column
      await customStatement(
        'ALTER TABLE tickets ADD COLUMN assigned_technician_id_new INTEGER;',
      );

      // Step 2: Copy data, converting TEXT to INTEGER (skip NULL and non-numeric values)
      await customStatement('''
        UPDATE tickets 
        SET assigned_technician_id_new = CAST(assigned_technician_id AS INTEGER)
        WHERE assigned_technician_id IS NOT NULL 
        AND assigned_technician_id != '' 
        AND assigned_technician_id GLOB '[0-9]*'
      ''');

      // Step 3: Drop old column (SQLite doesn't support DROP COLUMN in older versions)
      // Instead, we'll recreate the table structure
      await customStatement('''
        CREATE TABLE tickets_new (
          id TEXT PRIMARY KEY,
          customer_id TEXT,
          employee_id INTEGER NOT NULL,
          ticket_number INTEGER NOT NULL,
          customer_name TEXT NOT NULL,
          services TEXT NOT NULL,
          priority INTEGER,
          notes TEXT,
          status TEXT,
          created_at TEXT,
          updated_at TEXT,
          business_date TEXT NOT NULL,
          check_in_time TEXT,
          assigned_technician_id INTEGER,
          total_amount REAL,
          payment_status TEXT,
          is_group_service INTEGER,
          group_size INTEGER
        )
      ''');

      // Step 4: Copy all data to new table
      await customStatement('''
        INSERT INTO tickets_new 
        SELECT 
          id, customer_id, employee_id, ticket_number, customer_name, services, 
          priority, notes, status, created_at, updated_at, business_date, 
          check_in_time, assigned_technician_id_new, total_amount, payment_status, 
          is_group_service, group_size
        FROM tickets
      ''');

      // Step 5: Drop old table and rename new one
      await customStatement('DROP TABLE tickets');
      await customStatement('ALTER TABLE tickets_new RENAME TO tickets');

      // Step 6: Recreate indexes
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_customer_id ON tickets(customer_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_assigned_technician_id ON tickets(assigned_technician_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_payment_status ON tickets(payment_status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_status ON tickets(status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_tickets_check_in_time ON tickets(check_in_time);',
      );

      Logger.info('assigned_technician_id migration completed successfully');
    } catch (e) {
      Logger.error('Error migrating assigned_technician_id column', e);
      rethrow; // This is a critical migration, so fail if it doesn't work
    }
  }

  /// Add TechnicianSchedules table (v9 to v10)
  Future<void> _addTechnicianSchedulesTable(Migrator m) async {
    try {
      Logger.info('Creating technician_schedules table...');

      // Create the technician schedules table
      await m.createTable(technicianSchedules);

      // Add index for common queries
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_technician_schedules_employee_day ON technician_schedules(employee_id, day_of_week);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_technician_schedules_effective_date ON technician_schedules(effective_date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_technician_schedules_active ON technician_schedules(is_active);',
      );

      Logger.info('TechnicianSchedules table created successfully');
    } catch (e) {
      Logger.error('Error creating technician_schedules table', e);
      // Don't fail migration if table creation fails
    }
  }

  /// Migration for adding TimeEntries table (schema version 11)
  Future<void> _addTimeEntriesTable(Migrator m) async {
    try {
      Logger.info('Creating time_entries table...');

      // Create the time entries table
      await m.createTable(timeEntries);

      // Add indexes for common queries
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_time_entries_employee_id ON time_entries(employee_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_time_entries_clock_in ON time_entries(clock_in);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_time_entries_status ON time_entries(status);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_time_entries_employee_date ON time_entries(employee_id, date(clock_in));',
      );

      Logger.info('TimeEntries table created successfully');
    } catch (e) {
      Logger.error('Error creating time_entries table', e);
      // Don't fail migration if table creation fails
    }
  }

  /// Ensure time_entries table exists (schema version 16)
  Future<void> _ensureTimeEntriesTableExists(Migrator m) async {
    try {
      Logger.info('Ensuring time_entries table exists...');

      // Check if table exists
      final result = await customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='time_entries';",
      ).get();

      if (result.isEmpty) {
        Logger.info('time_entries table does not exist, creating it now...');

        // Create the table manually with SQL since it might not have been created before
        await customStatement('''
          CREATE TABLE IF NOT EXISTS time_entries (
            id TEXT PRIMARY KEY NOT NULL,
            employee_id INTEGER NOT NULL,
            clock_in TEXT NOT NULL,
            clock_out TEXT,
            break_minutes INTEGER NOT NULL DEFAULT 0,
            total_hours REAL,
            status TEXT NOT NULL DEFAULT 'active',
            edited_by TEXT,
            edit_reason TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
        ''');

        // Add indexes for common queries
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_time_entries_employee_id ON time_entries(employee_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_time_entries_clock_in ON time_entries(clock_in);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_time_entries_status ON time_entries(status);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_time_entries_employee_date ON time_entries(employee_id, date(clock_in));',
        );

        Logger.info('time_entries table created successfully');
      } else {
        Logger.info('time_entries table already exists');
      }
    } catch (e) {
      Logger.error('Error ensuring time_entries table exists', e);
    }
  }

  /// Migration for adding PIN authentication fields to employees table (schema version 12)
  Future<void> _addEmployeePinFields(Migrator m) async {
    try {
      Logger.info('Adding PIN authentication fields to employees table...');

      // Add PIN authentication columns to employees table
      await customStatement('ALTER TABLE employees ADD COLUMN pin TEXT;');
      await customStatement('ALTER TABLE employees ADD COLUMN pin_salt TEXT;');
      await customStatement(
        'ALTER TABLE employees ADD COLUMN pin_created_at TEXT;',
      );
      await customStatement(
        'ALTER TABLE employees ADD COLUMN pin_last_used_at TEXT;',
      );

      Logger.info(
        'PIN authentication fields added to employees table successfully',
      );
    } catch (e) {
      Logger.error('Error adding PIN fields to employees table', e);
      // Don't fail migration if column addition fails
    }
  }

  /// Migration to add Invoices table and update Payments table (v12 to v13)
  Future<void> _addInvoicesTable(Migrator m) async {
    try {
      Logger.info('Adding Invoices table and updating Payments table...');

      // Create the invoices table
      await m.createTable(invoices);

      // Add invoice_id column to payments table
      await customStatement('ALTER TABLE payments ADD COLUMN invoice_id TEXT;');

      Logger.info(
        'Invoices table created and Payments table updated successfully',
      );
    } catch (e) {
      Logger.error('Error adding Invoices table', e);
      // Don't fail migration if table creation fails
    }
  }

  Future<void> _addIconColumnToServiceCategories(Migrator m) async {
    try {
      Logger.info('Adding icon column to service_categories table...');

      // Add icon column to service_categories table
      await customStatement(
        'ALTER TABLE service_categories ADD COLUMN icon TEXT;',
      );

      Logger.info('Icon column added to service_categories table successfully');
    } catch (e) {
      Logger.error('Error adding icon column to service_categories', e);
      // Don't fail migration if column already exists
    }
  }

  Future<void> _addAppointmentIdToTickets(Migrator m) async {
    try {
      Logger.info('Adding appointment_id column to tickets table...');

      // Add appointment_id column to tickets table
      await customStatement(
        'ALTER TABLE tickets ADD COLUMN appointment_id TEXT;',
      );

      Logger.info('appointment_id column added to tickets table successfully');
    } catch (e) {
      Logger.error('Error adding appointment_id column to tickets', e);
      // Don't fail migration if column already exists
    }
  }
}

/// Opens a connection to the database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Get the application documents directory
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pos.db'));
    final dbPath = file.path;

    Logger.info('Database path: $dbPath');

    // Only copy seeded database if it doesn't exist (normal behavior)
    if (!await file.exists()) {
      try {
        // Load the seeded database from assets
        final data = await rootBundle.load('assets/database/pos.db');
        final bytes = data.buffer.asUint8List();

        // Create the directory if it doesn't exist
        await dbFolder.create(recursive: true);

        // Write the database file
        await file.writeAsBytes(bytes);
        Logger.success('Seeded database copied to: $dbPath');
      } catch (e) {
        Logger.error('Error copying seeded database', e);
        // Continue without seeded data - the database will be created empty
      }
    } else {
      Logger.info('Database already exists, will use existing with migrations');
    }

    // Make sure sqlite3 is available on Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}
