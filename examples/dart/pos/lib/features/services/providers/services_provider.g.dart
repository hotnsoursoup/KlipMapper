// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Repository provider - single source of truth for repository access
@ProviderFor(serviceRepository)
const serviceRepositoryProvider = ServiceRepositoryProvider._();

/// Repository provider - single source of truth for repository access
final class ServiceRepositoryProvider
    extends
        $FunctionalProvider<
          DriftServiceRepository,
          DriftServiceRepository,
          DriftServiceRepository
        >
    with $Provider<DriftServiceRepository> {
  /// Repository provider - single source of truth for repository access
  const ServiceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftServiceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftServiceRepository create(Ref ref) {
    return serviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftServiceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftServiceRepository>(value),
    );
  }
}

String _$serviceRepositoryHash() => r'b031fcc12b8104ce5324fd33c4e86eb4a244bda3';

/// Master services provider - single source of truth for ALL services
/// This is the ONLY provider that fetches services from the database
@ProviderFor(ServicesMaster)
const servicesMasterProvider = ServicesMasterProvider._();

/// Master services provider - single source of truth for ALL services
/// This is the ONLY provider that fetches services from the database
final class ServicesMasterProvider
    extends $AsyncNotifierProvider<ServicesMaster, List<Service>> {
  /// Master services provider - single source of truth for ALL services
  /// This is the ONLY provider that fetches services from the database
  const ServicesMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicesMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicesMasterHash();

  @$internal
  @override
  ServicesMaster create() => ServicesMaster();
}

String _$servicesMasterHash() => r'b1e8f93f9bce019f6328fe3e0e5f4f50013b20f7';

abstract class _$ServicesMaster extends $AsyncNotifier<List<Service>> {
  FutureOr<List<Service>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Service>>, List<Service>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Service>>, List<Service>>,
              AsyncValue<List<Service>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Master service categories provider
@ProviderFor(ServiceCategoriesMaster)
const serviceCategoriesMasterProvider = ServiceCategoriesMasterProvider._();

/// Master service categories provider
final class ServiceCategoriesMasterProvider
    extends
        $AsyncNotifierProvider<
          ServiceCategoriesMaster,
          List<db.ServiceCategory>
        > {
  /// Master service categories provider
  const ServiceCategoriesMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceCategoriesMasterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceCategoriesMasterHash();

  @$internal
  @override
  ServiceCategoriesMaster create() => ServiceCategoriesMaster();
}

String _$serviceCategoriesMasterHash() =>
    r'3d6d08c304c1202989309e34481a7de553d705b1';

abstract class _$ServiceCategoriesMaster
    extends $AsyncNotifier<List<db.ServiceCategory>> {
  FutureOr<List<db.ServiceCategory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<db.ServiceCategory>>,
              List<db.ServiceCategory>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<db.ServiceCategory>>,
                List<db.ServiceCategory>
              >,
              AsyncValue<List<db.ServiceCategory>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for services filtered by criteria
/// Uses family to enable caching per filter combination
@ProviderFor(servicesByFilter)
const servicesByFilterProvider = ServicesByFilterFamily._();

/// Provider for services filtered by criteria
/// Uses family to enable caching per filter combination
final class ServicesByFilterProvider
    extends $FunctionalProvider<List<Service>, List<Service>, List<Service>>
    with $Provider<List<Service>> {
  /// Provider for services filtered by criteria
  /// Uses family to enable caching per filter combination
  const ServicesByFilterProvider._({
    required ServicesByFilterFamily super.from,
    required ServiceFilter super.argument,
  }) : super(
         retry: null,
         name: r'servicesByFilterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesByFilterHash();

  @override
  String toString() {
    return r'servicesByFilterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Service>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Service> create(Ref ref) {
    final argument = this.argument as ServiceFilter;
    return servicesByFilter(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Service> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Service>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesByFilterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesByFilterHash() => r'00fe4c08e8e0e70c520ade0ed1e708183da20155';

/// Provider for services filtered by criteria
/// Uses family to enable caching per filter combination
final class ServicesByFilterFamily extends $Family
    with $FunctionalFamilyOverride<List<Service>, ServiceFilter> {
  const ServicesByFilterFamily._()
    : super(
        retry: null,
        name: r'servicesByFilterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for services filtered by criteria
  /// Uses family to enable caching per filter combination
  ServicesByFilterProvider call(ServiceFilter filter) =>
      ServicesByFilterProvider._(argument: filter, from: this);

  @override
  String toString() => r'servicesByFilterProvider';
}

/// Provider for services by category
@ProviderFor(servicesByCategory)
const servicesByCategoryProvider = ServicesByCategoryFamily._();

/// Provider for services by category
final class ServicesByCategoryProvider
    extends $FunctionalProvider<List<Service>, List<Service>, List<Service>>
    with $Provider<List<Service>> {
  /// Provider for services by category
  const ServicesByCategoryProvider._({
    required ServicesByCategoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'servicesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesByCategoryHash();

  @override
  String toString() {
    return r'servicesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Service>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Service> create(Ref ref) {
    final argument = this.argument as int;
    return servicesByCategory(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Service> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Service>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesByCategoryHash() =>
    r'23e0c696b76ae7d056d1d416c90b64fe912d5954';

/// Provider for services by category
final class ServicesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<List<Service>, int> {
  const ServicesByCategoryFamily._()
    : super(
        retry: null,
        name: r'servicesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for services by category
  ServicesByCategoryProvider call(int categoryId) =>
      ServicesByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'servicesByCategoryProvider';
}

/// Provider for active services only
@ProviderFor(activeServices)
const activeServicesProvider = ActiveServicesProvider._();

/// Provider for active services only
final class ActiveServicesProvider
    extends $FunctionalProvider<List<Service>, List<Service>, List<Service>>
    with $Provider<List<Service>> {
  /// Provider for active services only
  const ActiveServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeServicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeServicesHash();

  @$internal
  @override
  $ProviderElement<List<Service>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Service> create(Ref ref) {
    return activeServices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Service> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Service>>(value),
    );
  }
}

String _$activeServicesHash() => r'2bf6aff68b98ee235e3962b57c9c4feeca5c4d7b';

/// Provider for services grouped by category
@ProviderFor(servicesGroupedByCategory)
const servicesGroupedByCategoryProvider = ServicesGroupedByCategoryProvider._();

/// Provider for services grouped by category
final class ServicesGroupedByCategoryProvider
    extends
        $FunctionalProvider<
          Map<int, List<Service>>,
          Map<int, List<Service>>,
          Map<int, List<Service>>
        >
    with $Provider<Map<int, List<Service>>> {
  /// Provider for services grouped by category
  const ServicesGroupedByCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'servicesGroupedByCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$servicesGroupedByCategoryHash();

  @$internal
  @override
  $ProviderElement<Map<int, List<Service>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, List<Service>> create(Ref ref) {
    return servicesGroupedByCategory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, List<Service>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, List<Service>>>(value),
    );
  }
}

String _$servicesGroupedByCategoryHash() =>
    r'ff59a1193fdfe8864108db2935d9738626a9eeb9';

/// Provider for service by ID
@ProviderFor(serviceById)
const serviceByIdProvider = ServiceByIdFamily._();

/// Provider for service by ID
final class ServiceByIdProvider
    extends $FunctionalProvider<Service?, Service?, Service?>
    with $Provider<Service?> {
  /// Provider for service by ID
  const ServiceByIdProvider._({
    required ServiceByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'serviceByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceByIdHash();

  @override
  String toString() {
    return r'serviceByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Service?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Service? create(Ref ref) {
    final argument = this.argument as int;
    return serviceById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Service? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Service?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceByIdHash() => r'143c369ed88bd995d98c339e2fbb335c863bfb3a';

/// Provider for service by ID
final class ServiceByIdFamily extends $Family
    with $FunctionalFamilyOverride<Service?, int> {
  const ServiceByIdFamily._()
    : super(
        retry: null,
        name: r'serviceByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for service by ID
  ServiceByIdProvider call(int serviceId) =>
      ServiceByIdProvider._(argument: serviceId, from: this);

  @override
  String toString() => r'serviceByIdProvider';
}

/// Provider for service statistics
@ProviderFor(serviceStatistics)
const serviceStatisticsProvider = ServiceStatisticsProvider._();

/// Provider for service statistics
final class ServiceStatisticsProvider
    extends
        $FunctionalProvider<
          ServiceStatistics,
          ServiceStatistics,
          ServiceStatistics
        >
    with $Provider<ServiceStatistics> {
  /// Provider for service statistics
  const ServiceStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceStatisticsHash();

  @$internal
  @override
  $ProviderElement<ServiceStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServiceStatistics create(Ref ref) {
    return serviceStatistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServiceStatistics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServiceStatistics>(value),
    );
  }
}

String _$serviceStatisticsHash() => r'beed09eebd1874b93f105362e3675c46b7693c3a';

/// Search query for services screen
@ProviderFor(ServiceSearchQuery)
const serviceSearchQueryProvider = ServiceSearchQueryProvider._();

/// Search query for services screen
final class ServiceSearchQueryProvider
    extends $NotifierProvider<ServiceSearchQuery, String> {
  /// Search query for services screen
  const ServiceSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceSearchQueryHash();

  @$internal
  @override
  ServiceSearchQuery create() => ServiceSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$serviceSearchQueryHash() =>
    r'434e5f71ffad0d7a2150be0f56325cb04a8a6b7f';

abstract class _$ServiceSearchQuery extends $Notifier<String> {
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

/// Selected category filter
@ProviderFor(ServiceCategoryFilter)
const serviceCategoryFilterProvider = ServiceCategoryFilterProvider._();

/// Selected category filter
final class ServiceCategoryFilterProvider
    extends $NotifierProvider<ServiceCategoryFilter, int?> {
  /// Selected category filter
  const ServiceCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceCategoryFilterHash();

  @$internal
  @override
  ServiceCategoryFilter create() => ServiceCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$serviceCategoryFilterHash() =>
    r'9c439a5d7e84b32af70004fb79b8d462fb4e1506';

abstract class _$ServiceCategoryFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Show inactive services toggle
@ProviderFor(ShowInactiveServices)
const showInactiveServicesProvider = ShowInactiveServicesProvider._();

/// Show inactive services toggle
final class ShowInactiveServicesProvider
    extends $NotifierProvider<ShowInactiveServices, bool> {
  /// Show inactive services toggle
  const ShowInactiveServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showInactiveServicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showInactiveServicesHash();

  @$internal
  @override
  ShowInactiveServices create() => ShowInactiveServices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showInactiveServicesHash() =>
    r'7c2ae69338f0e815fe1c96eb33ad37365179a559';

abstract class _$ShowInactiveServices extends $Notifier<bool> {
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

/// Expanded categories in UI
@ProviderFor(ExpandedServiceCategories)
const expandedServiceCategoriesProvider = ExpandedServiceCategoriesProvider._();

/// Expanded categories in UI
final class ExpandedServiceCategoriesProvider
    extends $NotifierProvider<ExpandedServiceCategories, Set<int>> {
  /// Expanded categories in UI
  const ExpandedServiceCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expandedServiceCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expandedServiceCategoriesHash();

  @$internal
  @override
  ExpandedServiceCategories create() => ExpandedServiceCategories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$expandedServiceCategoriesHash() =>
    r'af002bf5dbc7e068c32dbef505592d59f5a62fff';

abstract class _$ExpandedServiceCategories extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
