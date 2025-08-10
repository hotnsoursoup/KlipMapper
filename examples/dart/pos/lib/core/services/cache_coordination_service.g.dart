// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_coordination_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CacheCoordinator)
const cacheCoordinatorProvider = CacheCoordinatorProvider._();

final class CacheCoordinatorProvider
    extends $NotifierProvider<CacheCoordinator, void> {
  const CacheCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheCoordinatorHash();

  @$internal
  @override
  CacheCoordinator create() => CacheCoordinator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$cacheCoordinatorHash() => r'b85b6307e72aee05686d9142550591c4e05fdacf';

abstract class _$CacheCoordinator extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
