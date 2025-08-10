// lib/features/employees/presentation/widgets/employee_details_dialog.dart
// Employee details dialog for viewing and editing employee information with Riverpod state management. Features comprehensive employee data form, validation, and secure information handling for HR operations.
// Usage: ACTIVE - Used throughout employee management screens for employee data viewing and editing

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/auth/pin_auth_service.dart';
import '../../../../core/auth/widgets/pin_management_dialog.dart';
import '../../../../utils/error_logger.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../data/models/employee_capability.dart';
import '../../../services/providers/services_provider.dart';
import '../../../../core/database/database.dart' as db;
import 'pin_setup_card.dart';
import 'employee_schedule_editor.dart';

/// A comprehensive dialog for creating and editing employee details.
/// 
/// Features:
/// * Full employee information form (name, contact, role, rates)
/// * PIN management with secure authentication
/// * Service capability assignment with category filtering
/// * Employee scheduling and availability management
/// * Form validation with error handling
/// * Riverpod integration for state management
/// * Create and edit modes with different UX flows
/// * Delete functionality with confirmation
/// 
/// Usage:
/// ```dart
/// // Create new employee
/// EmployeeDetailsDialog(
///   onSave: (employee) => _createEmployee(employee),
/// )
/// 
/// // Edit existing employee
/// EmployeeDetailsDialog(
///   employee: existingEmployee,
///   onSave: (employee) => _updateEmployee(employee),
///   onDelete: (id) => _deleteEmployee(id),
/// )
/// ```
class EmployeeDetailsDialog extends ConsumerStatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;
  final Function(String)? onDelete;

  const EmployeeDetailsDialog({
    super.key,
    this.employee,
    required this.onSave,
    this.onDelete,
  });

  @override
  ConsumerState<EmployeeDetailsDialog> createState() => _EmployeeDetailsDialogState();
}

class _EmployeeDetailsDialogState extends ConsumerState<EmployeeDetailsDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _commissionRateController;

  String _selectedRole = 'technician';
  bool _isActive = true;
  List<String> _selectedCapabilities = [];
  List<db.ServiceCategory> _serviceCategories = [];
  bool _isLoadingCategories = false;
  
  // PIN status tracking
  final _pinAuthService = PinAuthService.instance;
  bool _hasPin = false;
  bool _isLoadingPinStatus = false;

  final List<String> _roles = [
    'technician',
    'manager',
    'receptionist',
    'admin',
  ];

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;

    // Use firstName and lastName from employee model
    final String firstName = employee?.firstName ?? '';
    final String lastName = employee?.lastName ?? '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(text: employee?.email ?? '');
    _phoneController = TextEditingController(text: employee?.phone ?? '');
    _commissionRateController = TextEditingController(
      text: employee?.commissionRate != null && employee!.commissionRate > 0
          ? (employee.commissionRate * 100).toStringAsFixed(0)
          : '',
    );

    if (employee != null) {
      _selectedRole = employee.role;
      _isActive = employee.status == 'active';
      // Load selected capabilities after service categories are loaded
      _loadSelectedCapabilities();
    } else {
      // For new employees, if they're technicians, auto-select Nails (mani-pedi)
      if (_selectedRole == 'technician') {
        _selectedCapabilities = ['1']; // Default to Nails category ID
      }
    }
    
    // Load service categories from database
    _loadServiceCategories();
    
    // Load PIN status for existing employee
    if (employee != null) {
      _loadPinStatus();
    }
  }
  
  Future<void> _loadPinStatus() async {
    if (widget.employee == null) return;
    
    setState(() {
      _isLoadingPinStatus = true;
    });
    
    try {
      final hasPin = await _pinAuthService.hasPin(widget.employee!.id);
      if (mounted) {
        setState(() {
          _hasPin = hasPin;
          _isLoadingPinStatus = false;
        });
      }
    } catch (e, stack) {
      ErrorLogger.logError('Error loading PIN status for employee ${widget.employee!.id}', e, stack);
      if (mounted) {
        setState(() {
          _isLoadingPinStatus = false;
        });
      }
    }
  }
  
  Future<void> _loadServiceCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    
    final categoriesAsync = ref.read(serviceCategoriesProvider);
    categoriesAsync.when(
      data: (categories) {
        if (mounted) {
          setState(() {
            _serviceCategories = categories.map((cat) => db.ServiceCategory(
              id: int.tryParse(cat.id) ?? 0,
              name: cat.name,
              color: cat.color,
            )).toList();
            _isLoadingCategories = false;
          });
          // Load selected capabilities after categories are loaded
          if (widget.employee != null) {
            _loadSelectedCapabilities();
          }
        }
      },
      loading: () {
        // Loading state handled above
      },
      error: (_, __) {
        if (mounted) {
          setState(() {
            _isLoadingCategories = false;
          });
        }
      },
    );
  }

  void _loadSelectedCapabilities() {
    if (widget.employee == null || _serviceCategories.isEmpty) return;
    
    // Create a mapping from capability names to service category IDs
    final capabilityToServiceIdMap = {
      'gels': '2',           // Gel Nails
      'acrylics': '3',       // Acrylics  
      'dip_powder': '6',     // SNS
      'waxing': '4',         // Waxing
      'facials': '5',        // Facial
      'massage': '5',        // Map to Facial for now
      'nail_art': '2',       // Map to Gel Nails for now
    };
    
    // Map employee capabilities to service category IDs
    final selectedIds = <String>[];
    for (final capability in widget.employee!.capabilities) {
      final serviceId = capabilityToServiceIdMap[capability.id];
      if (serviceId != null && !selectedIds.contains(serviceId)) {
        selectedIds.add(serviceId);
      }
    }
    
    setState(() {
      _selectedCapabilities = selectedIds;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _commissionRateController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      
      // Map selected capability IDs to EmployeeCapability objects
      final capabilities = _selectedCapabilities.map((categoryId) {
        // Find the service category
        final category = _serviceCategories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => db.ServiceCategory(
            id: categoryId,
            name: categoryId,
            color: '#808080',
          ),
        );
        
        // Convert to EmployeeCapability
        return EmployeeCapability(
          id: category.id ?? categoryId,
          name: category.name,
          displayName: category.name,
          color: category.color ?? '#808080',
        );
      }).toList();
      
      final employee = Employee(
        id: widget.employee?.id ?? 0, // 0 for new employees (will auto-increment)
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        commissionRate: _commissionRateController.text.isEmpty
            ? 0.0
            : double.tryParse(_commissionRateController.text)! / 100,
        status: _isActive ? 'active' : 'inactive',
        locationId: '',
        username: _emailController.text.trim(),
        capabilities: capabilities,
        createdAt: widget.employee?.createdAt ?? now,
        updatedAt: now,
      );

      widget.onSave(employee);
      
      // For new employees, offer PIN setup after saving
      if (widget.employee == null) {
        _showPinSetupSuggestion(employee);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  /// Show PIN setup suggestion for new employees
  void _showPinSetupSuggestion(Employee newEmployee) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee Created!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Set up PIN for secure operations?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${newEmployee.fullName} has been successfully added to your team.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure PIN Setup',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set up a PIN now to enable secure operations like refunds, price overrides, and time tracking.',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondary,
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close suggestion dialog
              Navigator.of(context).pop(); // Close employee dialog
            },
            child: const Text('Skip for Now'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Close suggestion dialog
              Navigator.of(context).pop(); // Close employee dialog
              _showQuickPinSetup(newEmployee);
            },
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('Set Up PIN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Show quick PIN setup for new employee
  void _showQuickPinSetup(Employee employee) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.setNew(
        employeeId: employee.id,
        employeeName: employee.fullName,
        onComplete: (success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PIN set up successfully for ${employee.fullName}'),
                backgroundColor: AppColors.successGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  /// Determine if a color is light (luminance > 0.5)
  bool _isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Get contrasting text color (black for light backgrounds, white for dark)
  Color _getContrastingTextColor(Color backgroundColor) {
    return _isLightColor(backgroundColor) ? Colors.black87 : Colors.white;
  }

  /// Adjust background color to ensure it's not too light for good contrast
  Color _getAdjustedBackgroundColor(Color originalColor) {
    final luminance = originalColor.computeLuminance();
    
    // If the color is too light (luminance > 0.85), darken it
    if (luminance > 0.85) {
      final hsl = HSLColor.fromColor(originalColor);
      return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
    }
    
    // If the color is too dark (luminance < 0.15), lighten it slightly
    if (luminance < 0.15) {
      final hsl = HSLColor.fromColor(originalColor);
      return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    }
    
    return originalColor;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee?'),
        content: Text(
          'Are you sure you want to permanently delete ${widget.employee!.firstName} ${widget.employee!.lastName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              Navigator.of(context).pop(); // Close employee details dialog
              widget.onDelete!(widget.employee!.id.toString());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildPinStatusSection() {
    if (widget.employee == null) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.security,
              size: 18,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'PIN Security',
              style: AppTextStyles.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        if (_isLoadingPinStatus)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading...',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_hasPin ? AppColors.successGreen : AppColors.warningOrange)
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: (_hasPin ? AppColors.successGreen : AppColors.warningOrange)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _hasPin ? Icons.lock : Icons.lock_open,
                  color: _hasPin ? AppColors.successGreen : AppColors.warningOrange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _hasPin ? 'PIN configured' : 'No PIN set',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _hasPin ? AppColors.successGreen : AppColors.warningOrange,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showPinManagementSheet(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _hasPin ? AppColors.primaryBlue : AppColors.successGreen,
                    side: BorderSide(
                      color: (_hasPin ? AppColors.primaryBlue : AppColors.successGreen)
                          .withValues(alpha: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    _hasPin ? 'Manage' : 'Set Up',
                    style: AppTextStyles.labelMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showPinManagementSheet() {
    if (widget.employee == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PinSetupCard(
        employee: widget.employee!,
        showManagerActions: true,
        currentManagerId: 1, // Assume current user is manager for now
        onPinChanged: () {
          // Reload PIN status when changed
          _loadPinStatus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    isEditing ? 'Edit Employee' : 'Add Employee',
                    style: AppTextStyles.headline2,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // First row: First Name, Last Name, Phone
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _PhoneNumberFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Second row: Email, Role, Commission Rate
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role[0].toUpperCase() + role.substring(1)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            final oldRole = _selectedRole;
                            _selectedRole = value;
                            
                            // If changing TO technician and no capabilities selected, auto-select Nails (mani-pedi)
                            if (value == 'technician' && oldRole != 'technician' && _selectedCapabilities.isEmpty) {
                              _selectedCapabilities = ['1']; // Mani-Pedi category ID
                            }
                            // If changing FROM technician TO technician (shouldn't happen but just in case)
                            else if (value == 'technician' && !_selectedCapabilities.contains('1')) {
                              _selectedCapabilities.add('1'); // Ensure Mani-Pedi is always included for technicians
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _commissionRateController,
                      decoration: const InputDecoration(
                        labelText: 'Commission (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent),
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final rate = int.tryParse(value);
                          if (rate == null || rate < 0 || rate > 100) {
                            return 'Please enter a valid percentage (0-100)';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Capabilities section
              Text(
                'Service Capabilities',
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _selectedRole == 'technician' 
                    ? 'Select what service categories this employee can perform. All technicians can do mani-pedi (Nails).'
                    : 'Select what service categories this employee can perform',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              if (_isLoadingCategories)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_serviceCategories.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'No service categories found. Please add service categories first.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.warningOrange,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _serviceCategories.map((category) {
                    final categoryId = category.id ?? '';
                    final isSelected = _selectedCapabilities.contains(categoryId);
                    final colorHex = category.color ?? '#808080';
                    final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                    
                    // Prevent technicians from deselecting Nails (mani-pedi is mandatory)
                    final canDeselect = !(_selectedRole == 'technician' && categoryId == '1');
                    
                    // Show required indicator for Nails if technician
                    final isRequired = _selectedRole == 'technician' && categoryId == '1';
                    
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(category.name),
                          if (isRequired) ...[
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                color: isSelected 
                                    ? _getContrastingTextColor(color)
                                    : AppColors.errorRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: isSelected,
                      onSelected: canDeselect ? (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCapabilities.add(categoryId);
                          } else {
                            _selectedCapabilities.remove(categoryId);
                          }
                        });
                      } : isSelected ? null : (selected) {
                        // Allow selecting if not selected, but not deselecting if it's Nails for technicians
                        setState(() {
                          if (selected) {
                            _selectedCapabilities.add(categoryId);
                          }
                        });
                      },
                      selectedColor: _getAdjustedBackgroundColor(color),
                      checkmarkColor: _getContrastingTextColor(_getAdjustedBackgroundColor(color)),
                      labelStyle: TextStyle(
                        color: isSelected 
                            ? _getContrastingTextColor(_getAdjustedBackgroundColor(color))
                            : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? _getAdjustedBackgroundColor(color) : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),

              // PIN Security Status
              if (isEditing) ...[
                _buildPinStatusSection(),
                const SizedBox(height: 12),
              ],

              // Employee Schedule Editor
              if (isEditing) ...[
                EmployeeScheduleEditor(
                  employeeId: widget.employee!.id,
                  employeeName: widget.employee!.fullName,
                ),
                const SizedBox(height: 12),
              ],

              // Active status
              if (isEditing)
                SwitchListTile(
                  title: Text(
                    'Active Employee',
                    style: AppTextStyles.labelLarge,
                  ),
                  subtitle: Text(
                    _isActive
                        ? 'Employee can be assigned to services'
                        : 'Employee cannot be assigned to services',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  thumbColor: WidgetStatePropertyAll<Color>(AppColors.successGreen),
                ),
              const SizedBox(height: 20),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Delete button (only show when editing)
                  if (isEditing && widget.onDelete != null)
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(),
                      icon: const Icon(Icons.delete, size: 20),
                      label: const Text('Delete Employee'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  // Save and Cancel buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Save Changes' : 'Add Employee',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom phone number formatter
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 10; i++) {
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
      buffer.write(digitsOnly[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
