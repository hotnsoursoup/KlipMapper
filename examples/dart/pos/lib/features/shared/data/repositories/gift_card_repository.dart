// lib/features/shared/data/repositories/gift_card_repository.dart
// Legacy gift card repository that requires complete Drift migration to replace deprecated DatabaseService dependency.
// All methods throw UnimplementedError until DriftGiftCardRepository is created to handle gift card operations.
// Usage: ORPHANED - Completely non-functional, requires full migration to Drift

import '../models/gift_card_model.dart';

/// Repository for gift card data management
/// CRITICAL: This repository needs full Drift migration - DatabaseService is deprecated
class GiftCardRepository {
  // Singleton pattern
  static final GiftCardRepository instance = GiftCardRepository._internal();
  GiftCardRepository._internal();

  /// All methods throw UnimplementedError until DriftGiftCardRepository is created
  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<List<GiftCard>> getAllGiftCards({bool activeOnly = true}) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<GiftCard?> getGiftCardById(String id) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<GiftCard?> getGiftCardByCode(String code) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<GiftCard> createGiftCard({
    required double amount,
    String? purchaserName,
    String? purchaserEmail,
    String? recipientName,
    String? recipientEmail,
    String? message,
    DateTime? expirationDate,
  }) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> redeemGiftCard(String giftCardId, double amount, String ticketId) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> refundToGiftCard(String originalGiftCardId, double amount, String ticketId) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> voidGiftCard(String giftCardId, String reason) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<List<Map<String, dynamic>>> getGiftCardTransactions(String giftCardId) async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<void> updateExpiredGiftCards() async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }

  @Deprecated('Needs full Drift migration - DatabaseService is deprecated')
  Future<Map<String, dynamic>> getGiftCardStats() async {
    throw UnimplementedError(
      'GiftCardRepository requires full migration to Drift. '
      'DatabaseService is deprecated and will cause runtime crashes. '
      'Create DriftGiftCardRepository to replace this functionality.'
    );
  }
}