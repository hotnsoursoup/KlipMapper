// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(invoiceRepository)
const invoiceRepositoryProvider = InvoiceRepositoryProvider._();

final class InvoiceRepositoryProvider
    extends
        $FunctionalProvider<
          DriftInvoiceRepository,
          DriftInvoiceRepository,
          DriftInvoiceRepository
        >
    with $Provider<DriftInvoiceRepository> {
  const InvoiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invoiceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invoiceRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftInvoiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftInvoiceRepository create(Ref ref) {
    return invoiceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftInvoiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftInvoiceRepository>(value),
    );
  }
}

String _$invoiceRepositoryHash() => r'27d560816a1972b96f69675fc0176a2609198066';

/// Multi-ticket checkout provider handling payment processing and invoice generation
@ProviderFor(Checkout)
const checkoutProvider = CheckoutProvider._();

/// Multi-ticket checkout provider handling payment processing and invoice generation
final class CheckoutProvider
    extends $AsyncNotifierProvider<Checkout, CheckoutState> {
  /// Multi-ticket checkout provider handling payment processing and invoice generation
  const CheckoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutHash();

  @$internal
  @override
  Checkout create() => Checkout();
}

String _$checkoutHash() => r'73803885bb370695a215c18ad181fed21a913283';

abstract class _$Checkout extends $AsyncNotifier<CheckoutState> {
  FutureOr<CheckoutState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CheckoutState>, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckoutState>, CheckoutState>,
              AsyncValue<CheckoutState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for available tickets (ready for checkout)
@ProviderFor(availableTickets)
const availableTicketsProvider = AvailableTicketsProvider._();

/// Provider for available tickets (ready for checkout)
final class AvailableTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for available tickets (ready for checkout)
  const AvailableTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return availableTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$availableTicketsHash() => r'66a896dc28f49ce5cd087370e711fdf7c228831f';

/// Provider for currently selected tickets
@ProviderFor(selectedTickets)
const selectedTicketsProvider = SelectedTicketsProvider._();

/// Provider for currently selected tickets
final class SelectedTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for currently selected tickets
  const SelectedTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return selectedTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$selectedTicketsHash() => r'9f5a5dd10e4314ec51bbf707ee5fb1c4a6bdb97e';

/// Provider for checkout calculation
@ProviderFor(checkoutCalculation)
const checkoutCalculationProvider = CheckoutCalculationProvider._();

/// Provider for checkout calculation
final class CheckoutCalculationProvider
    extends
        $FunctionalProvider<
          CheckoutCalculation,
          CheckoutCalculation,
          CheckoutCalculation
        >
    with $Provider<CheckoutCalculation> {
  /// Provider for checkout calculation
  const CheckoutCalculationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutCalculationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutCalculationHash();

  @$internal
  @override
  $ProviderElement<CheckoutCalculation> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckoutCalculation create(Ref ref) {
    return checkoutCalculation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutCalculation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutCalculation>(value),
    );
  }
}

String _$checkoutCalculationHash() =>
    r'100c3b9f29b0f4cf1ccba722fc66ea20abe2c81c';

/// Provider to check if payment can be processed
@ProviderFor(canProcessPayment)
const canProcessPaymentProvider = CanProcessPaymentProvider._();

/// Provider to check if payment can be processed
final class CanProcessPaymentProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if payment can be processed
  const CanProcessPaymentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canProcessPaymentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canProcessPaymentHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canProcessPayment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canProcessPaymentHash() => r'5231053058d98682640a691f0f51716f0e92eadd';

/// Provider for primary customer name (for multi-ticket checkout)
@ProviderFor(primaryCustomerName)
const primaryCustomerNameProvider = PrimaryCustomerNameProvider._();

/// Provider for primary customer name (for multi-ticket checkout)
final class PrimaryCustomerNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Provider for primary customer name (for multi-ticket checkout)
  const PrimaryCustomerNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'primaryCustomerNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$primaryCustomerNameHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return primaryCustomerName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$primaryCustomerNameHash() =>
    r'e0dc028d9b67a5111aed06cef4bee22e9fd5c9ac';

/// Provider for ready tickets count
@ProviderFor(readyTicketsCount)
const readyTicketsCountProvider = ReadyTicketsCountProvider._();

/// Provider for ready tickets count
final class ReadyTicketsCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for ready tickets count
  const ReadyTicketsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readyTicketsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readyTicketsCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return readyTicketsCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$readyTicketsCountHash() => r'1a08c9583747291d698393ce2b016bbeb9c7e340';

/// Provider for total available value
@ProviderFor(totalAvailableValue)
const totalAvailableValueProvider = TotalAvailableValueProvider._();

/// Provider for total available value
final class TotalAvailableValueProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Provider for total available value
  const TotalAvailableValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalAvailableValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalAvailableValueHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return totalAvailableValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$totalAvailableValueHash() =>
    r'7138f3ba41faffbe25f05c8d0a63c164b52872d0';

/// Check if a ticket is selected
@ProviderFor(isTicketSelected)
const isTicketSelectedProvider = IsTicketSelectedFamily._();

/// Check if a ticket is selected
final class IsTicketSelectedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Check if a ticket is selected
  const IsTicketSelectedProvider._({
    required IsTicketSelectedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isTicketSelectedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isTicketSelectedHash();

  @override
  String toString() {
    return r'isTicketSelectedProvider'
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
    return isTicketSelected(ref, argument);
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
    return other is IsTicketSelectedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isTicketSelectedHash() => r'772be528d57fb13107b5fa7f1c706f23d7af5b12';

/// Check if a ticket is selected
final class IsTicketSelectedFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const IsTicketSelectedFamily._()
    : super(
        retry: null,
        name: r'isTicketSelectedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check if a ticket is selected
  IsTicketSelectedProvider call(String ticketId) =>
      IsTicketSelectedProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'isTicketSelectedProvider';
}

/// Get selection summary text
@ProviderFor(selectionSummary)
const selectionSummaryProvider = SelectionSummaryProvider._();

/// Get selection summary text
final class SelectionSummaryProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Get selection summary text
  const SelectionSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionSummaryHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return selectionSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectionSummaryHash() => r'c7230901c74cadc21957dfaa2764eee59b09f2fa';

/// Get ready tickets summary text
@ProviderFor(readyTicketsSummary)
const readyTicketsSummaryProvider = ReadyTicketsSummaryProvider._();

/// Get ready tickets summary text
final class ReadyTicketsSummaryProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Get ready tickets summary text
  const ReadyTicketsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readyTicketsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readyTicketsSummaryHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return readyTicketsSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$readyTicketsSummaryHash() =>
    r'7681cab7f615792c8246cd89f759ac74a5a4eec8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
