// lib/features/employees/data/models/clock_in_order_entry.dart
// Model representing an employee's clock-in entry with timestamp and formatted display time.
// Usage: ACTIVE - Used in employee screen to display clock-in order list
import '../../../shared/data/models/employee_model.dart';

/// Model for representing a clock-in entry in the daily clock-in order list
class ClockInOrderEntry {
  final Employee employee;
  final DateTime clockInTime;
  final String formattedTime;

  ClockInOrderEntry({
    required this.employee,
    required this.clockInTime,
    required this.formattedTime,
  });

  /// Create from a map (for compatibility with existing code)
  factory ClockInOrderEntry.fromMap(Map<String, dynamic> map, Employee employee) {
    final time = map['time'] ?? DateTime.now().toIso8601String();
    final clockInTime = time is DateTime ? time : DateTime.parse(time);
    
    // Format time as HH:MM AM/PM
    final hour = clockInTime.hour;
    final minute = clockInTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return ClockInOrderEntry(
      employee: employee,
      clockInTime: clockInTime,
      formattedTime: '$displayHour:$minute $period',
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employee.id,
      'name': employee.fullName,
      'time': clockInTime.toIso8601String(),
      'formattedTime': formattedTime,
    };
  }
}