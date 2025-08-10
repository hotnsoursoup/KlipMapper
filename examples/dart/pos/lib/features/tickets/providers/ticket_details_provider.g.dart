// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Pure Riverpod implementation following the UI Bible patterns
/// This provider ONLY manages the dialog form state
/// It does NOT directly interact with other providers
@ProviderFor(TicketDetails)
const ticketDetailsProvider = TicketDetailsFamily._();

/// Pure Riverpod implementation following the UI Bible patterns
/// This provider ONLY manages the dialog form state
/// It does NOT directly interact with other providers
final class TicketDetailsProvider
    extends $NotifierProvider<TicketDetails, TicketDetailsState> {
  /// Pure Riverpod implementation following the UI Bible patterns
  /// This provider ONLY manages the dialog form state
  /// It does NOT directly interact with other providers
  const TicketDetailsProvider._({
    required TicketDetailsFamily super.from,
    required ({
      Ticket? ticket,
      Customer? customer,
      bool isNewCheckIn,
      List<Service> availableServices,
      List<Technician> availableTechnicians,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'ticketDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketDetailsHash();

  @override
  String toString() {
    return r'ticketDetailsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TicketDetails create() => TicketDetails();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketDetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketDetailsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TicketDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketDetailsHash() => r'5089d318df7a73035679651c7f69faf81d2803e8';

/// Pure Riverpod implementation following the UI Bible patterns
/// This provider ONLY manages the dialog form state
/// It does NOT directly interact with other providers
final class TicketDetailsFamily extends $Family
    with
        $ClassFamilyOverride<
          TicketDetails,
          TicketDetailsState,
          TicketDetailsState,
          TicketDetailsState,
          ({
            Ticket? ticket,
            Customer? customer,
            bool isNewCheckIn,
            List<Service> availableServices,
            List<Technician> availableTechnicians,
          })
        > {
  const TicketDetailsFamily._()
    : super(
        retry: null,
        name: r'ticketDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Pure Riverpod implementation following the UI Bible patterns
  /// This provider ONLY manages the dialog form state
  /// It does NOT directly interact with other providers
  TicketDetailsProvider call({
    Ticket? ticket,
    Customer? customer,
    bool isNewCheckIn = false,
    List<Service> availableServices = const [],
    List<Technician> availableTechnicians = const [],
  }) => TicketDetailsProvider._(
    argument: (
      ticket: ticket,
      customer: customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
    ),
    from: this,
  );

  @override
  String toString() => r'ticketDetailsProvider';
}

abstract class _$TicketDetails extends $Notifier<TicketDetailsState> {
  late final _$args =
      ref.$arg
          as ({
            Ticket? ticket,
            Customer? customer,
            bool isNewCheckIn,
            List<Service> availableServices,
            List<Technician> availableTechnicians,
          });
  Ticket? get ticket => _$args.ticket;
  Customer? get customer => _$args.customer;
  bool get isNewCheckIn => _$args.isNewCheckIn;
  List<Service> get availableServices => _$args.availableServices;
  List<Technician> get availableTechnicians => _$args.availableTechnicians;

  TicketDetailsState build({
    Ticket? ticket,
    Customer? customer,
    bool isNewCheckIn = false,
    List<Service> availableServices = const [],
    List<Technician> availableTechnicians = const [],
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      ticket: _$args.ticket,
      customer: _$args.customer,
      isNewCheckIn: _$args.isNewCheckIn,
      availableServices: _$args.availableServices,
      availableTechnicians: _$args.availableTechnicians,
    );
    final ref = this.ref as $Ref<TicketDetailsState, TicketDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TicketDetailsState, TicketDetailsState>,
              TicketDetailsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
