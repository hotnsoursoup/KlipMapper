// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Queue management provider for managing queue tickets and filtering
/// Converted from queue_management_store.dart
@ProviderFor(QueueManagement)
const queueManagementProvider = QueueManagementProvider._();

/// Queue management provider for managing queue tickets and filtering
/// Converted from queue_management_store.dart
final class QueueManagementProvider
    extends $AsyncNotifierProvider<QueueManagement, QueueManagementState> {
  /// Queue management provider for managing queue tickets and filtering
  /// Converted from queue_management_store.dart
  const QueueManagementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueManagementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueManagementHash();

  @$internal
  @override
  QueueManagement create() => QueueManagement();
}

String _$queueManagementHash() => r'f525ec872f595e506bd3f804ae215d45680f963c';

abstract class _$QueueManagement extends $AsyncNotifier<QueueManagementState> {
  FutureOr<QueueManagementState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<QueueManagementState>, QueueManagementState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<QueueManagementState>,
                QueueManagementState
              >,
              AsyncValue<QueueManagementState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ticketRepository)
const ticketRepositoryProvider = TicketRepositoryProvider._();

final class TicketRepositoryProvider
    extends
        $FunctionalProvider<
          DriftTicketRepository,
          DriftTicketRepository,
          DriftTicketRepository
        >
    with $Provider<DriftTicketRepository> {
  const TicketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftTicketRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftTicketRepository create(Ref ref) {
    return ticketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftTicketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftTicketRepository>(value),
    );
  }
}

String _$ticketRepositoryHash() => r'fdbe1e19aa382bd50937c96efcfbd400de8b0179';

/// Filtered tickets based on current filter
@ProviderFor(filteredQueueTickets)
const filteredQueueTicketsProvider = FilteredQueueTicketsProvider._();

/// Filtered tickets based on current filter
final class FilteredQueueTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Filtered tickets based on current filter
  const FilteredQueueTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredQueueTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredQueueTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return filteredQueueTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$filteredQueueTicketsHash() =>
    r'7b986c9ae31bc82bb862698fc20b31d62cf81553';

/// Queue length
@ProviderFor(queueLength)
const queueLengthProvider = QueueLengthProvider._();

/// Queue length
final class QueueLengthProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Queue length
  const QueueLengthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueLengthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueLengthHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return queueLength(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$queueLengthHash() => r'c4427bd7e0655a50bb9bf2a069f400636177e7d7';

/// Waiting customers count (queued tickets only)
@ProviderFor(waitingCustomersCount)
const waitingCustomersCountProvider = WaitingCustomersCountProvider._();

/// Waiting customers count (queued tickets only)
final class WaitingCustomersCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Waiting customers count (queued tickets only)
  const WaitingCustomersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waitingCustomersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waitingCustomersCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return waitingCustomersCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$waitingCustomersCountHash() =>
    r'eca658c10bd8f6d9ba7c660874ec612fa40ddf52';

/// Next ticket in FIFO order
@ProviderFor(nextTicket)
const nextTicketProvider = NextTicketProvider._();

/// Next ticket in FIFO order
final class NextTicketProvider
    extends $FunctionalProvider<Ticket?, Ticket?, Ticket?>
    with $Provider<Ticket?> {
  /// Next ticket in FIFO order
  const NextTicketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextTicketProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextTicketHash();

  @$internal
  @override
  $ProviderElement<Ticket?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Ticket? create(Ref ref) {
    return nextTicket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Ticket? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Ticket?>(value),
    );
  }
}

String _$nextTicketHash() => r'5c7d349d0935abf0efe3492c6f465854a6eaf21f';

/// Priority tickets
@ProviderFor(priorityTickets)
const priorityTicketsProvider = PriorityTicketsProvider._();

/// Priority tickets
final class PriorityTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Priority tickets
  const PriorityTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'priorityTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$priorityTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return priorityTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$priorityTicketsHash() => r'be64d8a2a27f2f043f45d129e192406efa370f0f';

/// Walk-in tickets only
@ProviderFor(walkInTickets)
const walkInTicketsProvider = WalkInTicketsProvider._();

/// Walk-in tickets only
final class WalkInTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Walk-in tickets only
  const WalkInTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkInTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkInTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return walkInTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$walkInTicketsHash() => r'4955e220ba370e1f2005772818850bf578023841';

/// Appointment tickets only
@ProviderFor(appointmentTickets)
const appointmentTicketsProvider = AppointmentTicketsProvider._();

/// Appointment tickets only
final class AppointmentTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Appointment tickets only
  const AppointmentTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return appointmentTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$appointmentTicketsHash() =>
    r'b95a60499b3c3c6941c127b89342333e6faefaa4';

/// Group tickets by service category
@ProviderFor(ticketsByServiceCategory)
const ticketsByServiceCategoryProvider = TicketsByServiceCategoryProvider._();

/// Group tickets by service category
final class TicketsByServiceCategoryProvider
    extends
        $FunctionalProvider<
          Map<String, List<Ticket>>,
          Map<String, List<Ticket>>,
          Map<String, List<Ticket>>
        >
    with $Provider<Map<String, List<Ticket>>> {
  /// Group tickets by service category
  const TicketsByServiceCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsByServiceCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsByServiceCategoryHash();

  @$internal
  @override
  $ProviderElement<Map<String, List<Ticket>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, List<Ticket>> create(Ref ref) {
    return ticketsByServiceCategory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<Ticket>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<Ticket>>>(value),
    );
  }
}

String _$ticketsByServiceCategoryHash() =>
    r'a51fc6eceef2db7294a44b62859b35e217136c35';

/// Check if queue has unassigned tickets
@ProviderFor(hasUnassignedTickets)
const hasUnassignedTicketsProvider = HasUnassignedTicketsProvider._();

/// Check if queue has unassigned tickets
final class HasUnassignedTicketsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Check if queue has unassigned tickets
  const HasUnassignedTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasUnassignedTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasUnassignedTicketsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasUnassignedTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasUnassignedTicketsHash() =>
    r'c7d695107b63e4c444e0cb833620d07864e51db3';

/// Estimated wait time for next ticket
@ProviderFor(estimatedWaitTime)
const estimatedWaitTimeProvider = EstimatedWaitTimeProvider._();

/// Estimated wait time for next ticket
final class EstimatedWaitTimeProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// Estimated wait time for next ticket
  const EstimatedWaitTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'estimatedWaitTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$estimatedWaitTimeHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return estimatedWaitTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$estimatedWaitTimeHash() => r'7b4ddc54d4f46ac02e588bc6a8480687facc2072';

/// Get ticket by ID
@ProviderFor(getTicketById)
const getTicketByIdProvider = GetTicketByIdFamily._();

/// Get ticket by ID
final class GetTicketByIdProvider
    extends $FunctionalProvider<Ticket?, Ticket?, Ticket?>
    with $Provider<Ticket?> {
  /// Get ticket by ID
  const GetTicketByIdProvider._({
    required GetTicketByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getTicketByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getTicketByIdHash();

  @override
  String toString() {
    return r'getTicketByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Ticket?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Ticket? create(Ref ref) {
    final argument = this.argument as String;
    return getTicketById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Ticket? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Ticket?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTicketByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTicketByIdHash() => r'44a94cb8848196afd5754ebc90e2ae4add8e6078';

/// Get ticket by ID
final class GetTicketByIdFamily extends $Family
    with $FunctionalFamilyOverride<Ticket?, String> {
  const GetTicketByIdFamily._()
    : super(
        retry: null,
        name: r'getTicketByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get ticket by ID
  GetTicketByIdProvider call(String ticketId) =>
      GetTicketByIdProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'getTicketByIdProvider';
}

/// Get queue position for ticket
@ProviderFor(getQueuePosition)
const getQueuePositionProvider = GetQueuePositionFamily._();

/// Get queue position for ticket
final class GetQueuePositionProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Get queue position for ticket
  const GetQueuePositionProvider._({
    required GetQueuePositionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getQueuePositionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getQueuePositionHash();

  @override
  String toString() {
    return r'getQueuePositionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return getQueuePosition(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetQueuePositionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getQueuePositionHash() => r'a8a207d4accd249ca423ca6497d0641e9f97f91b';

/// Get queue position for ticket
final class GetQueuePositionFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  const GetQueuePositionFamily._()
    : super(
        retry: null,
        name: r'getQueuePositionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get queue position for ticket
  GetQueuePositionProvider call(String ticketId) =>
      GetQueuePositionProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'getQueuePositionProvider';
}

/// Get tickets for technician categories
@ProviderFor(getTicketsForTechnicianCategories)
const getTicketsForTechnicianCategoriesProvider =
    GetTicketsForTechnicianCategoriesFamily._();

/// Get tickets for technician categories
final class GetTicketsForTechnicianCategoriesProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Get tickets for technician categories
  const GetTicketsForTechnicianCategoriesProvider._({
    required GetTicketsForTechnicianCategoriesFamily super.from,
    required List<String> super.argument,
  }) : super(
         retry: null,
         name: r'getTicketsForTechnicianCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$getTicketsForTechnicianCategoriesHash();

  @override
  String toString() {
    return r'getTicketsForTechnicianCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    final argument = this.argument as List<String>;
    return getTicketsForTechnicianCategories(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTicketsForTechnicianCategoriesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTicketsForTechnicianCategoriesHash() =>
    r'0e92bf8525ce84e686e8ff77a5b287b606967b7b';

/// Get tickets for technician categories
final class GetTicketsForTechnicianCategoriesFamily extends $Family
    with $FunctionalFamilyOverride<List<Ticket>, List<String>> {
  const GetTicketsForTechnicianCategoriesFamily._()
    : super(
        retry: null,
        name: r'getTicketsForTechnicianCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get tickets for technician categories
  GetTicketsForTechnicianCategoriesProvider call(
    List<String> technicianCategories,
  ) => GetTicketsForTechnicianCategoriesProvider._(
    argument: technicianCategories,
    from: this,
  );

  @override
  String toString() => r'getTicketsForTechnicianCategoriesProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
