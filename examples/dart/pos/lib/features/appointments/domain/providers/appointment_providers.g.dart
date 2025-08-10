// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(appointmentRepository)
const appointmentRepositoryProvider = AppointmentRepositoryProvider._();

final class AppointmentRepositoryProvider
    extends
        $FunctionalProvider<
          DriftAppointmentRepository,
          DriftAppointmentRepository,
          DriftAppointmentRepository
        >
    with $Provider<DriftAppointmentRepository> {
  const AppointmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftAppointmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftAppointmentRepository create(Ref ref) {
    return appointmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftAppointmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftAppointmentRepository>(value),
    );
  }
}

String _$appointmentRepositoryHash() =>
    r'1cd102d4fd1de474d0106fe7354a24c94ee07ab6';

@ProviderFor(TodaysAppointments)
const todaysAppointmentsProvider = TodaysAppointmentsProvider._();

final class TodaysAppointmentsProvider
    extends $AsyncNotifierProvider<TodaysAppointments, List<Appointment>> {
  const TodaysAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysAppointmentsHash();

  @$internal
  @override
  TodaysAppointments create() => TodaysAppointments();
}

String _$todaysAppointmentsHash() =>
    r'3ac23af1a5b4b4f2a73f593817fee6f08eb709a0';

abstract class _$TodaysAppointments extends $AsyncNotifier<List<Appointment>> {
  FutureOr<List<Appointment>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Appointment>>, List<Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Appointment>>, List<Appointment>>,
              AsyncValue<List<Appointment>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(appointmentsMaster)
const appointmentsMasterProvider = AppointmentsMasterProvider._();

final class AppointmentsMasterProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const AppointmentsMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsMasterHash();

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    return appointmentsMaster(ref);
  }
}

String _$appointmentsMasterHash() =>
    r'281960a90b58b33f2c56d37053234978d3c78237';

@ProviderFor(appointmentWithServices)
const appointmentWithServicesProvider = AppointmentWithServicesFamily._();

final class AppointmentWithServicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<dao.AppointmentWithServices?>,
          dao.AppointmentWithServices?,
          FutureOr<dao.AppointmentWithServices?>
        >
    with
        $FutureModifier<dao.AppointmentWithServices?>,
        $FutureProvider<dao.AppointmentWithServices?> {
  const AppointmentWithServicesProvider._({
    required AppointmentWithServicesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'appointmentWithServicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentWithServicesHash();

  @override
  String toString() {
    return r'appointmentWithServicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<dao.AppointmentWithServices?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<dao.AppointmentWithServices?> create(Ref ref) {
    final argument = this.argument as String;
    return appointmentWithServices(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentWithServicesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentWithServicesHash() =>
    r'10ff9cc0aeb5c8e22fe907dfb6dd7159d01ee7d1';

final class AppointmentWithServicesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<dao.AppointmentWithServices?>,
          String
        > {
  const AppointmentWithServicesFamily._()
    : super(
        retry: null,
        name: r'appointmentWithServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentWithServicesProvider call(String appointmentId) =>
      AppointmentWithServicesProvider._(argument: appointmentId, from: this);

  @override
  String toString() => r'appointmentWithServicesProvider';
}

@ProviderFor(upcomingAppointmentsForDashboard)
const upcomingAppointmentsForDashboardProvider =
    UpcomingAppointmentsForDashboardProvider._();

final class UpcomingAppointmentsForDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const UpcomingAppointmentsForDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingAppointmentsForDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingAppointmentsForDashboardHash();

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    return upcomingAppointmentsForDashboard(ref);
  }
}

String _$upcomingAppointmentsForDashboardHash() =>
    r'233a9593122c63dfebd8e1796d76f79bb83b0e38';

@ProviderFor(TodaysCalendarAppointments)
const todaysCalendarAppointmentsProvider =
    TodaysCalendarAppointmentsProvider._();

final class TodaysCalendarAppointmentsProvider
    extends
        $AsyncNotifierProvider<TodaysCalendarAppointments, List<Appointment>> {
  const TodaysCalendarAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysCalendarAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysCalendarAppointmentsHash();

  @$internal
  @override
  TodaysCalendarAppointments create() => TodaysCalendarAppointments();
}

String _$todaysCalendarAppointmentsHash() =>
    r'4809ac7f29b53fb19d6c6210a2525c1a4e4b37a5';

abstract class _$TodaysCalendarAppointments
    extends $AsyncNotifier<List<Appointment>> {
  FutureOr<List<Appointment>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Appointment>>, List<Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Appointment>>, List<Appointment>>,
              AsyncValue<List<Appointment>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(appointmentsByDateRange)
const appointmentsByDateRangeProvider = AppointmentsByDateRangeFamily._();

final class AppointmentsByDateRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const AppointmentsByDateRangeProvider._({
    required AppointmentsByDateRangeFamily super.from,
    required DateTimeRange super.argument,
  }) : super(
         retry: null,
         name: r'appointmentsByDateRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentsByDateRangeHash();

  @override
  String toString() {
    return r'appointmentsByDateRangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as DateTimeRange;
    return appointmentsByDateRange(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentsByDateRangeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentsByDateRangeHash() =>
    r'd9c028f5e1edb3d250d1b1710821ce3c419a22c4';

final class AppointmentsByDateRangeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Appointment>>, DateTimeRange> {
  const AppointmentsByDateRangeFamily._()
    : super(
        retry: null,
        name: r'appointmentsByDateRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentsByDateRangeProvider call(DateTimeRange dateRange) =>
      AppointmentsByDateRangeProvider._(argument: dateRange, from: this);

  @override
  String toString() => r'appointmentsByDateRangeProvider';
}

@ProviderFor(appointmentsByDateRangeForCalendar)
const appointmentsByDateRangeForCalendarProvider =
    AppointmentsByDateRangeForCalendarFamily._();

final class AppointmentsByDateRangeForCalendarProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const AppointmentsByDateRangeForCalendarProvider._({
    required AppointmentsByDateRangeForCalendarFamily super.from,
    required DateTimeRange super.argument,
  }) : super(
         retry: null,
         name: r'appointmentsByDateRangeForCalendarProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$appointmentsByDateRangeForCalendarHash();

  @override
  String toString() {
    return r'appointmentsByDateRangeForCalendarProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as DateTimeRange;
    return appointmentsByDateRangeForCalendar(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentsByDateRangeForCalendarProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentsByDateRangeForCalendarHash() =>
    r'2596e0d69fb9591597f18a417b6af51df369737b';

final class AppointmentsByDateRangeForCalendarFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Appointment>>, DateTimeRange> {
  const AppointmentsByDateRangeForCalendarFamily._()
    : super(
        retry: null,
        name: r'appointmentsByDateRangeForCalendarProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentsByDateRangeForCalendarProvider call(DateTimeRange dateRange) =>
      AppointmentsByDateRangeForCalendarProvider._(
        argument: dateRange,
        from: this,
      );

  @override
  String toString() => r'appointmentsByDateRangeForCalendarProvider';
}

@ProviderFor(customerAppointments)
const customerAppointmentsProvider = CustomerAppointmentsFamily._();

final class CustomerAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const CustomerAppointmentsProvider._({
    required CustomerAppointmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerAppointmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerAppointmentsHash();

  @override
  String toString() {
    return r'customerAppointmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as String;
    return customerAppointments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerAppointmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerAppointmentsHash() =>
    r'bc535076f572f14b0ee463bae193dd6906582607';

final class CustomerAppointmentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Appointment>>, String> {
  const CustomerAppointmentsFamily._()
    : super(
        retry: null,
        name: r'customerAppointmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerAppointmentsProvider call(String customerId) =>
      CustomerAppointmentsProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerAppointmentsProvider';
}

@ProviderFor(technicianAppointments)
const technicianAppointmentsProvider = TechnicianAppointmentsFamily._();

final class TechnicianAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const TechnicianAppointmentsProvider._({
    required TechnicianAppointmentsFamily super.from,
    required (String, {DateTime? date}) super.argument,
  }) : super(
         retry: null,
         name: r'technicianAppointmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianAppointmentsHash();

  @override
  String toString() {
    return r'technicianAppointmentsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as (String, {DateTime? date});
    return technicianAppointments(ref, argument.$1, date: argument.date);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianAppointmentsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianAppointmentsHash() =>
    r'5224b82b897cfe5563f7d27c9eb66de7dab2f37f';

final class TechnicianAppointmentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Appointment>>,
          (String, {DateTime? date})
        > {
  const TechnicianAppointmentsFamily._()
    : super(
        retry: null,
        name: r'technicianAppointmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TechnicianAppointmentsProvider call(String technicianId, {DateTime? date}) =>
      TechnicianAppointmentsProvider._(
        argument: (technicianId, date: date),
        from: this,
      );

  @override
  String toString() => r'technicianAppointmentsProvider';
}

/// Selected date for calendar views
@ProviderFor(SelectedDate)
const selectedDateProvider = SelectedDateProvider._();

/// Selected date for calendar views
final class SelectedDateProvider
    extends $NotifierProvider<SelectedDate, DateTime> {
  /// Selected date for calendar views
  const SelectedDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDateHash();

  @$internal
  @override
  SelectedDate create() => SelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedDateHash() => r'cc25445f32865aab46f31ec226a27ffb9869f769';

abstract class _$SelectedDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Appointment filters (compatibility with old API)
@ProviderFor(AppointmentFilters)
const appointmentFiltersProvider = AppointmentFiltersProvider._();

/// Appointment filters (compatibility with old API)
final class AppointmentFiltersProvider
    extends $NotifierProvider<AppointmentFilters, AppointmentFilterState> {
  /// Appointment filters (compatibility with old API)
  const AppointmentFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentFiltersHash();

  @$internal
  @override
  AppointmentFilters create() => AppointmentFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentFilterState>(value),
    );
  }
}

String _$appointmentFiltersHash() =>
    r'331a6af57b47e4c30e77658452832ff6f46650b8';

abstract class _$AppointmentFilters extends $Notifier<AppointmentFilterState> {
  AppointmentFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AppointmentFilterState, AppointmentFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppointmentFilterState, AppointmentFilterState>,
              AppointmentFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Calendar view mode (compatibility alias)
@ProviderFor(AppointmentViewMode)
const appointmentViewModeProvider = AppointmentViewModeProvider._();

/// Calendar view mode (compatibility alias)
final class AppointmentViewModeProvider
    extends $NotifierProvider<AppointmentViewMode, CalendarViewMode> {
  /// Calendar view mode (compatibility alias)
  const AppointmentViewModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentViewModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentViewModeHash();

  @$internal
  @override
  AppointmentViewMode create() => AppointmentViewMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarViewMode>(value),
    );
  }
}

String _$appointmentViewModeHash() =>
    r'd939e300d99b8625c8d971ba671a2d1cadcb38b3';

abstract class _$AppointmentViewMode extends $Notifier<CalendarViewMode> {
  CalendarViewMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CalendarViewMode, CalendarViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalendarViewMode, CalendarViewMode>,
              CalendarViewMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Filtered appointments based on current filters (compatibility)
@ProviderFor(filteredAppointments)
const filteredAppointmentsProvider = FilteredAppointmentsProvider._();

/// Filtered appointments based on current filters (compatibility)
final class FilteredAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  /// Filtered appointments based on current filters (compatibility)
  const FilteredAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAppointmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    return filteredAppointments(ref);
  }
}

String _$filteredAppointmentsHash() =>
    r'7d6d003f77320cce94f2d22e3cb713c8ba87e5a8';

/// Provider for appointments filtered by AppointmentFilter (compatibility)
@ProviderFor(appointmentsByFilter)
const appointmentsByFilterProvider = AppointmentsByFilterFamily._();

/// Provider for appointments filtered by AppointmentFilter (compatibility)
final class AppointmentsByFilterProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  /// Provider for appointments filtered by AppointmentFilter (compatibility)
  const AppointmentsByFilterProvider._({
    required AppointmentsByFilterFamily super.from,
    required AppointmentFilter super.argument,
  }) : super(
         retry: null,
         name: r'appointmentsByFilterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentsByFilterHash();

  @override
  String toString() {
    return r'appointmentsByFilterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as AppointmentFilter;
    return appointmentsByFilter(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentsByFilterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentsByFilterHash() =>
    r'ac04428dbe2f00cb35275492cbe762e8d1092956';

/// Provider for appointments filtered by AppointmentFilter (compatibility)
final class AppointmentsByFilterFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Appointment>>,
          AppointmentFilter
        > {
  const AppointmentsByFilterFamily._()
    : super(
        retry: null,
        name: r'appointmentsByFilterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for appointments filtered by AppointmentFilter (compatibility)
  AppointmentsByFilterProvider call(AppointmentFilter filter) =>
      AppointmentsByFilterProvider._(argument: filter, from: this);

  @override
  String toString() => r'appointmentsByFilterProvider';
}

/// Get appointments for the selected date
/// Automatically uses today's provider or date range provider
@ProviderFor(selectedDateAppointments)
const selectedDateAppointmentsProvider = SelectedDateAppointmentsProvider._();

/// Get appointments for the selected date
/// Automatically uses today's provider or date range provider
final class SelectedDateAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  /// Get appointments for the selected date
  /// Automatically uses today's provider or date range provider
  const SelectedDateAppointmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDateAppointmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDateAppointmentsHash();

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    return selectedDateAppointments(ref);
  }
}

String _$selectedDateAppointmentsHash() =>
    r'7439749ac35302a5fb294bd5dbe823d6173192be';

@ProviderFor(SelectedDateAppointmentsStream)
const selectedDateAppointmentsStreamProvider =
    SelectedDateAppointmentsStreamProvider._();

final class SelectedDateAppointmentsStreamProvider
    extends
        $StreamNotifierProvider<
          SelectedDateAppointmentsStream,
          List<Appointment>
        > {
  const SelectedDateAppointmentsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDateAppointmentsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDateAppointmentsStreamHash();

  @$internal
  @override
  SelectedDateAppointmentsStream create() => SelectedDateAppointmentsStream();
}

String _$selectedDateAppointmentsStreamHash() =>
    r'2dc9d2ece95d98dfe2fce75e192e7332e42c5138';

abstract class _$SelectedDateAppointmentsStream
    extends $StreamNotifier<List<Appointment>> {
  Stream<List<Appointment>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Appointment>>, List<Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Appointment>>, List<Appointment>>,
              AsyncValue<List<Appointment>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WeekAppointmentsForCalendarStream)
const weekAppointmentsForCalendarStreamProvider =
    WeekAppointmentsForCalendarStreamFamily._();

final class WeekAppointmentsForCalendarStreamProvider
    extends
        $StreamNotifierProvider<
          WeekAppointmentsForCalendarStream,
          List<Appointment>
        > {
  const WeekAppointmentsForCalendarStreamProvider._({
    required WeekAppointmentsForCalendarStreamFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'weekAppointmentsForCalendarStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$weekAppointmentsForCalendarStreamHash();

  @override
  String toString() {
    return r'weekAppointmentsForCalendarStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WeekAppointmentsForCalendarStream create() =>
      WeekAppointmentsForCalendarStream();

  @override
  bool operator ==(Object other) {
    return other is WeekAppointmentsForCalendarStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekAppointmentsForCalendarStreamHash() =>
    r'34a1326d3b7e32033598b2cf7d04e17936db5e57';

final class WeekAppointmentsForCalendarStreamFamily extends $Family
    with
        $ClassFamilyOverride<
          WeekAppointmentsForCalendarStream,
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          Stream<List<Appointment>>,
          DateTime
        > {
  const WeekAppointmentsForCalendarStreamFamily._()
    : super(
        retry: null,
        name: r'weekAppointmentsForCalendarStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeekAppointmentsForCalendarStreamProvider call(DateTime anchorDay) =>
      WeekAppointmentsForCalendarStreamProvider._(
        argument: anchorDay,
        from: this,
      );

  @override
  String toString() => r'weekAppointmentsForCalendarStreamProvider';
}

abstract class _$WeekAppointmentsForCalendarStream
    extends $StreamNotifier<List<Appointment>> {
  late final _$args = ref.$arg as DateTime;
  DateTime get anchorDay => _$args;

  Stream<List<Appointment>> build(DateTime anchorDay);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<Appointment>>, List<Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Appointment>>, List<Appointment>>,
              AsyncValue<List<Appointment>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Upcoming appointments count for dashboard
@ProviderFor(upcomingAppointmentsCount)
const upcomingAppointmentsCountProvider = UpcomingAppointmentsCountProvider._();

/// Upcoming appointments count for dashboard
final class UpcomingAppointmentsCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Upcoming appointments count for dashboard
  const UpcomingAppointmentsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingAppointmentsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingAppointmentsCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return upcomingAppointmentsCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$upcomingAppointmentsCountHash() =>
    r'221b825bf889290fa1724bffca48e2c2eec757e3';

/// Next appointment for dashboard
@ProviderFor(nextAppointment)
const nextAppointmentProvider = NextAppointmentProvider._();

/// Next appointment for dashboard
final class NextAppointmentProvider
    extends $FunctionalProvider<Appointment?, Appointment?, Appointment?>
    with $Provider<Appointment?> {
  /// Next appointment for dashboard
  const NextAppointmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextAppointmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextAppointmentHash();

  @$internal
  @override
  $ProviderElement<Appointment?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Appointment? create(Ref ref) {
    return nextAppointment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Appointment? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Appointment?>(value),
    );
  }
}

String _$nextAppointmentHash() => r'1ed42fe88f1a9f2ee924133ea6f0df2befc231cc';

/// Appointment statistics
@ProviderFor(appointmentStatistics)
const appointmentStatisticsProvider = AppointmentStatisticsProvider._();

/// Appointment statistics
final class AppointmentStatisticsProvider
    extends
        $FunctionalProvider<
          AppointmentStatistics,
          AppointmentStatistics,
          AppointmentStatistics
        >
    with $Provider<AppointmentStatistics> {
  /// Appointment statistics
  const AppointmentStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentStatisticsHash();

  @$internal
  @override
  $ProviderElement<AppointmentStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppointmentStatistics create(Ref ref) {
    return appointmentStatistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentStatistics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentStatistics>(value),
    );
  }
}

String _$appointmentStatisticsHash() =>
    r'e19f5b2541384148d7af5f9e072c5e9233808a0f';

@ProviderFor(weekAppointmentsForCalendar)
const weekAppointmentsForCalendarProvider =
    WeekAppointmentsForCalendarFamily._();

final class WeekAppointmentsForCalendarProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Appointment>>,
          List<Appointment>,
          FutureOr<List<Appointment>>
        >
    with
        $FutureModifier<List<Appointment>>,
        $FutureProvider<List<Appointment>> {
  const WeekAppointmentsForCalendarProvider._({
    required WeekAppointmentsForCalendarFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'weekAppointmentsForCalendarProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weekAppointmentsForCalendarHash();

  @override
  String toString() {
    return r'weekAppointmentsForCalendarProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Appointment>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Appointment>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return weekAppointmentsForCalendar(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeekAppointmentsForCalendarProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weekAppointmentsForCalendarHash() =>
    r'566c1bf153098a092d8cf6b5f952a2b0e14977e8';

final class WeekAppointmentsForCalendarFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Appointment>>, DateTime> {
  const WeekAppointmentsForCalendarFamily._()
    : super(
        retry: null,
        name: r'weekAppointmentsForCalendarProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeekAppointmentsForCalendarProvider call(DateTime anchorDay) =>
      WeekAppointmentsForCalendarProvider._(argument: anchorDay, from: this);

  @override
  String toString() => r'weekAppointmentsForCalendarProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
