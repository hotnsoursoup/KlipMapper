// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Dashboard UI state provider using pure Riverpod.
/// This Notifier manages the immutable DashboardUIState.
@ProviderFor(DashboardUI)
const dashboardUIProvider = DashboardUIProvider._();

/// Dashboard UI state provider using pure Riverpod.
/// This Notifier manages the immutable DashboardUIState.
final class DashboardUIProvider
    extends $NotifierProvider<DashboardUI, DashboardUIState> {
  /// Dashboard UI state provider using pure Riverpod.
  /// This Notifier manages the immutable DashboardUIState.
  const DashboardUIProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardUIProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardUIHash();

  @$internal
  @override
  DashboardUI create() => DashboardUI();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardUIState>(value),
    );
  }
}

String _$dashboardUIHash() => r'562d96f83d61d2a94319a47f715ca3e64b07a1eb';

abstract class _$DashboardUI extends $Notifier<DashboardUIState> {
  DashboardUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DashboardUIState, DashboardUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DashboardUIState, DashboardUIState>,
              DashboardUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(hasOpenDialogs)
const hasOpenDialogsProvider = HasOpenDialogsProvider._();

final class HasOpenDialogsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const HasOpenDialogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasOpenDialogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasOpenDialogsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasOpenDialogs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasOpenDialogsHash() => r'6a822d91206d52be650be2ad7dddcd54a77d37d5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
