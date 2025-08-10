// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(customerRepository)
const customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          DriftCustomerRepository,
          DriftCustomerRepository,
          DriftCustomerRepository
        >
    with $Provider<DriftCustomerRepository> {
  const CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftCustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftCustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftCustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftCustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'260d8ba8766ae2638faf6cce2149300f8b34a074';

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
        isAutoDispose: false,
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

String _$ticketRepositoryHash() => r'138c38c9d6b906d56bc7f3f6a415a74fc67e3a3b';

/// Master customers provider with comprehensive state management and 10-minute cache TTL
@ProviderFor(CustomersMaster)
const customersMasterProvider = CustomersMasterProvider._();

/// Master customers provider with comprehensive state management and 10-minute cache TTL
final class CustomersMasterProvider
    extends $AsyncNotifierProvider<CustomersMaster, Map<String, Customer>> {
  /// Master customers provider with comprehensive state management and 10-minute cache TTL
  const CustomersMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customersMasterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customersMasterHash();

  @$internal
  @override
  CustomersMaster create() => CustomersMaster();
}

String _$customersMasterHash() => r'8f551a7f552f6f0f27d084a041c1d8f0b8c42c1e';

abstract class _$CustomersMaster extends $AsyncNotifier<Map<String, Customer>> {
  FutureOr<Map<String, Customer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, Customer>>, Map<String, Customer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, Customer>>,
                Map<String, Customer>
              >,
              AsyncValue<Map<String, Customer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Customer filter and search state provider
@ProviderFor(CustomerFilters)
const customerFiltersProvider = CustomerFiltersProvider._();

/// Customer filter and search state provider
final class CustomerFiltersProvider
    extends $NotifierProvider<CustomerFilters, CustomerFiltersState> {
  /// Customer filter and search state provider
  const CustomerFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerFiltersHash();

  @$internal
  @override
  CustomerFilters create() => CustomerFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerFiltersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerFiltersState>(value),
    );
  }
}

String _$customerFiltersHash() => r'bdaf3a7b262abe754d0c5529faebccb0e07b3019';

abstract class _$CustomerFilters extends $Notifier<CustomerFiltersState> {
  CustomerFiltersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CustomerFiltersState, CustomerFiltersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CustomerFiltersState, CustomerFiltersState>,
              CustomerFiltersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for filtered and sorted customers list
@ProviderFor(filteredCustomers)
const filteredCustomersProvider = FilteredCustomersProvider._();

/// Provider for filtered and sorted customers list
final class FilteredCustomersProvider
    extends $FunctionalProvider<List<Customer>, List<Customer>, List<Customer>>
    with $Provider<List<Customer>> {
  /// Provider for filtered and sorted customers list
  const FilteredCustomersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCustomersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCustomersHash();

  @$internal
  @override
  $ProviderElement<List<Customer>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Customer> create(Ref ref) {
    return filteredCustomers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Customer> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Customer>>(value),
    );
  }
}

String _$filteredCustomersHash() => r'830f35630f00005d223c61e32abb96165ffa3c6e';

/// Provider for comprehensive customer statistics
@ProviderFor(customerStatistics)
const customerStatisticsProvider = CustomerStatisticsProvider._();

/// Provider for comprehensive customer statistics
final class CustomerStatisticsProvider
    extends
        $FunctionalProvider<
          CustomerStatistics,
          CustomerStatistics,
          CustomerStatistics
        >
    with $Provider<CustomerStatistics> {
  /// Provider for comprehensive customer statistics
  const CustomerStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerStatisticsHash();

  @$internal
  @override
  $ProviderElement<CustomerStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerStatistics create(Ref ref) {
    return customerStatistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerStatistics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerStatistics>(value),
    );
  }
}

String _$customerStatisticsHash() =>
    r'd349fc7aeb9f7a0adc51a9d060911044bd5e7d62';

/// Provider for selected customer state and details
@ProviderFor(SelectedCustomer)
const selectedCustomerProvider = SelectedCustomerProvider._();

/// Provider for selected customer state and details
final class SelectedCustomerProvider
    extends $NotifierProvider<SelectedCustomer, Customer?> {
  /// Provider for selected customer state and details
  const SelectedCustomerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCustomerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCustomerHash();

  @$internal
  @override
  SelectedCustomer create() => SelectedCustomer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Customer? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Customer?>(value),
    );
  }
}

String _$selectedCustomerHash() => r'bcdeef6d8b9857ef109ebd102d12996a7bdf5eda';

abstract class _$SelectedCustomer extends $Notifier<Customer?> {
  Customer? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Customer?, Customer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Customer?, Customer?>,
              Customer?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for selected customer tickets with date filtering
@ProviderFor(selectedCustomerTickets)
const selectedCustomerTicketsProvider = SelectedCustomerTicketsProvider._();

/// Provider for selected customer tickets with date filtering
final class SelectedCustomerTicketsProvider
    extends $FunctionalProvider<List<Ticket>, List<Ticket>, List<Ticket>>
    with $Provider<List<Ticket>> {
  /// Provider for selected customer tickets with date filtering
  const SelectedCustomerTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCustomerTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCustomerTicketsHash();

  @$internal
  @override
  $ProviderElement<List<Ticket>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Ticket> create(Ref ref) {
    return selectedCustomerTickets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$selectedCustomerTicketsHash() =>
    r'74c559946cf0edbc204378b4274ea697d191567c';

/// Provider for selected customer analytics
@ProviderFor(selectedCustomerAnalytics)
const selectedCustomerAnalyticsProvider = SelectedCustomerAnalyticsProvider._();

/// Provider for selected customer analytics
final class SelectedCustomerAnalyticsProvider
    extends
        $FunctionalProvider<
          SelectedCustomerAnalytics,
          SelectedCustomerAnalytics,
          SelectedCustomerAnalytics
        >
    with $Provider<SelectedCustomerAnalytics> {
  /// Provider for selected customer analytics
  const SelectedCustomerAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCustomerAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCustomerAnalyticsHash();

  @$internal
  @override
  $ProviderElement<SelectedCustomerAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SelectedCustomerAnalytics create(Ref ref) {
    return selectedCustomerAnalytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectedCustomerAnalytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectedCustomerAnalytics>(value),
    );
  }
}

String _$selectedCustomerAnalyticsHash() =>
    r'af3255f0305b43f5efbaa3ecd4ab9113af3c4884';

/// Provider for a single customer by ID
@ProviderFor(customerById)
const customerByIdProvider = CustomerByIdFamily._();

/// Provider for a single customer by ID
final class CustomerByIdProvider
    extends $FunctionalProvider<Customer?, Customer?, Customer?>
    with $Provider<Customer?> {
  /// Provider for a single customer by ID
  const CustomerByIdProvider._({
    required CustomerByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerByIdHash();

  @override
  String toString() {
    return r'customerByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Customer?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Customer? create(Ref ref) {
    final argument = this.argument as String;
    return customerById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Customer? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Customer?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerByIdHash() => r'ee8cb1a53734d7bc50d14346c3b707dd578f3763';

/// Provider for a single customer by ID
final class CustomerByIdFamily extends $Family
    with $FunctionalFamilyOverride<Customer?, String> {
  const CustomerByIdFamily._()
    : super(
        retry: null,
        name: r'customerByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single customer by ID
  CustomerByIdProvider call(String customerId) =>
      CustomerByIdProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerByIdProvider';
}

/// Provider for customer count
@ProviderFor(customerCount)
const customerCountProvider = CustomerCountProvider._();

/// Provider for customer count
final class CustomerCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for customer count
  const CustomerCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return customerCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$customerCountHash() => r'4ee73bece7948014b11f5a63553cb82b3ba2fd4e';

/// Provider for recent customers
@ProviderFor(recentCustomers)
const recentCustomersProvider = RecentCustomersFamily._();

/// Provider for recent customers
final class RecentCustomersProvider
    extends $FunctionalProvider<List<Customer>, List<Customer>, List<Customer>>
    with $Provider<List<Customer>> {
  /// Provider for recent customers
  const RecentCustomersProvider._({
    required RecentCustomersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recentCustomersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentCustomersHash();

  @override
  String toString() {
    return r'recentCustomersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Customer>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Customer> create(Ref ref) {
    final argument = this.argument as int;
    return recentCustomers(ref, limit: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Customer> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Customer>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecentCustomersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentCustomersHash() => r'2c2431e1f8c3e9ca43893a058b7c5c2eb045bf24';

/// Provider for recent customers
final class RecentCustomersFamily extends $Family
    with $FunctionalFamilyOverride<List<Customer>, int> {
  const RecentCustomersFamily._()
    : super(
        retry: null,
        name: r'recentCustomersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for recent customers
  RecentCustomersProvider call({int limit = 10}) =>
      RecentCustomersProvider._(argument: limit, from: this);

  @override
  String toString() => r'recentCustomersProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
