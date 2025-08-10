// lib/features/dashboard/presentation/widgets/ticket_actions_widget.dart
// Ticket action buttons widget providing status management and service operations. Features ticket status updates, service modifications, and action callbacks for ticket lifecycle management within dashboard workflows.
// Usage: ACTIVE - Used within ticket details dialogs and dashboard ticket cards for ticket operations

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/ticket_model.dart';
import 'service_selection_widget.dart';

/// Widget for ticket action buttons (check-in, complete, checkout, etc.)
class TicketActionsWidget extends StatelessWidget {
  final Ticket? ticket;
  final bool isNewCheckIn;
  final bool canConfirm;
  final VoidCallback? onConfirm;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onBeginCheckout;
  final VoidCallback? onShowCheckout;

  const TicketActionsWidget({
    super.key,
    this.ticket,
    required this.isNewCheckIn,
    required this.canConfirm,
    this.onConfirm,
    this.onMarkComplete,
    this.onBeginCheckout,
    this.onShowCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Secondary actions for existing tickets
          if (ticket != null && !isNewCheckIn) ...[
            if (ticket!.status == 'in-service') ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleMarkComplete(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.successGreen,
                    side: BorderSide(color: AppColors.successGreen),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Mark Complete'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            if (ticket!.status == 'completed') ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleBeginCheckout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: BorderSide(color: AppColors.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Begin Checkout'),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ],
          
          // Primary action button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canConfirm ? () => _handlePrimaryAction(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _getButtonText(),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (isNewCheckIn) {
      return 'Check In Customer';
    }
    
    if (ticket != null) {
      switch (ticket!.status.toLowerCase()) {
        case 'in-service':
          return 'Mark Complete';
        case 'completed':
          return 'Begin Checkout';
        case 'paid':
          return 'View Receipt';
        default:
          return 'Save Changes';
      }
    }
    
    return 'Save Changes';
  }

  void _handlePrimaryAction(BuildContext context) {
    if (isNewCheckIn) {
      onConfirm?.call();
      return;
    }

    if (ticket != null) {
      switch (ticket!.status.toLowerCase()) {
        case 'in-service':
          _handleMarkComplete(context);
          break;
        case 'completed':
          _handleBeginCheckout(context);
          break;
        case 'paid':
          onShowCheckout?.call(); // Show receipt or payment details
          break;
        default:
          onConfirm?.call(); // Save changes
      }
    } else {
      onConfirm?.call();
    }
  }

  void _handleMarkComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Complete'),
        content: const Text('Mark this ticket as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onMarkComplete?.call();
              
              // Show checkout prompt after a brief delay
              Future.delayed(const Duration(milliseconds: 300), () {
                _showCheckoutPrompt(context);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            child: const Text('Yes, Mark Complete'),
          ),
        ],
      ),
    );
  }

  void _handleBeginCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Begin Checkout'),
        content: const Text('Proceed to checkout for this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onBeginCheckout?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('Yes, Begin Checkout'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Service Complete'),
        content: const Text('Service marked as complete. Would you like to begin checkout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onBeginCheckout?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text('Begin Checkout'),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor() {
    if (ticket?.status == 'completed') {
      return AppColors.successGreen;
    }
    if (isNewCheckIn) {
      return AppColors.primaryBlue;
    }
    return AppColors.primaryBlue;
  }
}

/// Widget for displaying ticket totals and summary (embedded in actions widget)
class EmbeddedTicketSummaryWidget extends StatelessWidget {
  final List<ServiceSelection> selectedServices;
  final Map<String, List<ServiceSelection>> memberServices;
  final bool isGroupService;
  final int groupSize;

  const EmbeddedTicketSummaryWidget({
    super.key,
    required this.selectedServices,
    required this.memberServices,
    required this.isGroupService,
    required this.groupSize,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * 0.0875; // 8.75% tax rate
    final total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Summary',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Service count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services (${_getTotalServiceCount()})',
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Group information
          if (isGroupService) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Group size: $groupSize',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${memberServices.length + 1} members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          
          const Divider(),
          
          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax (8.75%)',
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                '\$${tax.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    // Primary customer services
    double total = selectedServices.fold(0.0, (sum, selection) => sum + selection.service.price);
    
    // Group member services
    memberServices.forEach((memberName, services) {
      total += services.fold(0.0, (sum, selection) => sum + selection.service.price);
    });
    
    return total;
  }

  int _getTotalServiceCount() {
    int count = selectedServices.length;
    memberServices.forEach((memberName, services) {
      count += services.length;
    });
    return count;
  }
}