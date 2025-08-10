// lib/features/dashboard/presentation/widgets/technician_card.dart
// Technician status card displaying current assignment, availability, and quick actions. Features Riverpod state management, service categorization, and real-time status updates for dashboard monitoring.
// Usage: ACTIVE - Core component of dashboard technician section for staff management and assignment tracking

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/config/service_categories.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/presentation/widgets/service_category_icon.dart';
import '../../../employees/presentation/widgets/self_service_pin_dialog.dart';
import '../../providers/employee_status_provider.dart';
import '../../../tickets/presentation/widgets/ticket_dialog/ticket_dialog.dart';

/// A comprehensive card widget for displaying technician status and assigned tickets.
/// 
/// Features:
/// * Real-time technician state tracking (Available, Busy, Break, etc.)
/// * Assigned ticket display with customer and service information
/// * Service category icons with color coding
/// * Interactive PIN management for clock in/out
/// * Touch-friendly design with visual state indicators
/// * Riverpod integration for reactive state management
/// * Ticket details dialog integration
/// * Service pills display for quick service identification
/// 
/// Usage:
/// ```dart
/// TechnicianCard(
///   technicianId: '1',
///   technicianName: 'John Smith',
///   state: TechnicianState.available,
///   assignedTicket: ticket,
///   onAssignCustomer: () => _showCustomerAssignment(),
/// )
/// ```
class TechnicianCard extends ConsumerWidget {
  final String technicianId;
  final String technicianName;
  final EmployeeState state;
  final Ticket? assignedTicket;
  final VoidCallback? onAssignCustomer;

  const TechnicianCard({
    super.key,
    required this.technicianId,
    required this.technicianName,
    required this.state,
    this.assignedTicket,
    this.onAssignCustomer,
  });

  /// Handle clock toggle with active ticket check
  Future<void> _handleClockToggle(BuildContext context, WidgetRef ref) async {
    final isClockedIn = !state.isOff;
    
    if (isClockedIn) {
      // Check for active tickets
      final hasActiveTickets = assignedTicket != null && assignedTicket!.status == 'in-service';
      
      if (hasActiveTickets) {
        _showActiveTicketDialog(context);
        return;
      }
      
      // Clock out logic - TODO: Implement with provider
      await ref.read(employeeStatusProvider.notifier).clockOut(technicianId);
      _showSnackBar(
        context,
        '$technicianName clocked out successfully',
        Colors.orange,
      );
    } else {
      // Clock in logic - TODO: Implement with provider
      await ref.read(employeeStatusProvider.notifier).clockIn(technicianId);
      _showSnackBar(
        context,
        '$technicianName clocked in successfully',
        Colors.green,
      );
    }
  }

  /// Show dialog when trying to clock out with active tickets
  void _showActiveTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warningOrange,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Active Service in Progress'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You cannot clock out while you have active services in progress.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Please complete or transfer your current service before clocking out.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show a snack bar message
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show PIN change menu on long press
  void _showPinChangeMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              technicianName,
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Employee Actions',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock_reset,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              title: const Text('Change My PIN'),
              subtitle: const Text('Update your security PIN'),
              onTap: () {
                Navigator.pop(context);
                _showSelfServicePinDialog(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Show self-service PIN change dialog
  void _showSelfServicePinDialog(BuildContext context) {
    // Convert Technician to Employee model for the dialog
    final nameParts = technicianName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : 'Unknown';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    final employee = Employee(
      id: int.tryParse(technicianId) ?? 0,
      firstName: firstName,
      lastName: lastName,
      email: '',
      phone: '',
      role: 'technician',
      status: state.isAvailable ? 'available' : (state.isBusy ? 'busy' : 'off'),
      locationId: '',
      username: technicianName.toLowerCase().replaceAll(' ', ''),
      capabilities: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SelfServicePinDialog(
        employee: employee,
        onComplete: (success) {
          if (success) {
            _showSnackBar(context, 'PIN updated successfully!', AppColors.successGreen);
          }
        },
      ),
    );
  }

  /// Build service specialization display - ALWAYS use icons for status menu
  Widget _buildSpecializationDisplay() {
    // TODO: Get specializations from employee data
    final specializations = <String>[];
    
    if (specializations.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Always use icons for the status menu on dashboard
    return Row(
      children: specializations.take(3).map((categoryId) => Padding(
        padding: const EdgeInsets.only(right: 4),
          child: ServiceCategoryIcon(
            categoryId: categoryId,
            serviceName: ServiceCategories.getCategory(categoryId).displayName,
            size: 20,
          ),
        )).toList(),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAvailable = state.isAvailable;
    final isClockedIn = !state.isOff;
    final currentTicket = assignedTicket; // Create local copy to avoid null issues
    final isBusy = state.isBusy && currentTicket != null;
    
    // Determine border color based on status
    Color borderColor;
    double borderWidth;
    if (isBusy) {
      // Use wait time to determine urgency
      final waitTime = currentTicket.waitTimeMinutes;
      if (waitTime >= 45) {
        borderColor = const Color(0xFFB71C1C); // Dark red for 45+ minutes
        borderWidth = 2.0;
      } else if (waitTime >= 30) {
        borderColor = const Color(0xFFEF5350).withValues(alpha: 0.8); // Light red for 30-44 minutes
        borderWidth = 2.0;
      } else if (waitTime >= 20) {
        borderColor = const Color(0xFFFFB74D).withValues(alpha: 0.7); // Light orange for 20-29 minutes
        borderWidth = 2.0;
      } else {
        borderColor = AppColors.textSecondary.withValues(alpha: 0.4);
        borderWidth = 1.5;
      }
    } else if (isAvailable) {
      borderColor = AppColors.successGreen.withValues(alpha: 0.4); // Green for available
      borderWidth = 1.5;
    } else {
      borderColor = AppColors.textSecondary.withValues(alpha: 0.4); // Default grey
      borderWidth = 1.5;
    }
    
    // Get avatar initial from name
    final avatarInitial = technicianName.isNotEmpty ? technicianName[0].toUpperCase() : '?';
    
    // Determine status color
    final statusColor = isClockedIn 
      ? (isAvailable ? AppColors.successGreen : AppColors.warningOrange)
      : AppColors.textSecondary;
        
        return Container(
          height: isBusy ? 160 : 140,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA).withValues(alpha: 0.7), // More translucent background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
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
              onTap: () {
                if (currentTicket != null) {
                  // TODO: Get available services and technicians from providers
                  showDialog(
                    context: context,
                    builder: (context) => TicketDialog(
                      ticket: currentTicket,
                      availableServices: [], // TODO: Get from service provider
                      availableTechnicians: [], // TODO: Get from technician provider
                      onConfirm: (ticket) {
                        // TODO: Update ticket via provider
                      },
                    ),
                  );
                } else if (onAssignCustomer != null) {
                  onAssignCustomer!();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top section: Avatar, name and service icons
                    Row(
                      children: [
                        // Clickable avatar with clock in/out functionality
                        GestureDetector(
                          onTap: () => _handleClockToggle(context, ref),
                          onLongPress: () => _showPinChangeMenu(context),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              border: isClockedIn 
                                ? Border.all(color: Colors.white, width: 2) 
                                : null,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    avatarInitial,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (isClockedIn)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.access_time,
                                        size: 8,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Technician name and hours worked
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                technicianName,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isClockedIn)
                                Text(
                                  'Today: 0h 0m', // TODO: Calculate hours worked
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Service category icons/pills
                        _buildSpecializationDisplay(),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Content area for ticket information or availability
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isBusy
                              ? const Color(0xFFFFE5E5)  // Light red for assigned tickets
                              : isClockedIn
                                  ? const Color(0xFFE8F5E9)  // Light green for available
                                  : AppColors.background.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isBusy
                                ? Colors.red.withValues(alpha: 0.2)
                                : isClockedIn
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : AppColors.border.withValues(alpha: 0.2),
                          ),
                        ),
                        child: isBusy
                            ? Stack(
                                children: [
                                  // Ticket number in top right
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Text(
                                      'T-${currentTicket.ticketNumber}',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // Customer info on left
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        currentTicket.customer.name,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      if (currentTicket.services.isNotEmpty)
                                        Text(
                                          currentTicket.services.first.name,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ],
                              )
                            : Center(
                                child: isClockedIn
                                    ? Text(
                                        'Available',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: const Color(0xFF2E7D32),  // Darker green
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Not Clocked In',
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Tap avatar to clock in',
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.textSecondary,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            'Long press for PIN options',
                                            style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.textSecondary.withValues(alpha: 0.7),
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
