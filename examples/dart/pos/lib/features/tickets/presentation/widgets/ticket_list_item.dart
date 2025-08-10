// lib/features/tickets/presentation/widgets/ticket_list_item.dart
// Expandable ticket list item widget displaying ticket summary and detailed service information.
// Shows ticket header with expand/collapse functionality, customer info, status, and management actions for completed tickets.
// Usage: ACTIVE - Used in tickets screen for displaying ticket information in a collapsible list format

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/service_model.dart';

class TicketListItem extends StatelessWidget {
  final Ticket ticket;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onRefund;
  final VoidCallback onVoid;
  final VoidCallback onEdit;

  const TicketListItem({
    super.key,
    required this.ticket,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onRefund,
    required this.onVoid,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header row (always visible)
          InkWell(
            onTap: onToggleExpanded,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  // Ticket number
                  Text(
                    '#${ticket.ticketNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Customer name and group size
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          ticket.customer.name,
                          style: AppTextStyles.bodyMedium,
                        ),
                        if (ticket.isGroupService && ticket.groupSize != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.servicePurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.servicePurple.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${ticket.groupSize} people',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.servicePurple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.status.replaceAll('-', ' '),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(ticket.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Total amount
                  SizedBox(
                    width: 80,
                    child: Text(
                      '\$${ticket.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Date
                  Text(
                    _formatDate(ticket.checkInTime),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Action buttons
                  if (ticket.status == 'completed' || ticket.status == 'paid') ...[
                    TextButton(
                      onPressed: onRefund,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Refund'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onVoid,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Void'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Expanded content
          if (isExpanded) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Services section
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Services',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...ticket.services.map((service) => _buildServiceRow(service)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Type:', ticket.type == 'walk-in' ? 'Walk-in' : 'Appointment'),
                        const SizedBox(height: 8),
                        if (ticket.paymentStatus != null)
                          _buildDetailRow('Notes:', 'Prefers light colors.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceRow(Service service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // TODO: Look up technician name by ID
          // if (service.technicianId != null) ...[
          //   SizedBox(
          //     width: 120,
          //     child: Text(
          //       'Tech name here:',
          //       style: AppTextStyles.bodySmall,
          //     ),
          //   ),
          //   const SizedBox(width: 8),
          // ],
          Expanded(
            child: Row(
              children: [
                Text(
                  service.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${service.price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return AppColors.successGreen;
      case 'in-service':
        return AppColors.primaryBlue;
      case 'queued':
        return AppColors.warningOrange;
      case 'cancelled':
      case 'refunded':
        return AppColors.errorRed;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}