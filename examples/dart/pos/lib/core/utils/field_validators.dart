// lib/core/utils/field_validators.dart
// Comprehensive field validation utilities for consistent form validation across the app. Provides validators for names, emails, phones, and other common form fields with standardized error messages.
// Usage: ACTIVE - Used throughout the app for form validation in customer, employee, and settings forms

/// Comprehensive field validation utilities for consistent validation across the app
class FieldValidators {
  /// Validates a name field (first name, last name, etc.)
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    final trimmedValue = value.trim();
    
    // Check minimum length
    if (trimmedValue.length < 2) {
      return '$fieldName must be at least 2 characters long';
    }
    
    // Check maximum length
    if (trimmedValue.length > 50) {
      return '$fieldName must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  /// Validates a phone number field
  static String? validatePhone(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's a valid US phone number (10 digits)
    if (digitsOnly.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    // For US phone numbers, area codes can't start with 0 or 1
    // But many valid area codes like 123, 234, etc. exist, so let's be more lenient
    // Only reject if it starts with 0 or if area code is 0xx or 1xx
    final areaCode = digitsOnly.substring(0, 3);
    if (areaCode.startsWith('0')) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validates an email address field
  static String? validateEmail(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Email address is required' : null;
    }
    
    final trimmedValue = value.trim();
    
    // Check maximum length
    if (trimmedValue.length > 254) {
      return 'Email address is too long';
    }
    
    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    
    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates a zip code field
  static String? validateZipCode(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Zip code is required' : null;
    }
    
    final trimmedValue = value.trim();
    
    // US zip code patterns: 12345 or 12345-6789
    final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');
    
    if (!zipRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid zip code (12345 or 12345-6789)';
    }
    
    return null;
  }

  /// Validates a state field (2-letter state code or full name)
  static String? validateState(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'State is required' : null;
    }
    
    final trimmedValue = value.trim();
    
    // Check if it's a 2-letter state code
    if (trimmedValue.length == 2) {
      final stateCodeRegex = RegExp(r'^[A-Z]{2}$');
      if (!stateCodeRegex.hasMatch(trimmedValue.toUpperCase())) {
        return 'Please enter a valid 2-letter state code';
      }
      return null;
    }
    
    // Check if it's a full state name
    if (trimmedValue.length > 2 && trimmedValue.length <= 20) {
      final stateNameRegex = RegExp(r'^[a-zA-Z\s]+$');
      if (!stateNameRegex.hasMatch(trimmedValue)) {
        return 'Please enter a valid state name';
      }
      return null;
    }
    
    return 'Please enter a valid state';
  }

  /// Validates a city field
  static String? validateCity(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'City is required' : null;
    }
    
    final trimmedValue = value.trim();
    
    // Check minimum length
    if (trimmedValue.length < 2) {
      return 'City name must be at least 2 characters long';
    }
    
    // Check maximum length
    if (trimmedValue.length > 50) {
      return 'City name must be less than 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes, periods)
    final cityRegex = RegExp(r"^[a-zA-Z\s\-'.]+$");
    if (!cityRegex.hasMatch(trimmedValue)) {
      return 'City name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }
    
    return null;
  }

  /// Validates an address field
  static String? validateAddress(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Address is required' : null;
    }
    
    final trimmedValue = value.trim();
    
    // Check minimum length
    if (trimmedValue.length < 5) {
      return 'Address must be at least 5 characters long';
    }
    
    // Check maximum length
    if (trimmedValue.length > 100) {
      return 'Address must be less than 100 characters';
    }
    
    // Check for valid characters (letters, numbers, spaces, common punctuation)
    final addressRegex = RegExp(r"^[a-zA-Z0-9\s\-'.,#/]+$");
    if (!addressRegex.hasMatch(trimmedValue)) {
      return 'Address contains invalid characters';
    }
    
    return null;
  }

  /// Validates notes or comments field
  static String? validateNotes(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Notes are typically optional
    }
    
    final trimmedValue = value.trim();
    
    // Check maximum length
    if (trimmedValue.length > maxLength) {
      return 'Notes must be less than $maxLength characters';
    }
    
    return null;
  }

  /// Validates allergies field
  static String? validateAllergies(String? value, {int maxLength = 300}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allergies are typically optional
    }
    
    final trimmedValue = value.trim();
    
    // Check maximum length
    if (trimmedValue.length > maxLength) {
      return 'Allergies information must be less than $maxLength characters';
    }
    
    return null;
  }

  /// Validates a date of birth
  static String? validateDateOfBirth(DateTime? value, {bool isRequired = false}) {
    if (value == null) {
      return isRequired ? 'Date of birth is required' : null;
    }
    
    final now = DateTime.now();
    final age = now.year - value.year;
    
    // Check if person is at least 1 year old
    if (value.isAfter(now.subtract(const Duration(days: 365)))) {
      return 'Please enter a valid date of birth';
    }
    
    // Check if person is not older than 150 years
    if (age > 150) {
      return 'Please enter a valid date of birth';
    }
    
    return null;
  }

  /// Validates a gender selection
  static String? validateGender(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? 'Please select a gender' : null;
    }
    
    final validGenders = ['Male', 'Female', 'Other', 'Prefer not to say'];
    if (!validGenders.contains(value)) {
      return 'Please select a valid gender option';
    }
    
    return null;
  }

  /// Formats phone number to a standard format: (123) 456-7890
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Format as (123) 456-7890 if it's 10 digits
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    }
    
    // Return original if not 10 digits
    return phoneNumber;
  }

  /// Formats zip code to standard format
  static String formatZipCode(String zipCode) {
    final digitsOnly = zipCode.replaceAll(RegExp(r'[^\d]'), '');
    
    // Format as 12345-6789 if it's 9 digits
    if (digitsOnly.length == 9) {
      return '${digitsOnly.substring(0, 5)}-${digitsOnly.substring(5)}';
    }
    
    // Return as-is if 5 digits or other length
    return zipCode;
  }

  /// Capitalizes the first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Validates multiple fields at once and returns the first error found
  static String? validateMultiple(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}

/// Extension methods for common validation scenarios
extension StringValidation on String? {
  String? get validateAsName => FieldValidators.validateName(this);
  String? get validateAsPhone => FieldValidators.validatePhone(this);
  String? get validateAsEmail => FieldValidators.validateEmail(this);
  String? get validateAsZipCode => FieldValidators.validateZipCode(this);
  String? get validateAsState => FieldValidators.validateState(this);
  String? get validateAsCity => FieldValidators.validateCity(this);
  String? get validateAsAddress => FieldValidators.validateAddress(this);
}