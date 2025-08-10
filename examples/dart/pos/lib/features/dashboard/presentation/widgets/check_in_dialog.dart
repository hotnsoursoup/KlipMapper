/// Comprehensive check-in dialog supporting walk-ins and scheduled appointments.
/// 
/// **Architecture:**
/// - **State Management**: Local StatefulWidget with MobX AppointmentsStore integration
/// - **Data Flow**: Repository pattern for services/employees, callback-based ticket creation
/// - **Dialog Chain**: Customer/appointment selection → TicketDialog → confirmation
/// 
/// **Key Features:**
/// - Dual mode support (walk-in vs appointment check-in)
/// - Real-time appointment loading from AppointmentsStore
/// - Customer search integration for walk-ins
/// - Pre-populated appointment support for direct booking check-ins
/// - Employee/technician loading with error handling
/// - Service repository integration for ticket creation
/// 
/// **Check-in Workflow:**
/// 1. **Type Selection**: Walk-in or appointment mode
/// 2. **Customer/Appointment Selection**: 
///    - Walk-in: CustomerSearchWidget for customer lookup/creation
///    - Appointment: Today's appointment list with selection
/// 3. **Service Configuration**: Handoff to TicketDialog with:
///    - Selected customer/appointment data
///    - Available services from repository
///    - Available technicians converted from employees
/// 4. **Ticket Creation**: Final ticket confirmation and creation
/// 
/// **Data Integration:**
/// - **AppointmentsStore**: Today's appointments with availability filtering
/// - **DriftEmployeeRepository**: Active technician loading
/// - **DriftServiceRepository**: Complete service catalog
/// - **CustomerSearchWidget**: Customer lookup and creation
/// 
/// **Error Handling:**
/// - Repository initialization failures with fallback empty states
/// - Loading state management for appointments and technicians
/// - Error logging for debugging failed operations
/// 
/// **Pre-populated Mode:**
/// When initialized with `prePopulatedAppointment`, automatically:
/// - Sets appointment mode
/// - Pre-selects customer and appointment data
/// - Skips type selection UI
/// - Shows appointment details confirmation
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/data/repositories/drift_employee_repository.dart';
import '../../../shared/data/repositories/drift_service_repository.dart';
import '../../../../utils/error_logger.dart';
import '../../../appointments/data/stores/appointments_store.dart';
import '../../../shared/presentation/widgets/customer_search_widget.dart';
import '../../../shared/data/models/technician_model.dart';
import '../../../tickets/presentation/widgets/ticket_dialog/ticket_dialog.dart';

enum CheckInType { walkIn, appointment }

class CheckInDialog extends StatefulWidget {
  final Function(Ticket)? onCheckIn;
  final Appointment? prePopulatedAppointment;

  const CheckInDialog({
    super.key,
    this.onCheckIn,
    this.prePopulatedAppointment,
  });

  @override
  State<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  CheckInType _selectedType = CheckInType.walkIn;
  Customer? _selectedCustomer;
  Ticket? _selectedAppointment;
  List<Ticket> _todaysAppointments = [];
  List<Employee> _availableTechnicians = [];
  bool _isLoadingTechnicians = false;
  late AppointmentsStore _appointmentsStore;
  bool _isLoadingAppointments = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize appointments store
    _appointmentsStore = AppointmentsStore();
    
    // If pre-populated appointment is provided, set up the dialog accordingly
    if (widget.prePopulatedAppointment != null) {
      _selectedType = CheckInType.appointment;
      _selectedCustomer = widget.prePopulatedAppointment!.customer;
      
      // Convert appointment to ticket format for compatibility
      _selectedAppointment = Ticket(
        id: widget.prePopulatedAppointment!.id,
        ticketNumber: '',
        customer: widget.prePopulatedAppointment!.customer ?? Customer.withName(
          id: widget.prePopulatedAppointment!.customerId,
          name: 'Unknown Customer',
          phone: '',
        ),
        services: widget.prePopulatedAppointment!.services ?? [],
        status: 'scheduled',
        type: 'appointment',
        checkInTime: DateTime.now(),
        appointmentTime: widget.prePopulatedAppointment!.appointmentDate,
        assignedTechnicianId: widget.prePopulatedAppointment!.assignedTechnicianId,
        requestedTechnicianId: widget.prePopulatedAppointment!.requestedTechnicianId,
      );
      
      // Customer is already set for pre-populated appointments
    }
    
    _loadTodaysAppointments();
    _loadTechnicians();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadTechnicians() async {
    setState(() {
      _isLoadingTechnicians = true;
    });

    try {
      final employeeRepo = DriftEmployeeRepository.instance;
      await employeeRepo.initialize();
      final technicians = await employeeRepo.getTechnicians();
      
      setState(() {
        _availableTechnicians = technicians;
        _isLoadingTechnicians = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTechnicians = false;
        // Fallback to empty list - user will see no technicians available
        _availableTechnicians = [];
      });
    }
  }

  void _loadTodaysAppointments() async {
    setState(() {
      _isLoadingAppointments = true;
    });
    
    try {
      // Initialize and load appointments from shared store
      await _appointmentsStore.initialize();
      await _appointmentsStore.loadTodaysAppointments();
      
      // Convert available appointments (filtered) to tickets for display
      final availableAppointments = _appointmentsStore.availableAppointments;
      final tickets = availableAppointments.map((appointment) => Ticket(
        id: appointment.id,
        ticketNumber: 'APT-${appointment.id.length >= 6 ? appointment.id.substring(0, 6) : appointment.id}',
        customer: appointment.customer ?? Customer.withName(
          id: appointment.customerId,
          name: 'Unknown Customer',
          phone: '',
        ),
        services: appointment.services ?? [],
        status: appointment.status,
        type: 'appointment',
        checkInTime: DateTime.now(),
        appointmentTime: appointment.appointmentDate,
        assignedTechnicianId: appointment.assignedTechnicianId,
        requestedTechnicianId: appointment.requestedTechnicianId,
      ),).toList();
      
      setState(() {
        _todaysAppointments = tickets;
        _isLoadingAppointments = false;
      });
    } catch (e) {
      setState(() {
        _todaysAppointments = [];
        _isLoadingAppointments = false;
      });
      ErrorLogger.logError('Failed to load appointments from store', e, StackTrace.current);
    }
  }


  void _handleCheckIn() async {
    // Don't proceed if technicians are still loading
    if (_isLoadingTechnicians) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading technicians, please wait...')),
      );
      return;
    }

    // Load services from repository
    List<Service> availableServices = [];
    try {
      final serviceRepo = DriftServiceRepository.instance;
      await serviceRepo.initialize();
      availableServices = await serviceRepo.getServices();
    } catch (e) {
      ErrorLogger.logError('Failed to load services', e, StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load services')),
        );
      }
      return;
    }

    // Convert Employee objects to Technician objects
    final availableTechnicians = _availableTechnicians.map((employee) {
      final fullName = '${employee.firstName} ${employee.lastName}'.trim();
      return Technician(
        id: employee.id.toString(),
        name: fullName,
        turnNumber: 1, // Default turn number
        status: 'available', // Default status
        avatarColor: '#4A90E2', // Default color
        avatarInitial: fullName.isNotEmpty ? fullName[0].toUpperCase() : 'T',
      );
    }).toList();

    if (_selectedType == CheckInType.walkIn && _selectedCustomer != null) {
      // Show ticket details dialog for new walk-in
      if (mounted) {
        Navigator.of(context).pop(); // Close customer selection dialog
        showDialog(
          context: context,
          builder: (context) => TicketDialog(
          customer: _selectedCustomer!,
          availableServices: availableServices,
          availableTechnicians: availableTechnicians,
          isNewCheckIn: true,
          onConfirm: (ticket) {
            widget.onCheckIn?.call(ticket);
          },
        ),
        );
      }
    } else if (_selectedType == CheckInType.appointment && _selectedAppointment != null) {
      // Show ticket details dialog for appointment check-in
      if (mounted) {
        Navigator.of(context).pop(); // Close appointment selection dialog
        showDialog(
          context: context,
          builder: (context) => TicketDialog(
            ticket: _selectedAppointment!,
            availableServices: availableServices,
            availableTechnicians: availableTechnicians,
            isNewCheckIn: true,
            onConfirm: (ticket) {
              widget.onCheckIn?.call(ticket);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 28,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.prePopulatedAppointment != null ? 'Appointment Check-in' : 'New Check-in',
                    style: AppTextStyles.headline2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

            // Type Selection Pills (hidden if pre-populated appointment)
            if (widget.prePopulatedAppointment == null) ...{
              Text(
                'Check-in Type',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTypePill(
                    type: CheckInType.walkIn,
                    label: 'Walk In',
                    icon: Icons.directions_walk,
                    isSelected: _selectedType == CheckInType.walkIn,
                  ),
                  const SizedBox(width: 12),
                  _buildTypePill(
                    type: CheckInType.appointment,
                    label: 'Appointment',
                    icon: Icons.event,
                    isSelected: _selectedType == CheckInType.appointment,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            } else ...{
              // Show appointment details when pre-populated
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment for ${widget.prePopulatedAppointment!.customer?.name ?? widget.prePopulatedAppointment!.customerId}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            'Scheduled: ${widget.prePopulatedAppointment!.appointmentTime}',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            },

                    // Dynamic Content
                    Expanded(
                      child: _selectedType == CheckInType.walkIn
                          ? _buildWalkInSection()
                          : _buildAppointmentSection(),
                    ),

                    // Action Buttons
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: (_canCheckIn() && !_isLoadingTechnicians) ? _handleCheckIn : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: _isLoadingTechnicians 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Check In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypePill({
    required CheckInType type,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCustomer = null;
          _selectedAppointment = null;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (type == CheckInType.walkIn 
                  ? const Color(0xFF6B7280) 
                  : AppColors.primaryBlue)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (type == CheckInType.walkIn 
                    ? const Color(0xFF6B7280) 
                    : AppColors.primaryBlue)
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalkInSection() {
    return Expanded(
      child: CustomerSearchWidget(
        selectedCustomer: _selectedCustomer,
        onCustomerSelected: (customer) {
          setState(() {
            _selectedCustomer = customer;
          });
        },
        onCustomerCleared: () {
          setState(() {
            _selectedCustomer = null;
          });
        },
        allowGenericCustomer: false, // Disable generic customer - force search first
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Appointments',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select an appointment to check in',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: _isLoadingAppointments
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _todaysAppointments.isNotEmpty
              ? ListView.builder(
                  itemCount: _todaysAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = _todaysAppointments[index];
                    final isSelected = _selectedAppointment?.id == appointment.id;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        selected: isSelected,
                        selectedTileColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                        leading: CircleAvatar(
                          backgroundColor: isSelected 
                              ? AppColors.primaryBlue 
                              : AppColors.surfaceLight,
                          child: Text(
                            appointment.appointmentTime != null
                                ? '${appointment.appointmentTime!.hour}:${appointment.appointmentTime!.minute.toString().padLeft(2, '0')}'
                                : '?',
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          appointment.customer.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appointment.customer.phone ?? 'No phone'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Appointment',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: AppColors.primaryBlue,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedAppointment = appointment;
                          });
                        },
                      ),
                    );
                  },
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No appointments today',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoadingAppointments
                            ? 'Loading appointments...'
                            : 'All appointments have been checked in or no appointments are scheduled.',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  bool _canCheckIn() {
    if (_selectedType == CheckInType.walkIn) {
      return _selectedCustomer != null;
    } else {
      return _selectedAppointment != null;
    }
  }


}