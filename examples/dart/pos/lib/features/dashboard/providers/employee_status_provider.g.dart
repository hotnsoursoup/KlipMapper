// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Employee status provider for managing employee operational states
/// Handles availability, assignments, and clock-in status for all employees regardless of role
@ProviderFor(EmployeeStatus)
const employeeStatusProvider = EmployeeStatusProvider._();

/// Employee status provider for managing employee operational states
/// Handles availability, assignments, and clock-in status for all employees regardless of role
final class EmployeeStatusProvider
    extends $AsyncNotifierProvider<EmployeeStatus, EmployeeStatusState> {
  /// Employee status provider for managing employee operational states
  /// Handles availability, assignments, and clock-in status for all employees regardless of role
  const EmployeeStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeStatusHash();

  @$internal
  @override
  EmployeeStatus create() => EmployeeStatus();
}

String _$employeeStatusHash() => r'bc5cb3ca67b463b549b6b8eb68abcbc0b50d0c15';

abstract class _$EmployeeStatus extends $AsyncNotifier<EmployeeStatusState> {
  FutureOr<EmployeeStatusState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EmployeeStatusState>, EmployeeStatusState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EmployeeStatusState>, EmployeeStatusState>,
              AsyncValue<EmployeeStatusState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(employeeRepository)
const employeeRepositoryProvider = EmployeeRepositoryProvider._();

final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          DriftEmployeeRepository,
          DriftEmployeeRepository,
          DriftEmployeeRepository
        >
    with $Provider<DriftEmployeeRepository> {
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

@ProviderFor(timeEntryRepository)
const timeEntryRepositoryProvider = TimeEntryRepositoryProvider._();

final class TimeEntryRepositoryProvider
    extends
        $FunctionalProvider<
          DriftTimeEntryRepository,
          DriftTimeEntryRepository,
          DriftTimeEntryRepository
        >
    with $Provider<DriftTimeEntryRepository> {
  const TimeEntryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeEntryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeEntryRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftTimeEntryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftTimeEntryRepository create(Ref ref) {
    return timeEntryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftTimeEntryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftTimeEntryRepository>(value),
    );
  }
}

String _$timeEntryRepositoryHash() =>
    r'4b06e569914f38ad93c9866e74fa6e4cf38398be';

/// Available employees (any role)
@ProviderFor(availableEmployees)
const availableEmployeesProvider = AvailableEmployeesProvider._();

/// Available employees (any role)
final class AvailableEmployeesProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// Available employees (any role)
  const AvailableEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return availableEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$availableEmployeesHash() =>
    r'7339374105bd705a5ae85d7592f10b5b1d3578be';

/// Busy employees
@ProviderFor(busyEmployees)
const busyEmployeesProvider = BusyEmployeesProvider._();

/// Busy employees
final class BusyEmployeesProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// Busy employees
  const BusyEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'busyEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$busyEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return busyEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$busyEmployeesHash() => r'93513d79c54fe78390820000ee0e75fc8b0e1f0a';

/// Assigned employees
@ProviderFor(assignedEmployees)
const assignedEmployeesProvider = AssignedEmployeesProvider._();

/// Assigned employees
final class AssignedEmployeesProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// Assigned employees
  const AssignedEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignedEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignedEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return assignedEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$assignedEmployeesHash() => r'955b3c82812ad9b6d547dadfff327f7a8d86e301';

/// Offline employees
@ProviderFor(offlineEmployees)
const offlineEmployeesProvider = OfflineEmployeesProvider._();

/// Offline employees
final class OfflineEmployeesProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// Offline employees
  const OfflineEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return offlineEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$offlineEmployeesHash() => r'2bf46c0abbc53b50f0e9434c537be51e42d16fed';

/// All dashboard employees
@ProviderFor(allDashboardEmployees)
const allDashboardEmployeesProvider = AllDashboardEmployeesProvider._();

/// All dashboard employees
final class AllDashboardEmployeesProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// All dashboard employees
  const AllDashboardEmployeesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allDashboardEmployeesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allDashboardEmployeesHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return allDashboardEmployees(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$allDashboardEmployeesHash() =>
    r'd030488cf82bd699d48bc4f3238518203816caaf';

/// Filter employees by role - technicians only (for dashboard compatibility)
@ProviderFor(availableTechnicians)
const availableTechniciansProvider = AvailableTechniciansProvider._();

/// Filter employees by role - technicians only (for dashboard compatibility)
final class AvailableTechniciansProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  /// Filter employees by role - technicians only (for dashboard compatibility)
  const AvailableTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return availableTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$availableTechniciansHash() =>
    r'9e177f0616604bd88bf012a40608900b25bfd4d8';

@ProviderFor(busyTechnicians)
const busyTechniciansProvider = BusyTechniciansProvider._();

final class BusyTechniciansProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  const BusyTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'busyTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$busyTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return busyTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$busyTechniciansHash() => r'dd5a7fb85ab9c217a1a734a14ccda95fa8b82e82';

@ProviderFor(assignedTechnicians)
const assignedTechniciansProvider = AssignedTechniciansProvider._();

final class AssignedTechniciansProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  const AssignedTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignedTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignedTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return assignedTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$assignedTechniciansHash() =>
    r'255d615956b02e029c02fbae845a00c337c9d421';

@ProviderFor(offlineTechnicians)
const offlineTechniciansProvider = OfflineTechniciansProvider._();

final class OfflineTechniciansProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  const OfflineTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return offlineTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$offlineTechniciansHash() =>
    r'0c7611bb249e0b646f38b5ca10313459dae51052';

@ProviderFor(allTechnicians)
const allTechniciansProvider = AllTechniciansProvider._();

final class AllTechniciansProvider
    extends
        $FunctionalProvider<
          List<Technician>,
          List<Technician>,
          List<Technician>
        >
    with $Provider<List<Technician>> {
  const AllTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Technician>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Technician> create(Ref ref) {
    return allTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Technician> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Technician>>(value),
    );
  }
}

String _$allTechniciansHash() => r'4962b9e7c65720be071ab3c7044c6b69dc66c4d0';

/// Count providers
@ProviderFor(availableCount)
const availableCountProvider = AvailableCountProvider._();

/// Count providers
final class AvailableCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Count providers
  const AvailableCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return availableCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$availableCountHash() => r'571c0e5987a2f16c9143520a8706ebe9c43a6329';

@ProviderFor(busyCount)
const busyCountProvider = BusyCountProvider._();

final class BusyCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const BusyCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'busyCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$busyCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return busyCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$busyCountHash() => r'14f165c97154ef70dbd07703c6e9e2668b669367';

@ProviderFor(assignedCount)
const assignedCountProvider = AssignedCountProvider._();

final class AssignedCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const AssignedCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignedCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignedCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return assignedCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$assignedCountHash() => r'92f6855b5845cd92b53a2899deca5d18af33a07f';

@ProviderFor(offlineCount)
const offlineCountProvider = OfflineCountProvider._();

final class OfflineCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const OfflineCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return offlineCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$offlineCountHash() => r'a0a31b60aec4569e95547318612a1a3ee864f348';

/// Get specific employee state
@ProviderFor(getEmployeeState)
const getEmployeeStateProvider = GetEmployeeStateFamily._();

/// Get specific employee state
final class GetEmployeeStateProvider
    extends $FunctionalProvider<EmployeeState?, EmployeeState?, EmployeeState?>
    with $Provider<EmployeeState?> {
  /// Get specific employee state
  const GetEmployeeStateProvider._({
    required GetEmployeeStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getEmployeeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEmployeeStateHash();

  @override
  String toString() {
    return r'getEmployeeStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<EmployeeState?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmployeeState? create(Ref ref) {
    final argument = this.argument as String;
    return getEmployeeState(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeState?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetEmployeeStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEmployeeStateHash() => r'998dfabb8ec9297ac9e9fde9ff49cb1404241670';

/// Get specific employee state
final class GetEmployeeStateFamily extends $Family
    with $FunctionalFamilyOverride<EmployeeState?, String> {
  const GetEmployeeStateFamily._()
    : super(
        retry: null,
        name: r'getEmployeeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get specific employee state
  GetEmployeeStateProvider call(String empId) =>
      GetEmployeeStateProvider._(argument: empId, from: this);

  @override
  String toString() => r'getEmployeeStateProvider';
}

/// Get specific employee (dashboard model)
@ProviderFor(getEmployee)
const getEmployeeProvider = GetEmployeeFamily._();

/// Get specific employee (dashboard model)
final class GetEmployeeProvider
    extends $FunctionalProvider<Technician?, Technician?, Technician?>
    with $Provider<Technician?> {
  /// Get specific employee (dashboard model)
  const GetEmployeeProvider._({
    required GetEmployeeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getEmployeeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEmployeeHash();

  @override
  String toString() {
    return r'getEmployeeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Technician?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Technician? create(Ref ref) {
    final argument = this.argument as String;
    return getEmployee(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Technician? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Technician?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetEmployeeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEmployeeHash() => r'fe7a20906613dd813429a37dc2f9b2e10e172e10';

/// Get specific employee (dashboard model)
final class GetEmployeeFamily extends $Family
    with $FunctionalFamilyOverride<Technician?, String> {
  const GetEmployeeFamily._()
    : super(
        retry: null,
        name: r'getEmployeeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get specific employee (dashboard model)
  GetEmployeeProvider call(String empId) =>
      GetEmployeeProvider._(argument: empId, from: this);

  @override
  String toString() => r'getEmployeeProvider';
}

/// Check if employee is available
@ProviderFor(isEmployeeAvailable)
const isEmployeeAvailableProvider = IsEmployeeAvailableFamily._();

/// Check if employee is available
final class IsEmployeeAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Check if employee is available
  const IsEmployeeAvailableProvider._({
    required IsEmployeeAvailableFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isEmployeeAvailableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isEmployeeAvailableHash();

  @override
  String toString() {
    return r'isEmployeeAvailableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isEmployeeAvailable(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsEmployeeAvailableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isEmployeeAvailableHash() =>
    r'2cf81e19a363d5afbfbcf156f065399a00373683';

/// Check if employee is available
final class IsEmployeeAvailableFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const IsEmployeeAvailableFamily._()
    : super(
        retry: null,
        name: r'isEmployeeAvailableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check if employee is available
  IsEmployeeAvailableProvider call(String empId) =>
      IsEmployeeAvailableProvider._(argument: empId, from: this);

  @override
  String toString() => r'isEmployeeAvailableProvider';
}

/// Legacy aliases for backwards compatibility
@ProviderFor(getTechnicianState)
const getTechnicianStateProvider = GetTechnicianStateFamily._();

/// Legacy aliases for backwards compatibility
final class GetTechnicianStateProvider
    extends $FunctionalProvider<EmployeeState?, EmployeeState?, EmployeeState?>
    with $Provider<EmployeeState?> {
  /// Legacy aliases for backwards compatibility
  const GetTechnicianStateProvider._({
    required GetTechnicianStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getTechnicianStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getTechnicianStateHash();

  @override
  String toString() {
    return r'getTechnicianStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<EmployeeState?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmployeeState? create(Ref ref) {
    final argument = this.argument as String;
    return getTechnicianState(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeState?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTechnicianStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTechnicianStateHash() =>
    r'a7e15a85c5e11c439cafd8ccc73c3cc6b8767520';

/// Legacy aliases for backwards compatibility
final class GetTechnicianStateFamily extends $Family
    with $FunctionalFamilyOverride<EmployeeState?, String> {
  const GetTechnicianStateFamily._()
    : super(
        retry: null,
        name: r'getTechnicianStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Legacy aliases for backwards compatibility
  GetTechnicianStateProvider call(String techId) =>
      GetTechnicianStateProvider._(argument: techId, from: this);

  @override
  String toString() => r'getTechnicianStateProvider';
}

@ProviderFor(getTechnician)
const getTechnicianProvider = GetTechnicianFamily._();

final class GetTechnicianProvider
    extends $FunctionalProvider<Technician?, Technician?, Technician?>
    with $Provider<Technician?> {
  const GetTechnicianProvider._({
    required GetTechnicianFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getTechnicianProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getTechnicianHash();

  @override
  String toString() {
    return r'getTechnicianProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Technician?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Technician? create(Ref ref) {
    final argument = this.argument as String;
    return getTechnician(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Technician? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Technician?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTechnicianProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTechnicianHash() => r'a10c83d6227cf885c9340962efbd433c48784398';

final class GetTechnicianFamily extends $Family
    with $FunctionalFamilyOverride<Technician?, String> {
  const GetTechnicianFamily._()
    : super(
        retry: null,
        name: r'getTechnicianProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetTechnicianProvider call(String techId) =>
      GetTechnicianProvider._(argument: techId, from: this);

  @override
  String toString() => r'getTechnicianProvider';
}

@ProviderFor(isTechnicianAvailable)
const isTechnicianAvailableProvider = IsTechnicianAvailableFamily._();

final class IsTechnicianAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsTechnicianAvailableProvider._({
    required IsTechnicianAvailableFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isTechnicianAvailableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isTechnicianAvailableHash();

  @override
  String toString() {
    return r'isTechnicianAvailableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isTechnicianAvailable(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsTechnicianAvailableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isTechnicianAvailableHash() =>
    r'ffb9f3ab23b655747f1250416e62687a0ba0654a';

final class IsTechnicianAvailableFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const IsTechnicianAvailableFamily._()
    : super(
        retry: null,
        name: r'isTechnicianAvailableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsTechnicianAvailableProvider call(String techId) =>
      IsTechnicianAvailableProvider._(argument: techId, from: this);

  @override
  String toString() => r'isTechnicianAvailableProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
