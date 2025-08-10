// lib/core/services/technician_lookup_service.dart
// Static utility service for handling technician lookups, "Any" technician logic, and ticket assignment decisions. Provides centralized logic for technician name resolution and queue management.
// Usage: ACTIVE - Used throughout dashboard and appointment features for technician assignment and display logic
import '../../features/shared/data/models/technician_model.dart';

/// Service for handling technician lookups and "Any" technician logic
class TechnicianLookupService {
  static const String anyTechnicianId = '-1';
  static const String anyTechnicianName = 'Any';
  
  /// Check if a technician ID represents "Any" technician
  static bool isAnyTechnician(String? technicianId) {
    return technicianId == null || 
           technicianId.isEmpty ||
           technicianId == '0' ||
           technicianId == '-1' ||
           technicianId == anyTechnicianId;
  }
  
  /// Get technician name, returning "Any" for unassigned
  static String getTechnicianName(String? technicianId, List<Technician> technicians) {
    if (isAnyTechnician(technicianId)) {
      return anyTechnicianName;
    }
    
    try {
      final technician = technicians.firstWhere((t) => t.id == technicianId);
      return technician.name;
    } catch (_) {
      return anyTechnicianName; // Fallback to "Any" if technician not found
    }
  }
  
  /// Find technician by ID, returning null for "Any"
  static Technician? findTechnician(String? technicianId, List<Technician> technicians) {
    if (isAnyTechnician(technicianId)) {
      return null;
    }
    
    try {
      return technicians.firstWhere((t) => t.id == technicianId);
    } catch (_) {
      return null; // Return null if technician not found
    }
  }
  
  /// Create a virtual "Any" technician entry (useful for dropdowns)
  static Technician createAnyTechnicianEntry() {
    return Technician(
      id: anyTechnicianId,
      name: anyTechnicianName,
      status: 'available',
      turnNumber: -1,
      avatarColor: '#9E9E9E', // Gray color as hex string
      avatarInitial: 'A',
      specializations: [],
    );
  }
  
  /// Get display text for UI (e.g., "Tech: Any" or "Tech: John Smith")
  static String getDisplayText(String? technicianId, List<Technician> technicians, {String prefix = 'Tech'}) {
    final name = getTechnicianName(technicianId, technicians);
    return '$prefix: $name';
  }
  
  /// Check if a ticket should be considered unassigned/in queue
  static bool shouldBeInQueue(String? assignedTechnicianId, String status) {
    return status == 'queued' && isAnyTechnician(assignedTechnicianId);
  }
  
  /// Check if a ticket should go directly to a technician card
  static bool shouldGoToTechnicianCard(String? assignedTechnicianId, String status, List<Technician> availableTechnicians) {
    // Only if assigned to a specific technician and they're available/clocked in
    if (isAnyTechnician(assignedTechnicianId)) {
      return false;
    }
    
    final technician = findTechnician(assignedTechnicianId, availableTechnicians);
    return technician != null && !technician.isOff && technician.status == 'available';
  }
}