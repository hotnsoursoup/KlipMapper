// lib/features/employees/data/models/employee_capability.dart
// Employee capability model defining specialized skills and service categories that staff can perform.
// Includes predefined capabilities with colors and display names for service assignment and filtering.
// Usage: ACTIVE - Employee skill tracking, service assignment rules, and capability-based scheduling

/// Employee capability model
class EmployeeCapability {
  final String id;
  final String name;
  final String displayName;
  final String color;

  const EmployeeCapability({
    required this.id,
    required this.name,
    required this.displayName,
    required this.color,
  });

  // Define standard capabilities (excluding basic mani-pedi which everyone can do)
  static const List<EmployeeCapability> standardCapabilities = [
    EmployeeCapability(
      id: 'gels',
      name: 'Gels',
      displayName: 'Gel Services',
      color: '#4A90E2',
    ),
    EmployeeCapability(
      id: 'acrylics',
      name: 'Acrylics',
      displayName: 'Acrylic Services',
      color: '#9B59B6',
    ),
    EmployeeCapability(
      id: 'dip_powder',
      name: 'Dip Powder',
      displayName: 'Dip Powder Services',
      color: '#E74C3C',
    ),
    EmployeeCapability(
      id: 'waxing',
      name: 'Waxing',
      displayName: 'Waxing Services',
      color: '#F39C12',
    ),
    EmployeeCapability(
      id: 'facials',
      name: 'Facials',
      displayName: 'Facial Services',
      color: '#27AE60',
    ),
    EmployeeCapability(
      id: 'massage',
      name: 'Massage',
      displayName: 'Massage Services',
      color: '#16A085',
    ),
    EmployeeCapability(
      id: 'nail_art',
      name: 'Nail Art',
      displayName: 'Nail Art & Design',
      color: '#E91E63',
    ),
  ];

  factory EmployeeCapability.fromJson(Map<String, dynamic> json) {
    return EmployeeCapability(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String? ?? json['name'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'color': color,
    };
  }
}