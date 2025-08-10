// lib/features/dashboard/presentation/screens/dashboard_screen.dart
// Main dashboard screen displaying technician status, customer queue, and schedule overview. Provides central hub for salon operations with real-time status updates and quick access to key functions.
// Usage: ACTIVE - Primary screen accessed via main navigation, central hub of the POS application

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../utils/error_logger.dart';
import '../../../appointments/presentation/widgets/appointment_card.dart';
import '../../../appointments/providers/appointment_providers.dart';
import '../widgets/todays_schedule_widget.dart';
import '../../../tickets/providers/live_tickets_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../providers/dashboard_ui_provider.dart';
import '../../providers/queue_management_provider.dart';
import '../../providers/employee_status_provider.dart';
import '../../providers/ticket_assignment_provider.dart';
import '../widgets/contact_customer_dialog.dart';
import '../widgets/customer_queue_card_stub.dart';
import '../widgets/technician_card.dart';
import '../../../tickets/presentation/widgets/ticket_dialog/ticket_dialog.dart';

// Placeholder background options for old dashboard (should be migrated)
class BackgroundType {
  static const String none = 'none';
  static const String gradient = 'gradient';
  static const String image = 'image';
}

class BackgroundOption {
  final String type;
  final List<int>? colors;
  final String? assetPath;
  final String? fileExtension;
  final Map<String, dynamic>? qualitySettings;
  
  const BackgroundOption({
    required this.type,
    this.colors,
    this.assetPath,
    this.fileExtension,
    this.qualitySettings,
  });
}

const Map<String, BackgroundOption> backgroundOptions = {
  'none': BackgroundOption(type: BackgroundType.none),
  'gradient': BackgroundOption(
    type: BackgroundType.gradient,
    colors: [0xFF4A90E2, 0xFF357ABD],
  ),
  // Placeholder for image backgrounds
  'image': BackgroundOption(
    type: BackgroundType.image,
    fileExtension: '.jpg',
    qualitySettings: {
      'cacheWidth': 1920,
      'cacheHeight': 1080,
    },
  ),
};

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize providers on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Providers will automatically load data when first accessed
      ref.read(employeeStatusProvider);
      ref.read(queueManagementProvider);
      ref.read(todaysAppointmentsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: false, // Keep app bar solid
      appBar: StandardAppHeader(
        title: 'Operations Dashboard',
        secondaryActions: [
          HeaderActionStyles.calendarButton(() => context.go('/calendar')),
          const SizedBox(width: 8),
          HeaderActionStyles.checkInButton(() => _showCheckInDialog(context)),
          const SizedBox(width: 8),
          HeaderActionStyles.checkoutButton(() => context.go('/checkout')),
          const SizedBox(width: 8),
          HeaderActionStyles.registerButton(() {}), // TODO: Implement cash register
          const SizedBox(width: 8), // Add spacing after to prevent cutoff
        ],
      ),
      body: Stack(
        children: [
          // Background based on settings
          _buildBackground(),
          // Content with padding
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  // Action bar method no longer needed - actions moved to header

  Widget _buildBackground() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final backgroundKey = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_background']?.parsedValue as String? ?? 'none',
      orElse: () => 'none',
    );
    final backgroundOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_background_opacity']?.parsedValue as double? ?? 0.3,
      orElse: () => 0.3,
    );
    
    final backgroundOption = backgroundOptions[backgroundKey];
    
    if (backgroundOption == null || backgroundOption.type == BackgroundType.none) {
      return Container(color: AppColors.background);
    }
    
    // Handle gradient backgrounds
    if (backgroundOption.type == BackgroundType.gradient) {
      return Positioned.fill(
        child: Opacity(
          opacity: backgroundOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: backgroundOption.colors?.map((color) => 
                  Color(color)
                ).toList() ?? [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Handle image backgrounds
    if (backgroundOption.type == BackgroundType.image) {
      // Build the image path with the correct extension
      String imagePath = 'assets/backgrounds/$backgroundKey';
      
      // Use the file extension from the BackgroundOption
      if (backgroundOption.fileExtension != null) {
        imagePath += backgroundOption.fileExtension!;
      } else {
        imagePath += '.jpg'; // Default to JPG
      }
      
      return Positioned.fill(
        child: Opacity(
          opacity: backgroundOpacity,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            cacheWidth: backgroundOption.qualitySettings?['cacheWidth'] as int?,
            cacheHeight: backgroundOption.qualitySettings?['cacheHeight'] as int?,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading background image: $error');
              return Container(color: AppColors.background);
            },
          ),
        ),
      );
    }
    
    return Container(color: AppColors.background);
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Schedule at the top (conditional based on settings)
        Consumer(
          builder: (context, ref, child) {
            final settingsAsync = ref.watch(settingsMasterProvider);
            final showSchedule = settingsAsync.maybeWhen(
              data: (settings) => settings['dashboard_show_todays_schedule']?.parsedValue as bool? ?? true,
              orElse: () => true,
            );
            
            if (showSchedule) {
              return Column(
                children: [
                  _buildTodaysSchedule(),
                  const SizedBox(height: 12),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Main sections - use Expanded to take all remaining space
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Section with correct flex
              Expanded(
                flex: ref.watch(dashboardUIProvider).showUpcomingAppointments ? 375 : 500,
                child: _buildStatusSection(),
              ),
              const SizedBox(width: 12),
              // Queue Section with correct flex
              Expanded(
                flex: ref.watch(dashboardUIProvider).showUpcomingAppointments ? 375 : 500,
                child: _buildCustomerQueueSection(),
              ),
              // Appointments Section (conditional)
              if (ref.watch(dashboardUIProvider).showUpcomingAppointments) ...[
                const SizedBox(width: 12),
                Expanded(
                  flex: 250,
                  child: _buildUpcomingAppointmentsSection(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysSchedule() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final containerOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_container_opacity']?.parsedValue as double? ?? 0.95,
      orElse: () => 0.95,
    );
    final dashboardUI = ref.watch(dashboardUIProvider);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: containerOpacity),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          const TodaysScheduleWidget(),
          // Expand button in top right
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref.read(dashboardUIProvider.notifier).toggleTimelineExpanded(),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    dashboardUI.isTimelineExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final containerOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_container_opacity']?.parsedValue as double? ?? 0.95,
      orElse: () => 0.95,
    );
    final dashboardBackground = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_background']?.parsedValue as String? ?? 'none',
      orElse: () => 'none',
    );
    
    return Container(
      decoration: _getGlassmorphismDecoration(containerOpacity, dashboardBackground),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Status', style: AppTextStyles.headline2),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', ref.watch(dashboardUIProvider).technicianFilter == 'All', 
                          () => ref.read(dashboardUIProvider.notifier).setTechnicianFilter('All')),
                        const SizedBox(width: 8),
                        _buildFilterChip('Available', ref.watch(dashboardUIProvider).technicianFilter == 'Available', 
                          () => ref.read(dashboardUIProvider.notifier).setTechnicianFilter('Available')),
                        const SizedBox(width: 8),
                        _buildFilterChip('Busy', ref.watch(dashboardUIProvider).technicianFilter == 'Busy', 
                          () => ref.read(dashboardUIProvider.notifier).setTechnicianFilter('Busy')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTechnicianGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerQueueSection() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final containerOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_container_opacity']?.parsedValue as double? ?? 0.95,
      orElse: () => 0.95,
    );
    final dashboardBackground = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_background']?.parsedValue as String? ?? 'none',
      orElse: () => 'none',
    );
    
    return Container(
      decoration: _getGlassmorphismDecoration(containerOpacity, dashboardBackground),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Queue', style: AppTextStyles.headline2),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', ref.watch(dashboardUIProvider).queueFilter == 'All', 
                        () => ref.read(dashboardUIProvider.notifier).setQueueFilter('All')),
                      const SizedBox(width: 8),
                      _buildFilterChip('Walk In', ref.watch(dashboardUIProvider).queueFilter == 'Walk In', 
                        () => ref.read(dashboardUIProvider.notifier).setQueueFilter('Walk In')),
                      const SizedBox(width: 8),
                      _buildFilterChip('Appointment', ref.watch(dashboardUIProvider).queueFilter == 'Appointment', 
                        () => ref.read(dashboardUIProvider.notifier).setQueueFilter('Appointment')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildQueueGrid(),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentsSection() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final containerOpacity = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_container_opacity']?.parsedValue as double? ?? 0.95,
      orElse: () => 0.95,
    );
    final dashboardBackground = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_background']?.parsedValue as String? ?? 'none',
      orElse: () => 'none',
    );
    
    return Container(
      decoration: _getGlassmorphismDecoration(containerOpacity, dashboardBackground),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Appointments', style: AppTextStyles.headline2),
          const SizedBox(height: 10),
          Expanded(
            child: _buildUpcomingAppointments(),
          ),
        ],
        ),
      ),
    );
  }

  // Performant glassmorphism effect without expensive blur
  BoxDecoration _getGlassmorphismDecoration(double containerOpacity, String dashboardBackground) {
    final hasBackground = dashboardBackground != 'none';
    
    return BoxDecoration(
      color: AppColors.surface.withValues(alpha: containerOpacity),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: hasBackground 
          ? Colors.white.withValues(alpha: 0.2)  // Lighter border with background
          : AppColors.border.withValues(alpha: 0.2),
      ),
      // Multiple shadows for depth effect
      boxShadow: hasBackground ? [
        // Outer glow
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(-5, -5),
          spreadRadius: 1,
        ),
        // Inner shadow
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(5, 5),
          spreadRadius: -5,
        ),
      ] : null,
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianGrid() {
    final technicianStatusAsync = ref.watch(employeeStatusProvider);
    
    return AsyncValueWidget.fromProvider(
      provider: employeeStatusProvider,
      data: (context, technicianStatus, isRefreshing) {
        final technicians = technicianStatus.employeeStates.entries
            .where((entry) {
              final filter = ref.watch(dashboardUIProvider).technicianFilter;
              if (filter == 'All') return true;
              if (filter == 'Available') return entry.value.isAvailable;
              if (filter == 'Busy') return entry.value.isBusy;
              return true;
            })
            .toList();
            
        if (technicians.isEmpty) {
          return const Center(child: Text('No technicians available'));
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: technicians.length,
          itemBuilder: (context, index) {
            final tech = technicians[index];
            final techId = tech.key;
            final techState = tech.value;
            // Use live tickets derived per technician; clock-in aware
            final techTickets = ref.watch(ticketsByTechnicianProvider(techId));
            final assignedTicket = techTickets.isNotEmpty ? techTickets.first : null;
            
            return TechnicianCard(
              technicianId: techId,
              technicianName: techId, // TODO: Get actual name from employee data
              state: techState,
              assignedTicket: assignedTicket,
              onAssignCustomer: () {
                if (assignedTicket != null) {
                  _showTicketDetailsDialog(context, assignedTicket);
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQueueGrid() {
    final settingsAsync = ref.watch(settingsMasterProvider);
    final showCustomerPhone = settingsAsync.maybeWhen(
      data: (settings) => settings['dashboard_show_customer_phone']?.parsedValue as bool? ?? true,
      orElse: () => true,
    );
    
    return AsyncValueWidget.fromProvider(
      provider: queueManagementProvider,
      data: (context, queueState, isRefreshing) {
        // Apply filter
        final filter = ref.watch(dashboardUIProvider).queueFilter;
        final filteredTickets = queueState.queueTickets.where((ticket) {
          if (filter == 'All') return true;
          if (filter == 'Walk In') return ticket.type == 'walk-in';
          if (filter == 'Appointment') return ticket.type == 'appointment';
          return true;
        }).toList();
        
        if (filteredTickets.isEmpty) {
          return const Center(child: Text('No customers in the queue.'));
        }
        
        // Use a custom layout to handle group appointments spanning full width
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final cardWidth = (maxWidth - 12) / 2; // Width for regular cards (2 columns)
            
            final List<Widget> cards = [];
            
            for (final ticket in filteredTickets) {
              final isGroup = ticket.isGroupService && (ticket.groupSize ?? 0) > 1;
              
              // Wrap in a container with defined width instead of SizedBox with null height
              final card = Container(
                width: isGroup ? maxWidth : cardWidth,
                constraints: BoxConstraints(
                  minHeight: isGroup ? 120 : 140, // Slightly taller for 2 rows of pills
                  maxHeight: isGroup ? 120 : 180, // Set to 180px to match queue card height
                ),
                child: CustomerQueueCard(
                  key: ValueKey(ticket.id),
                  ticket: ticket,
                  serviceDisplayMode: 'inline', // TODO: Get from settings when needed
                  onTap: () => _showTicketDetailsDialog(context, ticket),
                ),
              );
              
              cards.add(card);
            }
            
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cards,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUpcomingAppointments() {
    return AsyncValueWidget.fromProvider(
      provider: todaysAppointmentsProvider,
      data: (context, appointments, isRefreshing) {
        if (appointments.isEmpty) {
          return const Center(child: Text('No upcoming appointments.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final Appointment appointment = appointments[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppointmentCard(
                appointment: appointment,
                onCheckIn: () => _showMainCheckInDialog(context, appointment),
                onContact: () => showDialog(
                  context: context,
                  builder: (_) => ContactCustomerDialog(appointment: appointment),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTicketDetailsDialog(BuildContext context, Ticket ticket) async {
    try {
      // TODO: Get available services and technicians from providers
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TicketDialog(
            ticket: ticket,
            availableServices: [], // TODO: Get from service provider
            availableTechnicians: [], // TODO: Get from technician provider
            onConfirm: (updatedTicket) async {
              await ref.read(queueManagementProvider.notifier).updateTicket(updatedTicket);
              // Dialog is already closed by the TicketDetailsDialog's confirm button
            },
          );
        },
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error showing ticket details dialog', e, stack);
    }
  }

  Future<void> _showCheckInDialog(BuildContext context) async {
    try {
      // TODO: Get available services and technicians from providers
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TicketDialog(
            isNewCheckIn: true,
            availableServices: [], // TODO: Get from service provider
            availableTechnicians: [], // TODO: Get from technician provider
            onConfirm: (ticket) async {
              await ref.read(queueManagementProvider.notifier).addTicket(ticket);
              // Dialog is already closed by the TicketDetailsDialog's confirm button
            },
          );
        },
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error showing check-in dialog', e, stack);
    }
  }

  Future<void> _showMainCheckInDialog(BuildContext context, Appointment appointment) async {
    try {
      // TODO: Get available services and technicians from providers
      if (!mounted) return;
      
      // Get current queue count for ticket number
      final queueState = ref.read(queueManagementProvider).valueOrNull;
      final ticketCount = queueState?.queueTickets.length ?? 0;
      
      // Create a ticket from the appointment
      final ticket = Ticket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ticketNumber: (ticketCount + 1001).toString(), // Generate next ticket number
        customer: Customer.withName(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: appointment.customerName,
        ),
        services: appointment.services ?? [],
        type: 'appointment',
        status: 'queued',
        checkInTime: DateTime.now(),
        assignedTechnicianId: appointment.requestedTechnicianId,
        requestedTechnicianName: appointment.requestedTechnicianName,
        appointmentTime: appointment.scheduledStartTime,
        isGroupService: appointment.isGroupBooking,
        groupSize: appointment.groupSize,
        appointmentId: appointment.id, // Link to the original appointment
      );
      
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return TicketDialog(
            ticket: ticket,
            availableServices: [], // TODO: Get from service provider
            availableTechnicians: [], // TODO: Get from technician provider
            isNewCheckIn: true,
            onConfirm: (confirmedTicket) async {
              // Mark appointment as checked in (status: arrived)
              await ref.read(todaysAppointmentsProvider.notifier).checkInAppointment(appointment.id);
              
              // Add ticket to queue
              await ref.read(queueManagementProvider.notifier).addTicket(confirmedTicket);
              // Dialog is already closed by the TicketDetailsDialog's confirm button
            },
          );
        },
      );
    } catch (e, stack) {
      ErrorLogger.logError('Error showing main check-in dialog', e, stack);
    }
  }
}
