// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CustomerDetailsNotifier)
const customerDetailsNotifierProvider = CustomerDetailsNotifierFamily._();

final class CustomerDetailsNotifierProvider
    extends $NotifierProvider<CustomerDetailsNotifier, CustomerDetails> {
  const CustomerDetailsNotifierProvider._({
    required CustomerDetailsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerDetailsNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerDetailsNotifierHash();

  @override
  String toString() {
    return r'customerDetailsNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerDetailsNotifier create() => CustomerDetailsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerDetails value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerDetails>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDetailsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerDetailsNotifierHash() =>
    r'fbe516c9db1f5dd41eabfd87dd51d953ad4e27c6';

final class CustomerDetailsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerDetailsNotifier,
          CustomerDetails,
          CustomerDetails,
          CustomerDetails,
          String
        > {
  const CustomerDetailsNotifierFamily._()
    : super(
        retry: null,
        name: r'customerDetailsNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerDetailsNotifierProvider call(String customerId) =>
      CustomerDetailsNotifierProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerDetailsNotifierProvider';
}

abstract class _$CustomerDetailsNotifier extends $Notifier<CustomerDetails> {
  late final _$args = ref.$arg as String;
  String get customerId => _$args;

  CustomerDetails build(String customerId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<CustomerDetails, CustomerDetails>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CustomerDetails, CustomerDetails>,
              CustomerDetails,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
