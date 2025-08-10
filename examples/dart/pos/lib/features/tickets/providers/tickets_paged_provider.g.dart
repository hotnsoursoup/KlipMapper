// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_paged_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Repository provider - single source of truth for repository access
@ProviderFor(ticketRepository)
const ticketRepositoryProvider = TicketRepositoryProvider._();

/// Repository provider - single source of truth for repository access
final class TicketRepositoryProvider
    extends
        $FunctionalProvider<
          DriftTicketRepository,
          DriftTicketRepository,
          DriftTicketRepository
        >
    with $Provider<DriftTicketRepository> {
  /// Repository provider - single source of truth for repository access
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

String _$ticketRepositoryHash() => r'bb222f302542d3666269789bef005b223cda697f';

/// Active tickets provider - only loads today's active tickets
/// Auto-refreshes every 30 seconds for real-time updates
/// Used by Dashboard for queue management
@ProviderFor(ActiveTickets)
const activeTicketsProvider = ActiveTicketsProvider._();

/// Active tickets provider - only loads today's active tickets
/// Auto-refreshes every 30 seconds for real-time updates
/// Used by Dashboard for queue management
final class ActiveTicketsProvider
    extends $AsyncNotifierProvider<ActiveTickets, List<Ticket>> {
  /// Active tickets provider - only loads today's active tickets
  /// Auto-refreshes every 30 seconds for real-time updates
  /// Used by Dashboard for queue management
  const ActiveTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTicketsHash();

  @$internal
  @override
  ActiveTickets create() => ActiveTickets();
}

String _$activeTicketsHash() => r'e8f3e4e3aba577d2f15625d7e40f25fc2b8ee10d';

abstract class _$ActiveTickets extends $AsyncNotifier<List<Ticket>> {
  FutureOr<List<Ticket>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Ticket>>, List<Ticket>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Ticket>>, List<Ticket>>,
              AsyncValue<List<Ticket>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Queued tickets only - subset of active tickets
@ProviderFor(queuedTickets)
const queuedTicketsProvider = QueuedTicketsProvider._();

/// Queued tickets only - subset of active tickets
final class QueuedTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Queued tickets only - subset of active tickets
  const QueuedTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queuedTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queuedTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return queuedTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$queuedTicketsHash() => r'1ebcc44dccef45b13bb30d0333649e3eedb699e6';

/// In-service tickets only - subset of active tickets
@ProviderFor(inServiceTickets)
const inServiceTicketsProvider = InServiceTicketsProvider._();

/// In-service tickets only - subset of active tickets
final class InServiceTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// In-service tickets only - subset of active tickets
  const InServiceTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inServiceTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inServiceTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return inServiceTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$inServiceTicketsHash() => r'7bf5e4653b7171836613f1e52bad4bda486ec67f';

/// Assigned tickets only - subset of active tickets
@ProviderFor(assignedTickets)
const assignedTicketsProvider = AssignedTicketsProvider._();

/// Assigned tickets only - subset of active tickets
final class AssignedTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Assigned tickets only - subset of active tickets
  const AssignedTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignedTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignedTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return assignedTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$assignedTicketsHash() => r'1f4bd8347cca26f9535b8ab3348ae131d3caf115';

/// Tickets for a specific technician - filtered from active tickets
@ProviderFor(technicianTickets)
const technicianTicketsProvider = TechnicianTicketsFamily._();

/// Tickets for a specific technician - filtered from active tickets
final class TechnicianTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Tickets for a specific technician - filtered from active tickets
  const TechnicianTicketsProvider._({
    required TechnicianTicketsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'technicianTicketsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianTicketsHash();

  @override
  String toString() {
    return r'technicianTicketsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    final argument = this.argument as String;
    return technicianTickets(ref, argument);
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
    return other is TechnicianTicketsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianTicketsHash() => r'3b0f89d44f712fcfa5047f1ead744b6027d69549';

/// Tickets for a specific technician - filtered from active tickets
final class TechnicianTicketsFamily extends $Family
    with $FunctionalFamilyOverride<List<Ticket>, String> {
  const TechnicianTicketsFamily._()
    : super(
        retry: null,
        name: r'technicianTicketsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Tickets for a specific technician - filtered from active tickets
  TechnicianTicketsProvider call(String technicianId) =>
      TechnicianTicketsProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'technicianTicketsProvider';
}

/// Historical tickets with pagination - for Tickets Management Screen
/// This does NOT auto-refresh as it's for viewing history
@ProviderFor(TicketHistory)
const ticketHistoryProvider = TicketHistoryProvider._();

/// Historical tickets with pagination - for Tickets Management Screen
/// This does NOT auto-refresh as it's for viewing history
final class TicketHistoryProvider
    extends $AsyncNotifierProvider<TicketHistory, TicketHistoryState> {
  /// Historical tickets with pagination - for Tickets Management Screen
  /// This does NOT auto-refresh as it's for viewing history
  const TicketHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketHistoryHash();

  @$internal
  @override
  TicketHistory create() => TicketHistory();
}

String _$ticketHistoryHash() => r'3380a86dcc6c0df848f8e92c3765e88688432122';

abstract class _$TicketHistory extends $AsyncNotifier<TicketHistoryState> {
  FutureOr<TicketHistoryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<TicketHistoryState>, TicketHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TicketHistoryState>, TicketHistoryState>,
              AsyncValue<TicketHistoryState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Today's completed tickets - for reporting
@ProviderFor(todaysCompletedTickets)
const todaysCompletedTicketsProvider = TodaysCompletedTicketsProvider._();

/// Today's completed tickets - for reporting
final class TodaysCompletedTicketsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Ticket>>,
          List<Ticket>,
          FutureOr<List<Ticket>>
        >
    with $FutureModifier<List<Ticket>>, $FutureProvider<List<Ticket>> {
  /// Today's completed tickets - for reporting
  const TodaysCompletedTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysCompletedTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysCompletedTicketsHash();

  @$internal
  @override
  $FutureProviderElement<List<Ticket>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Ticket>> create(Ref ref) {
    return todaysCompletedTickets(ref);
  }
}

String _$todaysCompletedTicketsHash() =>
    r'a6d328463a2b65c89187f007805c1ff7728b8696';

/// Ticket statistics for dashboard
@ProviderFor(ticketStatistics)
const ticketStatisticsProvider = TicketStatisticsProvider._();

/// Ticket statistics for dashboard
final class TicketStatisticsProvider
    extends
        $FunctionalProvider<
          TicketStatistics,
          TicketStatistics,
          TicketStatistics
        >
    with $Provider<TicketStatistics> {
  /// Ticket statistics for dashboard
  const TicketStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketStatisticsHash();

  @$internal
  @override
  $ProviderElement<TicketStatistics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TicketStatistics create(Ref ref) {
    return ticketStatistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketStatistics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketStatistics>(value),
    );
  }
}

String _$ticketStatisticsHash() => r'd31a6bf8f56c3eaf743807bdaa503bdc9e4618c5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
