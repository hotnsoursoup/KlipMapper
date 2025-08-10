/// Employee-authenticated discount selector widget with PIN protection.
/// 
/// **Architecture:**
/// - **Authentication**: PIN-protected access via PinProtectedWrapper
/// - **State Management**: Local StatefulWidget with form controllers
/// - **Validation**: Input validation for percentage/amount ranges
/// 
/// **Key Features:**
/// - Pre-defined quick discounts with single-tap application
/// - Custom discount creation (percentage or fixed amount)
/// - Required reason field for audit compliance
/// - Optional discount code tracking
/// - Real-time discount amount calculation
/// - Employee authorization tracking
/// 
/// **Discount Types:**
/// - **Percentage**: 1-100% with automatic calculation
/// - **Fixed Amount**: Dollar amount not exceeding subtotal
/// - **Quick Discounts**: Common preset discounts (10%, 15%, etc.)
/// 
/// **Security:**
/// - All discount applications require PIN authentication
/// - Employee ID tracking for audit trails
/// - Input validation prevents invalid discount amounts
/// 
/// **Usage:**
/// ```dart
/// DiscountSelector(
///   currentDiscount: existingDiscount,
///   subtotal: orderSubtotal,
///   currentEmployeeId: employeeId,
///   onDiscountChanged: (discount) => setState(() => this.discount = discount),
/// )
/// ```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/auth/widgets/pin_protected_wrapper.dart';
import '../../data/models/discount_model.dart';

class DiscountSelector extends StatefulWidget {
  final Discount? currentDiscount;
  final double subtotal;
  final int currentEmployeeId; // For PIN authentication
  final Function(Discount?) onDiscountChanged;

  const DiscountSelector({
    super.key,
    this.currentDiscount,
    required this.subtotal,
    required this.currentEmployeeId,
    required this.onDiscountChanged,
  });

  @override
  State<DiscountSelector> createState() => _DiscountSelectorState();
}

class _DiscountSelectorState extends State<DiscountSelector> {
  final _customAmountController = TextEditingController();
  final _customPercentageController = TextEditingController();
  final _discountCodeController = TextEditingController();
  final _reasonController = TextEditingController();
  
  bool _showCustomDiscount = false;
  String _customDiscountType = 'percentage'; // 'percentage' or 'fixed'

  @override
  void initState() {
    super.initState();
    
    // Initialize with current discount if exists
    if (widget.currentDiscount != null) {
      final discount = widget.currentDiscount!;
      _discountCodeController.text = discount.code ?? '';
      _reasonController.text = discount.reason ?? '';
      
      if (discount.type == 'percentage') {
        _customPercentageController.text = (discount.value * 100).toStringAsFixed(0);
        _customDiscountType = 'percentage';
        _showCustomDiscount = !Discount.commonDiscounts.any((d) => 
          d.type == discount.type && d.value == discount.value,);
      } else if (discount.type == 'fixed') {
        _customAmountController.text = discount.value.toStringAsFixed(2);
        _customDiscountType = 'fixed';
        _showCustomDiscount = !Discount.commonDiscounts.any((d) => 
          d.type == discount.type && d.value == discount.value,);
      }
    }
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _customPercentageController.dispose();
    _discountCodeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (widget.currentDiscount == null) ...[
            _buildQuickDiscounts(),
            const SizedBox(height: 16),
            _buildCustomDiscountToggle(),
            if (_showCustomDiscount) ...[
              const SizedBox(height: 16),
              _buildCustomDiscountForm(),
            ],
          ] else ...[
            _buildCurrentDiscount(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.local_offer,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Discount',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (widget.currentDiscount != null)
          TextButton.icon(
            onPressed: () => _removeDiscount(),
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Remove'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
          ),
      ],
    );
  }

  Widget _buildQuickDiscounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Discounts',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Discount.commonDiscounts.map((discount) {
            return _buildDiscountChip(discount);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDiscountChip(Discount discount) {
    return PinProtectedWrapper(
      employeeId: widget.currentEmployeeId,
      authMessage: 'Enter PIN to apply ${discount.displayName}',
      onAccessGranted: () => _applyDiscount(discount),
      child: InputChip(
        label: Text(discount.displayName),
        avatar: Icon(
          Icons.local_offer,
          size: 16,
          color: AppColors.primaryBlue,
        ),
        onPressed: () {}, // Handled by PinProtectedWrapper
        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.05),
        side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
        labelStyle: TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCustomDiscountToggle() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _showCustomDiscount = !_showCustomDiscount;
        });
      },
      icon: Icon(
        _showCustomDiscount ? Icons.expand_less : Icons.expand_more,
        size: 18,
      ),
      label: const Text('Custom Discount'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildCustomDiscountForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discount type selection
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Percentage'),
                  value: 'percentage',
                  groupValue: _customDiscountType,
                  onChanged: (value) {
                    setState(() {
                      _customDiscountType = value!;
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Fixed Amount'),
                  value: 'fixed',
                  groupValue: _customDiscountType,
                  onChanged: (value) {
                    setState(() {
                      _customDiscountType = value!;
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Discount value input
          if (_customDiscountType == 'percentage')
            TextFormField(
              controller: _customPercentageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Percentage',
                suffixText: '%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            TextFormField(
              controller: _customAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Discount Amount',
                prefixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Reason field
          TextFormField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Reason (Required)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Discount code field (optional)
          TextFormField(
            controller: _discountCodeController,
            decoration: InputDecoration(
              labelText: 'Discount Code (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Apply button
          SizedBox(
            width: double.infinity,
            child: PinProtectedWrapper(
              employeeId: widget.currentEmployeeId,
              authMessage: 'Enter PIN to apply custom discount',
              onAccessGranted: () => _applyCustomDiscount(),
              child: ElevatedButton.icon(
                onPressed: () {}, // Handled by PinProtectedWrapper
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Apply Custom Discount'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentDiscount() {
    final discount = widget.currentDiscount!;
    final discountAmount = discount.calculateAmount(widget.subtotal);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.successGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Discount Applied',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            discount.displayName,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (discount.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              discount.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount Amount:',
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                '-\$${discountAmount.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyDiscount(Discount discount) {
    final discountWithAuth = discount.copyWith(
      authorizedBy: widget.currentEmployeeId,
    );
    
    widget.onDiscountChanged(discountWithAuth);
  }

  void _applyCustomDiscount() {
    final reason = _reasonController.text.trim();
    
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reason for the discount'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    double value;
    Discount discount;

    if (_customDiscountType == 'percentage') {
      final percentage = double.tryParse(_customPercentageController.text);
      if (percentage == null || percentage <= 0 || percentage > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid percentage (1-100)'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
        return;
      }
      
      discount = Discount.percentage(
        percentage: percentage,
        reason: reason,
        code: _discountCodeController.text.trim().isEmpty 
            ? null 
            : _discountCodeController.text.trim(),
        authorizedBy: widget.currentEmployeeId,
      );
    } else {
      final amount = double.tryParse(_customAmountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid discount amount'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
        return;
      }
      
      if (amount > widget.subtotal) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discount amount cannot exceed subtotal'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
        return;
      }
      
      discount = Discount.fixed(
        amount: amount,
        reason: reason,
        code: _discountCodeController.text.trim().isEmpty 
            ? null 
            : _discountCodeController.text.trim(),
        authorizedBy: widget.currentEmployeeId,
      );
    }

    widget.onDiscountChanged(discount);
    
    // Clear form and hide custom discount section
    _customAmountController.clear();
    _customPercentageController.clear();
    _discountCodeController.clear();
    _reasonController.clear();
    setState(() {
      _showCustomDiscount = false;
    });
  }

  void _removeDiscount() {
    widget.onDiscountChanged(null);
  }
}