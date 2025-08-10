// lib/features/dashboard/presentation/widgets/customer_selection_widget.dart
// Customer selection widget for check-in process with search functionality and walk-in support. Features customer search, selection confirmation, and automatic "Adult" customer creation for walk-ins.
// Usage: ACTIVE - Core component of check-in dialog and appointment management workflows

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/customer_model.dart';

/// A widget for handling customer selection and confirmation in the check-in process.
/// 
/// Features:
/// * Two-state display: search/selection mode and confirmed customer mode
/// * Walk-in customer handling with automatic "Adult" customer creation
/// * Confirmed customer display with customer details and status badge
/// * Visual feedback with color-coded states and icons
/// * Customer avatar with initial letter display
/// 
/// Usage:
/// ```dart
/// CustomerSelectionWidget(
///   selectedCustomer: selectedCustomer,
///   customerConfirmed: isConfirmed,
///   onCustomerSelected: (customer) => setState(() => _selectedCustomer = customer),
///   onCustomerConfirmed: (customer) => _confirmCustomer(customer),
///   checkInType: 'walk-in', // or 'appointment'
/// )
/// ```
class CustomerSelectionWidget extends StatefulWidget {
  final Customer? selectedCustomer;
  final bool customerConfirmed;
  final Function(Customer) onCustomerSelected;
  final Function(Customer) onCustomerConfirmed;
  final String checkInType;

  const CustomerSelectionWidget({
    super.key,
    required this.selectedCustomer,
    required this.customerConfirmed,
    required this.onCustomerSelected,
    required this.onCustomerConfirmed,
    required this.checkInType,
  });

  @override
  State<CustomerSelectionWidget> createState() => _CustomerSelectionWidgetState();
}

class _CustomerSelectionWidgetState extends State<CustomerSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.customerConfirmed && widget.selectedCustomer != null) {
      return _buildConfirmedCustomer();
    }

    if (widget.checkInType == 'walk-in') {
      return _buildCustomerSearch();
    }

    return const SizedBox.shrink();
  }

  Widget _buildConfirmedCustomer() {
    final customer = widget.selectedCustomer!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (customer.phone?.isNotEmpty == true)
                  Text(
                    customer.phone!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (customer.email?.isNotEmpty == true)
                  Text(
                    customer.email!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Confirmed',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
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

  Widget _buildCustomerSearch() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(
              Icons.person_add,
              color: AppColors.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Walk-in Customer',
            style: AppTextStyles.headline3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continue without customer details',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final adultCustomer = Customer.withName(
                  id: 'walk_in_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'Adult',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                widget.onCustomerSelected(adultCustomer);
                widget.onCustomerConfirmed(adultCustomer);
              },
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text('Continue as Adult'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}