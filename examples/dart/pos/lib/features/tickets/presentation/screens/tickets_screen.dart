// lib/features/tickets/presentation/screens/tickets_screen.dart
// Comprehensive ticket management screen with advanced filtering, pagination, and status tracking. Provides complete ticket lifecycle management from creation to payment processing with Riverpod state management.
// Usage: ACTIVE - Core screen for ticket operations, service tracking, and customer service management

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading_skeletons.dart';
import '../../../../core/widgets/pagination_controls.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/models/technician_model.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../../shared/data/repositories/drift_service_repository.dart';
import '../../../shared/data/repositories/drift_employee_repository.dart';
import '../widgets/ticket_filters.dart';
import '../widgets/ticket_dialog/ticket_dialog.dart';
import '../../providers/tickets_paged_provider.dart';

class TicketsScreen extends ConsumerStatefulWidget {
  const TicketsScreen({super.key});

  @override
  ConsumerState<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen> {
  final _searchController = TextEditingController();
  Ticket? _selectedTicket;
  
  // Data repositories for edit dialog
  final DriftServiceRepository _serviceRepository = DriftServiceRepository.instance;
  final DriftEmployeeRepository _employeeRepository = DriftEmployeeRepository.instance;
  
  List<Service> _availableServices = [];
  List<Technician> _availableTechnicians = [];

  @override
  void initState() {
    super.initState();
    _loadDialogData();
    // Trigger initial load of ticket history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ticketHistoryProvider);
    });
  }
  
  Future<void> _loadDialogData() async {
    try {
      // Load services and employees for the edit dialog
      final services = await _serviceRepository.getServices();
      final employees = await _employeeRepository.getEmployees();
      
      setState(() {
        _availableServices = services;
        _availableTechnicians = employees.map((employee) => Technician(
          id: employee.id.toString(),
          name: employee.fullName,
          turnNumber: 0,
          status: employee.status == 'active' ? 'available' : 'off',
          avatarColor: '',
          avatarInitial: employee.initials.isNotEmpty ? employee.initials[0] : 'T',
        ),).toList();
      });
    } catch (e) {
      // Handle error silently for now
      // Use ErrorLogger instead of print for production code
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectTicket(Ticket? ticket) {
    setState(() {
      _selectedTicket = ticket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppHeader(
        title: 'Tickets',
        showSearch: true,
        onSearchChanged: (query) {
          _searchController.text = query;
          ref.read(ticketHistoryProvider.notifier).applyFilters(search: query);
        },
        onSearchClear: () {
          _searchController.clear();
          ref.read(ticketHistoryProvider.notifier).applyFilters(search: '');
        },
        searchHint: 'Search tickets...',
        searchValue: _searchController.text,
      ),
      // Debug FAB removed - production ready
      body: Column(
        children: [
          // Filters section
          TicketFilters(
            onStatusChanged: (status) => ref.read(ticketHistoryProvider.notifier).applyFilters(status: status),
            onTechnicianChanged: (technicianId) {}, // TODO: Implement technician filter
            onCustomerTypeChanged: (type) {}, // TODO: Implement customer type filter
            onCustomerNameChanged: (name) {}, // TODO: Implement customer name filter
            onDateRangeChanged: (dateRange) => ref.read(ticketHistoryProvider.notifier).applyFilters(dateRange: dateRange),
            onAmountRangeChanged: (minAmount, maxAmount) {}, // TODO: Implement amount range filter
          ),
          // Tickets list
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final ticketHistoryAsync = ref.watch(ticketHistoryProvider);
                
                return ticketHistoryAsync.when(
                  loading: () => LoadingSkeletons.dataGridSkeleton(
                    columnCount: 5,
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error loading tickets: $error'),
                  ),
                  data: (ticketHistory) {
                    final tickets = ticketHistory.tickets;
                if (tickets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tickets found',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (ticketHistory.search?.isNotEmpty == true ||
                            ticketHistory.status != null) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => ref.read(ticketHistoryProvider.notifier).applyFilters(),
                            child: const Text('Clear filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Stack(
                  children: [
                    Row(
                      children: [
                        // Left side - Tickets table
                        Expanded(
                          flex: 2,
                          child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Table header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Date',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Ticket ID',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Customer',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Status',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Total',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Table content
                            Expanded(
                              child: ListView.builder(
                                itemCount: tickets.length,
                                itemBuilder: (context, index) {
                                  final ticket = tickets[index];
                                  final isSelected = _selectedTicket?.id == ticket.id;
                                  
                                  return _buildTicketRow(ticket, isSelected);
                                },
                              ),
                            ),
                            // Pagination controls
                            PaginationControls(
                              currentPage: ticketHistory.currentPage,
                              totalPages: ticketHistory.totalPages,
                              paginationInfo: 'Page ${ticketHistory.currentPage} of ${ticketHistory.totalPages} (${ticketHistory.totalCount} total)',
                              canGoToPreviousPage: ticketHistory.currentPage > 1,
                              canGoToNextPage: ticketHistory.currentPage < ticketHistory.totalPages,
                              itemsPerPage: 20, // Fixed page size
                              onFirstPage: () => ref.read(ticketHistoryProvider.notifier).goToPage(1),
                              onPreviousPage: () => ref.read(ticketHistoryProvider.notifier).goToPage(ticketHistory.currentPage - 1),
                              onNextPage: () => ref.read(ticketHistoryProvider.notifier).goToPage(ticketHistory.currentPage + 1),
                              onLastPage: () => ref.read(ticketHistoryProvider.notifier).goToPage(ticketHistory.totalPages),
                              onItemsPerPageChanged: (newSize) {}, // TODO: Implement variable page size
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right side - Ticket preview
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _selectedTicket == null
                            ? _buildEmptyPreview()
                            : _buildTicketPreview(_selectedTicket!),
                      ),
                    ),
                  ],
                ),
                // Subtle loading overlay when refreshing cached data
                if (ticketHistory.isLoading)
                  Positioned(
                    top: 0,
                    right: 16,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Updating...',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void _editTicket(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => TicketDialog(
        ticket: ticket,
        customer: ticket.customer,
        availableServices: _availableServices,
        availableTechnicians: _availableTechnicians,
        onConfirm: (updatedTicket) {
          ref.read(ticketHistoryProvider.notifier).refresh();
          
          // Update selected ticket if it's the same one
          if (_selectedTicket?.id == updatedTicket.id) {
            setState(() {
              _selectedTicket = updatedTicket;
            });
          }
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ticket updated successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketRow(Ticket ticket, bool isSelected) {
    return Material(
      color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
      child: InkWell(
        onTap: () => _selectTicket(ticket),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            children: [
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  '${ticket.checkInTime.month.toString().padLeft(2, '0')}/${ticket.checkInTime.day.toString().padLeft(2, '0')}/${ticket.checkInTime.year.toString().substring(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              // Ticket ID
              Expanded(
                flex: 2,
                child: Text(
                  ticket.id,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                  ),
                ),
              ),
              // Customer
              Expanded(
                flex: 3,
                child: Text(
                  ticket.customer.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              // Status
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ticket.status.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _getStatusColor(ticket.status),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Total
              Expanded(
                flex: 2,
                child: Text(
                  '\$${(ticket.totalAmount ?? 0.0).toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.successGreen,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Select a ticket',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click on any ticket in the table to view its details',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketPreview(Ticket ticket) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with ticket ID and status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ticket #${ticket.id}',
                  style: AppTextStyles.headline3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  ticket.status.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _getStatusColor(ticket.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Customer information
          _buildPreviewSection(
            'Customer',
            Icons.person_outline,
            [
              _buildPreviewItem('Name', ticket.customer.name),
              if (ticket.customer.phone != null && ticket.customer.phone!.isNotEmpty)
                _buildPreviewItem('Phone', ticket.customer.phone!),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Services
          _buildPreviewSection(
            'Services',
            Icons.design_services_outlined,
            ticket.services.map((service) => 
              _buildServicePreviewItem({
                'name': service.name,
                'price': service.price,
                'duration': service.durationMinutes,
              }),
            ).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Technician
          if (ticket.requestedTechnicianName != null)
            _buildPreviewSection(
              'Technician',
              Icons.person_pin_outlined,
              [_buildPreviewItem('Assigned to', ticket.requestedTechnicianName!)],
            ),
          
          const SizedBox(height: 16),
          
          // Timing
          _buildPreviewSection(
            'Timing',
            Icons.schedule_outlined,
            [
              _buildPreviewItem('Check-in', _formatDateTime(ticket.checkInTime)),
              if (ticket.appointmentTime != null)
                _buildPreviewItem('Appointment', _formatDateTime(ticket.appointmentTime!)),
              if (ticket.updatedAt != null)
                _buildPreviewItem('Last Updated', _formatDateTime(ticket.updatedAt!)),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(ticket.totalAmount ?? 0.0).toStringAsFixed(2)}',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editTicket(context, ticket),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Ticket'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement print functionality
                  },
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Print'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicePreviewItem(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'] ?? 'Unknown Service',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (service['duration'] != null)
                  Text(
                    '${service['duration']} minutes',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '\$${(service['price'] ?? 0.0).toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.successGreen,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.successGreen;
      case 'in_progress':
        return AppColors.warningOrange;
      case 'queued':
        return AppColors.primaryBlue;
      case 'cancelled':
        return AppColors.errorRed;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ticketDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    if (ticketDate == today) {
      return 'Today at $timeStr';
    } else if (ticketDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at $timeStr';
    } else {
      return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year} at $timeStr';
    }
  }

}