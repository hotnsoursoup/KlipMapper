// lib/core/utils/ticket_utils.dart
// Utility functions for ticket management including status formatting, price calculations, priority handling, and business logic checks. Provides consistent ticket operations across dashboard and checkout features.
// Usage: ACTIVE - Used throughout dashboard, checkout, and reporting features for ticket display, status management, and calculation logic
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/shared/data/models/ticket_model.dart';

/// Utility class for ticket-related helper methods
class TicketUtils {
  TicketUtils._(); // Private constructor to prevent instantiation

  /// Format price to currency string
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Get status color based on ticket status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.successGreen;
      case 'in-service':
        return AppColors.warningOrange;
      case 'queued':
        return AppColors.primaryBlue;
      case 'paid':
        return AppColors.successGreen;
      case 'assigned':
        return AppColors.primaryBlue;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Get readable status label
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in-service':
        return 'In Service';
      case 'queued':
        return 'Queued';
      case 'paid':
        return 'Paid';
      case 'assigned':
        return 'Assigned';
      default:
        return status;
    }
  }

  /// Calculate total service time for a ticket
  static int calculateTotalServiceTime(Ticket ticket) {
    return ticket.services.fold<int>(
      0, 
      (total, service) => total + service.durationMinutes,
    );
  }

  /// Calculate total ticket value
  static double calculateTotalValue(Ticket ticket) {
    return ticket.services.fold<double>(
      0.0, 
      (total, service) => total + service.basePrice,
    );
  }

  /// Get priority label and color
  static ({String label, Color color}) getPriorityInfo(int? priority) {
    switch (priority) {
      case 1:
        return (label: 'High', color: AppColors.errorRed);
      case 2:
        return (label: 'Medium', color: AppColors.warningOrange);
      case 3:
        return (label: 'Low', color: AppColors.primaryBlue);
      default:
        return (label: 'Normal', color: AppColors.textSecondary);
    }
  }

  /// Check if ticket is ready for checkout
  static bool isReadyForCheckout(Ticket ticket) {
    return ticket.status == 'completed' || ticket.status == 'in-service';
  }

  /// Check if ticket is overdue (more than expected service time)
  /// Note: This method kept for business logic, but time calculations should use AppDataFormatter
  static bool isOverdue(Ticket ticket) {
    final expectedDuration = calculateTotalServiceTime(ticket);
    final actualDuration = DateTime.now().difference(ticket.checkInTime).inMinutes;
    return actualDuration > (expectedDuration + 15); // 15 min buffer
  }

  /// Format services list to readable string
  static String formatServicesList(Ticket ticket, {int maxServices = 2}) {
    if (ticket.services.isEmpty) return 'No services';
    
    final serviceNames = ticket.services.take(maxServices).map((s) => s.name);
    final result = serviceNames.join(', ');
    
    if (ticket.services.length > maxServices) {
      final remaining = ticket.services.length - maxServices;
      return '$result +$remaining more';
    }
    
    return result;
  }
}