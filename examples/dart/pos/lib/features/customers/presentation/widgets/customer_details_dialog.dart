// lib/features/customers/presentation/widgets/customer_details_dialog.dart
// Comprehensive customer details dialog displaying customer information, statistics, service history, and ticket timeline.
// Features date filtering, service frequency analysis, membership levels, and detailed transaction history with revenue insights.
// Usage: ACTIVE - Primary customer detail view accessible from customer list and dashboard

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/data/models/ticket_model.dart';

class CustomerDetailsDialog extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerDetailsDialog({
    super.key,
    required this.customer,
  });

  @override
  ConsumerState<CustomerDetailsDialog> createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends ConsumerState<CustomerDetailsDialog> {
  DateTimeRange? _dateFilter;

  @override
  void initState() {
    super.initState();
    // Load customer details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerDetailsNotifierProvider(widget.customer.id).notifier).loadCustomerDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getAvatarColor(widget.customer.name),
                    child: Text(
                      widget.customer.name.isNotEmpty ? widget.customer.name[0].toUpperCase() : '?',
                      style: AppTextStyles.headline2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.customer.name,
                              style: AppTextStyles.headline2.copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            if (widget.customer.membershipLevel != 'Regular')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getMembershipColor(widget.customer.membershipLevel).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _getMembershipColor(widget.customer.membershipLevel).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  widget.customer.membershipLevel,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              widget.customer.phone ?? 'No phone',
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                            ),
                            if (widget.customer.email != null) ...[
                              const SizedBox(width: 16),
                              Icon(Icons.email, size: 16, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                widget.customer.email!,
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Customer info and stats
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      border: Border(
                        right: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Overview',
                              style: AppTextStyles.headline3,
                            ),
                            const SizedBox(height: 16),
                            // Stats cards
                            Consumer(
                              builder: (context, ref, _) {
                                final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                                return _buildStatCard(
                                  'Total Spent',
                                  '\$${details.totalSpent.toStringAsFixed(2)}',
                                  Icons.attach_money,
                                  AppColors.primaryBlue,
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Consumer(
                              builder: (context, ref, _) {
                                final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                                return _buildStatCard(
                                  'Visit Count',
                                  details.visitCount.toString(),
                                  Icons.calendar_today,
                                  AppColors.successGreen,
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Consumer(
                              builder: (context, ref, _) {
                                final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                                return _buildStatCard(
                                  'Average Spent',
                                  '\$${details.averageSpent.toStringAsFixed(2)}',
                                  Icons.trending_up,
                                  AppColors.serviceOrange,
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Consumer(
                              builder: (context, ref, _) {
                                final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                                return _buildStatCard(
                                  'Last Visit',
                                  details.lastVisit != null
                                      ? _formatDate(details.lastVisit!)
                                      : 'Never',
                                  Icons.access_time,
                                  AppColors.textSecondary,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            // Service Frequency Analysis
                            Text(
                              'Service History',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Consumer(
                              builder: (context, ref, _) {
                                final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                                if (details.serviceFrequency.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Text(
                                      'No service history',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    constraints: BoxConstraints(maxHeight: 200),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: details.serviceFrequency.entries.take(5).map((entry) {
                                            final percentage = details.visitCount > 0 
                                                ? (entry.value / details.visitCount * 100).toStringAsFixed(0)
                                                : '0';
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 6),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                child: Text(
                                                  entry.key.length > 20 ? '${entry.key.substring(0, 20)}...' : entry.key,
                                                  style: AppTextStyles.labelMedium,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${entry.value}x',
                                                style: AppTextStyles.labelMedium.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '($percentage%)',
                                                style: AppTextStyles.labelSmall.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            // Notes
                            if (widget.customer.notes != null) ...[
                              Text(
                                'Notes',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  widget.customer.notes!,
                                  style: AppTextStyles.labelMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ),
                  // Right side - Ticket history
                  Expanded(
                    child: Column(
                      children: [
                        // Date filter
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Ticket History',
                                style: AppTextStyles.headline3,
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => _selectDateRange(context),
                                icon: const Icon(Icons.calendar_today, size: 18),
                                label: Text(
                                  _dateFilter != null
                                      ? '${_formatShortDate(_dateFilter!.start)} - ${_formatShortDate(_dateFilter!.end)}'
                                      : 'All Time',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tickets list
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final details = ref.watch(customerDetailsNotifierProvider(widget.customer.id));
                              final tickets = details.tickets;
                              
                              if (tickets.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 48,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No tickets found',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: tickets.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final ticket = tickets[tickets.length - 1 - index]; // Show newest first
                                  return _buildTicketCard(ticket);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Ticket #${ticket.ticketNumber}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ticket.status.replaceAll('-', ' '),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getStatusColor(ticket.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDateTime(ticket.checkInTime),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Services List
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Services (${ticket.services.length})',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...ticket.services.map((service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      Text(
                        '\$${(service.price ?? 0.0).toStringAsFixed(2)}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Business Metrics
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                // Duration & timing info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ticket.assignedTechnicianId != null || ticket.requestedTechnicianName != null)
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ticket.requestedTechnicianName ?? 'Tech ${ticket.assignedTechnicianId}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${ticket.services.fold(0, (sum, service) => sum + (service.durationMinutes ?? 30))} min total',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Revenue info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${ticket.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    if (ticket.services.isNotEmpty)
                      Text(
                        '\$${((ticket.totalAmount ?? 0) / ticket.services.length.toDouble()).toStringAsFixed(2)}/service',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateFilter,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dateFilter = picked;
      });
      // Reload customer details with date filter
      ref.read(customerDetailsNotifierProvider(widget.customer.id).notifier).loadCustomerDetails();
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [
      AppColors.primaryBlue,
      AppColors.successGreen,
      AppColors.serviceOrange,
      AppColors.servicePurple,
      AppColors.serviceTeal,
    ];
    
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  Color _getMembershipColor(String level) {
    switch (level.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFB800);
      case 'platinum':
        return const Color(0xFF8C8C8C);
      case 'vip':
        return AppColors.servicePurple;
      default:
        return AppColors.textSecondary;
    }
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
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatShortDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${date.month}/${date.day}/${date.year} $displayHour:$minute $period';
  }
}