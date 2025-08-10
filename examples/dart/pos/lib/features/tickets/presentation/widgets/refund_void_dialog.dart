// lib/features/tickets/presentation/widgets/refund_void_dialog.dart
// Secure refund and void operations dialog with manager authentication and comprehensive validation.
// Handles both partial/full refunds and ticket voiding with reason tracking, PIN protection, and privileged operation security.
// Usage: ACTIVE - Used in ticket management for processing refunds and voids with manager authorization

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/privileged_operations.dart';
import '../../../shared/data/models/ticket_model.dart';
import '../../../shared/data/models/payment_model.dart';
import '../../../shared/data/repositories/payment_repository.dart';

/// Dialog for handling refund and void operations with PIN protection
class RefundVoidDialog extends StatefulWidget {
  final Ticket ticket;
  final List<Payment>? payments; // Null for void operations
  final bool isVoid; // true for void, false for refund
  final int currentEmployeeId;
  final Function(bool success)? onComplete;

  const RefundVoidDialog({
    super.key,
    required this.ticket,
    this.payments,
    this.isVoid = false,
    required this.currentEmployeeId,
    this.onComplete,
  });

  /// Factory for refund dialog
  factory RefundVoidDialog.refund({
    required Ticket ticket,
    required List<Payment> payments,
    required int currentEmployeeId,
    Function(bool success)? onComplete,
  }) {
    return RefundVoidDialog(
      ticket: ticket,
      payments: payments,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  /// Factory for void dialog
  factory RefundVoidDialog.voidTransaction({
    required Ticket ticket,
    required int currentEmployeeId,
    Function(bool success)? onComplete,
  }) {
    return RefundVoidDialog(
      ticket: ticket,
      isVoid: true,
      currentEmployeeId: currentEmployeeId,
      onComplete: onComplete,
    );
  }

  @override
  State<RefundVoidDialog> createState() => _RefundVoidDialogState();
}

class _RefundVoidDialogState extends State<RefundVoidDialog> {
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  final _refundAmountController = TextEditingController();
  
  final PaymentRepository _paymentRepository = PaymentRepository.instance;
  
  bool _isProcessing = false;
  bool _isPartialRefund = false;
  String? _selectedReason;
  double? _maxRefundAmount;

  // Common reasons for refunds/voids
  final List<String> _refundReasons = [
    'Customer request',
    'Service not satisfactory',
    'Booking error',
    'Technical issue',
    'Staff error',
    'Other',
  ];

  final List<String> _voidReasons = [
    'Duplicate entry',
    'Customer canceled',
    'Staff error',
    'Technical issue',
    'Price adjustment needed',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.isVoid && widget.payments != null) {
      _calculateMaxRefundAmount();
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    _refundAmountController.dispose();
    super.dispose();
  }

  void _calculateMaxRefundAmount() {
    if (widget.payments == null) return;
    
    double totalPaid = 0.0;
    double totalRefunded = 0.0;
    
    for (final payment in widget.payments!) {
      if (payment.paymentMethod == 'refund') {
        totalRefunded += (payment.totalAmount ?? payment.amount).abs();
      } else {
        totalPaid += payment.totalAmount ?? payment.amount;
      }
    }
    
    _maxRefundAmount = totalPaid - totalRefunded;
    _refundAmountController.text = _maxRefundAmount!.toStringAsFixed(2);
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
            _buildTicketInfo(),
            const SizedBox(height: 16),
            if (!widget.isVoid) _buildRefundSection(),
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
            color: AppColors.errorRed.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isVoid ? Icons.block : Icons.undo,
            color: AppColors.errorRed,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isVoid ? 'Void Ticket' : 'Process Refund',
                style: AppTextStyles.headline2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.isVoid 
                    ? 'Cancel this ticket before payment completion'
                    : 'Refund payment for completed ticket',
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

  Widget _buildTicketInfo() {
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
          Row(
            children: [
              Text(
                'Ticket #${widget.ticket.ticketNumber}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.ticket.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.ticket.status.toUpperCase() ?? 'UNKNOWN',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Customer: ${widget.ticket.customerName}',
            style: AppTextStyles.bodyMedium,
          ),
          if (widget.ticket.totalAmount != null) ...[
            const SizedBox(height: 4),
            Text(
              'Total: \$${widget.ticket.totalAmount!.toStringAsFixed(2)}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (!widget.isVoid && _maxRefundAmount != null) ...[
            const SizedBox(height: 4),
            Text(
              'Available for refund: \$${_maxRefundAmount!.toStringAsFixed(2)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRefundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Refund Amount',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isPartialRefund,
              onChanged: (value) {
                setState(() {
                  _isPartialRefund = value;
                  if (!value && _maxRefundAmount != null) {
                    _refundAmountController.text = _maxRefundAmount!.toStringAsFixed(2);
                  }
                });
              },
            ),
            const SizedBox(width: 8),
            Text(
              'Partial refund',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _refundAmountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: _isPartialRefund,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: '\$',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: !_isPartialRefund,
            fillColor: _isPartialRefund ? null : AppColors.backgroundGrey,
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter refund amount';
            final amount = double.tryParse(value!);
            if (amount == null) return 'Please enter a valid amount';
            if (amount <= 0) return 'Amount must be greater than 0';
            if (_maxRefundAmount != null && amount > _maxRefundAmount!) {
              return 'Amount exceeds available refund amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReasonSection() {
    final reasons = widget.isVoid ? _voidReasons : _refundReasons;
    
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
          initialValue: _selectedReason,
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
          validator: (value) {
            if (value == null) return 'Please select a reason';
            return null;
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
            validator: (value) {
              if (_selectedReason == 'Other' && (value?.isEmpty ?? true)) {
                return 'Please specify the reason';
              }
              return null;
            },
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
            onPressed: _isProcessing ? null : _handleProcess,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
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
                : Text(widget.isVoid ? 'Void Ticket' : 'Process Refund'),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'completed':
      case 'paid':
        return AppColors.successGreen;
      case 'in-service':
        return AppColors.primaryBlue;
      case 'queued':
        return AppColors.warningOrange;
      case 'cancelled':
      case 'refunded':
      case 'voided':
        return AppColors.errorRed;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _handleProcess() async {
    // Validate form
    if (_selectedReason == null) {
      _showSnackBar('Please select a reason', AppColors.warningOrange);
      return;
    }
    
    if (_selectedReason == 'Other' && _reasonController.text.trim().isEmpty) {
      _showSnackBar('Please specify the reason', AppColors.warningOrange);
      return;
    }

    if (!widget.isVoid) {
      final refundAmount = double.tryParse(_refundAmountController.text);
      if (refundAmount == null || refundAmount <= 0) {
        _showSnackBar('Please enter a valid refund amount', AppColors.warningOrange);
        return;
      }
      if (_maxRefundAmount != null && refundAmount > _maxRefundAmount!) {
        _showSnackBar('Refund amount exceeds available amount', AppColors.warningOrange);
        return;
      }
    }

    final reason = _selectedReason == 'Other' 
        ? _reasonController.text.trim() 
        : _selectedReason!;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Use privileged operations for PIN authentication
      final operation = widget.isVoid 
          ? PrivilegedOperation.voidTicket 
          : PrivilegedOperation.refundPayment;

      if (!mounted) return;
      
      final success = await context.executePrivilegedOperation(
        operation,
        widget.currentEmployeeId,
        () async {
          if (widget.isVoid) {
            return await _paymentRepository.voidTicket(
              ticketId: widget.ticket.id,
              reason: reason,
              authorizedBy: widget.currentEmployeeId,
              notes: _notesController.text.trim().isEmpty 
                  ? null 
                  : _notesController.text.trim(),
            );
          } else {
            // For refund, we need the payment ID
            // In a real implementation, we'd need to select which payment to refund
            final refundAmount = double.parse(_refundAmountController.text);
            final originalPayment = widget.payments!.firstWhere(
              (p) => p.paymentMethod != 'refund',
            );
            
            final result = await _paymentRepository.processRefund(
              originalPaymentId: originalPayment.id,
              refundAmount: refundAmount,
              reason: reason,
              authorizedBy: widget.currentEmployeeId,
              notes: _notesController.text.trim().isEmpty 
                  ? null 
                  : _notesController.text.trim(),
            );
            
            return result.paymentId.isNotEmpty && !result.paymentId.startsWith('error_');
          }
        },
        onSuccess: (result) {
          if (result == true) {
            _showSnackBar(
              widget.isVoid ? 'Ticket voided successfully' : 'Refund processed successfully',
              AppColors.successGreen,
            );
            widget.onComplete?.call(true);
            Navigator.of(context).pop(true);
          } else {
            _showSnackBar(
              widget.isVoid ? 'Failed to void ticket' : 'Failed to process refund',
              AppColors.errorRed,
            );
          }
        },
        onError: (error) {
          _showSnackBar(
            'Error: ${error.toString()}',
            AppColors.errorRed,
          );
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