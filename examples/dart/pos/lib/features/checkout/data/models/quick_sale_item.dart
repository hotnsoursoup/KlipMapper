// lib/features/checkout/data/models/quick_sale_item.dart
// Quick sale item model for services, products, and gift cards with technician assignment.
// Includes quantity tracking, price calculations, and validation for different service types.
// Usage: ACTIVE - Quick sale checkout, service assignment, and non-ticketed transactions

enum ServiceType { service, product, giftCard }

class QuickSaleItem {
  final String id;
  final String serviceId;
  final String serviceName;
  final double price;
  final String? assignedTechnicianId;
  final ServiceType type; // service, product, giftCard
  final int quantity;
  
  const QuickSaleItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    this.assignedTechnicianId,
    required this.type,
    this.quantity = 1,
  });
  
  QuickSaleItem copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    double? price,
    String? assignedTechnicianId,
    ServiceType? type,
    int? quantity,
  }) {
    return QuickSaleItem(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      price: price ?? this.price,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  bool get requiresTechnician => type == ServiceType.service;

  bool get isValid => !requiresTechnician || assignedTechnicianId?.isNotEmpty == true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
      'assignedTechnicianId': assignedTechnicianId,
      'type': type.name,
      'quantity': quantity,
    };
  }

  factory QuickSaleItem.fromJson(Map<String, dynamic> json) {
    return QuickSaleItem(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      price: (json['price'] as num).toDouble(),
      assignedTechnicianId: json['assignedTechnicianId'] as String?,
      type: ServiceType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => ServiceType.service,
      ),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  @override
  String toString() {
    return 'QuickSaleItem(id: $id, name: $serviceName, price: \$${price.toStringAsFixed(2)}, type: $type, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QuickSaleItem &&
      other.id == id &&
      other.serviceId == serviceId &&
      other.serviceName == serviceName &&
      other.price == price &&
      other.assignedTechnicianId == assignedTechnicianId &&
      other.type == type &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      serviceId.hashCode ^
      serviceName.hashCode ^
      price.hashCode ^
      assignedTechnicianId.hashCode ^
      type.hashCode ^
      quantity.hashCode;
  }
}