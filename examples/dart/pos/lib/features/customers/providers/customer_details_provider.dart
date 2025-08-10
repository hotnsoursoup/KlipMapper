// lib/features/customers/providers/customer_details_provider.dart
// Riverpod provider for calculating detailed customer analytics including spending patterns, visit history, and service preferences.
// Aggregates data from tickets and payments to provide comprehensive customer insights with service frequency analysis.
// Usage: ACTIVE - Used in customer detail screens to display customer analytics and history

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../shared/data/repositories/drift_payment_repository.dart';
import '../../../utils/error_logger.dart';

part 'customer_details_provider.g.dart';
part 'customer_details_provider.freezed.dart';

@freezed
class CustomerDetails with _$CustomerDetails {
  const factory CustomerDetails({
    @Default(0.0) double totalSpent,
    @Default(0) int visitCount,
    @Default(0.0) double averageSpent,
    DateTime? lastVisit,
    @Default({}) Map<String, int> serviceFrequency,
    @Default([]) List<Ticket> tickets,
    @Default(false) bool isLoading,
  }) = _CustomerDetails;
}

@riverpod
class CustomerDetailsNotifier extends _$CustomerDetailsNotifier {
  @override
  CustomerDetails build(String customerId) {
    return const CustomerDetails();
  }

  Future<void> loadCustomerDetails() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final ticketRepo = DriftTicketRepository.instance;
      final paymentRepo = DriftPaymentRepository.instance;
      
      await ticketRepo.initialize();
      await paymentRepo.initialize();
      
      // Get all tickets for this customer
      final tickets = await ticketRepo.getCustomerTickets(customerId);
      
      // Calculate statistics
      double totalSpent = 0.0;
      final Map<String, int> serviceFrequency = {};
      DateTime? lastVisit;
      
      for (final ticket in tickets) {
        // Calculate total spent
        totalSpent += ticket.totalAmount ?? 0.0;
        
        // Track service frequency
        for (final service in ticket.services) {
          serviceFrequency[service.name] = (serviceFrequency[service.name] ?? 0) + 1;
        }
        
        // Track last visit
        if (lastVisit == null || ticket.checkInTime.isAfter(lastVisit)) {
          lastVisit = ticket.checkInTime;
        }
      }
      
      final visitCount = tickets.length;
      final averageSpent = visitCount > 0 ? totalSpent / visitCount : 0.0;
      
      // Sort service frequency by count
      final sortedServiceFrequency = Map.fromEntries(
        serviceFrequency.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))
      );
      
      state = CustomerDetails(
        totalSpent: totalSpent,
        visitCount: visitCount,
        averageSpent: averageSpent,
        lastVisit: lastVisit,
        serviceFrequency: sortedServiceFrequency,
        tickets: tickets,
      );
    } catch (e, stack) {
      ErrorLogger.logError('CustomerDetailsNotifier.loadCustomerDetails', e, stack);
      state = state.copyWith(isLoading: false);
    }
  }
}