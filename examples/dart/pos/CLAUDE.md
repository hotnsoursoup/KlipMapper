# CLAUDE.md - Flutter POS Development Guide

*Last updated: January 2025*

## Primary Development Approach

### 🎯 Core Principle: docs.flutter.dev First
When implementing any Flutter feature, pattern, or solving issues:
1. **ALWAYS** check https://docs.flutter.dev/ for the current best practices
2. **NEVER** assume patterns from memory - Flutter evolves rapidly
3. **VERIFY** widget parameters, APIs, and patterns against official docs

### 🚀 State Management: Riverpod 3.0+
We are migrating from MobX to Riverpod for state management. See `/docs/RIVERPOD_UI_BIBLE.md` for comprehensive guidelines.

#### Key Patterns:
- **AsyncValueWidget**: Use `/lib/core/widgets/async_value_widget.dart` for consistent async state handling
- **Providers**: All providers use `riverpod_generator` with `@riverpod` annotation
- **Architecture**: UI → Providers (Notifiers) → Repositories → Database (Drift)

### Running App Debug Session
```bash
# Start app in debug mode (Windows desktop - preferred)
flutter run -d windows --debug


## Project Structure

```
/mnt/d/ClaudeProjects/POSflutter/
├── /pos/                           # Flutter POS application (active development)
│   ├── lib/
│   │   ├── app/                    # Application layer
│   │   │   ├── router/             # go_router configuration
│   │   │   ├── screens/            # App-level screens (startup)
│   │   │   └── widgets/            # App shell and navigation
│   │   ├── core/                   # Core infrastructure
│   │   │   ├── api/                # HTTP client services
│   │   │   ├── auth/               # PIN authentication system
│   │   │   │   └── widgets/        # PIN dialogs and wrappers
│   │   │   ├── config/             # Configuration constants
│   │   │   ├── constants/          # App colors, text styles, API constants
│   │   │   ├── database/           # Drift database and seeds
│   │   │   ├── services/           # Core services (settings, auth, time, cache)
│   │   │   ├── theme/              # App theming (colors, text styles, theme)
│   │   │   ├── utils/              # Utilities (formatters, validators, loggers)
│   │   │   └── widgets/            # Reusable core widgets (AsyncValueWidget, skeletons)
│   │   ├── features/               # Feature-based architecture
│   │   │   ├── appointments/       # Appointment scheduling system
│   │   │   │   ├── data/           # Models, repositories, services
│   │   │   │   ├── presentation/   # Screens, widgets (calendar, booking, timeline)
│   │   │   │   └── providers/      # Riverpod providers (pagination, master, efficient)
│   │   │   ├── checkout/           # Payment processing system
│   │   │   │   ├── data/           # Models (calculation, state, discount, payment)
│   │   │   │   └── presentation/   # Screens, dialogs (checkout, discount selector)
│   │   │   ├── customers/          # Customer management
│   │   │   │   ├── presentation/   # Screens, widgets (details, list, new customer)
│   │   │   │   └── providers/      # Riverpod providers (master, details)
│   │   │   ├── dashboard/          # Main POS dashboard
│   │   │   │   ├── examples/       # Architecture examples (Riverpod+MobX)
│   │   │   │   ├── presentation/   # Main dashboard screen and components
│   │   │   │   │   ├── screens/    # Dashboard screen implementations
│   │   │   │   │   └── widgets/    # Queue cards, technician cards, dialogs
│   │   │   │   │       ├── sections/        # Dashboard sections (queue, schedule, status)
│   │   │   │   │       └── ticket_details/  # Ticket management components
│   │   │   │   └── providers/      # Dashboard state management
│   │   │   ├── employees/          # Staff management
│   │   │   │   ├── data/           # Models (capabilities)
│   │   │   │   ├── presentation/   # Screens, widgets (grid, list, dialogs, PIN setup)
│   │   │   │   └── providers/      # Employee providers
│   │   │   ├── reports/            # Business analytics
│   │   │   │   ├── data/           # Models (report data, extensions)
│   │   │   │   └── presentation/   # Screens, widgets (cards, details, time selector)
│   │   │   ├── services/           # Service management
│   │   │   │   ├── data/           # Models (category wrapper)
│   │   │   │   ├── presentation/   # Screens, widgets (forms, category sections, pickers)
│   │   │   │   └── providers/      # Service providers
│   │   │   ├── settings/           # App configuration
│   │   │   │   ├── data/           # Models (background options)
│   │   │   │   ├── presentation/   # Screens, widgets (background selector, remote view)
│   │   │   │   └── providers/      # Settings providers
│   │   │   ├── shared/             # Shared components across features
│   │   │   │   ├── data/           # Shared models, repositories, converters
│   │   │   │   │   ├── models/     # Core business models (Customer, Service, etc.)
│   │   │   │   │   └── repositories/ # Drift repositories for data access
│   │   │   │   ├── domain/         # Domain layer (models, converters, repositories)
│   │   │   │   ├── presentation/   # Shared UI components
│   │   │   │   │   └── widgets/    # Reusable widgets (pills, icons, dialogs)
│   │   │   │   └── providers/      # Master providers (appointments, tickets)
│   │   │   └── tickets/            # Ticket queue management
│   │   │       ├── presentation/   # Screens, widgets (filters, list items, dialogs)
│   │   │       └── providers/      # Ticket providers (efficient, details)
│   │   ├── utils/                  # App-level utilities
│   │   │   ├── app_logger.dart     # Professional logging with file output
│   │   │   ├── error_logger.dart   # Enhanced error logging
│   │   │   └── debug_logger.dart   # Debug utilities (ORPHANED)
│   │   ├── main.dart               # Application entry point
│   │   └── debug_*.dart            # Debug utilities (ORPHANED)
│   ├── test/                       # Test files
│   ├── docs/                       # Project documentation
│   │   ├── RIVERPOD_UI_BIBLE.md         # Comprehensive Riverpod guidelines
│   │   └── MOBX_TO_RIVERPOD_MIGRATION.md # Migration guide from MobX
│   ├── file_annotations_tracking.md     # Complete file documentation status
│   └── pubspec.yaml
└── /migrations/                    # Database migrations
```

## UI Structure Rule of Thumb
- Put navigation-level widgets in `screens/`.
- Put positioning/rendering logic in `layout/` or `rendering/` so it can be reused across screens (timeline, grid, week view).

## 📋 File Documentation System

**Every Dart file in the project now includes comprehensive documentation headers:**

### Standard Annotation Format:
```dart
// lib/path/to/filename.dart
// [2-3 sentences describing what the file does and how it works]
// Usage: [ACTIVE/ORPHANED] - [brief note about current usage status]
```

### Documentation Coverage:
- **100% Coverage**: All 231 Dart files are documented
- **226 files** use the standardized `// lib/` annotation format
- **227+ files** use professional Dart `///` documentation format
- **7 orphaned files** identified for potential cleanup

### Quick Reference:
- **ACTIVE** files are currently used in the application
- **ORPHANED** files are unused/incomplete implementations
- Check `file_annotations_tracking.md` for complete documentation status
- File headers provide immediate understanding of purpose and usage


- When conflicts arise, use `show`/`hide` directives:
```dart
// When you need specific types from drift_database
import '../../../core/database/drift_database.dart' show ServiceCategory, PosDatabase;
import '../../shared/data/repositories/drift_service_repository.dart' hide ServiceCategory;
```

### Current Database Schema (v7)

#### Customers Table
- **id**: TEXT (Primary Key)
- **firstName**: TEXT (first_name)
- **lastName**: TEXT (last_name)
- **email**: TEXT (nullable)
- **phone**: TEXT (nullable)
- **dateOfBirth**: TEXT (date_of_birth, nullable)
- **gender**: TEXT (nullable)
- **address**: TEXT (nullable)
- **city**: TEXT (nullable)
- **state**: TEXT (nullable)
- **zipCode**: TEXT (zip_code, nullable)
- **loyaltyPoints**: INTEGER (loyalty_points, nullable)
- **lastVisit**: TEXT (last_visit, nullable)
- **preferredTechnician**: TEXT (preferred_technician, nullable)
- **notes**: TEXT (nullable)
- **allergies**: TEXT (nullable)
- **emailOptIn**: INTEGER (email_opt_in, nullable, 0/1)
- **smsOptIn**: INTEGER (sms_opt_in, nullable, 0/1)
- **status**: TEXT (nullable)
- **isActive**: INTEGER (is_active, nullable, 0/1)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)

#### Employees Table
- **id**: INTEGER (Primary Key, autoIncrement)
- **firstName**: TEXT (first_name)
- **lastName**: TEXT (last_name)
- **email**: TEXT (nullable)
- **phone**: TEXT (nullable)
- **socialSecurityNumber**: TEXT (social_security_number, nullable, encrypted)
- **role**: TEXT
- **commissionRate**: REAL (commission_rate, nullable)
- **hourlyRate**: REAL (hourly_rate, nullable)
- **hireDate**: TEXT (hire_date, ISO8601)
- **isActive**: INTEGER (is_active, nullable, 0/1)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)

#### Services Table
- **id**: INTEGER (Primary Key, autoIncrement)
- **name**: TEXT
- **description**: TEXT (nullable) - Note: Not used in Service model
- **categoryId**: INTEGER (category_id, nullable)
- **durationMinutes**: INTEGER (duration_minutes)
- **basePrice**: REAL (base_price)
- **isActive**: INTEGER (is_active, nullable, 0/1)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)

#### ServiceCategories Table
- **id**: TEXT (nullable, Primary Key)
- **name**: TEXT
- **color**: TEXT (nullable, hex color like '#4A90E2')

#### Tickets Table
- **id**: TEXT (Primary Key)
- **customerId**: TEXT (customer_id, nullable)
- **employeeId**: INTEGER (employee_id)
- **ticketNumber**: INTEGER (ticket_number)
- **customerName**: TEXT (customer_name)
- **services**: TEXT (JSON array, uses ServicesJsonConverter)
- **priority**: INTEGER (nullable)
- **notes**: TEXT (nullable)
- **status**: TEXT (nullable, default 'queued', values: queued/assigned/in-service/completed/paid)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)
- **businessDate**: TEXT (business_date, ISO8601)
- **checkInTime**: TEXT (check_in_time, nullable)
- **assignedTechnicianId**: TEXT (assigned_technician_id, nullable)
- **totalAmount**: REAL (total_amount, nullable)
- **paymentStatus**: TEXT (payment_status, nullable)
- **isGroupService**: INTEGER (is_group_service, nullable, 0/1)
- **groupSize**: INTEGER (group_size, nullable)

#### Appointments Table
- **id**: TEXT (Primary Key)
- **customerId**: TEXT (customer_id)
- **employeeId**: INTEGER (employee_id)
- **appointmentStartDateTime**: TEXT (start_datetime, ISO8601)
- **appointmentEndDateTime**: TEXT (end_datetime, ISO8601)
- **services**: TEXT (JSON array, uses ServicesJsonConverter)
- **status**: TEXT (nullable)
- **notes**: TEXT (nullable)
- **isGroupBooking**: INTEGER (is_group_booking, nullable, 0/1)
- **groupSize**: INTEGER (group_size, nullable)
- **createdAt**: TEXT (created_at, ISO8601)
- **updatedAt**: TEXT (updated_at, ISO8601)
- **lastModifiedBy**: TEXT (last_modified_by, nullable)
- **lastModifiedDevice**: TEXT (last_modified_device, nullable)

#### Payments Table
- **id**: TEXT (Primary Key)
- **ticketId**: TEXT (ticket_id)
- **paymentMethod**: TEXT (payment_method)
- **amount**: REAL
- **tipAmount**: REAL (tip_amount, nullable)
- **taxAmount**: REAL (tax_amount, nullable)
- **discountAmount**: REAL (discount_amount, nullable)
- **totalAmount**: REAL (total_amount, nullable)
- **discountType**: TEXT (discount_type, nullable)
- **discountCode**: TEXT (discount_code, nullable)
- **discountReason**: TEXT (discount_reason, nullable)
- **cardType**: TEXT (card_type, nullable)
- **lastFourDigits**: TEXT (last_four_digits, nullable)
- **transactionId**: TEXT (transaction_id, nullable)
- **authorizationCode**: TEXT (authorization_code, nullable)
- **processedAt**: TEXT (processed_at, nullable, ISO8601)
- **processedBy**: TEXT (processed_by, nullable)
- **notes**: TEXT (nullable)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)

#### Settings Table
- **key**: TEXT (Primary Key)
- **value**: TEXT (serialized as string/JSON)
- **category**: TEXT (nullable, values: dashboard/store/general/salon)
- **dataType**: TEXT (data_type, nullable, values: string/boolean/integer/double/json)
- **description**: TEXT (nullable, human-readable)
- **isSystem**: INTEGER (is_system, nullable, 0/1)
- **createdAt**: TEXT (created_at, nullable, ISO8601)
- **updatedAt**: TEXT (updated_at, nullable, ISO8601)

##### Default Settings:
**Dashboard Settings:**
- `dashboard_show_customer_phone`: boolean (true) - Display customer phone on tickets
- `dashboard_enable_checkout_notifications`: boolean (true) - Show checkout notifications
- `dashboard_font_size`: string ('medium') - Font size for dashboard
- `dashboard_technician_layout`: string ('grid2') - Technician cards layout

**Store Settings:**
- `store_hours_configuration`: JSON - Store hours for each day
  ```json
  {
    "hours": {
      "monday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "tuesday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "wednesday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "thursday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "friday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "saturday": {"isOpen": true, "openTime": 540, "closeTime": 1080},
      "sunday": {"isOpen": false}
    }
  }
  ```
  Note: Times are stored as minutes since midnight (540 = 9:00 AM, 1080 = 6:00 PM)
- `store_online_booking`: boolean (false) - Allow online bookings
- `store_location`: string ('Main Location') - Current store location
- `store_timezone`: string ('America/New_York') - Store timezone
- `store_appointment_buffer`: integer (15) - Minutes between appointments
- `store_walk_ins_enabled`: boolean (true) - Accept walk-in customers
- `store_max_daily_appointments`: integer (50) - Max appointments per day

**General Settings:**
- `general_theme`: string ('light') - App theme
- `general_sound_effects`: boolean (true) - Enable sounds
- `general_animations`: boolean (true) - Enable animations
- `general_language`: string ('en') - App language
- `general_currency`: string ('USD') - Currency
- `general_date_format`: string ('MM/dd/yyyy') - Date format
- `general_time_format`: string ('12h') - Time format

**Salon Settings:**
- `salon_service_duration_buffer`: integer (5) - Extra minutes per service
- `salon_require_technician_specialization`: boolean (false) - Restrict services by specialization
- `salon_auto_checkout_completed`: boolean (false) - Auto-checkout completed services
- `salon_loyalty_points_enabled`: boolean (true) - Enable loyalty points
- `salon_loyalty_points_ratio`: double (1.0) - Points per dollar
- `salon_require_appointment_confirmation`: boolean (true) - Require confirmations
- `salon_reminder_hours_before`: integer (24) - Hours before reminder
- `salon_group_booking_enabled`: boolean (true) - Allow group bookings
- `salon_max_group_size`: integer (8) - Max group size
- `salon_price_display_mode`: string ('individual') - Price display mode

#### EmployeeServiceCategories Table
- **id**: TEXT (nullable, Primary Key)
- **employeeId**: INTEGER (employee_id)
- **categoryName**: TEXT (category_name, nullable)

## Code Generation

### After modifying models or stores:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### For watching changes:
```bash
flutter pub run build_runner watch
```

### Handling MobX with Drift Generated Types:
**Working Solution with Type Alias**:
The project uses a type alias approach to help MobX work with Drift-generated types:

```dart
// In service_category_store.dart
import '../../../core/database/drift_database.dart' as db;

// Type alias to help MobX code generation
typedef DbServiceCategory = db.ServiceCategory;
```

This approach allows MobX to properly generate code using `DbServiceCategory` instead of producing `InvalidType` errors.

**Why Type Aliases Work**:
- The typedef creates a local type name that MobX can resolve
- The generated code correctly uses `DbServiceCategory` throughout
- No manual fixes needed after code generation

**Best Practices**:
- Always use type aliases for Drift types in MobX stores
- Import Drift database with an alias (`as db`)
- Define typedefs at the top of the store file
- For complex scenarios, consider wrapper classes

**Alternative Solutions**:
- Create wrapper classes for database types (e.g., `ServiceCategoryWrapper`)
- Use primitive types and convert in the repository layer
- Keep database types isolated to repository layer only

## Code Style
- Use trailing commas for better formatting
- Always run `flutter analyze` after changes
- Use `const` constructors where possible
- Prefer single quotes for strings
- Use `final` for variables that won't be reassigned

## Performance Optimization Patterns

### RepaintBoundary Strategy
```dart
// Isolate repaints for static content
RepaintBoundary(
  child: Container(
    // Static decorations and layout
    child: Column(
      children: [
        _buildHeader(), // Static header with Observer for dynamic parts
        _buildContent(), // Content with its own RepaintBoundary
      ],
    ),
  ),
)
```

### Strategic Observer Placement (MobX)
```dart
// ❌ Bad: Wrapping entire widget
Observer(
  builder: (_) => EntireComplexWidget(),
)

// ✅ Good: Wrapping only dynamic parts
Column(
  children: [
    const StaticHeader(),        // No Observer needed
    Observer(                    // Only for dynamic count
      builder: (_) => Text('${store.count}'),
    ),
    const StaticDecoration(),    // No Observer needed
  ],
)
```

### Widget Keys for Lists
```dart
// Use ValueKey for efficient list updates
ListView.builder(
  itemCount: services.length,
  itemBuilder: (context, index) {
    final service = services[index];
    return OptimizedServiceItem(
      key: ValueKey(service.id),  // Preserves state during reordering
      service: service,
    );
  },
)
```

### Const Constructors
```dart
// Use const for static widgets
const SizedBox(width: 8),
const Icon(Icons.arrow_forward, size: 16),
const Padding(
  padding: EdgeInsets.all(12),
  child: Text('Static Label'),
)
```

### Performance Testing
```dart
// Test for RepaintBoundary placement
testWidgets('should have RepaintBoundary at top level', (tester) async {
  await tester.pumpWidget(createTestWidget());

  final repaintBoundaryFinder = find.descendant(
    of: find.byType(OptimizedWidget),
    matching: find.byType(RepaintBoundary),
  );

  expect(repaintBoundaryFinder, findsWidgets);
});

// Test for minimal rebuilds
testWidgets('Observer placement should minimize rebuilds', (tester) async {
  final observers = find.byType(Observer);
  expect(observers, findsNWidgets(3)); // Only 3 Observer widgets for dynamic parts
});

// Test with large datasets
testWidgets('should handle large number of services efficiently', (tester) async {
  // Create 100+ services
  final manyServices = List.generate(100, (i) =>
    Service(
      id: 's$i',
      name: 'Service $i',
      durationMinutes: 30,
      price: 25.0 + i,
      categoryId: 1,
    ),
  );

  store.servicesByCategory['1'] = manyServices;
  store.expandedCategories['1'] = true;

  await tester.pumpWidget(createTestWidget());
  await tester.pumpAndSettle();

  // Should render without performance issues
  expect(find.byType(OptimizedServiceItem), findsNWidgets(100));
});
```

### AnimatedCrossFade for Smooth Transitions
```dart
AnimatedCrossFade(
  duration: const Duration(milliseconds: 200),
  crossFadeState: isExpanded
    ? CrossFadeState.showSecond
    : CrossFadeState.showFirst,
  firstChild: const SizedBox.shrink(),
  secondChild: _buildExpandedContent(),
)
```

## Cache and Performance Systems

### Cache TTL (Time-To-Live) System
The application implements a 5-minute cache TTL system for optimal performance:

- **Documentation**: See `/docs/cache_ttl_analysis.md` for complete TTL system analysis
- **Implementation**: Both `AppointmentsStore` and `TicketsStore` use 5-minute cache TTL
- **Coordination**: `CacheCoordinationService` handles cross-screen cache invalidation
- **Testing**: Unit tests in `/test/cache_ttl_verification_test.dart` verify TTL behavior

**Key Cache Behaviors**:
- Fresh data (< 5 minutes): Served from cache for fast loading
- Stale data (≥ 5 minutes): Triggers automatic reload from database
- Manual refresh: Bypass cache via pull-to-refresh or refresh buttons
- Cross-screen updates: Immediate cache invalidation when data changes

## Critical Reminders

1. **ALWAYS** check docs.flutter.dev for current APIs
2. **NEVER** create files unless absolutely necessary
3. **PREFER** editing existing files
4. **AVOID** assumptions about Flutter APIs - verify everything
5. **TEST** changes with `flutter analyze` before considering complete
6. **USE** import aliases for Drift to avoid type conflicts
7. **FOLLOW** existing patterns in the codebase
8. **REFERENCE** `type_issues.md` for ongoing type consistency challenges and solutions
9. **UNDERSTAND** cache TTL system when working with data stores - see `/docs/cache_ttl_analysis.md`

---

*Remember: Flutter changes rapidly. When in doubt, docs.flutter.dev is the source of truth*
