// lib/core/utils/name_formatter.dart
// Utility for consistent name formatting throughout the application, particularly for technician display names. Handles full name formatting and provides fallback logic for missing data.
// Usage: ACTIVE - Used in dashboard, appointment, and employee management features for consistent name display
/// Utility class for formatting names consistently across the app
class NameFormatter {
  /// Formats a full name as "First L." (e.g., "Isabella Nguyen" -> "Isabella N.")
  /// Returns the original name if no last name is present
  static String formatTechnicianDisplayName(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return 'Unknown';
    }
    
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      final firstName = parts[0];
      final lastInitial = parts.last[0].toUpperCase();
      return '$firstName $lastInitial.';
    }
    
    return fullName; // Return as-is if no last name
  }
  
  /// Formats a technician object's name using the displayName if available
  /// or falls back to formatting the name property
  static String formatTechnician(dynamic technician) {
    if (technician == null) {
      return 'Unknown';
    }
    
    // Try to use displayName first (already formatted)
    if (technician.displayName != null && technician.displayName.isNotEmpty) {
      return technician.displayName;
    }
    
    // Fall back to formatting the name property
    if (technician.name != null && technician.name.isNotEmpty) {
      return formatTechnicianDisplayName(technician.name);
    }
    
    // Last resort - try to get ID
    if (technician.id != null) {
      return 'Tech ${technician.id}';
    }
    
    return 'Unknown';
  }
}