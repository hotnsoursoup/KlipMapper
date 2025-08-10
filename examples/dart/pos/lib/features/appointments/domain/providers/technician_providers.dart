// lib/features/appointments/domain/providers/technician_providers.dart
// Specialized providers for technician data filtering from the employees system for appointment management.
// Provides active technicians list, technician lookup by ID, and display name resolution for appointment screens.
// Usage: ACTIVE - Used by appointment booking and management screens to populate technician dropdowns and display names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../employees/providers/employees_provider.dart';
import '../../../shared/data/models/employee_model.dart';

part 'technician_providers.g.dart';

// ========== TECHNICIAN PROVIDERS ==========
// Provides technician-related data for appointments

/// Get all active technicians
@riverpod
List<Employee> activeTechnicians(Ref ref) {
  // Use the employees provider to get technicians
  final employeesAsync = ref.watch(employeesMasterProvider);
  
  return employeesAsync.when(
    data: (employees) {
      // Filter for active technicians
      return employees.where((emp) => 
        emp.role.toLowerCase() == 'technician' && 
        (emp.isActive ?? true)
      ).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Get technician by ID
@riverpod
Employee? technicianById(Ref ref, String technicianId) {
  final technicians = ref.watch(activeTechniciansProvider);
  
  try {
    final id = int.tryParse(technicianId);
    if (id == null) return null;
    
    return technicians.firstWhere(
      (tech) => tech.id == id,
      orElse: () => throw Exception('Technician not found'),
    );
  } catch (_) {
    return null;
  }
}

/// Get technician display name
@riverpod
String technicianDisplayName(Ref ref, String technicianId) {
  final technician = ref.watch(technicianByIdProvider(technicianId));
  return technician?.fullName ?? 'Unknown Technician';
}