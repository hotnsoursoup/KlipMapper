// lib/features/shared/presentation/widgets/price_override_dialog.dart
// Price override dialog for modifying service prices with manager authorization and validation. Allows authorized price adjustments with reason tracking and audit logging.
// Usage: ACTIVE - Used in checkout and service selection for authorized price modifications

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/privileged_operations.dart';
import '../../data/models/service_model.dart';

/// Dialog for overriding service prices with PIN protection
class PriceOverrideDialog extends StatefulWidget {
  final Service service;
  final int currentEmployeeId;
  final Function(double newPrice, String reason)? onPriceChanged;

  const PriceOverrideDialog({
    super.key,
    required this.service,
    required this.currentEmployeeId,
    this.onPriceChanged,
  });

  @override
  State<PriceOverrideDialog> createState() => _PriceOverrideDialogState();
}

class _PriceOverrideDialogState extends State<PriceOverrideDialog> {
  final _newPriceController = TextEditingController();
  final _reasonController = TextEditingController();
  
  bool _isProcessing = false;
  String? _selectedReason;
  double? _discountPercentage;

  // Common reasons for price overrides
  final List<String> _priceOverrideReasons = [
    'Loyalty customer discount',
    'First-time customer promotion',
    'Senior/student discount', 
    'Service issue compensation',
    'Staff discount',
    'Manager special pricing',
    'Group booking discount',
    'Price match request',
    'Technical issue adjustment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _newPriceController.text = widget.service.basePrice.toStringAsFixed(2);
    _calculateDiscountPercentage();
    
    _newPriceController.addListener(() {
      _calculateDiscountPercentage();
    });
  }

  @override
  void dispose() {
    _newPriceController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _calculateDiscountPercentage() {
    final newPrice = double.tryParse(_newPriceController.text);
    if (newPrice != null && widget.service.basePrice > 0) {
      final discount = ((widget.service.basePrice - newPrice) / widget.service.basePrice) * 100;
      setState(() {
        _discountPercentage = discount;
      });
    } else {
      setState(() {
        _discountPercentage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildServiceInfo(),
            const SizedBox(height: 16),
            _buildPriceSection(),
            const SizedBox(height: 16),
            _buildReasonSection(),
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
            color: AppColors.warningOrange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit,
            color: AppColors.warningOrange,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Override Price',
                style: AppTextStyles.headline2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Modify the price for this service',
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

  Widget _buildServiceInfo() {
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
            widget.service.name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Original Price:',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: 8),
              Text(
                '\$${widget.service.basePrice.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Duration: ${widget.service.durationMinutes} minutes',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Price *',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _newPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _discountPercentage != null && _discountPercentage! > 0
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _discountPercentage! > 0 
                                ? AppColors.successGreen 
                                : AppColors.errorRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_discountPercentage!.toStringAsFixed(1)}%',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildQuickPriceButton('10% Off', 0.10),
                  const SizedBox(height: 4),
                  _buildQuickPriceButton('20% Off', 0.20),
                ],
              ),
            ),
          ],
        ),
        if (_discountPercentage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _discountPercentage! >= 0 
                  ? AppColors.successGreen.withValues(alpha: 0.1)
                  : AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _discountPercentage! >= 0 
                    ? AppColors.successGreen.withValues(alpha: 0.3)
                    : AppColors.errorRed.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _discountPercentage! >= 0 ? Icons.trending_down : Icons.trending_up,
                  size: 16,
                  color: _discountPercentage! >= 0 
                      ? AppColors.successGreen 
                      : AppColors.errorRed,
                ),
                const SizedBox(width: 8),
                Text(
                  _discountPercentage! >= 0 
                      ? 'Discount: ${_discountPercentage!.toStringAsFixed(1)}%'
                      : 'Price increase: ${(-_discountPercentage!).toStringAsFixed(1)}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _discountPercentage! >= 0 
                        ? AppColors.successGreen 
                        : AppColors.errorRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Difference: ${_discountPercentage! >= 0 ? '-' : '+'}\$${(widget.service.basePrice - (double.tryParse(_newPriceController.text) ?? widget.service.basePrice)).abs().toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickPriceButton(String label, double discountPercent) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          final newPrice = widget.service.basePrice * (1 - discountPercent);
          _newPriceController.text = newPrice.toStringAsFixed(2);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Override *',
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
          items: _priceOverrideReasons.map((reason) => DropdownMenuItem(
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
            onPressed: _isProcessing ? null : _handleOverride,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningOrange,
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
                : const Text('Override Price'),
          ),
        ),
      ],
    );
  }

  Future<void> _handleOverride() async {
    // Validate form
    final newPrice = double.tryParse(_newPriceController.text);
    if (newPrice == null || newPrice < 0) {
      _showSnackBar('Please enter a valid price', AppColors.warningOrange);
      return;
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
      
      final success = await context.executePrivilegedOperation(
        PrivilegedOperation.modifyPrice,
        widget.currentEmployeeId,
        () async {
          // Simulate price override operation
          await Future.delayed(const Duration(milliseconds: 500));
          return true;
        },
        onSuccess: (result) {
          if (result == true) {
            _showSnackBar('Price override applied successfully', AppColors.successGreen);
            widget.onPriceChanged?.call(newPrice, reason);
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