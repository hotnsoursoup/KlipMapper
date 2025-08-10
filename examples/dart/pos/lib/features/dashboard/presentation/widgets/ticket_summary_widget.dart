// lib/features/dashboard/presentation/widgets/ticket_summary_widget.dart
// Ticket summary widget displaying service breakdown, pricing, and totals. Features service itemization, pricing calculations, and summary formatting for ticket overview and checkout processes.
// Usage: ACTIVE - Used in ticket details dialogs and checkout screens for ticket summary display

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'service_selection_widget.dart';

/// Widget that shows payment summary for ticket
class TicketSummaryWidget extends StatelessWidget {
  final List<ServiceSelection> selectedServices;
  final Map<String, List<ServiceSelection>> memberServices;
  final bool isGroupService;
  final int groupSize;

  const TicketSummaryWidget({
    super.key,
    required this.selectedServices,
    required this.memberServices,
    required this.isGroupService,
    required this.groupSize,
  });

  double get subtotal {
    double total = selectedServices.fold(0.0, (sum, sel) => sum + sel.service.price);
    memberServices.forEach((_, services) {
      total += services.fold(0.0, (sum, sel) => sum + sel.service.price);
    });
    return total;
  }

  double get tax => subtotal * 0.0875; // 8.75% tax rate
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.receipt_long, size: 20, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Payment Summary',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Services breakdown
          if (selectedServices.isNotEmpty) ...[
            _buildServicesList('Primary Services', selectedServices),
            const SizedBox(height: 12),
          ],

          // Group member services
          if (memberServices.isNotEmpty) ...[
            ...memberServices.entries.map((entry) {
              if (entry.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildServicesList('${entry.key} Services', entry.value),
                );
              }
              return const SizedBox.shrink();
            }),
          ],

          if (selectedServices.isNotEmpty || memberServices.values.any((services) => services.isNotEmpty)) ...[
            const Divider(),
            const SizedBox(height: 8),

            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Tax
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax (8.75%)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${tax.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Total',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isGroupService) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Group Size',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$groupSize ${groupSize == 1 ? 'person' : 'people'}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  'No services selected',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesList(String title, List<ServiceSelection> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        ...services.map((selection) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selection.service.name,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (selection.technician != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selection.technician!.name,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryBlue,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${selection.service.price.toStringAsFixed(2)}',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),),
      ],
    );
  }
}