// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_tickets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(liveTicketRepository)
const liveTicketRepositoryProvider = LiveTicketRepositoryProvider._();

final class LiveTicketRepositoryProvider
    extends
        $FunctionalProvider<
          DriftTicketRepository,
          DriftTicketRepository,
          DriftTicketRepository
        >
    with $Provider<DriftTicketRepository> {
  const LiveTicketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveTicketRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveTicketRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftTicketRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftTicketRepository create(Ref ref) {
    return liveTicketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftTicketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftTicketRepository>(value),
    );
  }
}

String _$liveTicketRepositoryHash() =>
    r'2a038b415c641643fdd945ec3d330975523ebe90';

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
    r'673ccf9354c271989e1d604888284e8a84f17793';

@ProviderFor(liveTicketsToday)
const liveTicketsTodayProvider = LiveTicketsTodayProvider._();

final class LiveTicketsTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Ticket>>,
          List<Ticket>,
          Stream<List<Ticket>>
        >
    with $FutureModifier<List<Ticket>>, $StreamProvider<List<Ticket>> {
  const LiveTicketsTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveTicketsTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveTicketsTodayHash();

  @$internal
  @override
  $StreamProviderElement<List<Ticket>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Ticket>> create(Ref ref) {
    return liveTicketsToday(ref);
  }
}

String _$liveTicketsTodayHash() => r'0df72d7480520a16acb0f9023207fded1564f3f7';

@ProviderFor(clockedInTechnicianIds)
const clockedInTechnicianIdsProvider = ClockedInTechnicianIdsProvider._();

final class ClockedInTechnicianIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  const ClockedInTechnicianIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockedInTechnicianIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockedInTechnicianIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return clockedInTechnicianIds(ref);
  }
}

String _$clockedInTechnicianIdsHash() =>
    r'11d71bc187610bfe4fd89b95c766b55a319b2c97';

@ProviderFor(ticketsByTechnician)
const ticketsByTechnicianProvider = TicketsByTechnicianFamily._();

final class TicketsByTechnicianProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  const TicketsByTechnicianProvider._({
    required TicketsByTechnicianFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ticketsByTechnicianProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketsByTechnicianHash();

  @override
  String toString() {
    return r'ticketsByTechnicianProvider'
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
    return ticketsByTechnician(ref, argument);
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
    return other is TicketsByTechnicianProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketsByTechnicianHash() =>
    r'5aee49edc897ed3e68dafb84b1fc68f6ceb21829';

final class TicketsByTechnicianFamily extends $Family
    with $FunctionalFamilyOverride<List<Ticket>, String> {
  const TicketsByTechnicianFamily._()
    : super(
        retry: null,
        name: r'ticketsByTechnicianProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketsByTechnicianProvider call(String technicianId) =>
      TicketsByTechnicianProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'ticketsByTechnicianProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
