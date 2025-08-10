// lib/features/shared/data/models/ticket_model.dart
// Ticket data model with service relationships, group member support, and category mapping functionality for queue management.
// Usage: ACTIVE - Core ticket data model used throughout queue and service management systems
import 'service_model.dart';
import 'customer_model.dart';
import 'payment_model.dart';

// Helper function to map category names to IDs
int _getCategoryIdFromName(String categoryName) {
  switch (categoryName) {
    case 'Nails':
      return 1;
    case 'Gel':
      return 2;
    case 'Acrylic':
      return 3;
    case 'Waxing':
      return 4;
    case 'Facials':
      return 5;
    case 'SNS/Dip':
      return 6;
    default:
      return 1; // Default to Nails
  }
}

/// Group member in a ticket
class GroupMember {
  final String? customerId;
  final String name;
  final String type; // 'adult', 'child'
  final bool isGuest;

  const GroupMember({
    this.customerId,
    required this.name,
    required this.type,
    this.isGuest = false,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      customerId: json['customerId'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'customerId': customerId,
    'name': name,
    'type': type,
    'isGuest': isGuest,
  };
}

/// Service within a ticket
class TicketService {
  final String serviceId;
  final String? customerId;
  final String? guestName;
  final String technicianId;
  final String status; // 'pending', 'in-progress', 'completed'
  final bool addOn;
  final double price;
  final String? serviceName;
  final String? serviceCategory;
  final int? durationMinutes;

  const TicketService({
    required this.serviceId,
    this.customerId,
    this.guestName,
    required this.technicianId,
    required this.status,
    required this.addOn,
    required this.price,
    this.serviceName,
    this.serviceCategory,
    this.durationMinutes,
  });

  bool get isGuestService => guestName != null && customerId == null;

  factory TicketService.fromJson(Map<String, dynamic> json) {
    return TicketService(
      serviceId: json['serviceId'] as String,
      customerId: json['customerId'] as String?,
      guestName: json['guestName'] as String?,
      technicianId: json['technicianId'] as String? ?? '',
      status: json['status'] as String,
      addOn: json['addOn'] as bool,
      price: (json['price'] as num).toDouble(),
      serviceName: json['serviceName'] as String?,
      serviceCategory: json['serviceCategory'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'customerId': customerId,
    'guestName': guestName,
    'technicianId': technicianId,
    'status': status,
    'addOn': addOn,
    'price': price,
    'serviceName': serviceName,
    'serviceCategory': serviceCategory,
    'durationMinutes': durationMinutes,
  };

  TicketService copyWith({
    String? serviceId,
    String? customerId,
    String? guestName,
    String? technicianId,
    String? status,
    bool? addOn,
    double? price,
    String? serviceName,
    String? serviceCategory,
    int? durationMinutes,
  }) {
    return TicketService(
      serviceId: serviceId ?? this.serviceId,
      customerId: customerId ?? this.customerId,
      guestName: guestName ?? this.guestName,
      technicianId: technicianId ?? this.technicianId,
      status: status ?? this.status,
      addOn: addOn ?? this.addOn,
      price: price ?? this.price,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

/// Central Ticket model that links everything together
class Ticket {
  final String id;
  final String ticketNumber; // e.g., "109" (daily increment)
  final Customer customer; // Primary customer (for compatibility)
  final List<Service> services; // Legacy services list
  final String status; // 'queued', 'assigned', 'in-service', 'completed', 'paid'
  final String type; // 'walk-in', 'appointment'
  final int? priority; // 0 = normal, 1+ = priority levels (higher = more urgent)
  final DateTime checkInTime;
  final DateTime? appointmentTime;
  final String? assignedTechnicianId;
  final String? requestedTechnicianId;
  final String? requestedTechnicianName; // For display
  final double? totalAmount;
  final String? paymentStatus;
  final bool isGroupService;
  final int? groupSize;
  final bool? isConfirmed;
  final DateTime? confirmedAt;
  final String? appointmentId; // Reference to the original appointment
  
  // New fields for enhanced ticket model
  final String? primaryCustomerId;
  final List<GroupMember> groupMembers;
  final List<TicketService> ticketServices;
  final Payment? payment;
  final DateTime? updatedAt;

  const Ticket({
    required this.id,
    required this.ticketNumber,
    required this.customer,
    required this.services,
    required this.status,
    required this.type,
    this.priority,
    required this.checkInTime,
    this.appointmentTime,
    this.assignedTechnicianId,
    this.requestedTechnicianId,
    this.requestedTechnicianName,
    this.totalAmount,
    this.paymentStatus,
    this.isGroupService = false,
    this.groupSize,
    this.isConfirmed,
    this.confirmedAt,
    this.appointmentId,
    this.primaryCustomerId,
    this.groupMembers = const [],
    this.ticketServices = const [],
    this.payment,
    this.updatedAt,
  });

  // Calculate wait time in minutes
  int get waitTimeMinutes {
    if (status == 'completed' || status == 'paid') return 0;
    return DateTime.now().difference(checkInTime).inMinutes;
  }
  
  // Computed properties for enhanced model
  bool get isGroup => groupMembers.length > 1;
  double get subtotal => ticketServices.fold(0.0, (sum, s) => sum + s.price);
  List<String> get involvedTechnicianIds => 
    ticketServices.map((s) => s.technicianId).where((id) => id.isNotEmpty).toSet().toList();
  bool get allServicesCompleted => 
    ticketServices.isNotEmpty && ticketServices.every((s) => s.status == 'completed');

  // Format wait time for display
  String get formattedWaitTime {
    final minutes = waitTimeMinutes;
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  // Format check-in time
  String get formattedCheckInTime {
    final hour = checkInTime.hour;
    final minute = checkInTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return 'In: $displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    // Handle both legacy and enhanced ticket formats
    final groupMembers = json['groupMembers'] != null
        ? (json['groupMembers'] as List).map((m) => GroupMember.fromJson(m)).toList()
        : <GroupMember>[];
    
    final ticketServices = json['services'] != null && json['services'] is List && 
        (json['services'] as List).isNotEmpty && 
        (json['services'][0] as Map<String, dynamic>).containsKey('serviceId')
        ? (json['services'] as List).map((s) => TicketService.fromJson(s)).toList()
        : <TicketService>[];
    
    // Create primary customer from first group member if needed
    Customer primaryCustomer;
    if (json['customer'] != null) {
      primaryCustomer = Customer.fromJson(json['customer'] as Map<String, dynamic>);
    } else if (groupMembers.isNotEmpty && groupMembers.first.customerId != null) {
      // Create minimal customer from group member
      primaryCustomer = Customer.withName(
        id: groupMembers.first.customerId!,
        name: groupMembers.first.name,
        phone: '',
      );
    } else {
      // Fallback customer
      primaryCustomer = Customer.withName(
        id: json['primaryCustomerId'] as String? ?? 'unknown',
        name: 'Unknown Customer',
        phone: '',
      );
    }
    
    // Convert enhanced services to legacy services if needed
    final legacyServices = json['services'] != null && json['services'] is List && 
        (json['services'] as List).isNotEmpty && 
        !(json['services'][0] as Map<String, dynamic>).containsKey('serviceId')
        ? (json['services'] as List).map((s) => Service.fromJson(s as Map<String, dynamic>)).toList()
        : ticketServices.map((ts) => Service(
            id: ts.serviceId,
            name: ts.serviceName ?? 'Service',
            description: '',
            categoryId: _getCategoryIdFromName(ts.serviceCategory ?? 'Other'),
            basePrice: ts.price,
            durationMinutes: ts.durationMinutes ?? 30,
            isActive: true,
            createdAt: DateTime.now(),
          ),).toList();
    
    return Ticket(
      id: json['id'] as String,
      ticketNumber: json['ticketNumber'] as String? ?? json['id'] as String,
      customer: primaryCustomer,
      services: legacyServices,
      status: json['status'] as String,
      type: json['type'] as String,
      priority: json['priority'] as int?,
      checkInTime: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.parse(json['checkInTime'] as String),
      appointmentTime: json['appointmentTime'] != null
          ? DateTime.parse(json['appointmentTime'] as String)
          : null,
      assignedTechnicianId: json['assignedTechnicianId'] as String?,
      requestedTechnicianId: json['requestedTechnicianId'] as String?,
      requestedTechnicianName: json['requestedTechnicianName'] as String?,
      totalAmount: json['totalAmount'] != null
          ? (json['totalAmount'] as num).toDouble()
          : null,
      paymentStatus: json['paymentStatus'] as String? ?? json['payment']?['status'] as String?,
      isGroupService: json['isGroupService'] as bool? ?? groupMembers.length > 1,
      groupSize: json['groupSize'] as int? ?? groupMembers.length,
      isConfirmed: json['isConfirmed'] as bool?,
      primaryCustomerId: json['primaryCustomerId'] as String?,
      groupMembers: groupMembers,
      ticketServices: ticketServices,
      payment: json['payment'] != null 
          ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Ticket copyWith({
    String? id,
    String? ticketNumber,
    Customer? customer,
    List<Service>? services,
    String? status,
    String? type,
    int? priority,
    DateTime? checkInTime,
    DateTime? appointmentTime,
    String? assignedTechnicianId,
    String? requestedTechnicianId,
    String? requestedTechnicianName,
    double? totalAmount,
    String? paymentStatus,
    bool? isGroupService,
    int? groupSize,
    bool? isConfirmed,
    DateTime? confirmedAt,
    String? primaryCustomerId,
    List<GroupMember>? groupMembers,
    List<TicketService>? ticketServices,
    Payment? payment,
    DateTime? updatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      customer: customer ?? this.customer,
      services: services ?? this.services,
      status: status ?? this.status,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      checkInTime: checkInTime ?? this.checkInTime,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      requestedTechnicianId: requestedTechnicianId ?? this.requestedTechnicianId,
      requestedTechnicianName: requestedTechnicianName ?? this.requestedTechnicianName,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isGroupService: isGroupService ?? this.isGroupService,
      groupSize: groupSize ?? this.groupSize,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      primaryCustomerId: primaryCustomerId ?? this.primaryCustomerId,
      groupMembers: groupMembers ?? this.groupMembers,
      ticketServices: ticketServices ?? this.ticketServices,
      payment: payment ?? this.payment,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'customer': customer.toJson(),
      'services': services.map((s) => s.toJson()).toList(),
      'status': status,
      'type': type,
      'checkInTime': checkInTime.toIso8601String(),
      'appointmentTime': appointmentTime?.toIso8601String(),
      'assignedTechnicianId': assignedTechnicianId,
      'requestedTechnicianId': requestedTechnicianId,
      'requestedTechnicianName': requestedTechnicianName,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'isGroupService': isGroupService,
      'groupSize': groupSize,
    };
  }
}
