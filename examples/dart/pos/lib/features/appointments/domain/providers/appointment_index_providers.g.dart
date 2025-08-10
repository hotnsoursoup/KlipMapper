// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_index_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Map<id, Appointment> for the currently selected date (or today via your logic)
@ProviderFor(AppointmentsByIdForSelectedDate)
const appointmentsByIdForSelectedDateProvider =
    AppointmentsByIdForSelectedDateProvider._();

/// Map<id, Appointment> for the currently selected date (or today via your logic)
final class AppointmentsByIdForSelectedDateProvider
    extends
        $NotifierProvider<
          AppointmentsByIdForSelectedDate,
          Map<String, Appointment>
        > {
  /// Map<id, Appointment> for the currently selected date (or today via your logic)
  const AppointmentsByIdForSelectedDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsByIdForSelectedDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsByIdForSelectedDateHash();

  @$internal
  @override
  AppointmentsByIdForSelectedDate create() => AppointmentsByIdForSelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Appointment> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Appointment>>(value),
    );
  }
}

String _$appointmentsByIdForSelectedDateHash() =>
    r'5db7c4b98e4a394b22ba4c6d212792f840b0d50d';

abstract class _$AppointmentsByIdForSelectedDate
    extends $Notifier<Map<String, Appointment>> {
  Map<String, Appointment> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<String, Appointment>, Map<String, Appointment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Appointment>, Map<String, Appointment>>,
              Map<String, Appointment>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
