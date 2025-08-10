// lib/features/shared/data/models/technician_model.dart
// Technician model for managing staff members with status tracking, capabilities, and turn-based service assignment.
// Includes avatar generation, display name formatting, and service specialization management.
// Usage: ACTIVE - Core staff management, turn tracking, and service assignment logic

/// Technician model
class Technician {
  final String id;
  final String name;
  final int turnNumber;
  final String status; // 'available', 'busy', 'break', 'off'
  final String? currentTicketId; // Currently working on
  final String? assignedTicketId; // Next in queue
  final bool isOff;
  final List<String> capabilities;
  final List<String> specializations; // Service categories this technician specializes in
  final String avatarColor; // For display purposes
  final String avatarInitial;

  const Technician({
    required this.id,
    required this.name,
    required this.turnNumber,
    required this.status,
    this.currentTicketId,
    this.assignedTicketId,
    this.isOff = false,
    this.capabilities = const [],
    this.specializations = const [], // Default to empty list
    required this.avatarColor,
    required this.avatarInitial,
  });

  bool get isAvailable => status == 'available' && !isOff;
  bool get canAcceptNewTicket => isAvailable && assignedTicketId == null;
  bool get hasAssignedTicket => assignedTicketId != null;
  bool get isWorking => currentTicketId != null;
  
  /// Returns the name with last name as initial only (e.g., "Isabella N.")
  String get displayName {
    final parts = name.trim().split(' ');
    if (parts.length <= 1) {
      return name; // Return as-is if no last name
    }
    
    final firstName = parts[0];
    final lastNameInitial = parts.last[0].toUpperCase();
    return '$firstName $lastNameInitial.';
  }

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] as String,
      name: json['name'] as String,
      turnNumber: json['turn'] as int? ?? json['turnNumber'] as int? ?? 1,
      status: json['status'] as String,
      currentTicketId: json['currentTicketId'] as String?,
      assignedTicketId: json['assignedTicketId'] as String?,
      isOff: json['isOff'] as bool? ?? false,
      capabilities: (json['capabilities'] as List<dynamic>?)?.cast<String>() ?? [],
      avatarColor: json['avatarColor'] as String? ?? _getDefaultAvatarColor(json['name'] as String),
      avatarInitial: json['avatarInitial'] as String? ?? _getInitial(json['name'] as String),
    );
  }
  
  static String _getDefaultAvatarColor(String name) {
    final colors = ['green', 'purple', 'blue', 'orange', 'pink'];
    final index = name.length % colors.length;
    return colors[index];
  }
  
  static String _getInitial(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : 'T';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'turn': turnNumber,
      'status': status,
      'currentTicketId': currentTicketId,
      'assignedTicketId': assignedTicketId,
      'isOff': isOff,
      'capabilities': capabilities,
      'avatarColor': avatarColor,
      'avatarInitial': avatarInitial,
    };
  }

  Technician copyWith({
    String? id,
    String? name,
    int? turnNumber,
    String? status,
    String? currentTicketId,
    String? assignedTicketId,
    bool? isOff,
    List<String>? capabilities,
    List<String>? specializations,
    String? avatarColor,
    String? avatarInitial,
  }) {
    return Technician(
      id: id ?? this.id,
      name: name ?? this.name,
      turnNumber: turnNumber ?? this.turnNumber,
      status: status ?? this.status,
      currentTicketId: currentTicketId ?? this.currentTicketId,
      assignedTicketId: assignedTicketId ?? this.assignedTicketId,
      isOff: isOff ?? this.isOff,
      capabilities: capabilities ?? this.capabilities,
      specializations: specializations ?? this.specializations,
      avatarColor: avatarColor ?? this.avatarColor,
      avatarInitial: avatarInitial ?? this.avatarInitial,
    );
  }
}
