// lib/features/shared/data/repositories/drift_appointment_repository.dart
// Drift repository implementation for appointment management with date-time handling, service population, and query de-duplication.
// Usage: ACTIVE - Primary appointment data access layer with advanced time parsing and appointment lifecycle management
import 'package:drift/drift.dart';
import '../../../../core/database/drift_database.dart' as db;
import '../models/appointment_model.dart';
import '../models/customer_model.dart';
import '../models/service_model.dart';
import '../../../../utils/error_logger.dart';
import '../../../../core/services/time_service.dart';

/// Drift-based Appointment Repository
/// This handles appointments properly as appointments (not tickets)
class DriftAppointmentRepository {
  static DriftAppointmentRepository? _instance;
  static DriftAppointmentRepository get instance => _instance ??= DriftAppointmentRepository._();
  
  DriftAppointmentRepository._();
  
  db.PosDatabase? _database;
  bool _initialized = false;
  
  // De-duplication: Track in-flight requests to prevent duplicate queries
  static final Map<String, Future<List<Appointment>>> _inFlightQueries = {};
  static final Map<String, Future<int>> _inFlightCountQueries = {};
  
  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;
    
    try {
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftAppointmentRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftAppointmentRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Stream appointments for today, excluding completed/cancelled/noShow
  Stream<List<Appointment>> watchTodaysAppointments() async* {
    await initialize();
    final today = TimeService.instance.today;
    final todayDateString = today.toIso8601String().split('T')[0];

    final excludedStatuses = ['completed', 'cancelled', 'noShow', 'no-show'];
    final query = _database!.select(_database!.appointments)
      ..where((a) => a.appointmentStartDateTime.like('$todayDateString%') & a.status.isNotIn(excludedStatuses))
      ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);

    yield* query.watch().asyncMap((rows) async {
      // Batch fetch customers
      final customerIds = rows.map((a) => a.customerId).toSet().toList();
      final customers = customerIds.isEmpty
          ? <db.Customer>[]
          : await (_database!.select(_database!.customers)
                ..where((c) => c.id.isIn(customerIds)))
              .get();
      final customerMap = {for (var c in customers) c.id: c};

      final List<Appointment> result = [];
      for (final appt in rows) {
        try {
          result.add(await _convertToModelWithCustomer(appt, customerMap[appt.customerId]));
        } catch (e) {
          ErrorLogger.logError('watchTodaysAppointments convert ${appt.id}', e, StackTrace.current);
        }
      }
      return result;
    });
  }

  /// Stream appointments for today for calendar (exclude voided/cancelled/noShow)
  Stream<List<Appointment>> watchTodaysAppointmentsForCalendar() async* {
    await initialize();
    final today = TimeService.instance.today;
    final todayDateString = today.toIso8601String().split('T')[0];

    final excludedStatuses = ['voided', 'cancelled', 'noShow', 'no-show'];
    final query = _database!.select(_database!.appointments)
      ..where((a) => a.appointmentStartDateTime.like('$todayDateString%') & a.status.isNotIn(excludedStatuses))
      ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);

    yield* query.watch().asyncMap((rows) async {
      final customerIds = rows.map((a) => a.customerId).toSet().toList();
      final customers = customerIds.isEmpty
          ? <db.Customer>[]
          : await (_database!.select(_database!.customers)
                ..where((c) => c.id.isIn(customerIds)))
              .get();
      final customerMap = {for (var c in customers) c.id: c};

      final List<Appointment> result = [];
      for (final appt in rows) {
        try {
          result.add(await _convertToModelWithCustomer(appt, customerMap[appt.customerId]));
        } catch (e) {
          ErrorLogger.logError('watchTodaysAppointmentsForCalendar convert ${appt.id}', e, StackTrace.current);
        }
      }
      return result;
    });
  }

  /// Stream appointments by date range; optionally exclude cancelled-like statuses
  Stream<List<Appointment>> watchAppointmentsByDateRange(
    DateTime start,
    DateTime end, {
    bool excludeCancelledLike = false,
  }) async* {
    await initialize();

    final startString = start.toIso8601String().substring(0, 19);
    final endString = end.toIso8601String().substring(0, 19);

    final query = _database!.select(_database!.appointments)
      ..where((a) => a.appointmentStartDateTime.isBetweenValues(startString, endString));

    if (excludeCancelledLike) {
      final excluded = ['voided', 'cancelled', 'noShow', 'no-show'];
      query.where((a) => a.status.isNotIn(excluded));
    }

    query.orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);

    yield* query.watch().asyncMap((rows) async {
      final customerIds = rows.map((a) => a.customerId).toSet().toList();
      final customers = customerIds.isEmpty
          ? <db.Customer>[]
          : await (_database!.select(_database!.customers)
                ..where((c) => c.id.isIn(customerIds)))
              .get();
      final customerMap = {for (var c in customers) c.id: c};

      final List<Appointment> result = [];
      for (final appt in rows) {
        try {
          result.add(await _convertToModelWithCustomer(appt, customerMap[appt.customerId]));
        } catch (e) {
          ErrorLogger.logError('watchAppointmentsByDateRange convert ${appt.id}', e, StackTrace.current);
        }
      }
      return result;
    });
  }

  /// Convert Drift Appointment to Model Appointment with populated data
  Future<Appointment> _convertToModel(db.Appointment driftAppointment) async {
    try {
      // Parse the appointment datetime (stored as TEXT in format "2025-07-28 13:00:00")
      DateTime appointmentDateTime;
      try {
        appointmentDateTime = DateTime.parse(driftAppointment.appointmentStartDateTime);
      } catch (e) {
        // If parsing fails, create a reasonable default
        appointmentDateTime = DateTime.now();
        ErrorLogger.logError('Failed to parse appointmentStartDateTime: ${driftAppointment.appointmentStartDateTime}', e, StackTrace.current);
      }

      // Prefer normalized appointment_services; fallback to JSON if not present
      final List<Service> services = await _fetchNormalizedServicesForAppointment(driftAppointment.id);
      final List<String> serviceIds = services.isNotEmpty
          ? services.map((s) => s.id).toList()
          : _extractServiceIdsFromJson(driftAppointment.services);

      // Fetch customer details
      Customer? customer;
      try {
        final driftCustomer = await (_database!.select(_database!.customers)
          ..where((c) => c.id.equals(driftAppointment.customerId))
        ).getSingleOrNull();
        
        if (driftCustomer != null) {
          customer = Customer.withName(
            id: driftCustomer.id,
            name: '${driftCustomer.firstName} ${driftCustomer.lastName}'.trim(),
            phone: driftCustomer.phone ?? '',
            email: driftCustomer.email ?? '',
          );
        }
      } catch (e) {
        ErrorLogger.logError('Failed to fetch customer for appointment ${driftAppointment.id}', e, StackTrace.current);
      }


      // Fetch technician name if requested
      String? requestedTechnicianName;
      if (driftAppointment.employeeId != 0) {
        try {
          final driftEmployee = await (_database!.select(_database!.employees)
            ..where((e) => e.id.equals(driftAppointment.employeeId))
          ).getSingleOrNull();
          
          if (driftEmployee != null) {
            final firstName = driftEmployee.firstName;
            final lastName = driftEmployee.lastName;
            requestedTechnicianName = '$firstName $lastName'.trim();
            if (requestedTechnicianName.isEmpty) {
              requestedTechnicianName = 'Employee ${driftEmployee.id}';
            }
          }
        } catch (e) {
          ErrorLogger.logError('Failed to fetch technician for appointment ${driftAppointment.id}', e, StackTrace.current);
        }
      }

      return Appointment(
        id: driftAppointment.id,
        customerId: driftAppointment.customerId,
        appointmentDate: appointmentDateTime, // Keep full datetime instead of stripping time
        appointmentTime: '${appointmentDateTime.hour.toString().padLeft(2, '0')}:${appointmentDateTime.minute.toString().padLeft(2, '0')}',
        durationMinutes: _calculateDurationFromServices(driftAppointment.services),
        status: driftAppointment.status ?? 'scheduled',
        requestedTechnicianId: driftAppointment.employeeId != 0 ? driftAppointment.employeeId.toString() : null,
        assignedTechnicianId: driftAppointment.employeeId != 0 ? driftAppointment.employeeId.toString() : null,
        serviceIds: serviceIds,
        notes: driftAppointment.notes,
        isGroupBooking: (driftAppointment.isGroupBooking ?? 0) == 1,
        groupSize: driftAppointment.groupSize ?? 1,
        createdAt: DateTime.now(), // Default since not stored in current schema
        updatedAt: DateTime.now(), // Default since not stored in current schema
        
        // Populated objects
        customer: customer,
        services: services,
        requestedTechnicianName: requestedTechnicianName,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error converting appointment to model', e, stack);
      rethrow;
    }
  }

  /// Convert Drift appointment to model with pre-fetched customer (performance optimized)

  /// Convert Drift appointment to model with pre-fetched customer (performance optimized)
  Future<Appointment> _convertToModelWithCustomer(db.Appointment driftAppointment, db.Customer? driftCustomer) async {
    try {
      // Parse the appointment datetime (stored as TEXT in format "2025-07-28 13:00:00")
      DateTime appointmentDateTime;
      try {
        appointmentDateTime = DateTime.parse(driftAppointment.appointmentStartDateTime);
      } catch (e) {
        // If parsing fails, create a reasonable default
        appointmentDateTime = DateTime.now();
        ErrorLogger.logError('Failed to parse appointmentStartDateTime: ${driftAppointment.appointmentStartDateTime}', e, StackTrace.current);
      }

      // Prefer normalized appointment_services; fallback to JSON if not present
      final List<Service> services = await _fetchNormalizedServicesForAppointment(driftAppointment.id);
      final List<String> serviceIds = services.isNotEmpty
          ? services.map((s) => s.id).toList()
          : _extractServiceIdsFromJson(driftAppointment.services);

      // Use pre-fetched customer data
      Customer? customer;
      if (driftCustomer != null) {
        customer = Customer.withName(
          id: driftCustomer.id,
          name: '${driftCustomer.firstName} ${driftCustomer.lastName}'.trim(),
          phone: driftCustomer.phone ?? '',
          email: driftCustomer.email ?? '',
        );
      }

      // Fetch technician name if requested (this could be optimized too but less critical)
      String? requestedTechnicianName;
      if (driftAppointment.employeeId != 0) {
        try {
          final driftEmployee = await (_database!.select(_database!.employees)
            ..where((e) => e.id.equals(driftAppointment.employeeId))
          ).getSingleOrNull();
          
          if (driftEmployee != null) {
            final firstName = driftEmployee.firstName;
            final lastName = driftEmployee.lastName;
            requestedTechnicianName = '$firstName $lastName'.trim();
            if (requestedTechnicianName.isEmpty) {
              requestedTechnicianName = 'Employee ${driftEmployee.id}';
            }
          }
        } catch (e) {
          ErrorLogger.logError('Failed to fetch technician for appointment ${driftAppointment.id}', e, StackTrace.current);
        }
      }

      return Appointment(
        id: driftAppointment.id,
        customerId: driftAppointment.customerId,
        appointmentDate: appointmentDateTime, // Keep full datetime instead of stripping time
        appointmentTime: '${appointmentDateTime.hour.toString().padLeft(2, '0')}:${appointmentDateTime.minute.toString().padLeft(2, '0')}',
        durationMinutes: _calculateDurationFromServices(driftAppointment.services),
        status: driftAppointment.status ?? 'scheduled',
        requestedTechnicianId: driftAppointment.employeeId != 0 ? driftAppointment.employeeId.toString() : null,
        assignedTechnicianId: driftAppointment.employeeId != 0 ? driftAppointment.employeeId.toString() : null,
        serviceIds: serviceIds,
        notes: driftAppointment.notes,
        isGroupBooking: (driftAppointment.isGroupBooking ?? 0) == 1,
        groupSize: driftAppointment.groupSize ?? 1,
        createdAt: DateTime.now(), // Default since not stored in current schema
        updatedAt: DateTime.now(), // Default since not stored in current schema
        
        // Populated objects
        customer: customer,
        services: services,
        requestedTechnicianName: requestedTechnicianName,
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error converting appointment to model', e, stack);
      rethrow;
    }
  }

  /// Calculate total duration from services
  int _calculateDurationFromServices(List<Map<String, dynamic>> services) {
    int totalDuration = 0;
    for (var service in services) {
      final duration = service['duration_minutes'] ?? service['duration'] ?? 30;
      totalDuration += duration as int;
    }
    return totalDuration > 0 ? totalDuration : 60; // Default to 60 minutes
  }

  /// Extract service IDs from legacy JSON field
  List<String> _extractServiceIdsFromJson(List<Map<String, dynamic>> servicesJson) {
    final List<String> ids = [];
    for (final serviceJson in servicesJson) {
      final id = serviceJson['id']?.toString();
      if (id != null && id.isNotEmpty) ids.add(id);
    }
    return ids;
  }

  /// Fetch normalized services for an appointment from appointment_services join table
  Future<List<Service>> _fetchNormalizedServicesForAppointment(String appointmentId) async {
    try {
      const sql = '''
        SELECT aps.appointment_id AS appointment_id,
               s.id AS service_id,
               s.name AS name,
               COALESCE(s.description, '') AS description,
               COALESCE(s.category_id, 1) AS category_id,
               COALESCE(s.duration_minutes, 30) AS duration_minutes,
               aps.unit_price_cents AS unit_price_cents,
               aps.assigned_technician_id AS assigned_technician_id
        FROM appointment_services aps
        JOIN services s ON s.id = aps.service_id
        WHERE aps.appointment_id = ?
        ORDER BY aps.rowid;
      ''';
      final rows = await _database!
          .customSelect(sql, variables: [Variable<String>(appointmentId)])
          .get();
      if (rows.isEmpty) return [];
      return rows.map((row) {
        return Service(
          id: row.data['service_id'].toString(),
          name: row.data['name'] as String,
          description: row.data['description'] as String,
          categoryId: (row.data['category_id'] as num).toInt(),
          basePrice: ((row.data['unit_price_cents'] as num).toInt()) / 100.0,
          durationMinutes: (row.data['duration_minutes'] as num).toInt(),
          isActive: true,
          createdAt: DateTime.now(),
          technicianId: row.data['assigned_technician_id']?.toString(),
        );
      }).toList();
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch normalized services for appointment $appointmentId', e, stack);
      return [];
    }
  }

  /// Get appointments for today (filtered for check-in/ticket dialogs)
  /// Excludes completed, cancelled, and noShow appointments
  Future<List<Appointment>> getTodaysAppointments() async {
    try {
      await initialize();
      
      // Get today's date as string (using static time service)
      final today = TimeService.instance.today;
      final todayDateString = today.toIso8601String().split('T')[0]; // '2025-07-28'
      
      ErrorLogger.logInfo('Fetching appointments for today: $todayDateString');
      
      // Use SQL to filter appointments for better performance
      // Include all statuses EXCEPT final completed states
      final excludedStatuses = ['completed', 'cancelled', 'noShow'];
      final query = _database!.select(_database!.appointments)
        ..where((a) => 
          a.appointmentStartDateTime.like('$todayDateString%') &
          a.status.isNotIn(excludedStatuses),
        )
        ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);
      
      final todaysAppointments = await query.get();
      
      ErrorLogger.logInfo('Found ${todaysAppointments.length} appointments for today');
      
      // Batch fetch customers to avoid N+1 queries
      final customerIds = todaysAppointments
          .map((a) => a.customerId)
          .toSet();
      
      ErrorLogger.logInfo('Unique customer IDs needed: ${customerIds.length}');
      
      final Map<String, db.Customer> customerMap = {};
      if (customerIds.isNotEmpty) {
        final customers = await (_database!.select(_database!.customers)
          ..where((c) => c.id.isIn(customerIds.toList())))
          .get();
        
        ErrorLogger.logInfo('Found ${customers.length} customers in database');
        
        for (var customer in customers) {
          customerMap[customer.id] = customer;
        }
      }
      
      ErrorLogger.logInfo('Customer map size: ${customerMap.length}');
      
      // Convert to model appointments with batched customer data
      final List<Appointment> result = [];
      for (var appt in todaysAppointments) {
        try {
          final customer = customerMap[appt.customerId];
          if (customer == null) {
            ErrorLogger.logWarning('No customer found for appointment ${appt.id} with customerId: ${appt.customerId}');
          }
          result.add(await _convertToModelWithCustomer(appt, customer));
        } catch (e, stack) {
          ErrorLogger.logError('Error converting appointment ${appt.id}', e, stack);
          // Continue processing other appointments
        }
      }
      
      return result;
    } catch (e, stack) {
      // Handle database errors gracefully (table not exists, etc.)
      if (e.toString().contains('no such table') || e.toString().contains('appointments')) {
        ErrorLogger.logInfo('Appointment table not populated yet - returning empty list');
        return [];
      }
      ErrorLogger.logError('Failed to fetch today\'s appointments', e, stack);
      return [];
    }
  }

  /// Get appointments for today (calendar view - more permissive)
  /// Only excludes voided/cancelled appointments - shows all other statuses including completed
  Future<List<Appointment>> getTodaysAppointmentsForCalendar() async {
    try {
      await initialize();
      
      // Get today's date as string (using static time service)
      final today = TimeService.instance.today;
      final todayDateString = today.toIso8601String().split('T')[0]; // '2025-07-28'
      
      ErrorLogger.logInfo('Fetching calendar appointments for today: $todayDateString');
      
      // For calendar view, only exclude voided/cancelled/noShow appointments
      final excludedStatuses = ['voided', 'cancelled', 'noShow'];
      final query = _database!.select(_database!.appointments)
        ..where((a) => 
          a.appointmentStartDateTime.like('$todayDateString%') &
          a.status.isNotIn(excludedStatuses),
        )
        ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);
      
      final todaysAppointments = await query.get();
      
      ErrorLogger.logInfo('Found ${todaysAppointments.length} calendar appointments for today');
      
      // Batch fetch customers to avoid N+1 queries
      final customerIds = todaysAppointments
          .map((a) => a.customerId)
          .toSet();
      
      ErrorLogger.logInfo('Unique customer IDs needed: ${customerIds.length}');
      
      final Map<String, db.Customer> customerMap = {};
      if (customerIds.isNotEmpty) {
        final customers = await (_database!.select(_database!.customers)
          ..where((c) => c.id.isIn(customerIds.toList())))
          .get();
        
        for (var customer in customers) {
          customerMap[customer.id] = customer;
        }
      }
      
      // Convert drift appointments to domain models with customer data
      final List<Appointment> appointments = [];
      for (var appt in todaysAppointments) {
        final customer = customerMap[appt.customerId];
        final appointment = await _convertToModelWithCustomer(appt, customer);
        appointments.add(appointment);
      }
      
      return appointments;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch today\'s calendar appointments', e, stack);
      return [];
    }
  }

  /// Get upcoming appointments (future appointments)
  Future<List<Appointment>> getUpcomingAppointments({int limit = 10}) async {
    try {
      await initialize();
      
      final now = DateTime.now();
      final nowString = now.toIso8601String().substring(0, 19); // "2025-07-28 15:30:00" format
      
      ErrorLogger.logInfo('Fetching upcoming appointments after: $nowString');
      
      // Get all appointments and filter for future ones
      final allAppointments = await _database!.select(_database!.appointments).get();
      
      // Filter appointments: upcoming only, exclude completed, cancelled, and in-progress
      final validStatuses = ['scheduled', 'confirmed', 'arrived'];
      final upcomingAppointments = allAppointments
        .where((a) => 
          a.appointmentStartDateTime.compareTo(nowString) > 0 &&
          validStatuses.contains(a.status),)
        .toList()
        ..sort((a, b) => a.appointmentStartDateTime.compareTo(b.appointmentStartDateTime));
      
      // Take only the requested limit
      final limitedAppointments = upcomingAppointments.take(limit).toList();
      
      ErrorLogger.logInfo('Found ${limitedAppointments.length} upcoming appointments');
      
      // Convert to model appointments
      final List<Appointment> result = [];
      for (var appt in limitedAppointments) {
        try {
          result.add(await _convertToModel(appt));
        } catch (e, stack) {
          ErrorLogger.logError('Error converting appointment ${appt.id}', e, stack);
          // Continue processing other appointments
        }
      }
      
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch upcoming appointments', e, stack);
      return [];
    }
  }

  /// Get appointments with server-side pagination support
  Future<List<Appointment>> getAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? customerId,
    String? employeeId,
    int? limit,
    int? offset,
  }) async {
    // Create a unique key for this query to prevent duplicates
    final queryKey = 'appointments_${startDate?.toIso8601String() ?? 'null'}_${endDate?.toIso8601String() ?? 'null'}_${status ?? 'null'}_${customerId ?? 'null'}_${employeeId ?? 'null'}_${limit ?? 'null'}_${offset ?? 'null'}';
    
    // Check if this exact query is already in flight
    if (_inFlightQueries.containsKey(queryKey)) {
      ErrorLogger.logInfo('De-duplicating appointment query: $queryKey');
      return await _inFlightQueries[queryKey]!;
    }
    
    // Start the query and store it in the in-flight map
    final queryFuture = _executeGetAppointments(
      startDate: startDate,
      endDate: endDate,
      status: status,
      customerId: customerId,
      employeeId: employeeId,
      limit: limit,
      offset: offset,
    );
    
    _inFlightQueries[queryKey] = queryFuture;
    
    try {
      final result = await queryFuture;
      return result;
    } finally {
      // Clean up the in-flight query when done
      _inFlightQueries.remove(queryKey);
    }
  }
  
  /// Internal method that performs the actual query
  Future<List<Appointment>> _executeGetAppointments({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? customerId,
    String? employeeId,
    int? limit,
    int? offset,
  }) async {
    try {
      await initialize();
      
      var query = _database!.select(_database!.appointments);
      
      // Apply filters
      if (startDate != null) {
        final startString = startDate.toIso8601String().substring(0, 19);
        query = query..where((a) => a.appointmentStartDateTime.isBiggerOrEqual(Variable(startString)));
      }
      
      if (endDate != null) {
        final endString = endDate.toIso8601String().substring(0, 19);
        query = query..where((a) => a.appointmentStartDateTime.isSmallerThan(Variable(endString)));
      }
      
      if (status != null) {
        query = query..where((a) => a.status.equals(status));
      }
      
      if (customerId != null) {
        query = query..where((a) => a.customerId.equals(customerId));
      }
      
      if (employeeId != null) {
        final empId = int.tryParse(employeeId) ?? 0;
        query = query..where((a) => a.employeeId.equals(empId));
      }
      
      // Add ordering - ascending order by appointment date/time
      query = query..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);
      
      // Apply pagination
      if (limit != null) {
        query = query..limit(limit, offset: offset ?? 0);
      }
      
      final appointments = await query.get();
      
      ErrorLogger.logInfo('Loaded ${appointments.length} appointments from database (paginated: limit=$limit, offset=$offset)');
      
      // Convert to model appointments
      final List<Appointment> result = [];
      for (var appt in appointments) {
        try {
          result.add(await _convertToModel(appt));
        } catch (e, stack) {
          ErrorLogger.logError('Error converting appointment ${appt.id}', e, stack);
          // Continue processing other appointments
        }
      }
      
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch appointments with pagination', e, stack);
      return [];
    }
  }

  /// Get total count of appointments for pagination info
  Future<int> getAppointmentsCount({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? customerId,
    String? employeeId,
  }) async {
    // Create a unique key for this count query to prevent duplicates
    final countKey = 'appointments_count_${startDate?.toIso8601String() ?? 'null'}_${endDate?.toIso8601String() ?? 'null'}_${status ?? 'null'}_${customerId ?? 'null'}_${employeeId ?? 'null'}';
    
    // Check if this exact count query is already in flight
    if (_inFlightCountQueries.containsKey(countKey)) {
      ErrorLogger.logInfo('De-duplicating appointment count query: $countKey');
      return await _inFlightCountQueries[countKey]!;
    }
    
    // Start the count query and store it in the in-flight map
    final countFuture = _executeGetAppointmentsCount(
      startDate: startDate,
      endDate: endDate,
      status: status,
      customerId: customerId,
      employeeId: employeeId,
    );
    
    _inFlightCountQueries[countKey] = countFuture;
    
    try {
      final result = await countFuture;
      return result;
    } finally {
      // Clean up the in-flight count query when done
      _inFlightCountQueries.remove(countKey);
    }
  }
  
  /// Internal method that performs the actual count query
  Future<int> _executeGetAppointmentsCount({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? customerId,
    String? employeeId,
  }) async {
    try {
      await initialize();
      
      var query = _database!.selectOnly(_database!.appointments)
        ..addColumns([_database!.appointments.id.count()]);
      
      // Apply the same filters as getAppointments
      if (startDate != null) {
        final startString = startDate.toIso8601String().substring(0, 19);
        query = query..where(_database!.appointments.appointmentStartDateTime.isBiggerOrEqual(Variable(startString)));
      }
      
      if (endDate != null) {
        final endString = endDate.toIso8601String().substring(0, 19);
        query = query..where(_database!.appointments.appointmentStartDateTime.isSmallerThan(Variable(endString)));
      }
      
      if (status != null) {
        query = query..where(_database!.appointments.status.equals(status));
      }
      
      if (customerId != null) {
        query = query..where(_database!.appointments.customerId.equals(customerId));
      }
      
      if (employeeId != null) {
        final empId = int.tryParse(employeeId) ?? 0;
        query = query..where(_database!.appointments.employeeId.equals(empId));
      }
      
      final result = await query.getSingle();
      final count = result.read(_database!.appointments.id.count()) ?? 0;
      
      ErrorLogger.logInfo('Total appointments count: $count');
      return count;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get appointments count', e, stack);
      return 0;
    }
  }

  /// Get appointment by ID
  Future<Appointment?> getAppointmentById(String id) async {
    try {
      await initialize();
      
      final appointment = await (_database!.select(_database!.appointments)
        ..where((a) => a.id.equals(id)))
        .getSingleOrNull();
      
      if (appointment == null) return null;
      
      return await _convertToModel(appointment);
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch appointment by ID: $id', e, stack);
      return null;
    }
  }

  /// Check in appointment (convert to ticket)
  /// This should create a ticket and update the appointment status
  Future<String?> checkInAppointment(String appointmentId) async {
    try {
      await initialize();
      
      // Get the appointment
      final appointment = await getAppointmentById(appointmentId);
      if (appointment == null) {
        ErrorLogger.logError('Appointment not found for check-in', appointmentId, StackTrace.current);
        return null;
      }
      
      // Update appointment status to 'in-service' when checked in
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          status: const Value('in-service'),
        ),);
      
      ErrorLogger.logInfo('Appointment $appointmentId checked in successfully');
      
      // TODO: Create ticket from appointment using TicketRepository
      // This should be handled by the calling code to maintain separation of concerns
      
      return appointmentId;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to check in appointment: $appointmentId', e, stack);
      return null;
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          status: Value(status),
        ),);
      
      ErrorLogger.logInfo('Updated appointment $appointmentId status to $status');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update appointment status', e, stack);
      rethrow;
    }
  }

  /// Create new appointment
  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      await initialize();
      
      // Convert services to JSON format for database storage
      final servicesJson = appointment.services?.map((service) => {
        'id': service.id,
        'name': service.name,
        'category_id': service.categoryId,
        'price': service.price,
        'duration': service.durationMinutes,
      },).toList() ?? [];
      
      // Format appointment datetime for database storage
      final appointmentDateTime = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
        int.parse(appointment.appointmentTime.split(':')[0]),
        int.parse(appointment.appointmentTime.split(':')[1]),
      );
      
      // Calculate end time by adding duration to start time
      final appointmentEndDateTime = appointmentDateTime.add(Duration(minutes: appointment.durationMinutes));
      
      await _database!.into(_database!.appointments).insert(
        db.AppointmentsCompanion(
          id: Value(appointment.id),
          customerId: Value(appointment.customerId),
          employeeId: Value(int.tryParse(appointment.requestedTechnicianId ?? '0') ?? 0),
          appointmentStartDateTime: Value(appointmentDateTime.toIso8601String().substring(0, 19)),
          appointmentEndDateTime: Value(appointmentEndDateTime.toIso8601String().substring(0, 19)),
          services: Value(servicesJson),
          notes: Value(appointment.notes),
          status: Value(appointment.status),
          isGroupBooking: Value(appointment.isGroupBooking ? 1 : 0),
          groupSize: Value(appointment.groupSize),
          createdAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
          updatedAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
        ),
      );
      
      ErrorLogger.logInfo('Created appointment ${appointment.id}');
      return appointment.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to create appointment: ${appointment.id}', e, stack);
      rethrow;
    }
  }

  /// Reschedule appointment
  Future<void> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          appointmentStartDateTime: Value(newDateTime.toIso8601String().substring(0, 19)),
        ),);
      
      ErrorLogger.logInfo('Rescheduled appointment $appointmentId to $newDateTime');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to reschedule appointment: $appointmentId', e, stack);
      rethrow;
    }
  }

  /// Update appointment notes
  Future<void> updateAppointmentNotes(String appointmentId, String? notes) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          notes: notes != null ? Value(notes) : const Value.absent(),
          updatedAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
        ),);
      
      ErrorLogger.logInfo('Updated appointment notes for $appointmentId');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update appointment notes: $appointmentId', e, stack);
      rethrow;
    }
  }

  /// Get all appointments for a specific customer (most recent first)
  Future<List<Appointment>> getCustomerAppointments(String customerId) async {
    try {
      await initialize();

      final rows = await (_database!.select(_database!.appointments)
            ..where((a) => a.customerId.equals(customerId))
            ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime, mode: OrderingMode.desc)])
          )
          .get();

      final List<Appointment> result = [];
      for (final r in rows) {
        try {
          result.add(await _convertToModel(r));
        } catch (e, stack) {
          ErrorLogger.logError('getCustomerAppointments convert ${r.id}', e, stack);
        }
      }
      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get customer appointments for $customerId', e, stack);
      return [];
    }
  }

  /// Update existing appointment
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      await initialize();
      
      // Convert services to JSON format for database storage
      final servicesJson = appointment.services?.map((service) => {
        'id': service.id,
        'name': service.name,
        'category_id': service.categoryId,
        'price': service.price,
        'duration': service.durationMinutes,
      },).toList() ?? [];
      
      // Format appointment datetime for database storage
      final appointmentDateTime = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
        int.parse(appointment.appointmentTime.split(':')[0]),
        int.parse(appointment.appointmentTime.split(':')[1]),
      );
      
      // Calculate end time by adding duration to start time
      final appointmentEndDateTime = appointmentDateTime.add(Duration(minutes: appointment.durationMinutes));
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointment.id)))
        .write(db.AppointmentsCompanion(
          customerId: Value(appointment.customerId),
          employeeId: Value(int.tryParse(appointment.requestedTechnicianId ?? '0') ?? 0),
          appointmentStartDateTime: Value(appointmentDateTime.toIso8601String().substring(0, 19)),
          appointmentEndDateTime: Value(appointmentEndDateTime.toIso8601String().substring(0, 19)),
          services: Value(servicesJson),
          notes: Value(appointment.notes),
          status: Value(appointment.status),
          isGroupBooking: Value(appointment.isGroupBooking ? 1 : 0),
          groupSize: Value(appointment.groupSize),
          updatedAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
        ),);
      
      ErrorLogger.logInfo('Updated appointment ${appointment.id}');
      return appointment.copyWith(
        updatedAt: DateTime.now(),
      );
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update appointment: ${appointment.id}', e, stack);
      rethrow;
    }
  }

  /// Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await initialize();
      
      await (_database!.delete(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .go();
      
      ErrorLogger.logInfo('Deleted appointment $appointmentId');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete appointment: $appointmentId', e, stack);
      rethrow;
    }
  }

  /// Update assigned technician (employeeId in appointments table)
  Future<void> updateAppointmentTechnician(String appointmentId, String? technicianId) async {
    try {
      await initialize();
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          employeeId: technicianId != null ? Value(int.parse(technicianId)) : const Value.absent(),
          updatedAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
        ),);
      
      ErrorLogger.logInfo('Updated appointment technician for $appointmentId');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update appointment technician: $appointmentId', e, stack);
      rethrow;
    }
  }

  /// Update appointment duration (affects end time)
  Future<void> updateAppointmentDuration(String appointmentId, int durationMinutes) async {
    try {
      await initialize();
      
      // Get current appointment to calculate new end time
      final currentAppointment = await (_database!.select(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId))).getSingleOrNull();
      
      if (currentAppointment == null) {
        throw Exception('Appointment not found: $appointmentId');
      }
      
      // Parse start time and calculate new end time
      final startTime = DateTime.parse(currentAppointment.appointmentStartDateTime);
      final newEndTime = startTime.add(Duration(minutes: durationMinutes));
      
      await (_database!.update(_database!.appointments)
        ..where((a) => a.id.equals(appointmentId)))
        .write(db.AppointmentsCompanion(
          appointmentEndDateTime: Value(newEndTime.toIso8601String().substring(0, 19)),
          updatedAt: Value(DateTime.now().toIso8601String().substring(0, 19)),
        ),);
      
      ErrorLogger.logInfo('Updated appointment duration for $appointmentId to $durationMinutes minutes');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to update appointment duration: $appointmentId', e, stack);
      rethrow;
    }
  }

  /// Check if time slot is available for employee
  Future<bool> isTimeSlotAvailable({
    required String employeeId,
    required DateTime startTime,
    required DateTime endTime,
    String? excludeAppointmentId,
  }) async {
    try {
      await initialize();
      
      final employeeIdInt = int.tryParse(employeeId) ?? 0;
      final startTimeString = startTime.toIso8601String().substring(0, 19);
      final endTimeString = endTime.toIso8601String().substring(0, 19);
      
      // Get all appointments for this employee in the time range
      var query = _database!.select(_database!.appointments)
        ..where((a) => 
          a.employeeId.equals(employeeIdInt) &
          a.appointmentStartDateTime.isBetweenValues(startTimeString, endTimeString) &
          a.status.equals('scheduled').not() & // Exclude cancelled appointments
          a.status.equals('cancelled').not(),
        );
      
      // Exclude specific appointment if provided
      if (excludeAppointmentId != null) {
        query = query..where((a) => a.id.equals(excludeAppointmentId).not());
      }
      
      final conflictingAppointments = await query.get();
      
      return conflictingAppointments.isEmpty;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to check time slot availability', e, stack);
      return false; // Assume not available on error for safety
    }
  }

  /// Detect overlapping appointments for a technician
  Future<List<Appointment>> findOverlappingAppointments(String employeeId, {DateTime? date}) async {
    try {
      await initialize();
      
      final targetDate = date ?? DateTime.now();
      final dateString = targetDate.toIso8601String().split('T')[0];
      
      // Get all appointments for this employee on this date
      final query = _database!.select(_database!.appointments)
        ..where((a) => 
          a.employeeId.equals(int.tryParse(employeeId) ?? 0) &
          a.appointmentStartDateTime.like('$dateString%') &
          a.status.isNotIn(['cancelled', 'noShow']),
        )
        ..orderBy([(a) => OrderingTerm(expression: a.appointmentStartDateTime)]);
      
      final appointments = await query.get();
      final List<Appointment> converted = [];
      
      // Convert to model appointments
      for (var appt in appointments) {
        try {
          converted.add(await _convertToModel(appt));
        } catch (e) {
          ErrorLogger.logError('Error converting appointment ${appt.id}', e, StackTrace.current);
        }
      }
      
      // Find overlapping appointments
      final List<Appointment> overlapping = [];
      for (int i = 0; i < converted.length - 1; i++) {
        final current = converted[i];
        final next = converted[i + 1];
        
        final currentEndTime = current.appointmentDate.add(Duration(minutes: current.durationMinutes));
        
        if (currentEndTime.isAfter(next.appointmentDate)) {
          // Found overlap
          if (!overlapping.contains(current)) overlapping.add(current);
          if (!overlapping.contains(next)) overlapping.add(next);
          
          ErrorLogger.logWarning(
            'Appointment overlap detected: ${current.id} (${current.appointmentDate} - $currentEndTime) '
            'overlaps with ${next.id} (${next.appointmentDate})'
          );
        }
      }
      
      return overlapping;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to find overlapping appointments', e, stack);
      return [];
    }
  }

  /// Get appointment statistics
  Future<Map<String, int>> getAppointmentStats({
    DateTime? date,
    String? employeeId,
  }) async {
    try {
      await initialize();
      
      final targetDate = date ?? DateTime.now();
      final dateString = targetDate.toIso8601String().split('T')[0]; // Get date part only
      
      var query = _database!.select(_database!.appointments)
        ..where((a) => a.appointmentStartDateTime.like('$dateString%'));
      
      // Filter by employee if specified
      if (employeeId != null) {
        final employeeIdInt = int.tryParse(employeeId) ?? 0;
        query = query..where((a) => a.employeeId.equals(employeeIdInt));
      }
      
      final appointments = await query.get();
      
      final stats = <String, int>{
        'total': appointments.length,
        'scheduled': 0,
        'confirmed': 0,
        'arrived': 0,
        'completed': 0,
        'cancelled': 0,
      };
      
      for (final appointment in appointments) {
        final status = appointment.status ?? 'scheduled';
        stats[status] = (stats[status] ?? 0) + 1;
      }
      
      return stats;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get appointment stats', e, stack);
      return <String, int>{};
    }
  }
}
