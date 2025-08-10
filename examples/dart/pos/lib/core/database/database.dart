// lib/core/database/database.dart
// Main Drift database configuration with proper architecture: connection setup, schema wiring, and migration coordination. Implements clean separation of concerns with dedicated table files, DAOs, and type converters.
// Usage: ACTIVE - Core database singleton replacing drift_database.dart with improved structure

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:flutter/services.dart';

// Type converters

// Table definitions - order matters for foreign key references
import '../../features/services/data/tables/service_categories.dart';
import '../../features/employees/data/tables/employees.dart';
import '../../features/customers/data/tables/customers.dart';
import '../../features/services/data/tables/services.dart';
import '../../features/employees/data/tables/employee_service_categories.dart';
import '../../features/appointments/data/tables/appointments.dart';
import '../../features/tickets/data/tables/tickets.dart';
import '../../features/tickets/data/tables/ticket_services.dart'; // New normalized join table
import '../../features/appointments/data/tables/appointment_services.dart'; // New normalized join table for appointments
import '../../features/checkout/data/tables/invoices.dart';
import '../../features/checkout/data/tables/invoice_tickets.dart'; // New normalized join table
import '../../features/checkout/data/tables/payments.dart';
import '../../features/employees/data/tables/technician_schedules.dart';
import '../../features/employees/data/tables/time_entries.dart';
import 'tables/settings.dart';

// DAOs
import '../../features/employees/data/sources/employee_dao.dart';
import '../../features/customers/data/sources/customer_dao.dart';
import '../../features/tickets/data/sources/ticket_dao.dart';
import '../../features/checkout/data/sources/invoice_dao.dart';
import '../../features/checkout/data/sources/payment_dao.dart';
import '../../features/appointments/data/sources/appointment_dao.dart';

// Seeds - Asset-based seeding system
import 'seeds/seed_importer.dart';

import '../utils/logger.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ServiceCategories,
    Employees,
    Customers,
    Services,
    EmployeeServiceCategories,
    Appointments,
    Tickets,
    TicketServices, // New join table
    AppointmentServices, // New join table
    Invoices,
    InvoiceTickets, // New join table
    Payments,
    TechnicianSchedules,
    TimeEntries,
    Settings,
  ],
  daos: [
    EmployeeDao,
    CustomerDao,
    TicketDao,
    InvoiceDao,
    PaymentDao,
    AppointmentDao,
  ],
)
class PosDatabase extends _$PosDatabase {
  static PosDatabase? _instance;
  static PosDatabase get instance => _instance ??= PosDatabase._();
  static bool _initialized = false;

  PosDatabase._() : super(_openConnection());

  // Constructor for testing with custom connection
  PosDatabase.withConnection(super.connection);

  /// Backwards-compatible initializer used by older repositories.
  /// Ensures the singleton instance is created exactly once.
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    _instance ??= PosDatabase._();
    _initialized = true;
  }

  @override
  int get schemaVersion => 19; // v19: processed_by indexes, payments.authorized_by

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createPerformanceIndexes(m);
    },
    onUpgrade: (m, from, to) async => _runUpgrades(m, from, to),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      await customStatement('PRAGMA journal_mode = WAL;');
      await customStatement('PRAGMA cache_size = -16000;'); // 16MB cache
      await customStatement('PRAGMA temp_store = memory;');
      await customStatement('PRAGMA synchronous = NORMAL;');
      
      if (details.wasCreated) {
        await _seedDatabaseFromAssets();
      }
    },
  );

  /// Handles all database migrations in a centralized way
  Future<void> _runUpgrades(Migrator m, int from, int to) async {
    Logger.info('Upgrading database from version $from to $to');
    
    // Version 17: Major restructure with normalized tables
    if (from < 17) {
      await _migrateToNormalizedStructure(m);
    }
    // Version 18: ServiceCategories.id INT PK, Services.category_id INT FK
    if (from < 18) {
      await _migrateServiceCategoriesToIntIds(m);
    }
    if (from < 19) {
      await _addProcessedByEnhancements(m);
    }
    
    Logger.info('Database upgrade completed');
  }

  /// Major migration to normalized database structure
  Future<void> _migrateToNormalizedStructure(Migrator m) async {
    Logger.info('Migrating to normalized database structure...');
    
    // Create new join tables
    await m.createTable(ticketServices);
    await m.createTable(invoiceTickets);
    
    // Migrate existing JSON data to join tables
    await _migrateJsonToJoinTables();
    
    // Update table structures with proper constraints
    await _updateTableConstraints();
    
    Logger.info('Normalized structure migration completed');
  }

  /// Migrate existing JSON fields to normalized join tables
  Future<void> _migrateJsonToJoinTables() async {
    // TODO: Implement migration of existing tickets.services JSON to ticket_services table
    // TODO: Implement migration of existing invoices.ticket_ids JSON to invoice_tickets table
  }

  /// Add proper foreign key constraints and other improvements
  Future<void> _updateTableConstraints() async {
    // TODO: Add foreign key constraints
    // TODO: Add CHECK constraints for enums
    // TODO: Add UNIQUE constraints where needed
  }

  /// Creates performance-critical database indexes
  Future<void> _createPerformanceIndexes(Migrator m) async {
    try {
      // Customer search indexes
      await customStatement('CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(first_name, last_name);');
      
      // Ticket operational indexes
      await customStatement('CREATE INDEX IF NOT EXISTS idx_tickets_business_date_status ON tickets(business_date, status);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_tickets_customer_id ON tickets(customer_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_tickets_assigned_technician_id ON tickets(assigned_technician_id);');
      // Composite index recommended for live queue queries
      await customStatement('CREATE INDEX IF NOT EXISTS idx_tickets_tech_date_status ON tickets(assigned_technician_id, business_date, status);');
      
      // Appointment calendar indexes
      await customStatement('CREATE INDEX IF NOT EXISTS idx_appointments_start_datetime_status ON appointments(start_datetime, status);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_appointments_employee_id ON appointments(employee_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_appointments_customer_id ON appointments(customer_id);');
      
      // Financial indexes
      await customStatement('CREATE INDEX IF NOT EXISTS idx_payments_invoice_id ON payments(invoice_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_invoices_invoice_number ON invoices(invoice_number);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_invoices_processed_at ON invoices(processed_at);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_invoices_processed_by_date ON invoices(processed_by, processed_at);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_payments_processed_by_date ON payments(processed_by, processed_at);');
      
      // Join table indexes
      await customStatement('CREATE INDEX IF NOT EXISTS idx_ticket_services_ticket_id ON ticket_services(ticket_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_ticket_services_service_id ON ticket_services(service_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_appointment_services_appt_id ON appointment_services(appointment_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_appointment_services_service_id ON appointment_services(service_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_invoice_tickets_invoice_id ON invoice_tickets(invoice_id);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_invoice_tickets_ticket_id ON invoice_tickets(ticket_id);');
      
      Logger.info('Performance indexes created successfully');
    } catch (e) {
      Logger.error('Error creating performance indexes', e);
    }
  }

  /// v19: Add authorized_by to payments and create processed_by date indexes
  Future<void> _addProcessedByEnhancements(Migrator m) async {
    try {
      await customStatement('ALTER TABLE payments ADD COLUMN authorized_by INTEGER REFERENCES employees(id);');
    } catch (_) {
      // Column may already exist; ignore
    }
    await _createPerformanceIndexes(m);
  }

  /// Migration: Convert service_categories.id from TEXT to INTEGER PK and
  /// services.category_id from TEXT to INTEGER FK.
  Future<void> _migrateServiceCategoriesToIntIds(Migrator m) async {
    Logger.info('Migrating service categories to INTEGER primary keys...');
    try {
      // 1) Create new categories table with INTEGER PK
      await customStatement('''
        CREATE TABLE IF NOT EXISTS service_categories_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          color TEXT,
          icon TEXT,
          CONSTRAINT uq_service_categories_name UNIQUE (name)
        );
      ''');

      // 2) Copy all categories (rely on unique name)
      await customStatement('''
        INSERT INTO service_categories_new (name, color, icon)
        SELECT name, color, icon FROM service_categories;
      ''');

      // 3) Swap in the new categories table
      await customStatement('ALTER TABLE service_categories RENAME TO service_categories_old;');
      await customStatement('ALTER TABLE service_categories_new RENAME TO service_categories;');

      // 4) Recreate services table to use INTEGER FK for category_id
      await customStatement('ALTER TABLE services RENAME TO services_old;');
      await customStatement('''
        CREATE TABLE services (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          category_id INTEGER NOT NULL REFERENCES service_categories(id) ON DELETE CASCADE,
          duration_minutes INTEGER NOT NULL,
          base_price_cents INTEGER NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          CHECK (duration_minutes > 0 AND duration_minutes <= 480),
          CHECK (base_price_cents >= 0),
          CHECK (length(name) >= 2)
        );
      ''');

      // 5) Copy services, mapping category by name from old categories
      await customStatement('''
        INSERT INTO services (
          id, name, description, category_id, duration_minutes,
          base_price_cents, is_active, created_at, updated_at
        )
        SELECT s.id, s.name, s.description, sc_new.id, s.duration_minutes,
               s.base_price_cents, s.is_active, s.created_at, s.updated_at
        FROM services_old s
        JOIN service_categories_old sc_old ON sc_old.id = s.category_id
        JOIN service_categories sc_new ON sc_new.name = sc_old.name;
      ''');

      // 6) Migrate employee_service_categories.category_id from TEXT -> INTEGER
      // Rename old table and recreate with INTEGER FK
      await customStatement('ALTER TABLE employee_service_categories RENAME TO employee_service_categories_old;');
      await customStatement('''
        CREATE TABLE employee_service_categories (
          employee_id INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
          category_id INTEGER NOT NULL REFERENCES service_categories(id) ON DELETE CASCADE,
          certified_at INTEGER,
          is_active INTEGER NOT NULL DEFAULT 1,
          PRIMARY KEY (employee_id, category_id),
          UNIQUE (employee_id, category_id)
        );
      ''');
      await customStatement('''
        INSERT INTO employee_service_categories (
          employee_id, category_id, certified_at, is_active
        )
        SELECT esc_old.employee_id, sc_new.id, esc_old.certified_at, esc_old.is_active
        FROM employee_service_categories_old esc_old
        JOIN service_categories_old sc_old ON sc_old.id = esc_old.category_id
        JOIN service_categories sc_new ON sc_new.name = sc_old.name;
      ''');

      // 7) Drop old tables
      await customStatement('DROP TABLE services_old;');
      await customStatement('DROP TABLE employee_service_categories_old;');
      await customStatement('DROP TABLE service_categories_old;');

      // 8) Recreate performance indexes
      await _createPerformanceIndexes(m);

      Logger.success('Service categories migrated to INTEGER IDs');
    } catch (e) {
      Logger.error('Failed migrating service categories to INTEGER IDs', e);
    }
  }

  /// Seeds database with data from asset YAML files
  Future<void> _seedDatabaseFromAssets() async {
    try {
      Logger.info('Starting asset-based database seeding...');
      final seedImporter = SeedImporter(this);
      
      // Import service categories first (due to foreign key relationships)
      final categoriesResult = await seedImporter.importServiceCategories(
        createBackup: false, // No backup needed for initial seeding
        importedBy: 'system_init',
      );
      
      if (!categoriesResult.success) {
        Logger.error('Failed to import service categories: ${categoriesResult.message}');
        for (final error in categoriesResult.errors) {
          Logger.error('  - $error');
        }
        return;
      }
      
      Logger.success('Imported ${categoriesResult.itemsImported} service categories');
      
      // Import services
      final servicesResult = await seedImporter.importServices(
        createBackup: false, // No backup needed for initial seeding
        importedBy: 'system_init',
      );
      
      if (!servicesResult.success) {
        Logger.error('Failed to import services: ${servicesResult.message}');
        for (final error in servicesResult.errors) {
          Logger.error('  - $error');
        }
        return;
      }
      
      Logger.success('Imported ${servicesResult.itemsImported} services');
      Logger.success('Asset-based database seeding completed successfully');
      
    } catch (e) {
      Logger.error('Failed to seed database from assets', e);
      // Log but don't throw - let the app continue even if seeding fails
    }
  }
}

/// Opens optimized database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pos.db'));

    Logger.info('Database path: ${file.path}');

    // Copy seeded database if it doesn't exist
    if (!await file.exists()) {
      try {
        final data = await rootBundle.load('assets/database/pos.db');
        final bytes = data.buffer.asUint8List();
        await dbFolder.create(recursive: true);
        await file.writeAsBytes(bytes);
        Logger.success('Seeded database copied');
      } catch (e) {
        Logger.warning('No seeded database available, creating empty');
      }
    }

    // Android SQLite3 setup
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}
