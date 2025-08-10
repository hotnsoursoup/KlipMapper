// lib/features/shared/data/repositories/drift_ticket_repository.dart
// Drift repository implementation for ticket management with service JSON handling, category mapping, and queue management support.
// Usage: ACTIVE - Primary ticket data access layer with service model conversion and status tracking
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart' as db;
import '../models/ticket_model.dart';
import '../models/customer_model.dart';
import '../models/service_model.dart';
import '../../../../utils/error_logger.dart';

// Helper to get category ID from service JSON - returns int for consistency with domain model
int _getCategoryIdFromJson(Map<String, dynamic> serviceJson) {
  // First try to get category_id directly (new format)
  if (serviceJson['category_id'] != null) {
    // Handle both String and int types safely
    final categoryId = serviceJson['category_id'];
    if (categoryId is int) {
      return categoryId;
    } else if (categoryId is String) {
      return int.tryParse(categoryId) ?? 1;
    }
  }

  // Fallback to old category name mapping for backward compatibility
  final categoryName = serviceJson['category'] ?? 'other';
  switch (categoryName) {
    case 'Nails':
      return 1;
    case 'Gel':
      return 2;
    case 'Acrylic':
      return 3;
    case 'Waxing':
      return 4;
    case 'Facials':
      return 5;
    case 'SNS/Dip':
      return 6;
    default:
      return 1; // Default to Nails
  }
}

/// Drift-based Ticket Repository
/// This replaces the old TicketRepository with type-safe ORM queries
class DriftTicketRepository {
  static DriftTicketRepository? _instance;
  static DriftTicketRepository get instance =>
      _instance ??= DriftTicketRepository._();

  DriftTicketRepository._();

  db.PosDatabase? _database;
  bool _initialized = false;

  // Repository-level caching for converted tickets to avoid re-parsing JSON
  final Map<String, Ticket> _convertedTicketsCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  // De-duplication: Track in-flight requests to prevent duplicate queries
  static final Map<String, Future<List<Ticket>>> _inFlightTicketQueries = {};
  static final Map<String, Future<int>> _inFlightTicketCountQueries = {};

  /// Clear conversion cache for a specific ticket (when ticket is modified)
  void _invalidateTicketCache(String ticketId) {
    _convertedTicketsCache.remove(ticketId);
    _cacheTimestamps.remove(ticketId);
  }

  /// Stream today's active tickets (queued/assigned/in-service)
  Stream<List<Ticket>> watchTicketsForTodayActive() async* {
    await initialize();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final activeStatuses = ['queued', 'assigned', 'in-service'];
    final query = _database!.select(_database!.tickets)
      ..where((t) =>
          t.businessDate.isBiggerOrEqualValue(startOfDay) &
          t.businessDate.isSmallerThanValue(endOfDay) &
          t.status.isIn(activeStatuses))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    yield* query.watch().map((rows) {
      // Lightweight conversion; customer join not required for list panels
      return rows.map(_convertToModel).toList();
    });
  }

  /// Stream today's tickets for a technician (active statuses)
  Stream<List<Ticket>> watchTicketsForTechnicianToday(
    String technicianId,
  ) async* {
    await initialize();
    final techInt = int.tryParse(technicianId) ?? -1;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final activeStatuses = ['queued', 'assigned', 'in-service'];

    final query = _database!.select(_database!.tickets)
      ..where((t) =>
          t.assignedTechnicianId.equals(techInt) &
          t.businessDate.isBiggerOrEqualValue(startOfDay) &
          t.businessDate.isSmallerThanValue(endOfDay) &
          t.status.isIn(activeStatuses))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    yield* query.watch().map((rows) => rows.map(_convertToModel).toList());
  }

  /// Clear all conversion cache (when bulk operations occur)
  void _clearConversionCache() {
    _convertedTicketsCache.clear();
    _cacheTimestamps.clear();
  }

  /// Initialize the repository with the database instance
  Future<void> initialize() async {
    if (_initialized && _database != null) return;

    try {
      // Ensure database is fully initialized
      await db.PosDatabase.ensureInitialized();
      _database = db.PosDatabase.instance;
      _initialized = true;
      ErrorLogger.logInfo('DriftTicketRepository initialized successfully');
    } catch (e, stack) {
      ErrorLogger.logError('DriftTicketRepository initialization', e, stack);
      rethrow;
    }
  }

  /// Convert Drift Ticket to Model Ticket
  Ticket _convertToModel(db.Ticket driftTicket, {db.Customer? customer, List<Service>? normalizedServices}) {
    // Prefer normalized ticket_services rows when available; otherwise fallback to JSON
    final List<Service> services = <Service>[];
    if (normalizedServices != null && normalizedServices.isNotEmpty) {
      services.addAll(normalizedServices);
    } else if (driftTicket.services.isNotEmpty) {
      for (var serviceJson in driftTicket.services) {
        try {
          final categoryId = _getCategoryIdFromJson(serviceJson);
          services.add(Service(
            id: (serviceJson['id'] ?? '').toString(),
            name: serviceJson['name'] ?? 'Unknown Service',
            description: serviceJson['description'] ?? '',
            categoryId: categoryId,
            basePrice: (serviceJson['price'] ?? 0.0).toDouble(),
            durationMinutes: serviceJson['duration'] ?? 30,
            isActive: true,
            createdAt: DateTime.now(),
          ));
        } catch (e, stack) {
          ErrorLogger.logError('Failed to convert service JSON: ${serviceJson.toString()}', e, stack);
          continue;
        }
      }
    }

    // Create customer model (minimal if not provided)
    final customerModel = customer != null
        ? Customer.withName(
            id: customer.id,
            name: '${customer.firstName} ${customer.lastName}'.trim(),
            phone: customer.phone ?? '',
            email: customer.email ?? '',
          )
        : Customer.withName(
            id: driftTicket.customerId ?? 'walk-in',
            name: driftTicket.customerName,
            phone: '',
          );

    return Ticket(
      id: driftTicket.id,
      ticketNumber: '${driftTicket.ticketNumber}',
      customer: customerModel,
      services: services,
      status: _mapTicketStatus(driftTicket),
      type: (driftTicket.checkInTime != null)
          ? 'walk-in'
          : 'appointment',
      checkInTime: driftTicket.checkInTime ?? driftTicket.createdAt,
      assignedTechnicianId: driftTicket.assignedTechnicianId?.toString(),
      totalAmount: ((driftTicket.totalAmountCents ?? 0) / 100.0),
      paymentStatus: driftTicket.paymentStatus,
      isGroupService: driftTicket.isGroupService,
      groupSize: driftTicket.groupSize,
    );
  }

  /// Batch fetch normalized services for a list of tickets. Returns map by ticket_id.
  Future<Map<String, List<Service>>> _fetchNormalizedServicesForTickets(Set<String> ticketIds) async {
    if (ticketIds.isEmpty) return {};
    final placeholders = List.filled(ticketIds.length, '?').join(',');
    final sql = '''
      SELECT ts.ticket_id AS ticket_id,
             s.id AS service_id,
             s.name AS name,
             COALESCE(s.description, '') AS description,
             COALESCE(s.category_id, 1) AS category_id,
             COALESCE(s.duration_minutes, 30) AS duration_minutes,
             ts.unit_price_cents AS unit_price_cents,
             ts.assigned_technician_id AS assigned_technician_id
      FROM ticket_services ts
      JOIN services s ON s.id = ts.service_id
      WHERE ts.ticket_id IN ($placeholders)
      ORDER BY ts.ticket_id;
    ''';
    final result = await _database!.customSelect(sql, variables: ticketIds.map((id) => Variable<String>(id)).toList()).get();
    final Map<String, List<Service>> map = {};
    for (final row in result) {
      final tid = row.data['ticket_id']?.toString() ?? '';
      if (tid.isEmpty) continue;
      final service = Service(
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
      (map[tid] ??= <Service>[]).add(service);
    }
    return map;
  }

  String _mapTicketStatus(db.Ticket ticket) {
    // First check if status field is set
    if (ticket.status != null && ticket.status!.isNotEmpty) {
      return ticket.status!;
    }

    // Fallback: Map payment status and other fields to ticket status
    if (ticket.paymentStatus == 'paid') return 'paid';
    if (ticket.paymentStatus == 'completed') return 'completed';

    // Check if service has started (indicated by check_in_time being set)
    if (ticket.assignedTechnicianId != null) {
      // If payment_status is 'in-progress' or similar, it means service has started
      if (ticket.paymentStatus == 'in-progress' ||
          ticket.paymentStatus == 'processing') {
        return 'in-service';
      }
      // Otherwise it's just assigned but not started
      return 'assigned';
    }

    return 'queued';
  }

  /// Get all tickets with pagination support
  Future<List<Ticket>> getTickets({
    String? status,
    String? type,
    String? date, // Format: 'YYYY-MM-DD' for filtering by business date
    int? limit,
    int? offset,
  }) async {
    // Create a unique key for this query to prevent duplicates
    final queryKey =
        'tickets_${status ?? 'null'}_${type ?? 'null'}_${date ?? 'null'}_${limit ?? 'null'}_${offset ?? 'null'}';

    // Check if this exact query is already in flight
    if (_inFlightTicketQueries.containsKey(queryKey)) {
      ErrorLogger.logInfo('De-duplicating ticket query: $queryKey');
      return await _inFlightTicketQueries[queryKey]!;
    }

    // Start the query and store it in the in-flight map
    final queryFuture = _executeGetTickets(
      status: status,
      type: type,
      date: date,
      limit: limit,
      offset: offset,
    );

    _inFlightTicketQueries[queryKey] = queryFuture;

    try {
      final result = await queryFuture;
      return result;
    } finally {
      // Clean up the in-flight query when done
      _inFlightTicketQueries.remove(queryKey);
    }
  }

  /// Internal method that performs the actual ticket query
  Future<List<Ticket>> _executeGetTickets({
    String? status,
    String? type,
    String? date,
    int? limit,
    int? offset,
  }) async {
    try {
      await initialize();

      var query = _database!.select(_database!.tickets);

      // Apply filters if provided
      if (status != null) {
        // Map status to database fields
        if (status == 'paid') {
          query = query..where((t) => t.paymentStatus.equals('paid'));
        } else if (status == 'completed') {
          query = query..where((t) => t.paymentStatus.equals('completed'));
        } else if (status == 'in-service') {
          query = query..where((t) => t.status.equals('in-service'));
        } else if (status == 'assigned') {
          query = query..where((t) => t.status.equals('assigned'));
        } else if (status == 'queued') {
          query = query..where((t) => t.status.equals('queued'));
        } else {
          // Default case: filter by the exact status value
          query = query..where((t) => t.status.equals(status));
        }
      }

      // Apply date filter if provided
      if (date != null) {
        query = query..where((t) => t.businessDate.equals(date));
      }

      // Order by created_at descending
      query = query
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);

      // Apply pagination if specified
      if (limit != null) {
        query = query..limit(limit, offset: offset ?? 0);
      }

      final tickets = await query.get();

      // Batch fetch normalized line items (if any)
      final ticketIdSet = tickets.map((t) => t.id).toSet();
      final normalizedMap = await _fetchNormalizedServicesForTickets(ticketIdSet);

      // Batch fetch all customers to avoid N+1 queries
      final customerIds = tickets
          .where((t) => t.customerId != null)
          .map((t) => t.customerId!)
          .toSet();

      final Map<String, db.Customer> customerMap = {};
      if (customerIds.isNotEmpty) {
        final customers = await (_database!.select(
          _database!.customers,
        )..where((c) => c.id.isIn(customerIds.toList()))).get();

        for (var customer in customers) {
          customerMap[customer.id] = customer;
        }
      }

      // Convert to model with batched customer data (with caching)
      final List<Ticket> result = [];
      for (var ticket in tickets) {
        final customer = ticket.customerId != null
            ? customerMap[ticket.customerId!]
            : null;

        // Check cache for already converted ticket
        final ticketId = ticket.id;
        if (_convertedTicketsCache.containsKey(ticketId)) {
          final timestamp = _cacheTimestamps[ticketId]!;
          if (DateTime.now().difference(timestamp) < _cacheExpiry) {
            // Use cached converted ticket (skips expensive JSON parsing)
            result.add(_convertedTicketsCache[ticketId]!);
            continue;
          } else {
            // Remove expired cache entry
            _convertedTicketsCache.remove(ticketId);
            _cacheTimestamps.remove(ticketId);
          }
        }

        // Convert and cache the result
        final convertedTicket = _convertToModel(
          ticket,
          customer: customer,
          normalizedServices: normalizedMap[ticket.id],
        );
        _convertedTicketsCache[ticketId] = convertedTicket;
        _cacheTimestamps[ticketId] = DateTime.now();
        result.add(convertedTicket);
      }

      return result;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch tickets', e, stack);
      throw Exception('Failed to fetch tickets: $e');
    }
  }

  /// Get total count of tickets (for pagination)
  Future<int> getTicketsCount({
    String? status,
    String? type,
    String? date,
  }) async {
    try {
      await initialize();

      var query = _database!.selectOnly(_database!.tickets)
        ..addColumns([_database!.tickets.id.count()]);

      // Apply same filters as getTickets method
      if (status != null) {
        if (status == 'paid') {
          query = query..where(_database!.tickets.paymentStatus.equals('paid'));
        } else if (status == 'completed') {
          query = query
            ..where(_database!.tickets.paymentStatus.equals('completed'));
        } else if (status == 'in-service') {
          query = query
            ..where(_database!.tickets.assignedTechnicianId.isNotNull());
        } else if (status == 'queued') {
          query = query
            ..where(
              _database!.tickets.assignedTechnicianId.isNull() &
                  (_database!.tickets.paymentStatus.isNull() |
                      _database!.tickets.paymentStatus.equals('pending')),
            );
        }
      }

      // Apply date filter if provided
      if (date != null) {
        query = query..where(_database!.tickets.businessDate.equals(date));
      }

      final result = await query.getSingle();
      return result.read(_database!.tickets.id.count()) ?? 0;
    } catch (e, stack) {
      ErrorLogger.logError('Failed to get tickets count', e, stack);
      return 0;
    }
  }

  /// Get tickets by status
  Future<List<Ticket>> getTicketsByStatus(String status) async {
    return getTickets(status: status);
  }

  /// Get in-service tickets (tickets being actively worked on)
  Future<List<Ticket>> getInServiceTickets() async {
    try {
      await initialize();

      // Get tickets with payment_status 'in-progress' or 'processing'
      final tickets =
          await (_database!.select(_database!.tickets)
                ..where(
                  (t) =>
                      t.paymentStatus.equals('in-progress') |
                      t.paymentStatus.equals('processing'),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
              .get();

      final List<Ticket> result = [];
      for (var ticket in tickets) {
        result.add(_convertToModel(ticket));
      }

      return result;
    } catch (e) {
      throw Exception('Failed to fetch in-service tickets: $e');
    }
  }

  /// Get tickets assigned to a technician
  Future<List<Ticket>> getTicketsByTechnician(String technicianId) async {
    try {
      await initialize();

      final tickets =
          await (_database!.select(_database!.tickets)
                ..where(
                  (t) =>
                      t.assignedTechnicianId.equals(
                        int.tryParse(technicianId) ?? -1,
                      ) &
                      (t.paymentStatus.isNull() |
                          t.paymentStatus.equals('pending') |
                          t.paymentStatus.equals('in-progress') |
                          t.paymentStatus.equals('processing') |
                          t.paymentStatus.equals('completed')),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
              .get();

      // Optionally hydrate services if needed in this view in future
      return tickets.map((t) => _convertToModel(t)).toList();
    } catch (e) {
      throw Exception('Failed to fetch technician tickets: $e');
    }
  }

  /// Get ticket by ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      await initialize();

      final ticket = await (_database!.select(
        _database!.tickets,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (ticket == null) return null;

      // Try normalized services first
      final normalizedMap = await _fetchNormalizedServicesForTickets({ticket.id});

      // Fetch customer if available
      db.Customer? customer;
      if (ticket.customerId != null) {
        customer = await (_database!.select(
          _database!.customers,
        )..where((c) => c.id.equals(ticket.customerId!))).getSingleOrNull();
      }

      return _convertToModel(ticket, customer: customer, normalizedServices: normalizedMap[ticket.id]);
    } catch (e) {
      throw Exception('Failed to fetch ticket by ID: $e');
    }
  }

  /// Get tickets by customer ID
  Future<List<Ticket>> getTicketsByCustomerId(String customerId) async {
    try {
      await initialize();
      final tickets =
          await (_database!.select(_database!.tickets)
                ..where((t) => t.customerId.equals(customerId))
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.checkInTime,
                    mode: OrderingMode.desc,
                  ),
                ]))
              .get();

      // Fetch customer once since all tickets are for the same customer
      db.Customer? customer;
      if (tickets.isNotEmpty && tickets.first.customerId != null) {
        customer = await (_database!.select(
          _database!.customers,
        )..where((c) => c.id.equals(customerId))).getSingleOrNull();
      }

      final ticketModels = <Ticket>[];
      for (final ticket in tickets) {
        final model = _convertToModel(ticket, customer: customer);
        ticketModels.add(model);
      }

      return ticketModels;
    } catch (e, stack) {
      ErrorLogger.logError('Error getting tickets by customer ID', e, stack);
      return [];
    }
  }

  /// Generate next ticket number for today (daily reset)
  Future<int> _generateNextTicketNumber() async {
    try {
      await initialize();

      // Get today's date in business date format
      final today = DateTime.now();
      final businessDate =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Get the highest ticket number for today only
      final query = _database!.selectOnly(_database!.tickets)
        ..addColumns([_database!.tickets.ticketNumber.max()])
        ..where(_database!.tickets.businessDate.equals(businessDate));

      final result = await query.getSingleOrNull();
      final maxTicketNumber =
          result?.read(_database!.tickets.ticketNumber.max()) ?? 0;

      return maxTicketNumber + 1;
    } catch (e) {
      // If there's an error getting max, start from 1
      return 1;
    }
  }

  /// Insert new ticket
  Future<String> insertTicket(Ticket ticket) async {
    try {
      await initialize();

      // Generate unique ticket ID if the provided ID already exists
      String uniqueTicketId = ticket.id;
      final existingTicket = await (_database!.select(
        _database!.tickets,
      )..where((t) => t.id.equals(ticket.id))).getSingleOrNull();

      if (existingTicket != null) {
        // Generate new unique ID based on timestamp
        uniqueTicketId = 'T${DateTime.now().millisecondsSinceEpoch}';
        ErrorLogger.logInfo(
          'Ticket ID ${ticket.id} already exists, generating new ID: $uniqueTicketId',
        );
      }

      // Generate ticket number if empty or invalid
      int ticketNumber;
      if (ticket.ticketNumber.isEmpty) {
        ticketNumber = await _generateNextTicketNumber();
      } else {
        // Try to parse existing ticket number (now just a plain number)
        final parsed = int.tryParse(ticket.ticketNumber);
        if (parsed == null) {
          ticketNumber = await _generateNextTicketNumber();
        } else {
          ticketNumber = parsed;
        }
      }

      // Convert services to JSON (match database format)
      final servicesJson = ticket.services
          .map(
            (s) => {
              'id':
                  int.tryParse(s.id) ?? s.id, // Handle both string and int IDs
              'name': s.name,
              'category_id': s.categoryId,
              'price': s.price,
              'duration': s.durationMinutes,
            },
          )
          .toList();

      ErrorLogger.logInfo(
        'insertTicket - assignedTechnicianId from ticket: ${ticket.assignedTechnicianId}',
      );
      final assignedTechId = ticket.assignedTechnicianId != null
          ? int.tryParse(ticket.assignedTechnicianId!)
          : null;
      ErrorLogger.logInfo(
        'insertTicket - parsed assignedTechnicianId for DB: $assignedTechId',
      );

      await _database!
          .into(_database!.tickets)
          .insert(
            db.TicketsCompanion(
              id: Value(uniqueTicketId),
              customerId: Value(ticket.customer.id),
              employeeId: Value(
                int.tryParse(ticket.assignedTechnicianId ?? '1') ?? 1,
              ),
              ticketNumber: Value(ticketNumber),
              customerName: Value(ticket.customer.name),
              services: Value(servicesJson),
              priority: const Value(1),
              notes: const Value(null),
              status: Value(
                ticket.status.isEmpty ? 'queued' : ticket.status,
              ), // Set initial status
              createdAt: Value(DateTime.now().toIso8601String()),
              updatedAt: Value(DateTime.now().toIso8601String()),
              businessDate: Value(
                DateTime.now().toIso8601String().split('T')[0],
              ),
              checkInTime: Value(ticket.checkInTime.toIso8601String()),
              assignedTechnicianId: Value(assignedTechId),
              totalAmount: Value(ticket.totalAmount),
              paymentStatus: Value(ticket.paymentStatus ?? 'pending'),
              isGroupService: Value(ticket.isGroupService ? 1 : 0),
              groupSize: Value(ticket.groupSize),
            ),
          );
      // Also mirror services into normalized ticket_services for new tickets
      try {
        int totalCents = 0;
        for (final s in ticket.services) {
          final serviceIdInt = int.tryParse(s.id) ?? 0;
          final unitCents = ((s.basePrice) * 100).round();
          final total = unitCents; // quantity=1 in legacy flow
          totalCents += total;
          const sql = 'INSERT INTO ticket_services (id, ticket_id, service_id, quantity, unit_price_cents, total_price_cents, status, assigned_technician_id, created_at) VALUES (lower(hex(randomblob(16))), ?, ?, 1, ?, ?, \"pending\", ?, datetime(\'now\'))';
          await _database!.customStatement(sql, [uniqueTicketId, serviceIdInt, unitCents, total, assignedTechId]);
        }
        // Update ticket total from normalized rows if any were inserted
        await (_database!.update(_database!.tickets)
          ..where((t) => t.id.equals(uniqueTicketId)))
            .write(db.TicketsCompanion(
              totalAmount: Value(totalCents / 100.0),
              updatedAt: Value(DateTime.now().toIso8601String()),
            ));
      } catch (e, stack) {
        ErrorLogger.logError('Failed to mirror services into ticket_services for $uniqueTicketId', e, stack);
      }

      return uniqueTicketId;
    } catch (e) {
      throw Exception('Failed to insert ticket: $e');
    }
  }

  /// Update existing ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await initialize();

      // Convert services to JSON (match database format)
      final servicesJson = ticket.services
          .map(
            (s) => {
              'id':
                  int.tryParse(s.id) ?? s.id, // Handle both string and int IDs
              'name': s.name,
              'category_id': s.categoryId,
              'price': s.price,
              'duration': s.durationMinutes,
            },
          )
          .toList();

      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticket.id))).write(
        db.TicketsCompanion(
          assignedTechnicianId: Value(
            ticket.assignedTechnicianId != null
                ? int.tryParse(ticket.assignedTechnicianId!)
                : null,
          ),
          paymentStatus: Value(ticket.paymentStatus),
          totalAmount: Value(ticket.totalAmount),
          services: Value(servicesJson),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      // Mirror updated services into normalized ticket_services: replace rows
      try {
        await _database!.customStatement('DELETE FROM ticket_services WHERE ticket_id = ?', [ticket.id]);
        int totalCents = 0;
        for (final s in ticket.services) {
          final serviceIdInt = int.tryParse(s.id) ?? 0;
          final unitCents = (s.basePrice * 100).round();
          final total = unitCents; // quantity=1
          totalCents += total;
          await _database!.customStatement(
            'INSERT INTO ticket_services (id, ticket_id, service_id, quantity, unit_price_cents, total_price_cents, status, assigned_technician_id, created_at) VALUES (lower(hex(randomblob(16))), ?, ?, 1, ?, ?, \"pending\", ?, datetime(\'now\'))',
            [ticket.id, serviceIdInt, unitCents, total, int.tryParse(ticket.assignedTechnicianId ?? '')],
          );
        }
        await (_database!.update(_database!.tickets)
          ..where((t) => t.id.equals(ticket.id)))
            .write(db.TicketsCompanion(
              totalAmount: Value(totalCents / 100.0),
              updatedAt: Value(DateTime.now().toIso8601String()),
            ));
      } catch (e, stack) {
        ErrorLogger.logError('Failed to mirror updated services into ticket_services for ${ticket.id}', e, stack);
      }

      // Invalidate cache for the updated ticket
      _invalidateTicketCache(ticket.id);
    } catch (e) {
      throw Exception('Failed to update ticket: $e');
    }
  }

  /// Assign technician to ticket
  Future<void> assignTechnician(String ticketId, String technicianId) async {
    try {
      await initialize();

      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).write(
        db.TicketsCompanion(
          assignedTechnicianId: Value(int.tryParse(technicianId)),
          status: const Value('assigned'), // Update status to 'assigned'
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    } catch (e) {
      throw Exception('Failed to assign technician: $e');
    }
  }

  /// Start service on a ticket (moves from assigned to in-service)
  Future<void> startService(String ticketId) async {
    try {
      await initialize();

      // Update status to 'in-service' and payment_status to 'in-progress'
      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).write(
        db.TicketsCompanion(
          status: const Value('in-service'), // Update status
          paymentStatus: const Value('in-progress'),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    } catch (e) {
      throw Exception('Failed to start service: $e');
    }
  }

  /// Complete service on a ticket (moves from in-service to completed)
  Future<void> completeService(String ticketId) async {
    try {
      await initialize();

      // Update status to 'completed' and payment_status to 'completed'
      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).write(
        db.TicketsCompanion(
          status: const Value('completed'), // Update status
          paymentStatus: const Value('completed'),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    } catch (e) {
      throw Exception('Failed to complete service: $e');
    }
  }

  /// Process payment for a ticket (moves from completed to paid)
  Future<void> processPayment(String ticketId, double amount) async {
    try {
      await initialize();

      // Update payment_status to 'paid' and set total amount
      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).write(
        db.TicketsCompanion(
          paymentStatus: const Value('paid'),
          totalAmount: Value(amount),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  /// Void a ticket (requires manager authorization)
  Future<void> voidTicket(String ticketId, String reason) async {
    try {
      await initialize();

      // Update status to 'voided' and set notes with reason
      await (_database!.update(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).write(
        db.TicketsCompanion(
          status: const Value('voided'),
          notes: Value(reason.isNotEmpty ? 'VOIDED: $reason' : 'VOIDED'),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );

      // Clear cache for updated ticket
      _invalidateTicketCache(ticketId);

      ErrorLogger.logInfo('Ticket $ticketId voided with reason: $reason');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to void ticket $ticketId', e, stack);
      throw Exception('Failed to void ticket: $e');
    }
  }

  /// Delete a ticket permanently (requires manager authorization)
  Future<void> deleteTicket(String ticketId) async {
    try {
      await initialize();

      // Permanently delete the ticket from database
      await (_database!.delete(
        _database!.tickets,
      )..where((t) => t.id.equals(ticketId))).go();

      // Clear cache for deleted ticket
      _invalidateTicketCache(ticketId);

      ErrorLogger.logInfo('Ticket $ticketId permanently deleted');
    } catch (e, stack) {
      ErrorLogger.logError('Failed to delete ticket $ticketId', e, stack);
      throw Exception('Failed to delete ticket: $e');
    }
  }

  /// Get queue tickets (queued or assigned, not in-service/completed/paid)
  Future<List<Ticket>> getQueueTickets() async {
    try {
      await initialize();

      final today = DateTime.now().toIso8601String().split(
        'T',
      )[0]; // '2025-08-04'

      // Get only today's tickets that are in queue, assigned, or in-service status
      final tickets =
          await (_database!.select(_database!.tickets)
                ..where(
                  (t) =>
                      t.businessDate.equals(today) &
                      (t.status.equals('queued') |
                          t.status.equals('assigned') |
                          t.status.equals('in-service')),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
              .get();

      final List<Ticket> result = [];
      for (var ticket in tickets) {
        final status = _mapTicketStatus(ticket);
        // Only include queued and assigned tickets in the queue
        if (status == 'queued' || status == 'assigned') {
          result.add(_convertToModel(ticket));
        }
      }

      return result;
    } catch (e) {
      throw Exception('Failed to fetch queue tickets: $e');
    }
  }

  /// Get today's active tickets (queued, assigned, and in-service) for technician status calculation
  Future<List<Ticket>> getTodaysActiveTickets() async {
    try {
      await initialize();

      final today = DateTime.now().toIso8601String().split(
        'T',
      )[0]; // '2025-08-04'

      // Get only today's active tickets
      final query = _database!.select(_database!.tickets)
        ..where(
          (t) =>
              t.businessDate.equals(today) &
              (t.status.equals('queued') |
                  t.status.equals('assigned') |
                  t.status.equals('in-service')),
        )
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);

      final tickets = await query.get();

      // Batch fetch all customers to avoid N+1 queries
      final customerIds = tickets
          .where((t) => t.customerId != null)
          .map((t) => t.customerId!)
          .toSet();

      final Map<String, db.Customer> customerMap = {};
      if (customerIds.isNotEmpty) {
        final customers = await (_database!.select(
          _database!.customers,
        )..where((c) => c.id.isIn(customerIds.toList()))).get();

        for (var customer in customers) {
          customerMap[customer.id] = customer;
        }
      }

      // Convert to model with batched customer data
      final List<Ticket> result = [];
      for (var ticket in tickets) {
        final customer = ticket.customerId != null
            ? customerMap[ticket.customerId!]
            : null;

        final convertedTicket = _convertToModel(ticket, customer: customer);
        result.add(convertedTicket);
      }

      // Sort by check-in time
      result.sort((a, b) => a.checkInTime.compareTo(b.checkInTime));

      return result;
    } catch (e, stack) {
      ErrorLogger.logError('getTodaysActiveTickets', e, stack);
      return [];
    }
  }

  /// Get upcoming appointments from appointments table
  /// NOTE: This method should be deprecated - appointments should be handled by AppointmentsRepository
  /// This is kept temporarily for backward compatibility but should be refactored
  Future<List<Ticket>> getUpcomingAppointments() async {
    try {
      await initialize();

      ErrorLogger.logWarning(
        'getUpcomingAppointments called on TicketRepository - this should use AppointmentsRepository instead',
      );

      // Return empty list to avoid architectural issues
      // Appointments should be handled by the proper AppointmentsRepository
      return [];
    } catch (e, stack) {
      ErrorLogger.logError('Failed to fetch appointments', e, stack);
      return [];
    }
  }

  /// Search tickets by customer
  Future<List<Ticket>> searchTicketsByCustomer(String searchTerm) async {
    try {
      await initialize();

      final term = '%$searchTerm%';
      final tickets = await (_database!.select(
        _database!.tickets,
      )..where((t) => t.customerName.like(term))).get();

      return tickets.map((t) => _convertToModel(t)).toList();
    } catch (e) {
      throw Exception('Failed to search tickets: $e');
    }
  }

  /// Get ticket count by status
  Future<Map<String, int>> getTicketCountByStatus() async {
    try {
      await initialize();

      // Get all tickets
      final allTickets = await _database!.select(_database!.tickets).get();

      final Map<String, int> counts = {
        'queued': 0,
        'in-service': 0,
        'completed': 0,
        'paid': 0,
      };

      for (var ticket in allTickets) {
        final status = _mapTicketStatus(ticket);
        counts[status] = (counts[status] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get ticket counts: $e');
    }
  }

  /// Stream of queue tickets (for reactive UI)
  Stream<List<Ticket>> watchQueueTickets() {
    initialize();

    return (_database!.select(_database!.tickets)
          ..where(
            (t) =>
                t.paymentStatus.isNull() |
                t.paymentStatus.equals('pending') |
                t.paymentStatus.equals(''),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch()
        .map((tickets) => tickets.map((t) => _convertToModel(t)).toList());
  }

  /// Stream of upcoming appointments (for reactive UI)
  Stream<List<Ticket>> watchUpcomingAppointments() {
    // For now, return empty stream as this requires joining with appointments table
    return Stream.value([]);
  }

  /// Close database connection
  Future<void> close() async {
    // Don't close the shared database instance
  }
}
