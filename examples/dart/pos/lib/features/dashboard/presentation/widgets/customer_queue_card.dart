// lib/features/dashboard/presentation/widgets/customer_queue_card.dart
// Customer queue card widget displaying customer information, services, wait time, and action buttons for ticket management. Provides rich customer context with status indicators and priority handling.
// Usage: ACTIVE - Used by dashboard queue section to display individual customer tickets with interactive management options

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/lookup_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/presentation/widgets/service_category_icon.dart';
import '../../../shared/presentation/widgets/service_pill.dart';

/// A comprehensive card widget for displaying customer tickets in the dashboard queue.
/// 
/// Features:
/// * Walk-in/Appointment type badges with distinct visual styling
/// * Wait time tracking with color-coded urgency indicators
/// * Service display with configurable modes (pills or icons)
/// * Technician assignment with lookup service integration
/// * Group service indicators for multi-person bookings
/// * Responsive layout with error handling and fallback UI
/// * Performance optimizations including caching and minimal rebuilds
/// 
/// Usage:
/// ```dart
/// CustomerQueueCard(
///   ticket: ticket,
///   serviceDisplayMode: 'pills', // or 'icons'
///   onTap: () => _handleTicketTap(ticket),
/// )
/// ```
class CustomerQueueCard extends ConsumerWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final String serviceDisplayMode;

  const CustomerQueueCard({
    super.key,
    required this.ticket,
    this.onTap,
    required this.serviceDisplayMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      return _buildCard(context, ref);
    } catch (e, stack) {
      // Log the error but still show something on screen
      debugPrint('Error building CustomerQueueCard: $e');
      debugPrint('Stack trace: $stack');
      
      // Return a fallback widget instead of crashing
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error loading ticket #${ticket.ticketNumber}',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
  
  Widget _buildCard(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final widgetOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_widget_opacity']?.parsedValue as double? ?? 1.0,
      orElse: () => 1.0,
    );
    final borderColor = _getBorderColor();
    final shouldShowBorder = ticket.waitTimeMinutes >= 20; // Only show border for 20+ minutes
    
    return Container(
      height: 180, // Increased by 10px for better spacing
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA).withValues(alpha: widgetOpacity),
        borderRadius: BorderRadius.circular(8),
        border: shouldShowBorder 
          ? Border.all(
              color: borderColor,
              width: 2.0, // Visible border for long wait times
            )
          : null, // No border for wait times under 20 minutes
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2, // Match appointment card shadow
            offset: const Offset(0, 1), // Match appointment card shadow offset
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with type badge and wait time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getHeaderColor(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    // Type badge (Walk-in or Appointment)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ticket.type == 'walk-in' 
                              ? Icons.directions_walk 
                              : Icons.calendar_today,
                            size: 14,
                            color: _getTypeColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ticket.type == 'walk-in' ? 'Walk-in' : 'Appointment',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: _getTypeColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    
                    const SizedBox(width: 8),
                    
                    // Check-in time - more legible
                    Text(
                      _formatTime(ticket.checkInTime),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    // Group indicator
                    if (ticket.isGroupService && ticket.groupSize != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.group,
                              size: 14,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Group ${ticket.groupSize}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Wait time
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getWaitTimeBackgroundColor(),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${ticket.waitTimeMinutes} min',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: _getWaitTimeColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Stack(
                    children: [
                      // Ticket number in top right corner
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Text(
                          '#${ticket.ticketNumber}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Main content column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer name - smaller to match appointments
                          Text(
                            ticket.customer.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      
                          const SizedBox(height: 8),
                          
                          // Services - optimized for 2 rows
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 45,
                                maxHeight: 55,
                              ),
                              child: _buildServiceDisplay(),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Technician assignment at bottom
                          _buildTechnicianAssignment(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDisplay() {
    if (ticket.services.isEmpty) {
      return Center(
        child: Text(
          'No services selected',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (serviceDisplayMode == 'pills') {
      // Maximum of 4 services to display
      const maxPillsToShow = 4;
      
      return ClipRect(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          clipBehavior: Clip.hardEdge,
          children: [
            ...ticket.services.take(maxPillsToShow).map((service) => ServicePill(
              serviceName: service.name,
              categoryId: service.categoryId,
              isSmall: true,
            )),
            if (ticket.services.length > maxPillsToShow)
              Text(
                '...',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      );
    } else {
      // Icon display mode
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...ticket.services.take(4).map((service) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ServiceCategoryIcon(
                    categoryId: service.categoryId,
                    serviceName: service.name,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    service.name,
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            )),
            if (ticket.services.length > 4)
              Text(
                '+${ticket.services.length - 4} more',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildTechnicianAssignment() {
    final techName = _getTechnicianName();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.person,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            techName == 'Any Available' ? techName : 'Tech: $techName',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  String _getTechnicianName() {
    debugPrint('🎫 Queue Card - Getting technician name for ticket ${ticket.ticketNumber}');
    debugPrint('   assignedTechnicianId: "${ticket.assignedTechnicianId}"');
    debugPrint('   requestedTechnicianName: "${ticket.requestedTechnicianName}"');
    
    // First check if we have a technician name stored with the ticket
    if (ticket.requestedTechnicianName != null && ticket.requestedTechnicianName!.isNotEmpty) {
      // Already formatted as "First L." from the database
      debugPrint('   Using requestedTechnicianName: ${ticket.requestedTechnicianName}');
      return ticket.requestedTechnicianName!;
    }
    
    // Use the global lookup service for fast access
    if (ticket.assignedTechnicianId != null && ticket.assignedTechnicianId!.isNotEmpty) {
      final name = LookupService.instance.getTechnicianDisplayName(ticket.assignedTechnicianId);
      debugPrint('   Lookup service returned: $name');
      return name;
    }
    
    // No assigned technician
    debugPrint('   No assigned technician');
    return 'Any Available';
  }

  Color _getBorderColor() {
    if (ticket.waitTimeMinutes >= 45) {
      return const Color(0xFFB71C1C); // Dark red for 45+ minutes
    } else if (ticket.waitTimeMinutes >= 30) {
      return const Color(0xFFEF5350).withValues(alpha: 0.8); // Light red for 30-44 minutes
    } else if (ticket.waitTimeMinutes >= 20) {
      return const Color(0xFFFFB74D).withValues(alpha: 0.7); // Light orange for 20-29 minutes
    } else {
      return Colors.transparent; // No border for under 20 minutes
    }
  }

  Color _getHeaderColor() {
    if (ticket.type == 'walk-in') {
      return AppColors.primaryBlue.withValues(alpha: 0.1);
    } else {
      return AppColors.servicePurple.withValues(alpha: 0.1);
    }
  }

  Color _getTypeColor() {
    return ticket.type == 'walk-in' 
      ? AppColors.primaryBlue 
      : AppColors.servicePurple;
  }

  Color _getWaitTimeColor() {
    if (ticket.waitTimeMinutes > 40) {
      return AppColors.errorRed;
    } else if (ticket.waitTimeMinutes > 20) {
      return AppColors.warningOrange;
    } else {
      return AppColors.textPrimary;
    }
  }

  Color _getWaitTimeBackgroundColor() {
    if (ticket.waitTimeMinutes > 40) {
      return AppColors.errorRed.withValues(alpha: 0.1);
    } else if (ticket.waitTimeMinutes > 20) {
      return AppColors.warningOrange.withValues(alpha: 0.1);
    } else {
      return Colors.white.withValues(alpha: 0.9);
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}