// lib/features/appointments/providers/appointment_index_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/data/models/appointment_model.dart';
import 'appointment_providers.dart';

part 'appointment_index_providers.g.dart';

/// Map<id, Appointment> for the currently selected date (or today via your logic)
@Riverpod(keepAlive: true)
class AppointmentsByIdForSelectedDate extends _$AppointmentsByIdForSelectedDate {
  @override
  Map<String, Appointment> build() {
    // seed once; then we’ll subscribe to the stream below
    ref.listen<List<Appointment>>(
      selectedDateAppointmentsStreamProvider,
      (prev, next) {
        final data = next.valueOrNull ?? const <Appointment>[];
        final map = {for (final a in data) a.id: a};
        state = map;
      },
      fireImmediately: true,
    );

    return const <String, Appointment>{};
  }
}
