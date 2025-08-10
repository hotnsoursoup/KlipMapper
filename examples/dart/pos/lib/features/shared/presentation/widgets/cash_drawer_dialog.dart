// lib/features/shared/presentation/widgets/cash_drawer_dialog.dart
// Cash drawer management dialog for opening cash drawer and handling cash-related operations. Provides secure cash drawer controls with manager authorization.
// Usage: ACTIVE - Used in POS operations for cash drawer management and end-of-day procedures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/privileged_operations.dart';

/// Dialog for cash drawer operations with PIN protection
class CashDrawerDialog extends StatefulWidget {
  final CashDrawerOperation operation;
  final int currentEmployeeId;
  final Function(bool success, double? amount)? onComplete;

  const CashDrawerDialog({
    super.key,
    required this.operation,
    required this.currentEmployeeId,
    this.onComplete,
  });

  /// Factory for opening cash drawer
  factory CashDrawerDialog.open({
    required int currentEmployeeId,
    Function(bool success, double? amount)? onComplete,
  }) {
    return CashDrawerDialog(
      operation: CashDrawerOperation.open,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  /// Factory for cash drop
  factory CashDrawerDialog.drop({
    required int currentEmployeeId,
    Function(bool success, double? amount)? onComplete,
  }) {
    return CashDrawerDialog(
      operation: CashDrawerOperation.drop,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  /// Factory for cash pickup
  factory CashDrawerDialog.pickup({
    required int currentEmployeeId,
    Function(bool success, double? amount)? onComplete,
  }) {
    return CashDrawerDialog(
      operation: CashDrawerOperation.pickup,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  /// Factory for cash count
  factory CashDrawerDialog.count({
    required int currentEmployeeId,
    Function(bool success, double? amount)? onComplete,
  }) {
    return CashDrawerDialog(
      operation: CashDrawerOperation.count,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  @override
  State<CashDrawerDialog> createState() => _CashDrawerDialogState();
}

enum CashDrawerOperation {
  open('Open Drawer', 'Open the cash drawer without a transaction', Icons.point_of_sale),
  drop('Cash Drop', 'Remove cash from the drawer for deposit', Icons.arrow_circle_down),
  pickup('Cash Pickup', 'Add cash to the drawer from bank/change fund', Icons.arrow_circle_up),
  count('Cash Count', 'Count and record current cash in drawer', Icons.calculate);

  final String title;
  final String description;
  final IconData icon;
  const CashDrawerOperation(this.title, this.description, this.icon);
}

class _CashDrawerDialogState extends State<CashDrawerDialog> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  // For cash count
  final Map<String, TextEditingController> _denominationControllers = {
    '100': TextEditingController(),
    '50': TextEditingController(),
    '20': TextEditingController(),
    '10': TextEditingController(),
    '5': TextEditingController(),
    '1': TextEditingController(),
    '0.25': TextEditingController(),
    '0.10': TextEditingController(),
    '0.05': TextEditingController(),
    '0.01': TextEditingController(),
  };
  
  bool _isProcessing = false;
  String? _selectedReason;
  bool _showDenominationBreakdown = false;

  // Common reasons for each operation
  final Map<CashDrawerOperation, List<String>> _operationReasons = {
    CashDrawerOperation.open: [
      'Customer needs change',
      'Receipt issue',
      'Check payment',
      'Manager request',
      'Drawer stuck',
      'Other',
    ],
    CashDrawerOperation.drop: [
      'End of shift deposit',
      'Excess cash removal',
      'Bank deposit preparation',
      'Security precaution',
      'Manager instruction',
      'Other',
    ],
    CashDrawerOperation.pickup: [
      'Start of shift change fund',
      'Bank withdrawal addition',
      'Till replenishment',
      'Change shortage correction',
      'Manager instruction',
      'Other',
    ],
    CashDrawerOperation.count: [
      'Shift change reconciliation',
      'Daily closing count',
      'Audit requirement',
      'Discrepancy investigation',
      'Manager request',
      'Other',
    ],
  };

  @override
  void initState() {
    super.initState();
    
    // Add listeners for denomination controllers to calculate total
    if (widget.operation == CashDrawerOperation.count) {
      for (final controller in _denominationControllers.values) {
        controller.addListener(_calculateTotal);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    for (final controller in _denominationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateTotal() {
    double total = 0.0;
    _denominationControllers.forEach((denomination, controller) {
      final count = int.tryParse(controller.text) ?? 0;
      final value = double.parse(denomination);
      total += count * value;
    });
    
    _amountController.text = total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            if (_requiresAmount()) _buildAmountSection(),
            if (widget.operation == CashDrawerOperation.count) _buildCountSection(),
            _buildReasonSection(),
            const SizedBox(height: 16),
            _buildNotesSection(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.operation.icon,
            color: AppColors.primaryBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.operation.title,
                style: AppTextStyles.headline2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.operation.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount *',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: '\$',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cash Count',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Switch(
              value: _showDenominationBreakdown,
              onChanged: (value) {
                setState(() {
                  _showDenominationBreakdown = value;
                  if (!value) {
                    // Clear denomination controllers when disabled
                    for (final controller in _denominationControllers.values) {
                      controller.clear();
                    }
                    _amountController.clear();
                  }
                });
              },
            ),
            const SizedBox(width: 8),
            Text(
              'Count by denomination',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_showDenominationBreakdown) ...[
          _buildDenominationGrid(),
          const SizedBox(height: 16),
        ] else ...[
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              prefixText: '\$',
              labelText: 'Total Cash Amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildDenominationGrid() {
    final bills = ['100', '50', '20', '10', '5', '1'];
    final coins = ['0.25', '0.10', '0.05', '0.01'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bills',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final denomination = bills[index];
              return _buildDenominationField(denomination, '\$$denomination');
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Coins',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: coins.length,
            itemBuilder: (context, index) {
              final denomination = coins[index];
              return _buildDenominationField(denomination, '${(double.parse(denomination) * 100).toInt()}¢');
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${_amountController.text.isEmpty ? '0.00' : _amountController.text}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationField(String denomination, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _denominationControllers[denomination],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '0',
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    final reasons = _operationReasons[widget.operation] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason *',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedReason,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: reasons.map((reason) => DropdownMenuItem(
            value: reason,
            child: Text(reason),
          ),).toList(),
          onChanged: (value) {
            setState(() {
              _selectedReason = value;
              if (value != 'Other') {
                _reasonController.text = value ?? '';
              } else {
                _reasonController.clear();
              }
            });
          },
        ),
        if (_selectedReason == 'Other') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Please specify reason',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
          'Additional Notes',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter any additional notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _handleOperation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(widget.operation.title),
          ),
        ),
      ],
    );
  }

  bool _requiresAmount() {
    return widget.operation != CashDrawerOperation.open;
  }

  Future<void> _handleOperation() async {
    // Validate form
    if (_requiresAmount()) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount < 0) {
        _showSnackBar('Please enter a valid amount', AppColors.warningOrange);
        return;
      }
    }

    if (_selectedReason == null) {
      _showSnackBar('Please select a reason', AppColors.warningOrange);
      return;
    }
    
    if (_selectedReason == 'Other' && _reasonController.text.trim().isEmpty) {
      _showSnackBar('Please specify the reason', AppColors.warningOrange);
      return;
    }

    final reason = _selectedReason == 'Other' 
        ? _reasonController.text.trim() 
        : _selectedReason!;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (!mounted) return;
      
      // Map operations to privileged operations
      // For now, we'll use accessSettings as a placeholder for cash operations
      const privilegedOp = PrivilegedOperation.accessSettings;
      
      final success = await context.executePrivilegedOperation(
        privilegedOp,
        widget.currentEmployeeId,
        () async {
          // Simulate cash drawer operation
          await Future.delayed(const Duration(milliseconds: 1000));
          
          // Here you would integrate with actual cash drawer hardware/API
          // For now, we'll just simulate success
          return true;
        },
        config: PrivilegedOperationConfig(
          customMessage: 'Enter PIN to ${widget.operation.title.toLowerCase()}',
        ),
        onSuccess: (result) {
          if (result == true) {
            final amount = _requiresAmount() ? double.tryParse(_amountController.text) : null;
            _showSnackBar('${widget.operation.title} completed successfully', AppColors.successGreen);
            widget.onComplete?.call(true, amount);
            Navigator.of(context).pop(true);
          }
        },
        onError: (error) {
          _showSnackBar('Error: ${error.toString()}', AppColors.errorRed);
        },
      );

      if (success == null) {
        // Authorization was denied
        _showSnackBar('Authorization required', AppColors.warningOrange);
      }

    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', AppColors.errorRed);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}