// lib/features/tickets/presentation/widgets/ticket_filters.dart
// Comprehensive ticket filtering widget with multi-criteria search and real-time updates.
// Provides status, technician, customer, date range, and amount filtering with autocomplete and debounced input handling.
// Usage: ACTIVE - Used in tickets screen for advanced ticket search and filtering functionality

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/repositories/drift_employee_repository.dart';
import '../../../shared/data/repositories/drift_customer_repository.dart';
import '../../../../core/utils/debouncer.dart';

class TicketFilters extends StatefulWidget {
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTechnicianChanged;
  final ValueChanged<String?> onCustomerTypeChanged;
  final ValueChanged<String?> onCustomerNameChanged;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;
  final ValueChanged<RangeValues?> onAmountRangeChanged;

  const TicketFilters({
    super.key,
    required this.onStatusChanged,
    required this.onTechnicianChanged,
    required this.onCustomerTypeChanged,
    required this.onCustomerNameChanged,
    required this.onDateRangeChanged,
    required this.onAmountRangeChanged,
  });

  @override
  State<TicketFilters> createState() => _TicketFiltersState();
}

class _TicketFiltersState extends State<TicketFilters> {
  String? _selectedStatus;
  String? _selectedTechnician;
  String? _selectedCustomerType;
  String? _customerNameQuery;
  DateTime? _startDate;
  DateTime? _endDate;
  double? _minAmount;
  double? _maxAmount;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final _customerNameController = TextEditingController();
  List<String> _technicianNames = ['All Technicians'];
  List<String> _customerNames = [];
  final _amountDebouncer = Debouncer(milliseconds: 300);
  final _customerNameDebouncer = Debouncer(milliseconds: 300);
  double _technicianDropdownWidth = 200;

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
    _loadCustomers();
  }

  Future<void> _loadTechnicians() async {
    final employeeRepo = DriftEmployeeRepository.instance;
    await employeeRepo.initialize();
    final technicians = await employeeRepo.getEmployees();
    setState(() {
      _technicianNames = ['All Technicians', ...technicians.map((t) => '${t.firstName} ${t.lastName}'.trim())];
      _calculateTechnicianDropdownWidth();
    });
  }

  void _calculateTechnicianDropdownWidth() {
    // Calculate the required width based on the longest technician name
    double maxWidth = 0;
    
    for (final name in _technicianNames) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: name,
          style: AppTextStyles.bodyMedium,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      
      // Add padding for icon (16 + 8 spacing) + dropdown arrow (20) + padding (16) + extra margin (20)
      final requiredWidth = textPainter.width + 16 + 8 + 20 + 16 + 20;
      if (requiredWidth > maxWidth) {
        maxWidth = requiredWidth;
      }
    }
    
    // Set minimum width to 200, maximum to 280
    _technicianDropdownWidth = maxWidth.clamp(200, 280);
  }

  Future<void> _loadCustomers() async {
    try {
      final customerRepo = DriftCustomerRepository.instance;
      await customerRepo.initialize();
      final customers = await customerRepo.getCustomers();
      setState(() {
        _customerNames = customers.map((c) => c.name).toList();
        _customerNames.sort(); // Sort alphabetically for better UX
      });
    } catch (e) {
      // Handle error silently, autocomplete will just not have suggestions
      debugPrint('Failed to load customers for autocomplete: $e');
    }
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _customerNameController.dispose();
    _amountDebouncer.dispose();
    _customerNameDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceLight,
      child: Column(
        children: [
          // Primary filters row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                // Status dropdown
                SizedBox(
                  width: 150,
                  child: _buildCompactDropdown(
                    value: _selectedStatus ?? 'All Status',
                    items: ['All Status', 'Queued', 'In-Service', 'Completed', 'Paid', 'Cancelled', 'Refunded', 'Voided'],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value == 'All Status' ? null : value;
                      });
                      widget.onStatusChanged(_selectedStatus);
                    },
                    icon: Icons.flag_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                // Technician dropdown
                SizedBox(
                  width: _technicianDropdownWidth,
                  child: _buildCompactDropdown(
                    value: _selectedTechnician ?? 'All Technicians',
                    items: _technicianNames,
                    onChanged: (value) {
                      setState(() {
                        _selectedTechnician = value == 'All Technicians' ? null : value;
                      });
                      widget.onTechnicianChanged(_selectedTechnician);
                    },
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 12),
                // Customer type dropdown
                SizedBox(
                  width: 180,
                  child: _buildCompactDropdown(
                    value: _selectedCustomerType ?? 'All Types',
                    items: ['All Types', 'Walk-in', 'Appointment'],
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomerType = value == 'All Types' ? null : value;
                      });
                      widget.onCustomerTypeChanged(_selectedCustomerType);
                    },
                    icon: Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 12),
                // Customer name search field with autocomplete
                SizedBox(
                  width: 250,  // Made wider for better usability
                  height: 36,
                  child: _buildCustomerNameAutocomplete(),
                ),
                const SizedBox(width: 12),
                // Start date picker
                SizedBox(
                  width: 120,
                  height: 36,
                  child: InkWell(
                    onTap: () => _selectSingleDate(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _startDate != null
                                  ? '${_startDate!.month}/${_startDate!.day}/${_startDate!.year.toString().substring(2)}'
                                  : 'Start Date',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _startDate != null ? AppColors.textPrimary : AppColors.textLight,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // End date picker
                SizedBox(
                  width: 120,
                  height: 36,
                  child: InkWell(
                    onTap: () => _selectSingleDate(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _endDate != null
                                  ? '${_endDate!.month}/${_endDate!.day}/${_endDate!.year.toString().substring(2)}'
                                  : 'End Date',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _endDate != null ? AppColors.textPrimary : AppColors.textLight,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Quick date filters
                _buildQuickDateFilter('Today', 0),
                const SizedBox(width: 8),
                _buildQuickDateFilter('7 days', 7),
                const SizedBox(width: 8),
                _buildQuickDateFilter('30 days', 30),
                const SizedBox(width: 16),
                Container(
                  height: 30,
                  width: 1,
                  color: AppColors.border,
                ),
                const SizedBox(width: 16),
                // Amount range fields moved to main row
                Text(
                  'Amount:',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  height: 36,
                  child: _buildCompactAmountField(
                    hintText: 'Min',
                    controller: _minAmountController,
                    onChanged: (value) {
                      _amountDebouncer.run(() {
                        _minAmount = double.tryParse(value);
                        _updateAmountRange();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  height: 36,
                  child: _buildCompactAmountField(
                    hintText: 'Max',
                    controller: _maxAmountController,
                    onChanged: (value) {
                      _amountDebouncer.run(() {
                        _maxAmount = double.tryParse(value);
                        _updateAmountRange();
                      });
                    },
                  ),
                ),
                const Spacer(),
                // Clear filters button
                if (_hasActiveFilters())
                  OutlinedButton.icon(
                    onPressed: _clearAllFilters,
                    icon: const Icon(Icons.clear, size: 16),
                    label: Text('Clear (${_getActiveFilterCount()})'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: BorderSide(color: AppColors.errorRed.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(

          value: value,
          isExpanded: true,
          isDense: true,
          style: AppTextStyles.bodyMedium,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          padding: const EdgeInsets.only(left: 8, right: 8),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }


  Widget _buildCompactAmountField({
    required String hintText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.bodySmall,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
          prefixText: '\$',
          prefixStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          isDense: true,
        ),
      ),
    );
  }

  void _selectSingleDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart 
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        if (isStart) {
          _startDate = picked;
          // If end date is before start date, clear it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
          // If start date is not set, set it to the same as end date
          _startDate ??= picked;
        }
      });
      
      // Update the date range
      if (_startDate != null && _endDate != null) {
        widget.onDateRangeChanged(DateTimeRange(start: _startDate!, end: _endDate!));
      } else if (_startDate != null) {
        // If only start date is set, use it as both start and end
        widget.onDateRangeChanged(DateTimeRange(start: _startDate!, end: _startDate!));
      }
    }
  }

  void _updateAmountRange() {
    if (_minAmount != null || _maxAmount != null) {
      final min = _minAmount ?? 0.0;
      final max = _maxAmount ?? double.infinity;
      widget.onAmountRangeChanged(RangeValues(min, max));
    } else {
      widget.onAmountRangeChanged(null);
    }
  }

  Widget _buildQuickDateFilter(String label, int days) {
    final isActive = _isQuickFilterActive(days);
    return OutlinedButton(
      onPressed: () => _setQuickDateFilter(days),
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? Colors.white : AppColors.textSecondary,
        backgroundColor: isActive ? AppColors.primaryBlue : Colors.transparent,
        side: BorderSide(
          color: isActive ? AppColors.primaryBlue : AppColors.border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minimumSize: const Size(0, 36),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: isActive ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  bool _isQuickFilterActive(int days) {
    if (_startDate == null || _endDate == null) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (days == 0) {
      // Today
      return _startDate!.day == today.day && 
             _startDate!.month == today.month && 
             _startDate!.year == today.year &&
             _endDate!.day == today.day && 
             _endDate!.month == today.month && 
             _endDate!.year == today.year;
    } else {
      final startDate = today.subtract(Duration(days: days));
      return _startDate!.day == startDate.day && 
             _startDate!.month == startDate.month && 
             _startDate!.year == startDate.year &&
             _endDate!.day == today.day && 
             _endDate!.month == today.month && 
             _endDate!.year == today.year;
    }
  }

  void _setQuickDateFilter(int daysBack) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    setState(() {
      if (daysBack == 0) {
        _startDate = today;
        _endDate = today;
      } else {
        _startDate = today.subtract(Duration(days: daysBack));
        _endDate = today;
      }
    });
    
    widget.onDateRangeChanged(DateTimeRange(start: _startDate!, end: _endDate!));
  }

  void _clearAllFilters() {
    // Cancel any pending debounced operations
    _amountDebouncer.cancel();
    _customerNameDebouncer.cancel();
    
    setState(() {
      _selectedStatus = null;
      _selectedTechnician = null;
      _selectedCustomerType = null;
      _customerNameQuery = null;
      _startDate = null;
      _endDate = null;
      _minAmount = null;
      _maxAmount = null;
      _minAmountController.clear();
      _maxAmountController.clear();
      _customerNameController.clear();
    });
    
    widget.onStatusChanged(null);
    widget.onTechnicianChanged(null);
    widget.onCustomerTypeChanged(null);
    widget.onCustomerNameChanged(null);
    widget.onDateRangeChanged(null);
    widget.onAmountRangeChanged(null);
  }

  bool _hasActiveFilters() {
    return _selectedStatus != null ||
           _selectedTechnician != null ||
           _selectedCustomerType != null ||
           _customerNameQuery != null ||
           _startDate != null ||
           _endDate != null ||
           _minAmount != null ||
           _maxAmount != null;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedStatus != null) count++;
    if (_selectedTechnician != null) count++;
    if (_selectedCustomerType != null) count++;
    if (_customerNameQuery != null) count++;
    if (_startDate != null || _endDate != null) count++;
    if (_minAmount != null || _maxAmount != null) count++;
    return count;
  }

  Widget _buildCustomerNameAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        
        final query = textEditingValue.text.toLowerCase();
        return _customerNames.where((customer) {
          return customer.toLowerCase().contains(query);
        }).take(8); // Limit to 8 suggestions for better UX
      },
      onSelected: (String selection) {
        _customerNameController.text = selection;
        _customerNameDebouncer.run(() {
          setState(() {
            _customerNameQuery = selection.trim().isEmpty ? null : selection.trim();
          });
          widget.onCustomerNameChanged(_customerNameQuery);
        });
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Sync with our controller
        if (textEditingController.text != _customerNameController.text) {
          textEditingController.text = _customerNameController.text;
        }
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            style: AppTextStyles.bodyMedium,
            onChanged: (value) {
              _customerNameController.text = value;
              _customerNameDebouncer.run(() {
                setState(() {
                  _customerNameQuery = value.trim().isEmpty ? null : value.trim();
                });
                widget.onCustomerNameChanged(_customerNameQuery);
              });
            },
            onSubmitted: (value) => onFieldSubmitted(),
            decoration: InputDecoration(
              hintText: 'Search Customer Name...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
              prefixIcon: Icon(Icons.person_search, size: 16, color: AppColors.textSecondary),
              suffixIcon: _customerNameQuery != null 
                ? IconButton(
                    icon: Icon(Icons.clear, size: 16, color: AppColors.textSecondary),
                    onPressed: () {
                      textEditingController.clear();
                      _customerNameController.clear();
                      _customerNameDebouncer.cancel(); // Cancel pending debounced calls
                      setState(() {
                        _customerNameQuery = null;
                      });
                      widget.onCustomerNameChanged(null);
                    },
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              isDense: true,
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: index < options.length - 1 
                          ? Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3)))
                          : null,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              option,
                              style: AppTextStyles.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}