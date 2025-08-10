// lib/features/appointments/presentation/widgets/comprehensive_appointment_dialog.dart
// Advanced appointment creation/editing dialog with customer search, service compatibility, and group booking.
// Features technician-service compatibility checking, multiple dialog modes, and comprehensive appointment management.
// Usage: ACTIVE - Primary appointment CRUD dialog with advanced features

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../employees/providers/employees_provider.dart';
import '../../../services/providers/services_provider.dart';
import '../../../shared/presentation/widgets/customer_search_widget.dart';
import '../../data/services/technician_service_compatibility_service.dart';
import '../../domain/providers/technician_providers.dart';

enum AppointmentDialogMode { create, edit, fromCalendar }

class AppointmentDialog extends ConsumerStatefulWidget {
  final AppointmentDialogMode mode;
  final Appointment? appointment; // For editing existing appointment
  final DateTime? preSelectedDate; // From calendar overlay
  final TimeOfDay? preSelectedTime; // From calendar overlay  
  final String? preSelectedTechnicianId; // From calendar overlay
  final Function(Appointment)? onSave;
  final Function(String)? onCancel; // Cancellation with reason

  const AppointmentDialog({
    super.key,
    required this.mode,
    this.appointment,
    this.preSelectedDate,
    this.preSelectedTime,
    this.preSelectedTechnicianId,
    this.onSave,
    this.onCancel,
  });

  factory AppointmentDialog.create({
    Function(Appointment)? onSave,
  }) {
    return AppointmentDialog(
      mode: AppointmentDialogMode.create,
      onSave: onSave,
    );
  }

  factory AppointmentDialog.edit({
    required Appointment appointment,
    Function(Appointment)? onSave,
    Function(String)? onCancel,
  }) {
    return AppointmentDialog(
      mode: AppointmentDialogMode.edit,
      appointment: appointment,
      onSave: onSave,
      onCancel: onCancel,
    );
  }

  factory AppointmentDialog.fromCalendar({
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required String technicianId,
    Function(Appointment)? onSave,
  }) {
    return AppointmentDialog(
      mode: AppointmentDialogMode.fromCalendar,
      preSelectedDate: selectedDate,
      preSelectedTime: selectedTime,
      preSelectedTechnicianId: technicianId,
      onSave: onSave,
    );
  }

  @override
  ConsumerState<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends ConsumerState<AppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Customer search
  Customer? _selectedCustomer;
  
  // Date and time
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  // Technician selection
  String? _selectedTechnicianId;
  List<Employee> _availableTechnicians = [];
  bool _loadingTechnicians = false;
  
  // Services
  List<Service> _selectedServices = [];
  List<Service> _availableServices = [];
  
  // Group booking
  bool _isGroupBooking = false;
  int _groupSize = 1;
  
  // Notes
  final _notesController = TextEditingController();
  
  // Loading states
  bool _isSaving = false;
  
  // Services
  final _compatibilityService = TechnicianServiceCompatibilityService();

  bool get _isEditing => widget.mode == AppointmentDialogMode.edit;
  bool get _isFromCalendar => widget.mode == AppointmentDialogMode.fromCalendar;
  
  String get _dialogTitle {
    switch (widget.mode) {
      case AppointmentDialogMode.create:
        return 'New Appointment';
      case AppointmentDialogMode.edit:
        return 'Edit Appointment';
      case AppointmentDialogMode.fromCalendar:
        return 'Schedule Appointment';
    }
  }
  
  String get _saveButtonText {
    if (_isEditing) return 'Save Changes';
    return 'Schedule';
  }
  
  bool get _canSave {
    final basicValidation = _selectedCustomer != null &&
                           _selectedDate != null &&
                           _selectedTime != null &&
                           _selectedTechnicianId != null &&
                           _selectedServices.isNotEmpty &&
                           (!_isGroupBooking || _groupSize > 1);
    
    // For editing, also check if changes were made
    if (_isEditing && basicValidation && widget.appointment != null) {
      final changes = _generateChangesSummary();
      return changes.isNotEmpty;
    }
    
    return basicValidation;
  }

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _loadTechnicians();
    _loadServices();
  }

  void _initializeFields() {
    if (_isEditing && widget.appointment != null) {
      final apt = widget.appointment!;
      _selectedCustomer = apt.customer;
      _selectedDate = apt.appointmentDate;
      _selectedTime = TimeOfDay(
        hour: int.parse(apt.appointmentTime.split(':')[0]),
        minute: int.parse(apt.appointmentTime.split(':')[1]),
      );
      _selectedTechnicianId = apt.assignedTechnicianId ?? apt.requestedTechnicianId;
      _selectedServices = List.from(apt.services ?? []);
      _isGroupBooking = apt.isGroupBooking;
      _groupSize = apt.groupSize;
      _notesController.text = apt.notes ?? '';
    } else if (_isFromCalendar) {
      _selectedDate = widget.preSelectedDate;
      _selectedTime = widget.preSelectedTime;
      _selectedTechnicianId = widget.preSelectedTechnicianId;
    }
  }

  Future<void> _loadTechnicians() async {
    // Use Riverpod provider for technicians
    final technicians = ref.read(activeTechniciansProvider);
    setState(() {
      _availableTechnicians = technicians;
      _loadingTechnicians = false;
    });
  }

  Future<void> _loadServices() async {
    // Use Riverpod provider for services (master list)
    final servicesAsync = ref.read(servicesMasterProvider);
    servicesAsync.when(
      data: (services) {
        setState(() {
          _availableServices = services;
        });
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  /// Validates that the selected technician ID exists in the available technicians list
  String? _getValidatedTechnicianId() {
    if (_selectedTechnicianId == null) return null;
    if (_selectedTechnicianId == 'any') return 'any';
    
    // Check if the selected technician exists in the available technicians list
    final technicianExists = _availableTechnicians.any((tech) => tech.id.toString() == _selectedTechnicianId);
    
    if (technicianExists) {
      return _selectedTechnicianId;
    } else {
      // If the selected technician doesn't exist, default to 'any'
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedTechnicianId = 'any';
          });
        }
      });
      return 'any';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCustomerSection(),
                      const SizedBox(height: 24),
                      _buildDateTimeSection(),
                      const SizedBox(height: 24),
                      _buildTechnicianSection(),
                      const SizedBox(height: 24),
                      _buildServicesSection(),
                      const SizedBox(height: 24),
                      _buildGroupBookingSection(),
                      const SizedBox(height: 24),
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: AppColors.primaryBlue,
          size: 28,
        ),
        const SizedBox(width: 12),
        Text(
          _dialogTitle,
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (_isEditing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryBlue),
            ),
            child: Text(
              widget.appointment!.status.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.textLight.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSection() {
    return CustomerSearchWidget(
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
      allowGenericCustomer: false, // Appointments should have real customer info
      searchHint: 'Type name or phone number...',
      searchLabel: 'Customer *',
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primaryBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('EEEE, MMMM d, y').format(_selectedDate!)
                              : 'Select Date *',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _selectedDate != null 
                                ? AppColors.textPrimary 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Time *',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _selectedTime != null 
                                ? AppColors.textPrimary 
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicianSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technician',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (_loadingTechnicians)
          const CircularProgressIndicator()
        else
          DropdownButtonFormField<String>(
            value: _getValidatedTechnicianId(),
            decoration: const InputDecoration(
              labelText: 'Select Technician *',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: 'any',
                child: Row(
                  children: [
                    Icon(Icons.shuffle, size: 20),
                    SizedBox(width: 8),
                    Text('Any Available Technician'),
                  ],
                ),
              ),
              ..._availableTechnicians.map((tech) {
                return DropdownMenuItem(
                  value: tech.id.toString(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          tech.fullName.isNotEmpty ? tech.fullName[0] : 'T',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(tech.fullName),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedTechnicianId = value;
              });
              // Check service compatibility when technician changes
              _checkServiceCompatibility();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a technician';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(minHeight: 120),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedServices.isEmpty
              ? InkWell(
                  onTap: _showServiceSelector,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Select Services *',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    ..._selectedServices.map((service) => _buildServiceItem(service)),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextButton.icon(
                        onPressed: _showServiceSelector,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Another Service'),
                      ),
                    ),
                  ],
                ),
        ),
        if (_selectedServices.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Total Duration: ${_calculateTotalDuration()} min',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildServiceItem(Service service) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${service.durationMinutes} min • \$${service.basePrice.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedServices.remove(service);
              });
            },
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupBookingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Group Booking',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: _isGroupBooking,
              onChanged: (value) {
                setState(() {
                  _isGroupBooking = value;
                  if (!value) _groupSize = 1;
                });
              },
              thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
            ),
          ],
        ),
        if (_isGroupBooking) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 24),
              Text(
                'Number of people:',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: _groupSize.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  onChanged: (value) {
                    final size = int.tryParse(value) ?? 1;
                    setState(() {
                      _groupSize = size.clamp(2, 10);
                    });
                  },
                  validator: (value) {
                    final size = int.tryParse(value ?? '') ?? 0;
                    if (size < 2) return 'Min 2 people';
                    if (size > 10) return 'Max 10 people';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Additional notes or special requests...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isEditing && widget.onCancel != null)
          TextButton.icon(
            onPressed: () => _showCancelAppointmentDialog(),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel Appointment'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
          ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _canSave ? () => _saveAppointment() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(_saveButtonText),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _showServiceSelector() {
    showDialog(
      context: context,
      builder: (context) => _ServiceSelectorDialog(
        availableServices: _availableServices,
        selectedServices: _selectedServices,
        selectedTechnicianId: _selectedTechnicianId,
        compatibilityService: _compatibilityService,
        onServicesSelected: (services) {
          setState(() {
            _selectedServices = services;
          });
          // Check compatibility after services are selected
          _checkServiceCompatibility();
        },
      ),
    );
  }

  /// Check service compatibility with selected technician
  Future<void> _checkServiceCompatibility() async {
    if (_selectedTechnicianId == null || _selectedServices.isEmpty) return;

    try {
      final result = await _compatibilityService.checkMultiServiceCompatibility(
        technicianId: _selectedTechnicianId!,
        services: _selectedServices,
      );

      if (mounted && !result.isFullyCompatible && result.warningMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.warningMessage!),
            backgroundColor: AppColors.warningOrange,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Suggest Technicians',
              textColor: Colors.white,
              onPressed: () => _showAlternativeTechnicians(result.incompatibleServices),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle error silently - compatibility check is not critical
    }
  }

  /// Show alternative technicians who can perform incompatible services
  Future<void> _showAlternativeTechnicians(List<Service> incompatibleServices) async {
    try {
      final suggestions = await _compatibilityService.getSuggestedTechnicians(
        incompatibleServices: incompatibleServices,
        allTechnicians: _availableTechnicians,
      );

      if (!mounted) return;

      if (suggestions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No alternative technicians found for these services'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => _SuggestedTechniciansDialog(
          incompatibleServices: incompatibleServices,
          suggestedTechnicians: suggestions,
          onTechnicianSelected: (technicianId) {
            setState(() {
              _selectedTechnicianId = technicianId;
            });
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error finding alternative technicians: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  int _calculateTotalDuration() {
    return _selectedServices.fold(0, (total, service) => total + service.durationMinutes);
  }

  double _calculateTotalPrice() {
    return _selectedServices.fold(0.0, (total, service) => total + service.basePrice);
  }

  void _showCancelAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => _CancelAppointmentDialog(
        customerName: widget.appointment?.customer?.name ?? 'Unknown Customer',
        appointmentDate: widget.appointment?.appointmentDate ?? DateTime.now(),
        onCancel: (reason) {
          Navigator.of(context).pop(); // Close main dialog
          widget.onCancel?.call(reason); // Pass the cancellation reason to parent
        },
      ),
    );
  }

  void _saveAppointment() {
    if (!_formKey.currentState!.validate() || !_canSave) return;

    if (_isEditing) {
      _showSaveConfirmation();
    } else {
      _performSave();
    }
  }

  void _showSaveConfirmation() {
    final changes = _generateChangesSummary();
    
    // If no changes were made, show a message and don't allow saving
    if (changes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No changes were made to save'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Changes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to save these changes?'),
            const SizedBox(height: 16),
            const Text('Changes:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...changes.map((change) => Text('• $change')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performSave();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  List<String> _generateChangesSummary() {
    final changes = <String>[];
    final original = widget.appointment!;
    
    if (_selectedCustomer?.id != original.customerId) {
      changes.add('Customer changed');
    }
    
    final newDate = _selectedDate!;
    if (!_isSameDate(newDate, original.appointmentDate)) {
      changes.add('Date changed to ${DateFormat('MMM d, y').format(newDate)}');
    }
    
    final newTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    if (newTime != original.appointmentTime) {
      changes.add('Time changed to ${_selectedTime!.format(context)}');
    }
    
    if (_selectedTechnicianId != (original.assignedTechnicianId ?? original.requestedTechnicianId)) {
      changes.add('Technician changed');
    }
    
    if (_selectedServices.length != (original.services?.length ?? 0)) {
      changes.add('Services changed');
    }
    
    if (_isGroupBooking != original.isGroupBooking) {
      changes.add(_isGroupBooking ? 'Changed to group booking' : 'Changed from group booking');
    }
    
    if (_groupSize != original.groupSize) {
      changes.add('Group size changed to $_groupSize');
    }
    
    return changes;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _performSave() async {
    setState(() => _isSaving = true);
    
    try {
      // Validate that at least one service is selected
      if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select at least one service for the appointment'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }
      final appointment = Appointment(
        id: _isEditing ? widget.appointment!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: _selectedCustomer!.id,
        appointmentDate: _selectedDate!,
        appointmentTime: '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        durationMinutes: _calculateTotalDuration(),
        status: _isEditing ? widget.appointment!.status : 'scheduled',
        requestedTechnicianId: _selectedTechnicianId == 'any' ? null : _selectedTechnicianId,
        assignedTechnicianId: _selectedTechnicianId == 'any' ? null : _selectedTechnicianId,
        serviceIds: _selectedServices.map((s) => s.id.toString()).toList(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isGroupBooking: _isGroupBooking,
        groupSize: _groupSize,
        createdAt: _isEditing ? widget.appointment!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        customer: _selectedCustomer,
        services: _selectedServices,
      );
      
      widget.onSave?.call(appointment);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving appointment: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

class _ServiceSelectorDialog extends StatefulWidget {
  final List<Service> availableServices;
  final List<Service> selectedServices;
  final String? selectedTechnicianId;
  final TechnicianServiceCompatibilityService compatibilityService;
  final Function(List<Service>) onServicesSelected;

  const _ServiceSelectorDialog({
    required this.availableServices,
    required this.selectedServices,
    required this.selectedTechnicianId,
    required this.compatibilityService,
    required this.onServicesSelected,
  });

  @override
  State<_ServiceSelectorDialog> createState() => _ServiceSelectorDialogState();
}

class _ServiceSelectorDialogState extends State<_ServiceSelectorDialog> {
  late List<Service> _tempSelectedServices;
  String _searchQuery = '';
  Map<String, bool> _serviceCompatibility = {};
  bool _loadingCompatibility = false;

  @override
  void initState() {
    super.initState();
    _tempSelectedServices = List.from(widget.selectedServices);
    _checkAllServiceCompatibility();
  }

  /// Check compatibility for all services with selected technician
  Future<void> _checkAllServiceCompatibility() async {
    if (widget.selectedTechnicianId == null) return;

    setState(() => _loadingCompatibility = true);

    try {
      final compatibilityResults = <String, bool>{};
      
      for (final service in widget.availableServices) {
        final isCompatible = await widget.compatibilityService.canTechnicianPerformService(
          technicianId: widget.selectedTechnicianId!,
          service: service,
        );
        compatibilityResults[service.id] = isCompatible;
      }

      if (mounted) {
        setState(() {
          _serviceCompatibility = compatibilityResults;
          _loadingCompatibility = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingCompatibility = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = widget.availableServices.where((service) {
      if (_searchQuery.isEmpty) return true;
      return service.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Select Services',
                  style: AppTextStyles.headline3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.selectedTechnicianId != null && widget.selectedTechnicianId != 'any') ...[
                  const Spacer(),
                  if (_loadingCompatibility)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Filtered by technician',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search services...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  final isSelected = _tempSelectedServices.contains(service);
                  final isCompatible = _serviceCompatibility[service.id] ?? true;
                  final hasCompatibilityInfo = widget.selectedTechnicianId != null && 
                      widget.selectedTechnicianId != 'any' && 
                      _serviceCompatibility.isNotEmpty;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: hasCompatibilityInfo && !isCompatible
                          ? AppColors.errorRed.withValues(alpha: 0.05)
                          : null,
                      border: hasCompatibilityInfo && !isCompatible
                          ? Border.all(color: AppColors.errorRed.withValues(alpha: 0.2))
                          : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _tempSelectedServices.add(service);
                          } else {
                            _tempSelectedServices.remove(service);
                          }
                        });
                      },
                      title: Row(
                        children: [
                          Expanded(child: Text(service.name)),
                          if (hasCompatibilityInfo) ...[
                            const SizedBox(width: 8),
                            Icon(
                              isCompatible ? Icons.check_circle : Icons.warning,
                              size: 16,
                              color: isCompatible ? AppColors.successGreen : AppColors.errorRed,
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${service.durationMinutes} min • \$${service.basePrice.toStringAsFixed(2)}',
                          ),
                          if (hasCompatibilityInfo && !isCompatible)
                            Text(
                              'Selected technician cannot perform this service',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.errorRed,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      activeColor: AppColors.primaryBlue,
                      enabled: !hasCompatibilityInfo || isCompatible,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${_tempSelectedServices.length} selected',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onServicesSelected(_tempSelectedServices);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelAppointmentDialog extends StatefulWidget {
  final String customerName;
  final DateTime appointmentDate;
  final Function(String) onCancel;

  const _CancelAppointmentDialog({
    required this.customerName,
    required this.appointmentDate,
    required this.onCancel,
  });

  @override
  State<_CancelAppointmentDialog> createState() => _CancelAppointmentDialogState();
}

class _CancelAppointmentDialogState extends State<_CancelAppointmentDialog> {
  String? _selectedReason;
  final _customReasonController = TextEditingController();
  bool _isCustomReason = false;

  final List<String> _predefinedReasons = [
    'Customer requested cancellation',
    'No show - customer did not arrive',
    'No response to confirmation calls',
    'Technician unavailable',
    'Emergency scheduling conflict',
    'Customer illness',
    'Weather conditions',
    'Equipment issues',
    'Other (specify below)',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.cancel_outlined, color: AppColors.errorRed, size: 28),
          const SizedBox(width: 12),
          const Text('Cancel Appointment'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer: ${widget.customerName}',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${_formatDate(widget.appointmentDate)}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Reason for cancellation:',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Reason selection
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: _predefinedReasons.map((reason) {
                    final isOther = reason.startsWith('Other');
                    return RadioListTile<String>(
                      title: Text(
                        reason,
                        style: AppTextStyles.bodyMedium,
                      ),
                      value: reason,
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value;
                          _isCustomReason = isOther;
                          if (!isOther) {
                            _customReasonController.clear();
                          }
                        });
                      },
                      dense: true,
                      activeColor: AppColors.primaryBlue,
                    );
                  }).toList(),
                ),
              ),
            ),
            // Custom reason text field (shown when "Other" is selected)
            if (_isCustomReason) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customReasonController,
                decoration: const InputDecoration(
                  labelText: 'Please specify the reason',
                  border: OutlineInputBorder(),
                  hintText: 'Enter custom cancellation reason...',
                ),
                maxLines: 2,
                maxLength: 200,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Keep Appointment'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _canConfirmCancellation() ? _showFinalConfirmation : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel Appointment'),
        ),
      ],
    );
  }

  bool _canConfirmCancellation() {
    if (_selectedReason == null) return false;
    if (_isCustomReason && _customReasonController.text.trim().isEmpty) return false;
    return true;
  }

  void _showFinalConfirmation() {
    final reason = _isCustomReason 
        ? _customReasonController.text.trim()
        : _selectedReason!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to cancel this appointment?'),
            const SizedBox(height: 16),
            Text(
              'Customer: ${widget.customerName}',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'Date: ${_formatDate(widget.appointmentDate)}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Reason: $reason',
              style: AppTextStyles.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'This action will mark the appointment as cancelled. The customer should be notified of the cancellation.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warningOrange,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Go back to reason selection
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              Navigator.of(context).pop(); // Close reason dialog
              widget.onCancel(reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final time = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    
    return '$weekday, $month ${date.day}, ${date.year} at $time';
  }
}

class _SuggestedTechniciansDialog extends StatelessWidget {
  final List<Service> incompatibleServices;
  final List<Employee> suggestedTechnicians;
  final Function(String) onTechnicianSelected;

  const _SuggestedTechniciansDialog({
    required this.incompatibleServices,
    required this.suggestedTechnicians,
    required this.onTechnicianSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.swap_horiz, color: AppColors.primaryBlue, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Alternative Technicians',
                  style: AppTextStyles.headline3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'These technicians can perform the incompatible services:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: incompatibleServices.map((service) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    service.name,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Suggested technicians:',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestedTechnicians.length,
                itemBuilder: (context, index) {
                  final technician = suggestedTechnicians[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          technician.fullName.isNotEmpty ? technician.fullName[0] : 'T',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        technician.fullName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        technician.role,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => onTechnicianSelected(technician.id.toString()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
