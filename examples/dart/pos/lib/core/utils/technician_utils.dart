// lib/core/utils/technician_utils.dart
// Utility functions for technician management including name formatting, avatar generation, availability checking, and workload management. Provides consistent technician-related operations across features.
// Usage: ACTIVE - Used in dashboard, appointments, and employee management for technician display, assignment logic, and status management
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/shared/data/models/technician_model.dart';

/// Utility class for technician-related helper methods
class TechnicianUtils {
  TechnicianUtils._(); // Private constructor to prevent instantiation

  /// Get technician initials from full name
  /// Examples: "John Doe" -> "JD", "Mia" -> "M", "" -> "?"
  static String getTechnicianInitials(String name) {
    if (name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      // First and last name: "John Doe" -> "JD"
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.length == 1) {
      // Single name: "Mia" -> "M"
      return parts.first[0].toUpperCase();
    }
    
    return '?';
  }

  /// Check if technician is currently clocked in
  /// Note: This uses isOff as inverse logic until proper clock tracking is implemented
  static bool isTechnicianClockedIn(Technician technician) {
    // For now, use the inverse of isOff as a temporary implementation
    // This will be enhanced when proper clock in/out tracking is added to the model
    return !technician.isOff;
  }

  /// Get technician availability status
  static String getTechnicianStatus(Technician technician) {
    if (!isTechnicianClockedIn(technician)) {
      return 'Not clocked in';
    }
    
    return technician.isAvailable ? 'Available' : 'Currently busy';
  }

  /// Get technician status color
  static Color getTechnicianStatusColor(Technician technician) {
    if (!isTechnicianClockedIn(technician)) {
      return AppColors.textSecondary;
    }
    
    return technician.isAvailable ? AppColors.successGreen : AppColors.warningOrange;
  }

  /// Get avatar background color based on technician name
  /// Generates a consistent color based on the technician's name
  static Color getAvatarColor(String name) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.successGreen,
      AppColors.warningOrange,
      AppColors.errorRed,
    ];
    
    // Simple hash function based on name
    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  /// Get technician display name (first name + last initial)
  /// Example: "John Doe" -> "John D."
  static String getDisplayName(String fullName) {
    if (fullName.isEmpty) return 'Unknown';
    
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first} ${parts.last[0]}.';
    }
    
    return parts.first;
  }

  /// Check if technician can be assigned to services
  static bool canBeAssigned(Technician technician) {
    return isTechnicianClockedIn(technician) && technician.isAvailable;
  }

  /// Get list of available technicians from a list
  static List<Technician> getAvailableTechnicians(List<Technician> technicians) {
    return technicians.where((tech) => canBeAssigned(tech)).toList();
  }

  /// Get list of clocked-in technicians from a list
  static List<Technician> getClockedInTechnicians(List<Technician> technicians) {
    return technicians.where((tech) => isTechnicianClockedIn(tech)).toList();
  }

  /// Sort technicians by availability (available first, then busy, then clocked out)
  static List<Technician> sortByAvailability(List<Technician> technicians) {
    return List.from(technicians)..sort((a, b) {
      // Available technicians first
      if (canBeAssigned(a) && !canBeAssigned(b)) return -1;
      if (!canBeAssigned(a) && canBeAssigned(b)) return 1;
      
      // Then clocked-in but busy
      if (isTechnicianClockedIn(a) && !isTechnicianClockedIn(b)) return -1;
      if (!isTechnicianClockedIn(a) && isTechnicianClockedIn(b)) return 1;
      
      // Finally, sort by name
      return a.name.compareTo(b.name);
    });
  }

  /// Get technician's current workload description
  static String getWorkloadDescription(Technician technician) {
    if (!isTechnicianClockedIn(technician)) {
      return 'Not clocked in';
    }
    
    if (technician.isAvailable) {
      return 'Available for assignments';
    }
    
    return 'Currently serving customers';
  }

  /// Get recommended technician for a service based on availability
  static Technician? getRecommendedTechnician(
    List<Technician> technicians, {
    String? preferredTechnicianId,
  }) {
    // First, try preferred technician if specified and available
    if (preferredTechnicianId != null) {
      final preferred = technicians
          .where((tech) => tech.id == preferredTechnicianId && canBeAssigned(tech))
          .firstOrNull;
      if (preferred != null) return preferred;
    }
    
    // Otherwise, get the first available technician
    final available = getAvailableTechnicians(technicians);
    return available.isNotEmpty ? available.first : null;
  }
}