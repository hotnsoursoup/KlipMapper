// lib/features/shared/data/models/invoice_model.dart
// Invoice model for tracking multiple tickets paid together in a single transaction.
// Supports payment methods, discounts, taxes, and Drift database integration with JSON parsing.
// Usage: ACTIVE - Used for checkout processing, payment tracking, and invoice generation

import 'dart:convert';

/// Invoice model for tracking multiple tickets paid together
class Invoice {
  final String id;
  final String invoiceNumber;
  final List<String> ticketIds;
  final String? customerName;
  final double subtotal;
  final double taxAmount;
  final double tipAmount;
  final double discountAmount;
  final double totalAmount;
  final String paymentMethod;
  final String? discountType;
  final String? discountCode;
  final String? discountReason;
  final String? cardType;
  final String? lastFourDigits;
  final String? transactionId;
  final String? authorizationCode;
  final DateTime processedAt;
  final int processedBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.ticketIds,
    this.customerName,
    required this.subtotal,
    required this.taxAmount,
    required this.tipAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paymentMethod,
    this.discountType,
    this.discountCode,
    this.discountReason,
    this.cardType,
    this.lastFourDigits,
    this.transactionId,
    this.authorizationCode,
    required this.processedAt,
    required this.processedBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    List<String>? ticketIds,
    String? customerName,
    double? subtotal,
    double? taxAmount,
    double? tipAmount,
    double? discountAmount,
    double? totalAmount,
    String? paymentMethod,
    String? discountType,
    String? discountCode,
    String? discountReason,
    String? cardType,
    String? lastFourDigits,
    String? transactionId,
    String? authorizationCode,
    DateTime? processedAt,
    int? processedBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      ticketIds: ticketIds ?? this.ticketIds,
      customerName: customerName ?? this.customerName,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountType: discountType ?? this.discountType,
      discountCode: discountCode ?? this.discountCode,
      discountReason: discountReason ?? this.discountReason,
      cardType: cardType ?? this.cardType,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      transactionId: transactionId ?? this.transactionId,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'ticketIds': ticketIds,
      'customerName': customerName,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'tipAmount': tipAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'discountType': discountType,
      'discountCode': discountCode,
      'discountReason': discountReason,
      'cardType': cardType,
      'lastFourDigits': lastFourDigits,
      'transactionId': transactionId,
      'authorizationCode': authorizationCode,
      'processedAt': processedAt.toIso8601String(),
      'processedBy': processedBy,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      ticketIds: (json['ticketIds'] as List<dynamic>).cast<String>(),
      customerName: json['customerName'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      tipAmount: (json['tipAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      discountType: json['discountType'] as String?,
      discountCode: json['discountCode'] as String?,
      discountReason: json['discountReason'] as String?,
      cardType: json['cardType'] as String?,
      lastFourDigits: json['lastFourDigits'] as String?,
      transactionId: json['transactionId'] as String?,
      authorizationCode: json['authorizationCode'] as String?,
      processedAt: DateTime.parse(json['processedAt'] as String),
      processedBy: (json['processedBy'] as num).toInt(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert from Drift database record
  factory Invoice.fromDrift(dynamic driftInvoice) {
    List<String> ticketIds = [];
    if (driftInvoice.ticketIds != null && driftInvoice.ticketIds!.isNotEmpty) {
      try {
        final decoded = json.decode(driftInvoice.ticketIds!);
        if (decoded is List) {
          ticketIds = decoded.cast<String>();
        }
      } catch (e) {
        // Handle parsing error gracefully
        ticketIds = [];
      }
    }

    return Invoice(
      id: driftInvoice.id,
      invoiceNumber: driftInvoice.invoiceNumber,
      ticketIds: ticketIds,
      customerName: driftInvoice.customerName,
      subtotal: driftInvoice.subtotal,
      taxAmount: driftInvoice.taxAmount,
      tipAmount: driftInvoice.tipAmount,
      discountAmount: driftInvoice.discountAmount,
      totalAmount: driftInvoice.totalAmount,
      paymentMethod: driftInvoice.paymentMethod,
      discountType: driftInvoice.discountType,
      discountCode: driftInvoice.discountCode,
      discountReason: driftInvoice.discountReason,
      cardType: driftInvoice.cardType,
      lastFourDigits: driftInvoice.lastFourDigits,
      transactionId: driftInvoice.transactionId,
      authorizationCode: driftInvoice.authorizationCode,
      processedAt: DateTime.parse(driftInvoice.processedAt),
      processedBy: int.tryParse(driftInvoice.processedBy?.toString() ?? '0') ?? 0,
      notes: driftInvoice.notes,
      createdAt: DateTime.parse(driftInvoice.createdAt),
      updatedAt: DateTime.parse(driftInvoice.updatedAt),
    );
  }

  /// Generate a human-readable invoice number
  static String generateInvoiceNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8); // Last 5 digits
    return 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$timestamp';
  }

  /// Calculate total items count
  int get itemCount => ticketIds.length;

  /// Get main customer name or default
  String get displayCustomerName => customerName ?? 'Multiple Customers';

  /// Check if this is a multi-ticket invoice
  bool get isMultiTicket => ticketIds.length > 1;

  /// Get formatted total amount
  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  /// Get formatted subtotal
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';

  /// Get formatted tax amount
  String get formattedTax => '\$${taxAmount.toStringAsFixed(2)}';

  /// Get formatted tip amount
  String get formattedTip => '\$${tipAmount.toStringAsFixed(2)}';

  /// Get formatted discount amount
  String get formattedDiscount => discountAmount > 0 ? '-\$${discountAmount.toStringAsFixed(2)}' : '\$0.00';

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, ticketCount: ${ticketIds.length}, total: $formattedTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Invoice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
