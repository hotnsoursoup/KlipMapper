// lib/features/shared/data/models/time_entry_model.dart
// Time clock entry model using Freezed for tracking employee work hours and break time.
// Includes calculated hours, formatted duration display, and status tracking for payroll integration.
// Usage: ACTIVE - Employee time tracking, payroll calculations, and work hour management

import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_entry_model.freezed.dart';
part 'time_entry_model.g.dart';

/// Time clock entry model
@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required int id,
    required int employeeId,
    required DateTime clockIn,
    DateTime? clockOut,
    @Default(0) int breakMinutes,
    double? totalHours,
    @Default('active') String status,
    String? editedBy,
    String? editReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}

/// Calculate total hours worked
extension TimeEntryX on TimeEntry {
  double get calculatedHours {
    if (clockOut == null) return 0;

    final duration = clockOut!.difference(clockIn);
    final totalMinutes = duration.inMinutes - breakMinutes;
    return totalMinutes / 60.0;
  }

  bool get isActive => status == 'active' && clockOut == null;

  String get formattedDuration {
    final hours = calculatedHours;
    final wholeHours = hours.floor();
    final minutes = ((hours - wholeHours) * 60).round();
    return '${wholeHours}h ${minutes}m';
  }
}
