// lib/features/shared/data/repositories/ticket_repository.dart
// Legacy ticket repository wrapper providing backwards compatibility while delegating operations to DriftTicketRepository.
// Includes category mapping utilities and maintains legacy API surface for existing ticket management code.
// Usage: ACTIVE - Used by legacy code, but deprecated in favor of DriftTicketRepository

import '../models/ticket_model.dart';
import 'drift_ticket_repository.dart';
import '../../../../utils/error_logger.dart';

// Helper to parse category ID  
int _parseCategoryId(dynamic category) {
  if (category is int) {
    return category;
  } else if (category is String) {
    // Map string categories to IDs
    switch (category.toLowerCase()) {
      case 'nails':
      case 'manicure':
      case 'pedicure':
        return 1;
      case 'gel':
        return 2;
      case 'acrylic':
        return 3;
      case 'waxing':
      case 'wax':
        return 4;
      case 'facials':
      case 'facial':
        return 5;
      case 'sns/dip':
      case 'sns':
      case 'dip':
        return 6;
      default:
        return 1; // Default to Nails
    }
  }
  return 1;
}

/// Repository for ticket data management
/// DEPRECATED: Use DriftTicketRepository directly
class TicketRepository {
  final DriftTicketRepository _driftRepo = DriftTicketRepository.instance;
  
  // Singleton pattern
  static final TicketRepository instance = TicketRepository._internal();
  TicketRepository._internal();

  /// Get all tickets from local database
  Future<List<Ticket>> getAllTickets() async {
    return getTickets();
  }

  /// Get tickets with optional filters
  Future<List<Ticket>> getTickets({String? status, String? type}) async {
    try {
      return await _driftRepo.getTickets(status: status, type: type);
    } catch (e, stack) {
      ErrorLogger.logError('Error in TicketRepository.getTickets', e, stack);
      return [];
    }
  }

  /// Get single ticket by ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      return await _driftRepo.getTicketById(id);
    } catch (e, stack) {
      ErrorLogger.logError('Error in TicketRepository.getTicketById', e, stack);
      return null;
    }
  }

  /// Create new ticket
  Future<Ticket> createTicket(Ticket ticket) async {
    try {
      final ticketId = await _driftRepo.insertTicket(ticket);
      return ticket.copyWith(id: ticketId);
    } catch (e, stack) {
      ErrorLogger.logError('Error in TicketRepository.createTicket', e, stack);
      rethrow;
    }
  }

  /// Update ticket
  @Deprecated('Use DriftTicketRepository.updateTicket() with Ticket model')
  Future<void> updateTicket(String id, Map<String, dynamic> updates) async {
    throw UnimplementedError(
      'Legacy TicketRepository.updateTicket() is deprecated. '
      'Use DriftTicketRepository.instance.updateTicket() with a Ticket model instead.'
    );
  }

  /// Assign technician to ticket
  Future<void> assignTechnician(String ticketId, String technicianId) async {
    try {
      await _driftRepo.assignTechnician(ticketId, technicianId);
    } catch (e, stack) {
      ErrorLogger.logError('Error in TicketRepository.assignTechnician', e, stack);
      rethrow;
    }
  }
}
