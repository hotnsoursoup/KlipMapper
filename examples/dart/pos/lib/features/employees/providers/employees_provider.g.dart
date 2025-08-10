// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Repository provider - single source of truth for repository access
@ProviderFor(employeeRepository)
const employeeRepositoryProvider = EmployeeRepositoryProvider._();

/// Repository provider - single source of truth for repository access
final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          DriftEmployeeRepository,
          DriftEmployeeRepository,
          DriftEmployeeRepository
        >
    with $Provider<DriftEmployeeRepository> {
  /// Repository provider - single source of truth for repository access
  const EmployeeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftEmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftEmployeeRepository create(Ref ref) {
    return employeeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftEmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftEmployeeRepository>(value),
    );
  }
}

String _$employeeRepositoryHash() =>
    r'af04aafb877280ca7818ae52374cd9ddfba1ae4c';

/// Master employees provider - single source of truth for ALL employees
/// This is the ONLY provider that fetches employees from the database
@ProviderFor(EmployeesMaster)
const employeesMasterProvider = EmployeesMasterProvider._();

/// Master employees provider - single source of truth for ALL employees
/// This is the ONLY provider that fetches employees from the database
final class EmployeesMasterProvider
    extends $AsyncNotifierProvider<EmployeesMaster, List<Employee>> {
  /// Master employees provider - single source of truth for ALL employees
  /// This is the ONLY provider that fetches employees from the database
  const EmployeesMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesMasterHash();

  @$internal
  @override
  EmployeesMaster create() => EmployeesMaster();
}

String _$employeesMasterHash() => r'b4ef72aecd9bb3c65cd0e8da933e581885546d71';

abstract class _$EmployeesMaster extends $AsyncNotifier<List<Employee>> {
  FutureOr<List<Employee>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Employee>>, List<Employee>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Employee>>, List<Employee>>,
              AsyncValue<List<Employee>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for employees filtered by criteria
/// Uses family to enable caching per filter combination
@ProviderFor(employeesByFilter)
const employeesByFilterProvider = EmployeesByFilterFamily._();

/// Provider for employees filtered by criteria
/// Uses family to enable caching per filter combination
final class EmployeesByFilterProvider
    extends $FunctionalProvider<List<Employee>, List<Employee>, List<Employee>>
    with $Provider<List<Employee>> {
  /// Provider for employees filtered by criteria
  /// Uses family to enable caching per filter combination
  const EmployeesByFilterProvider._({
    required EmployeesByFilterFamily super.from,
    required EmployeeFilter super.argument,
  }) : super(
         retry: null,
         name: r'employeesByFilterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeesByFilterHash();

  @override
  String toString() {
    return r'employeesByFilterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Employee>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Employee> create(Ref ref) {
    final argument = this.argument as EmployeeFilter;
    return employeesByFilter(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Employee> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Employee>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeesByFilterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeesByFilterHash() => r'6a67c0820c2154bfd3c19b0d7891c52513df8fa2';

/// Provider for employees filtered by criteria
/// Uses family to enable caching per filter combination
final class EmployeesByFilterFamily extends $Family
    with $FunctionalFamilyOverride<List<Employee>, EmployeeFilter> {
  const EmployeesByFilterFamily._()
    : super(
        retry: null,
        name: r'employeesByFilterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for employees filtered by criteria
  /// Uses family to enable caching per filter combination
  EmployeesByFilterProvider call(EmployeeFilter filter) =>
      EmployeesByFilterProvider._(argument: filter, from: this);

  @override
  String toString() => r'employeesByFilterProvider';
}

/// Provider for active employees only
@ProviderFor(activeEmployees)
const activeEmployeesProvider = ActiveEmployeesProvider._();

/// Provider for active employees only
final class ActiveEmployeesProvider
    extends $FunctionalProvider<List<Employee>, List<Employee>, List<Employee>>
    with $Provider<List<Employee>> {
  /// Provider for active employees only
  const ActiveEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Employee>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Employee> create(Ref ref) {
    return activeEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Employee> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Employee>>(value),
    );
  }
}

String _$activeEmployeesHash() => r'149f09254883fa1ae18a989f69087cd7c80f67ea';

/// Provider for technicians only
@ProviderFor(technicians)
const techniciansProvider = TechniciansProvider._();

/// Provider for technicians only
final class TechniciansProvider
    extends $FunctionalProvider<List<Employee>, List<Employee>, List<Employee>>
    with $Provider<List<Employee>> {
  /// Provider for technicians only
  const TechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'techniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$techniciansHash();

  @$internal
  @override
  $ProviderElement<List<Employee>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Employee> create(Ref ref) {
    return technicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Employee> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Employee>>(value),
    );
  }
}

String _$techniciansHash() => r'48d6517e88f3f4337b957254e7e101b42676ad46';

/// Provider for managers only
@ProviderFor(managers)
const managersProvider = ManagersProvider._();

/// Provider for managers only
final class ManagersProvider
    extends $FunctionalProvider<List<Employee>, List<Employee>, List<Employee>>
    with $Provider<List<Employee>> {
  /// Provider for managers only
  const ManagersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managersHash();

  @$internal
  @override
  $ProviderElement<List<Employee>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Employee> create(Ref ref) {
    return managers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Employee> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Employee>>(value),
    );
  }
}

String _$managersHash() => r'22cc68121cd2b86d07f341d7e4bdb9651c8d2f41';

/// Provider for employee by ID
@ProviderFor(employeeById)
const employeeByIdProvider = EmployeeByIdFamily._();

/// Provider for employee by ID
final class EmployeeByIdProvider
    extends $FunctionalProvider<Employee?, Employee?, Employee?>
    with $Provider<Employee?> {
  /// Provider for employee by ID
  const EmployeeByIdProvider._({
    required EmployeeByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'employeeByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeByIdHash();

  @override
  String toString() {
    return r'employeeByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Employee?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Employee? create(Ref ref) {
    final argument = this.argument as int;
    return employeeById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Employee? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Employee?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeByIdHash() => r'62bed2331de9a4e46d1845a4c2b43cea5ba9eb4a';

/// Provider for employee by ID
final class EmployeeByIdFamily extends $Family
    with $FunctionalFamilyOverride<Employee?, int> {
  const EmployeeByIdFamily._()
    : super(
        retry: null,
        name: r'employeeByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for employee by ID
  EmployeeByIdProvider call(int employeeId) =>
      EmployeeByIdProvider._(argument: employeeId, from: this);

  @override
  String toString() => r'employeeByIdProvider';
}

/// Provider for employee statistics
@ProviderFor(employeeStatistics)
const employeeStatisticsProvider = EmployeeStatisticsProvider._();

/// Provider for employee statistics
final class EmployeeStatisticsProvider
    extends
        $FunctionalProvider<
          EmployeeStatistics,
          EmployeeStatistics,
          EmployeeStatistics
        >
    with $Provider<EmployeeStatistics> {
  /// Provider for employee statistics
  const EmployeeStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeStatisticsHash();

  @$internal
  @override
  $ProviderElement<EmployeeStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeStatistics create(Ref ref) {
    return employeeStatistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeStatistics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeStatistics>(value),
    );
  }
}

String _$employeeStatisticsHash() =>
    r'68d1af7af4a046e45cdc38b56c7bb3a0a17c3f45';

/// Search query for employees screen
@ProviderFor(EmployeeSearchQuery)
const employeeSearchQueryProvider = EmployeeSearchQueryProvider._();

/// Search query for employees screen
final class EmployeeSearchQueryProvider
    extends $NotifierProvider<EmployeeSearchQuery, String> {
  /// Search query for employees screen
  const EmployeeSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeSearchQueryHash();

  @$internal
  @override
  EmployeeSearchQuery create() => EmployeeSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$employeeSearchQueryHash() =>
    r'5cb550b08a1f8b5d1ae411e2a0dc28013e1c82ef';

abstract class _$EmployeeSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Selected role filter
@ProviderFor(EmployeeRoleFilter)
const employeeRoleFilterProvider = EmployeeRoleFilterProvider._();

/// Selected role filter
final class EmployeeRoleFilterProvider
    extends $NotifierProvider<EmployeeRoleFilter, String> {
  /// Selected role filter
  const EmployeeRoleFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRoleFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRoleFilterHash();

  @$internal
  @override
  EmployeeRoleFilter create() => EmployeeRoleFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$employeeRoleFilterHash() =>
    r'40119e557caff5d9d90b9c3f2e00797638abb0a3';

abstract class _$EmployeeRoleFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Show inactive employees toggle
@ProviderFor(ShowInactiveEmployees)
const showInactiveEmployeesProvider = ShowInactiveEmployeesProvider._();

/// Show inactive employees toggle
final class ShowInactiveEmployeesProvider
    extends $NotifierProvider<ShowInactiveEmployees, bool> {
  /// Show inactive employees toggle
  const ShowInactiveEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showInactiveEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showInactiveEmployeesHash();

  @$internal
  @override
  ShowInactiveEmployees create() => ShowInactiveEmployees();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showInactiveEmployeesHash() =>
    r'c323fe5347641f5cd25787408f217505d0bc5497';

abstract class _$ShowInactiveEmployees extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for employee clock-in status (accurate via Drift)
@ProviderFor(employeeClockedIn)
const employeeClockedInProvider = EmployeeClockedInFamily._();

/// Provider for employee clock-in status (accurate via Drift)
final class EmployeeClockedInProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for employee clock-in status (accurate via Drift)
  const EmployeeClockedInProvider._({
    required EmployeeClockedInFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'employeeClockedInProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$employeeClockedInHash();

  @override
  String toString() {
    return r'employeeClockedInProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as int;
    return employeeClockedIn(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeClockedInProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$employeeClockedInHash() => r'42d3ae18f7d2f392b3e1d2b53edd04648565db13';

/// Provider for employee clock-in status (accurate via Drift)
final class EmployeeClockedInFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, int> {
  const EmployeeClockedInFamily._()
    : super(
        retry: null,
        name: r'employeeClockedInProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for employee clock-in status (accurate via Drift)
  EmployeeClockedInProvider call(int employeeId) =>
      EmployeeClockedInProvider._(argument: employeeId, from: this);

  @override
  String toString() => r'employeeClockedInProvider';
}

/// Provider for today's clock-in order entries
@ProviderFor(ClockInOrder)
const clockInOrderProvider = ClockInOrderProvider._();

/// Provider for today's clock-in order entries
final class ClockInOrderProvider
    extends $AsyncNotifierProvider<ClockInOrder, List<ClockInOrderEntry>> {
  /// Provider for today's clock-in order entries
  const ClockInOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockInOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockInOrderHash();

  @$internal
  @override
  ClockInOrder create() => ClockInOrder();
}

String _$clockInOrderHash() => r'b8858f1c189109801dc95f94e0d3ea5acb4a7840';

abstract class _$ClockInOrder extends $AsyncNotifier<List<ClockInOrderEntry>> {
  FutureOr<List<ClockInOrderEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ClockInOrderEntry>>,
              List<ClockInOrderEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ClockInOrderEntry>>,
                List<ClockInOrderEntry>
              >,
              AsyncValue<List<ClockInOrderEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
