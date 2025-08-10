// lib/features/appointments/data/models/traffic_data_point.dart
// Minimal traffic/appointment overlay models to satisfy AppointmentIconOverlay.
// These are lightweight structs used for graph overlays and do not
// depend on the main Appointment repository types.

import 'package:flutter/material.dart';

/// Compact appointment slot for traffic overlays
class AppointmentSlot {
  final String id;
  final String technicianId;
  final String technicianName;
  final String categoryId;
  final DateTime startTime;
  final DateTime endTime;
  final String customerName;

  const AppointmentSlot({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.categoryId,
    required this.startTime,
    required this.endTime,
    required this.customerName,
  });
}

/// A single data point on the traffic graph with its appointments
class TrafficDataPoint {
  final DateTime timestamp;
  final List<AppointmentSlot> appointments;

  const TrafficDataPoint({
    required this.timestamp,
    required this.appointments,
  });
}

/// Day-level traffic data containing multiple points and business hours
class DayTrafficData {
  final DateTime businessDate;
  final TimeOfDay businessStartTime;
  final TimeOfDay businessEndTime;
  final List<TrafficDataPoint> dataPoints;

  const DayTrafficData({
    required this.businessDate,
    required this.businessStartTime,
    required this.businessEndTime,
    required this.dataPoints,
  });
}

