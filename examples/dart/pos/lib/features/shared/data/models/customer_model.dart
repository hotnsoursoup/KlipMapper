// lib/features/shared/data/models/customer_model.dart
// Unified Freezed customer data model matching Drift database schema with loyalty points, preferences, and contact information.
// Usage: ACTIVE - Core customer data model used throughout the application
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// Unified Customer model that matches Drift database schema
/// This replaces all previous customer model versions
@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    @Default(0) int loyaltyPoints,
    DateTime? lastVisit,
    String? preferredTechnician,
    String? notes,
    String? allergies,
    @Default(false) bool emailOptIn,
    @Default(false) bool smsOptIn,
    @Default('active') String status,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Customer;

  /// Backward compatible constructor that accepts name and splits it
  factory Customer.withName({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    int loyaltyPoints = 0,
    DateTime? lastVisit,
    String? preferredTechnician,
    String? notes,
    String? allergies,
    bool emailOptIn = false,
    bool smsOptIn = false,
    String status = 'active',
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';
    
    return Customer(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      loyaltyPoints: loyaltyPoints,
      lastVisit: lastVisit,
      preferredTechnician: preferredTechnician,
      notes: notes,
      allergies: allergies,
      emailOptIn: emailOptIn,
      smsOptIn: smsOptIn,
      status: status,
      isActive: isActive,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  const Customer._();

  /// Computed property for full name
  String get name => '$firstName $lastName'.trim();

  /// Convert to legacy Customer model for backward compatibility
  Map<String, dynamic> toLegacyCustomer() {
    return {
      'id': id,
      'name': name,
      'phone': phone ?? '',
      'email': email,
      'preferredTechnicianId': preferredTechnician,
      'lastVisit': lastVisit?.toIso8601String(),
      'notes': notes,
      'membershipLevel': membershipLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert from legacy Customer model
  factory Customer.fromLegacyCustomer(Map<String, dynamic> legacy) {
    final nameParts = (legacy['name'] as String? ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    return Customer(
      id: legacy['id'] as String,
      firstName: firstName,
      lastName: lastName,
      phone: legacy['phone'] as String?,
      email: legacy['email'] as String?,
      preferredTechnician: legacy['preferredTechnicianId'] as String?,
      lastVisit: legacy['lastVisit'] != null
          ? DateTime.tryParse(legacy['lastVisit'] as String)
          : null,
      notes: legacy['notes'] as String?,
      createdAt: legacy['createdAt'] != null
          ? DateTime.tryParse(legacy['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: legacy['updatedAt'] != null
          ? DateTime.tryParse(legacy['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert from CustomerV2 model
  factory Customer.fromV2(Map<String, dynamic> v2) {
    final nameParts = (v2['name'] as String? ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    return Customer(
      id: v2['id'] as String,
      firstName: firstName,
      lastName: lastName,
      phone: v2['phone'] as String?,
      email: v2['email'] as String?,
      loyaltyPoints: v2['loyaltyPoints'] as int? ?? 0,
      preferredTechnician: v2['preferredTechnicianId'] as String?,
      lastVisit: v2['lastVisit'] != null
          ? DateTime.tryParse(v2['lastVisit'] as String)
          : null,
      notes: v2['notes'] as String?,
      createdAt: v2['createdAt'] != null
          ? DateTime.tryParse(v2['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: v2['updatedAt'] != null
          ? DateTime.tryParse(v2['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert from Drift database object
  factory Customer.fromDrift(Map<String, dynamic> drift) {
    return Customer(
      id: drift['id'] as String,
      firstName: drift['first_name'] as String? ?? '',
      lastName: drift['last_name'] as String? ?? '',
      email: drift['email'] as String?,
      phone: drift['phone'] as String?,
      dateOfBirth: drift['date_of_birth'] as String?,
      gender: drift['gender'] as String?,
      address: drift['address'] as String?,
      city: drift['city'] as String?,
      state: drift['state'] as String?,
      zipCode: drift['zip_code'] as String?,
      loyaltyPoints: drift['loyalty_points'] as int? ?? 0,
      lastVisit: drift['last_visit'] != null
          ? DateTime.tryParse(drift['last_visit'] as String)
          : null,
      preferredTechnician: drift['preferred_technician'] as String?,
      notes: drift['notes'] as String?,
      allergies: drift['allergies'] as String?,
      emailOptIn: (drift['email_opt_in'] as int? ?? 0) == 1,
      smsOptIn: (drift['sms_opt_in'] as int? ?? 0) == 1,
      status: drift['status'] as String? ?? 'active',
      isActive: (drift['is_active'] as int? ?? 1) == 1,
      createdAt: drift['created_at'] != null
          ? DateTime.tryParse(drift['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: drift['updated_at'] != null
          ? DateTime.tryParse(drift['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert to Drift database format
  Map<String, dynamic> toDrift() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'loyalty_points': loyaltyPoints,
      'last_visit': lastVisit?.toIso8601String(),
      'preferred_technician': preferredTechnician,
      'notes': notes,
      'allergies': allergies,
      'email_opt_in': emailOptIn ? 1 : 0,
      'sms_opt_in': smsOptIn ? 1 : 0,
      'status': status,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get membership level based on loyalty points
  String get membershipLevel {
    if (loyaltyPoints >= 1000) return 'Platinum';
    if (loyaltyPoints >= 500) return 'Gold';
    if (loyaltyPoints >= 100) return 'Silver';
    return 'Regular';
  }

  /// Add loyalty points
  Customer addLoyaltyPoints(int points) {
    return copyWith(
      loyaltyPoints: loyaltyPoints + points,
      updatedAt: DateTime.now(),
    );
  }

  /// Update last visit
  Customer updateLastVisit({DateTime? visitTime}) {
    return copyWith(
      lastVisit: visitTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}