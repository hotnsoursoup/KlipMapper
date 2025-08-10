// lib/core/auth/widgets/pin_input_widget.dart
// Reusable PIN input widget with masking, validation, and modern design for authentication forms. Provides customizable PIN entry with visibility toggle, strength indicators, and input validation.
// Usage: ACTIVE - Used in authentication dialogs, employee PIN setup, and manager authentication flows

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Reusable PIN input widget with masking, validation, and modern design
class PinInputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final int maxLength;
  final bool obscureText;
  final bool showVisibilityToggle;
  final bool showStrengthIndicator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;
  final FocusNode? focusNode;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final bool enabled;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PinInputWidget({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.maxLength = 6,
    this.obscureText = true,
    this.showVisibilityToggle = true,
    this.showStrengthIndicator = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
    this.focusNode,
    this.borderColor,
    this.focusedBorderColor,
    this.decoration,
    this.textStyle,
    this.labelStyle,
    this.enabled = true,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isVisible = false;
  bool _hasFocus = false;
  String _pinStrength = '';
  Color _strengthColor = AppColors.textSecondary;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    
    // Set initial visibility state
    _isVisible = !widget.obscureText;
    
    // Listen for focus changes
    _focusNode.addListener(_handleFocusChange);
    
    // Listen for text changes to update strength indicator
    if (widget.showStrengthIndicator) {
      _controller.addListener(_updatePinStrength);
    }
    
    // Auto-focus if requested
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  void _updatePinStrength() {
    final pin = _controller.text;
    if (pin.isEmpty) {
      if (mounted) {
        setState(() {
          _pinStrength = '';
          _strengthColor = AppColors.textSecondary;
        });
      }
      return;
    }

    // Simple PIN strength calculation
    String strength;
    Color color;
    
    if (pin.length < 4) {
      strength = 'Too short';
      color = AppColors.errorRed;
    } else if (pin.length >= 4 && pin.length < 6) {
      if (_hasConsecutiveNumbers(pin) || _hasRepeatingNumbers(pin)) {
        strength = 'Weak';
        color = AppColors.warningOrange;
      } else {
        strength = 'Good';
        color = AppColors.successGreen;
      }
    } else {
      if (_hasConsecutiveNumbers(pin) || _hasRepeatingNumbers(pin)) {
        strength = 'Good';
        color = AppColors.successGreen;
      } else {
        strength = 'Strong';
        color = AppColors.primaryBlue;
      }
    }

    if (mounted) {
      setState(() {
        _pinStrength = strength;
        _strengthColor = color;
      });
    }
  }

  bool _hasConsecutiveNumbers(String pin) {
    for (int i = 0; i < pin.length - 2; i++) {
      final current = int.tryParse(pin[i]) ?? -1;
      final next1 = int.tryParse(pin[i + 1]) ?? -1;
      final next2 = int.tryParse(pin[i + 2]) ?? -1;
      
      if (current != -1 && next1 != -1 && next2 != -1) {
        if ((next1 == current + 1 && next2 == current + 2) ||
            (next1 == current - 1 && next2 == current - 2)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasRepeatingNumbers(String pin) {
    if (pin.length < 3) return false;
    
    for (int i = 0; i < pin.length - 2; i++) {
      if (pin[i] == pin[i + 1] && pin[i + 1] == pin[i + 2]) {
        return true;
      }
    }
    return false;
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  InputDecoration _buildDecoration() {
    if (widget.decoration != null) {
      return widget.decoration!;
    }

    final borderColor = widget.borderColor ?? AppColors.border;
    final focusedBorderColor = widget.focusedBorderColor ?? AppColors.primaryBlue;
    const errorBorderColor = AppColors.errorRed;

    return InputDecoration(
      labelText: widget.label,
      labelStyle: widget.labelStyle ?? AppTextStyles.bodyMedium.copyWith(
        color: _hasFocus ? focusedBorderColor : AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
      hintText: widget.hintText ?? '••••••',
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        letterSpacing: 4,
      ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      errorText: widget.errorText,
      errorStyle: AppTextStyles.labelMedium.copyWith(
        color: errorBorderColor,
      ),
      
      // Border styling
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorBorderColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorBorderColor, width: 2),
      ),
      
      // Styling
      filled: true,
      fillColor: _hasFocus 
          ? focusedBorderColor.withValues(alpha: 0.05)
          : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      counterText: '', // Hide character counter
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    if (!widget.showVisibilityToggle) {
      return null;
    }

    return IconButton(
      icon: Icon(
        _isVisible ? Icons.visibility_off : Icons.visibility,
        color: _hasFocus ? AppColors.primaryBlue : AppColors.textSecondary,
        size: 20,
      ),
      onPressed: widget.enabled ? _toggleVisibility : null,
      tooltip: _isVisible ? 'Hide PIN' : 'Show PIN',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText && !_isVisible,
          keyboardType: TextInputType.number,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          style: widget.textStyle ?? AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: widget.obscureText && !_isVisible ? 4 : 2,
            fontSize: 18,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          decoration: _buildDecoration(),
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: (value) {
            widget.onSubmitted?.call(value);
          },
        ),
        
        // PIN strength indicator
        if (widget.showStrengthIndicator && _pinStrength.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _strengthColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Strength: $_pinStrength',
                style: AppTextStyles.labelMedium.copyWith(
                  color: _strengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Specialized PIN input for verification scenarios
class PinVerificationWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final bool autofocus;
  final FocusNode? focusNode;

  const PinVerificationWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.autofocus = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return PinInputWidget(
      controller: controller,
      label: 'Enter PIN',
      hintText: '••••••',
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      errorText: errorText,
      prefixIcon: Container(
        margin: const EdgeInsets.only(left: 12, right: 8),
        child: Icon(
          Icons.lock,
          color: AppColors.primaryBlue,
          size: 20,
        ),
      ),
    );
  }
}

/// Specialized PIN input for setup scenarios  
class PinSetupWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? label;

  const PinSetupWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.autofocus = true,
    this.focusNode,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return PinInputWidget(
      controller: controller,
      label: label ?? 'Create PIN',
      hintText: '••••••',
      autofocus: autofocus,
      focusNode: focusNode,
      showStrengthIndicator: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      errorText: errorText,
      prefixIcon: Container(
        margin: const EdgeInsets.only(left: 12, right: 8),
        child: Icon(
          Icons.lock_outline,
          color: AppColors.successGreen,
          size: 20,
        ),
      ),
    );
  }
}