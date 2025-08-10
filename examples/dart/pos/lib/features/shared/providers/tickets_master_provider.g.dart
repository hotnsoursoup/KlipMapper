// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_master_provider.dart';

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

/// Master tickets provider - single source of truth for ALL tickets
/// This is the ONLY provider that fetches tickets from the database
/// All other ticket providers should derive from this one
@ProviderFor(TicketsMaster)
const ticketsMasterProvider = TicketsMasterProvider._();

/// Master tickets provider - single source of truth for ALL tickets
/// This is the ONLY provider that fetches tickets from the database
/// All other ticket providers should derive from this one
final class TicketsMasterProvider
    extends $AsyncNotifierProvider<TicketsMaster, List<Ticket>> {
  /// Master tickets provider - single source of truth for ALL tickets
  /// This is the ONLY provider that fetches tickets from the database
  /// All other ticket providers should derive from this one
  const TicketsMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketsMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketsMasterHash();

  @$internal
  @override
  TicketsMaster create() => TicketsMaster();
}

String _$ticketsMasterHash() => r'febae6ff9e2f99495a3f432360ea75c113415860';

abstract class _$TicketsMaster extends $AsyncNotifier<List<Ticket>> {
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

/// Provider for tickets filtered by date range
/// Uses family to enable caching per date range
@ProviderFor(ticketsByDateRange)
const ticketsByDateRangeProvider = TicketsByDateRangeFamily._();

/// Provider for tickets filtered by date range
/// Uses family to enable caching per date range
final class TicketsByDateRangeProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for tickets filtered by date range
  /// Uses family to enable caching per date range
  const TicketsByDateRangeProvider._({
    required TicketsByDateRangeFamily super.from,
    required TicketDateRangeFilter super.argument,
  }) : super(
         retry: null,
         name: r'ticketsByDateRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketsByDateRangeHash();

  @override
  String toString() {
    return r'ticketsByDateRangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    final argument = this.argument as TicketDateRangeFilter;
    return ticketsByDateRange(ref, argument);
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
    return other is TicketsByDateRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketsByDateRangeHash() =>
    r'5b2cc206c4e0c23997cc555419235d8b7d59f83b';

/// Provider for tickets filtered by date range
/// Uses family to enable caching per date range
final class TicketsByDateRangeFamily extends $Family
    with $FunctionalFamilyOverride<List<Ticket>, TicketDateRangeFilter> {
  const TicketsByDateRangeFamily._()
    : super(
        retry: null,
        name: r'ticketsByDateRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for tickets filtered by date range
  /// Uses family to enable caching per date range
  TicketsByDateRangeProvider call(TicketDateRangeFilter dateRange) =>
      TicketsByDateRangeProvider._(argument: dateRange, from: this);

  @override
  String toString() => r'ticketsByDateRangeProvider';
}

/// Provider for tickets filtered by complex criteria
/// Uses family to enable caching per filter combination
@ProviderFor(ticketsByFilter)
const ticketsByFilterProvider = TicketsByFilterFamily._();

/// Provider for tickets filtered by complex criteria
/// Uses family to enable caching per filter combination
final class TicketsByFilterProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for tickets filtered by complex criteria
  /// Uses family to enable caching per filter combination
  const TicketsByFilterProvider._({
    required TicketsByFilterFamily super.from,
    required TicketFilter super.argument,
  }) : super(
         retry: null,
         name: r'ticketsByFilterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketsByFilterHash();

  @override
  String toString() {
    return r'ticketsByFilterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    final argument = this.argument as TicketFilter;
    return ticketsByFilter(ref, argument);
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
    return other is TicketsByFilterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketsByFilterHash() => r'098e83638af0402d9897decebdea2b01cee574b8';

/// Provider for tickets filtered by complex criteria
/// Uses family to enable caching per filter combination
final class TicketsByFilterFamily extends $Family
    with $FunctionalFamilyOverride<List<Ticket>, TicketFilter> {
  const TicketsByFilterFamily._()
    : super(
        retry: null,
        name: r'ticketsByFilterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for tickets filtered by complex criteria
  /// Uses family to enable caching per filter combination
  TicketsByFilterProvider call(TicketFilter filter) =>
      TicketsByFilterProvider._(argument: filter, from: this);

  @override
  String toString() => r'ticketsByFilterProvider';
}

/// Provider for today's date range
@ProviderFor(todaysDateRange)
const todaysDateRangeProvider = TodaysDateRangeProvider._();

/// Provider for today's date range
final class TodaysDateRangeProvider
    extends
        $FunctionalProvider<
          TicketDateRangeFilter,
          TicketDateRangeFilter,
          TicketDateRangeFilter
        >
    with $Provider<TicketDateRangeFilter> {
  /// Provider for today's date range
  const TodaysDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysDateRangeHash();

  @$internal
  @override
  $ProviderElement<TicketDateRangeFilter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TicketDateRangeFilter create(Ref ref) {
    return todaysDateRange(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketDateRangeFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketDateRangeFilter>(value),
    );
  }
}

String _$todaysDateRangeHash() => r'3cda71fcc4b01360c86d702bed90d3b8e77d9728';

/// Provider for TODAY's tickets (used by dashboard)
@ProviderFor(todaysTickets)
const todaysTicketsProvider = TodaysTicketsProvider._();

/// Provider for TODAY's tickets (used by dashboard)
final class TodaysTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for TODAY's tickets (used by dashboard)
  const TodaysTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return todaysTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$todaysTicketsHash() => r'609a5e3d5db4cb2439639426a0d50495ec8bec07';

/// Provider for queued tickets only (used by dashboard queue section)
@ProviderFor(queuedTickets)
const queuedTicketsProvider = QueuedTicketsProvider._();

/// Provider for queued tickets only (used by dashboard queue section)
final class QueuedTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for queued tickets only (used by dashboard queue section)
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

String _$queuedTicketsHash() => r'cf3e9e00b3d5de544d3ec3e27e562d85b123fba4';

/// Provider for in-service tickets (used by dashboard)
@ProviderFor(inServiceTickets)
const inServiceTicketsProvider = InServiceTicketsProvider._();

/// Provider for in-service tickets (used by dashboard)
final class InServiceTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for in-service tickets (used by dashboard)
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

String _$inServiceTicketsHash() => r'a8ffdf89ea28e3c41ad7dbb6d0ccd441629d32fe';

/// Provider for tickets assigned to a specific technician
@ProviderFor(technicianTickets)
const technicianTicketsProvider = TechnicianTicketsFamily._();

/// Provider for tickets assigned to a specific technician
final class TechnicianTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for tickets assigned to a specific technician
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

String _$technicianTicketsHash() => r'2a970ceeee867d5363386bf2013eaf5307fb52f0';

/// Provider for tickets assigned to a specific technician
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

  /// Provider for tickets assigned to a specific technician
  TechnicianTicketsProvider call(String technicianId) =>
      TechnicianTicketsProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'technicianTicketsProvider';
}

/// Provider for ticket statistics
@ProviderFor(ticketStatistics)
const ticketStatisticsProvider = TicketStatisticsProvider._();

/// Provider for ticket statistics
final class TicketStatisticsProvider
    extends
        $FunctionalProvider<
          TicketStatistics,
          TicketStatistics,
          TicketStatistics
        >
    with $Provider<TicketStatistics> {
  /// Provider for ticket statistics
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

String _$ticketStatisticsHash() => r'0b57e5c1e79103b3d9bea7d7d9b13c37115b43f0';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
