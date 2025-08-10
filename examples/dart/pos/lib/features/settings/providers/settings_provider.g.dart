// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Repository provider - single source of truth for repository access
@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

/// Repository provider - single source of truth for repository access
final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          DriftSettingsRepository,
          DriftSettingsRepository,
          DriftSettingsRepository
        >
    with $Provider<DriftSettingsRepository> {
  /// Repository provider - single source of truth for repository access
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DriftSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DriftSettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DriftSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DriftSettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'1afbc44c3c91814514bf8e3a2ed7a2cecbdedf74';

/// Master settings provider - manages all application settings
/// This provider loads and caches all settings from the database
@ProviderFor(SettingsMaster)
const settingsMasterProvider = SettingsMasterProvider._();

/// Master settings provider - manages all application settings
/// This provider loads and caches all settings from the database
final class SettingsMasterProvider
    extends $AsyncNotifierProvider<SettingsMaster, Map<String, StoreSetting>> {
  /// Master settings provider - manages all application settings
  /// This provider loads and caches all settings from the database
  const SettingsMasterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsMasterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsMasterHash();

  @$internal
  @override
  SettingsMaster create() => SettingsMaster();
}

String _$settingsMasterHash() => r'03c53a61863286081a8ae97ed3b06a671f9c7b4e';

abstract class _$SettingsMaster
    extends $AsyncNotifier<Map<String, StoreSetting>> {
  FutureOr<Map<String, StoreSetting>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, StoreSetting>>,
              Map<String, StoreSetting>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, StoreSetting>>,
                Map<String, StoreSetting>
              >,
              AsyncValue<Map<String, StoreSetting>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Dashboard settings provider with state management
@ProviderFor(DashboardSettingsNotifier)
const dashboardSettingsNotifierProvider = DashboardSettingsNotifierProvider._();

/// Dashboard settings provider with state management
final class DashboardSettingsNotifierProvider
    extends
        $AsyncNotifierProvider<DashboardSettingsNotifier, DashboardSettings> {
  /// Dashboard settings provider with state management
  const DashboardSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSettingsNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSettingsNotifierHash();

  @$internal
  @override
  DashboardSettingsNotifier create() => DashboardSettingsNotifier();
}

String _$dashboardSettingsNotifierHash() =>
    r'24ca3b70d79aa4aa58d5eccad33132801e4ad0b8';

abstract class _$DashboardSettingsNotifier
    extends $AsyncNotifier<DashboardSettings> {
  FutureOr<DashboardSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<DashboardSettings>, DashboardSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardSettings>, DashboardSettings>,
              AsyncValue<DashboardSettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Store settings provider
@ProviderFor(storeSettings)
const storeSettingsProvider = StoreSettingsProvider._();

/// Store settings provider
final class StoreSettingsProvider
    extends $FunctionalProvider<StoreSettings, StoreSettings, StoreSettings>
    with $Provider<StoreSettings> {
  /// Store settings provider
  const StoreSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeSettingsHash();

  @$internal
  @override
  $ProviderElement<StoreSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoreSettings create(Ref ref) {
    return storeSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreSettings>(value),
    );
  }
}

String _$storeSettingsHash() => r'12850aeee7945772996a485aeb27b48970c2c90d';

/// General settings provider
@ProviderFor(generalSettings)
const generalSettingsProvider = GeneralSettingsProvider._();

/// General settings provider
final class GeneralSettingsProvider
    extends
        $FunctionalProvider<GeneralSettings, GeneralSettings, GeneralSettings>
    with $Provider<GeneralSettings> {
  /// General settings provider
  const GeneralSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generalSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generalSettingsHash();

  @$internal
  @override
  $ProviderElement<GeneralSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeneralSettings create(Ref ref) {
    return generalSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeneralSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeneralSettings>(value),
    );
  }
}

String _$generalSettingsHash() => r'c80ae4c99bd1cdd261f886b5b5a020bbd614dbc5';

/// Salon settings provider
@ProviderFor(salonSettings)
const salonSettingsProvider = SalonSettingsProvider._();

/// Salon settings provider
final class SalonSettingsProvider
    extends $FunctionalProvider<SalonSettings, SalonSettings, SalonSettings>
    with $Provider<SalonSettings> {
  /// Salon settings provider
  const SalonSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salonSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salonSettingsHash();

  @$internal
  @override
  $ProviderElement<SalonSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SalonSettings create(Ref ref) {
    return salonSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalonSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalonSettings>(value),
    );
  }
}

String _$salonSettingsHash() => r'1eb6dd52bec79f7a98bed67c2ebb1bc8a15fc3d3';

/// Background options provider
@ProviderFor(availableBackgroundOptions)
const availableBackgroundOptionsProvider =
    AvailableBackgroundOptionsProvider._();

/// Background options provider
final class AvailableBackgroundOptionsProvider
    extends
        $FunctionalProvider<
          Map<String, BackgroundOption>,
          Map<String, BackgroundOption>,
          Map<String, BackgroundOption>
        >
    with $Provider<Map<String, BackgroundOption>> {
  /// Background options provider
  const AvailableBackgroundOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableBackgroundOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableBackgroundOptionsHash();

  @$internal
  @override
  $ProviderElement<Map<String, BackgroundOption>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, BackgroundOption> create(Ref ref) {
    return availableBackgroundOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, BackgroundOption> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, BackgroundOption>>(
        value,
      ),
    );
  }
}

String _$availableBackgroundOptionsHash() =>
    r'da399f356a54f92f692196ee5de7bafe6d5765cc';

/// Get background option by key
@ProviderFor(getBackgroundOption)
const getBackgroundOptionProvider = GetBackgroundOptionFamily._();

/// Get background option by key
final class GetBackgroundOptionProvider
    extends
        $FunctionalProvider<
          BackgroundOption?,
          BackgroundOption?,
          BackgroundOption?
        >
    with $Provider<BackgroundOption?> {
  /// Get background option by key
  const GetBackgroundOptionProvider._({
    required GetBackgroundOptionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getBackgroundOptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getBackgroundOptionHash();

  @override
  String toString() {
    return r'getBackgroundOptionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BackgroundOption?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BackgroundOption? create(Ref ref) {
    final argument = this.argument as String;
    return getBackgroundOption(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackgroundOption? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackgroundOption?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetBackgroundOptionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getBackgroundOptionHash() =>
    r'4b4eb3e6785d28a19bca0eb9b0ca339152684fe3';

/// Get background option by key
final class GetBackgroundOptionFamily extends $Family
    with $FunctionalFamilyOverride<BackgroundOption?, String> {
  const GetBackgroundOptionFamily._()
    : super(
        retry: null,
        name: r'getBackgroundOptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get background option by key
  GetBackgroundOptionProvider call(String key) =>
      GetBackgroundOptionProvider._(argument: key, from: this);

  @override
  String toString() => r'getBackgroundOptionProvider';
}

/// Settings save state provider
@ProviderFor(SettingsSaveState)
const settingsSaveStateProvider = SettingsSaveStateProvider._();

/// Settings save state provider
final class SettingsSaveStateProvider
    extends $NotifierProvider<SettingsSaveState, AsyncValue<void>> {
  /// Settings save state provider
  const SettingsSaveStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSaveStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSaveStateHash();

  @$internal
  @override
  SettingsSaveState create() => SettingsSaveState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$settingsSaveStateHash() => r'df860e134a2955c5eb9197258566c2c801d9c94f';

abstract class _$SettingsSaveState extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
