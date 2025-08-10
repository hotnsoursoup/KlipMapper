// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_assignment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Ticket assignment provider for managing assignments and auto-assignment
/// Converted from ticket_assignment_store.dart
@ProviderFor(TicketAssignment)
const ticketAssignmentProvider = TicketAssignmentProvider._();

/// Ticket assignment provider for managing assignments and auto-assignment
/// Converted from ticket_assignment_store.dart
final class TicketAssignmentProvider
    extends $NotifierProvider<TicketAssignment, TicketAssignmentState> {
  /// Ticket assignment provider for managing assignments and auto-assignment
  /// Converted from ticket_assignment_store.dart
  const TicketAssignmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketAssignmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketAssignmentHash();

  @$internal
  @override
  TicketAssignment create() => TicketAssignment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketAssignmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketAssignmentState>(value),
    );
  }
}

String _$ticketAssignmentHash() => r'c1028ba8b92a31fe5e8f87439e54ee3c91bbf1cb';

abstract class _$TicketAssignment extends $Notifier<TicketAssignmentState> {
  TicketAssignmentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TicketAssignmentState, TicketAssignmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TicketAssignmentState, TicketAssignmentState>,
              TicketAssignmentState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Total assignments count
@ProviderFor(totalAssignments)
const totalAssignmentsProvider = TotalAssignmentsProvider._();

/// Total assignments count
final class TotalAssignmentsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Total assignments count
  const TotalAssignmentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalAssignmentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalAssignmentsHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalAssignments(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalAssignmentsHash() => r'b4e7279bfa9bfc0b6df56a81e1426a934c0b3b3e';

/// Get assigned technician ID for a ticket
@ProviderFor(getAssignedTechnicianId)
const getAssignedTechnicianIdProvider = GetAssignedTechnicianIdFamily._();

/// Get assigned technician ID for a ticket
final class GetAssignedTechnicianIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Get assigned technician ID for a ticket
  const GetAssignedTechnicianIdProvider._({
    required GetAssignedTechnicianIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getAssignedTechnicianIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAssignedTechnicianIdHash();

  @override
  String toString() {
    return r'getAssignedTechnicianIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return getAssignedTechnicianId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAssignedTechnicianIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAssignedTechnicianIdHash() =>
    r'4f173142d522e9c11ecb51032f6005253cd3494e';

/// Get assigned technician ID for a ticket
final class GetAssignedTechnicianIdFamily extends $Family
    with $FunctionalFamilyOverride<String?, String> {
  const GetAssignedTechnicianIdFamily._()
    : super(
        retry: null,
        name: r'getAssignedTechnicianIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get assigned technician ID for a ticket
  GetAssignedTechnicianIdProvider call(String ticketId) =>
      GetAssignedTechnicianIdProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'getAssignedTechnicianIdProvider';
}

/// Get tickets for a technician
@ProviderFor(getTicketsForTechnician)
const getTicketsForTechnicianProvider = GetTicketsForTechnicianFamily._();

/// Get tickets for a technician
final class GetTicketsForTechnicianProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Get tickets for a technician
  const GetTicketsForTechnicianProvider._({
    required GetTicketsForTechnicianFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getTicketsForTechnicianProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getTicketsForTechnicianHash();

  @override
  String toString() {
    return r'getTicketsForTechnicianProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as String;
    return getTicketsForTechnician(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetTicketsForTechnicianProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTicketsForTechnicianHash() =>
    r'a2b45e313e62c92e69c67339bd11acf5e7784d89';

/// Get tickets for a technician
final class GetTicketsForTechnicianFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, String> {
  const GetTicketsForTechnicianFamily._()
    : super(
        retry: null,
        name: r'getTicketsForTechnicianProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get tickets for a technician
  GetTicketsForTechnicianProvider call(String technicianId) =>
      GetTicketsForTechnicianProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'getTicketsForTechnicianProvider';
}

/// Check if ticket is assigned
@ProviderFor(isTicketAssigned)
const isTicketAssignedProvider = IsTicketAssignedFamily._();

/// Check if ticket is assigned
final class IsTicketAssignedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Check if ticket is assigned
  const IsTicketAssignedProvider._({
    required IsTicketAssignedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isTicketAssignedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isTicketAssignedHash();

  @override
  String toString() {
    return r'isTicketAssignedProvider'
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
    return isTicketAssigned(ref, argument);
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
    return other is IsTicketAssignedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isTicketAssignedHash() => r'f5bf153ea415971ae3f397c8a78a87c03791659d';

/// Check if ticket is assigned
final class IsTicketAssignedFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const IsTicketAssignedFamily._()
    : super(
        retry: null,
        name: r'isTicketAssignedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check if ticket is assigned
  IsTicketAssignedProvider call(String ticketId) =>
      IsTicketAssignedProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'isTicketAssignedProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
