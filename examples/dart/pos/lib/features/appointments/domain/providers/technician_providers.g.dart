// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Get all active technicians
@ProviderFor(activeTechnicians)
const activeTechniciansProvider = ActiveTechniciansProvider._();

/// Get all active technicians
final class ActiveTechniciansProvider
    extends $FunctionalProvider<List<Employee>, List<Employee>, List<Employee>>
    with $Provider<List<Employee>> {
  /// Get all active technicians
  const ActiveTechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTechniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTechniciansHash();

  @$internal
  @override
  $ProviderElement<List<Employee>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Employee> create(Ref ref) {
    return activeTechnicians(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Employee> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Employee>>(value),
    );
  }
}

String _$activeTechniciansHash() => r'fdb77a6cf08028cdd7ff5327590b5590c427822f';

/// Get technician by ID
@ProviderFor(technicianById)
const technicianByIdProvider = TechnicianByIdFamily._();

/// Get technician by ID
final class TechnicianByIdProvider
    extends $FunctionalProvider<Employee?, Employee?, Employee?>
    with $Provider<Employee?> {
  /// Get technician by ID
  const TechnicianByIdProvider._({
    required TechnicianByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'technicianByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianByIdHash();

  @override
  String toString() {
    return r'technicianByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Employee?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Employee? create(Ref ref) {
    final argument = this.argument as String;
    return technicianById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Employee? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Employee?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianByIdHash() => r'b507516643623b3c85b5163e0857d4cfb12d82fc';

/// Get technician by ID
final class TechnicianByIdFamily extends $Family
    with $FunctionalFamilyOverride<Employee?, String> {
  const TechnicianByIdFamily._()
    : super(
        retry: null,
        name: r'technicianByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get technician by ID
  TechnicianByIdProvider call(String technicianId) =>
      TechnicianByIdProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'technicianByIdProvider';
}

/// Get technician display name
@ProviderFor(technicianDisplayName)
const technicianDisplayNameProvider = TechnicianDisplayNameFamily._();

/// Get technician display name
final class TechnicianDisplayNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Get technician display name
  const TechnicianDisplayNameProvider._({
    required TechnicianDisplayNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'technicianDisplayNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianDisplayNameHash();

  @override
  String toString() {
    return r'technicianDisplayNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return technicianDisplayName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianDisplayNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianDisplayNameHash() =>
    r'82619bff542a31ff6823612694aff5ba88483e60';

/// Get technician display name
final class TechnicianDisplayNameFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  const TechnicianDisplayNameFamily._()
    : super(
        retry: null,
        name: r'technicianDisplayNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get technician display name
  TechnicianDisplayNameProvider call(String technicianId) =>
      TechnicianDisplayNameProvider._(argument: technicianId, from: this);

  @override
  String toString() => r'technicianDisplayNameProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
