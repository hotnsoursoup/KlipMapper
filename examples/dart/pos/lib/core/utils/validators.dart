// lib/core/utils/validators.dart
// Centralized form validation utilities providing consistent validation rules for email, phone, required fields, and numeric inputs. Eliminates duplicate validation logic across forms.
// Usage: ACTIVE - Used in customer dialogs, service forms, employee forms, and all data entry forms throughout the application
/// A centralized utility class for form field validation.
/// This class provides a set of common validation rules that can be reused
/// across different forms in the application, ensuring consistency and
/// reducing code duplication.
class AppValidators {
  // Private constructor to prevent instantiation.
  AppValidators._();

  /// Validator for a required field.
  ///
  /// This logic was found to be duplicated in many forms, such as:
  /// - `features/services/presentation/widgets/service_form_dialog.dart`
  /// - `features/customers/presentation/widgets/new_customer_dialog.dart`
  static String? notEmpty(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required.';
    }
    return null;
  }

  /// Validator for a valid email format.
  ///
  /// This logic was found in:
  /// - `features/customers/presentation/widgets/new_customer_dialog.dart`
  static String? isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Not a required field, so empty is valid.
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validator for a valid US phone number format.
  ///
  /// This logic was found in:
  /// - `features/customers/presentation/widgets/new_customer_dialog.dart`
  static String? isValidPhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Not a required field, so empty is valid.
    }
    // Basic validation for 10-digit numbers, allows for optional formatting.
    final phoneRegex = RegExp(r'^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number.';
    }
    return null;
  }

  /// Validator for a positive number (greater than zero).
  ///
  /// This logic was found in:
  /// - `features/services/presentation/widgets/service_form_dialog.dart` (for price and duration)
  static String? isPositiveNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      // This can be combined with notEmpty if the field is also required.
      // For simplicity, we assume it's required here.
      return '${fieldName ?? 'This field'} is required.';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid positive number.';
    }
    return null;
  }
}
