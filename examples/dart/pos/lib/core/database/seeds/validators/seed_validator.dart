// lib/core/database/seeds/validators/seed_validator.dart
// Comprehensive validation system for seed data integrity, type safety, and business rules
// Usage: ACTIVE - Validates seed imports before database operations

import '../models/seed_models.dart';

/// Validation result for individual items
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  ValidationResult.valid() : this(isValid: true);
  
  ValidationResult.invalid(List<String> errors, [List<String>? warnings])
      : this(isValid: false, errors: errors, warnings: warnings ?? []);
}

/// Service category seed validator
class ServiceCategoryValidator {
  /// Validate a single service category
  static ValidationResult validateCategory(ServiceCategorySeed category, ServiceCategoriesValidation? validation) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required field validation
    final requiredFields = validation?.requiredFields ?? ['id', 'name', 'color', 'icon'];
    for (final field in requiredFields) {
      switch (field) {
        case 'id':
          if (category.id <= 0) errors.add('ID must be positive integer');
          break;
        case 'name':
          if (category.name.trim().isEmpty) errors.add('Name is required');
          break;
        case 'color':
          if (category.color.trim().isEmpty) errors.add('Color is required');
          break;
        case 'icon':
          if (category.icon.trim().isEmpty) errors.add('Icon is required');
          break;
      }
    }

    // Name length validation
    final nameMaxLength = validation?.nameMaxLength ?? 50;
    if (category.name.length > nameMaxLength) {
      errors.add('Name exceeds maximum length of $nameMaxLength characters');
    }

    // Description length validation
    final descMaxLength = validation?.descriptionMaxLength ?? 200;
    if (category.description != null && category.description!.length > descMaxLength) {
      errors.add('Description exceeds maximum length of $descMaxLength characters');
    }

    // Color format validation
    if (validation?.colorFormat == 'hex') {
      if (!_isValidHexColor(category.color)) {
        errors.add('Color must be valid hex format (e.g., #FF6B9D)');
      }
    }

    // Icon format validation
    if (category.icon.contains(' ')) {
      warnings.add('Icon name contains spaces - consider using underscores');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate collection uniqueness constraints
  static ValidationResult validateUniqueness(List<ServiceCategorySeed> categories, ServiceCategoriesValidation? validation) {
    final errors = <String>[];
    final uniqueConstraints = validation?.uniqueConstraints ?? ['id', 'name'];

    for (final constraint in uniqueConstraints) {
      switch (constraint) {
        case 'id':
          final ids = categories.map((c) => c.id).toList();
          final duplicateIds = _findDuplicates(ids);
          if (duplicateIds.isNotEmpty) {
            errors.add('Duplicate IDs found: ${duplicateIds.join(', ')}');
          }
          break;
        case 'name':
          final names = categories.map((c) => c.name.toLowerCase().trim()).toList();
          final duplicateNames = _findDuplicates(names);
          if (duplicateNames.isNotEmpty) {
            errors.add('Duplicate names found: ${duplicateNames.join(', ')}');
          }
          break;
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate hex color format
  static bool _isValidHexColor(String color) {
    final hexRegex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return hexRegex.hasMatch(color);
  }
}

/// Service seed validator
class ServiceValidator {
  /// Validate a single service
  static ValidationResult validateService(ServiceSeed service, ServicesValidation? validation) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required field validation
    final requiredFields = validation?.requiredFields ?? ['name', 'category_id', 'duration_minutes', 'base_price_cents'];
    for (final field in requiredFields) {
      switch (field) {
        case 'name':
          if (service.name.trim().isEmpty) errors.add('Name is required');
          break;
        case 'category_id':
          if (service.categoryId <= 0) errors.add('Category ID must be positive integer');
          break;
        case 'duration_minutes':
          if (service.durationMinutes <= 0) errors.add('Duration must be positive');
          break;
        case 'base_price_cents':
          if (service.basePriceCents <= 0) errors.add('Price must be positive');
          break;
      }
    }

    // Name length validation
    final nameMaxLength = validation?.nameMaxLength ?? 100;
    if (service.name.length > nameMaxLength) {
      errors.add('Name exceeds maximum length of $nameMaxLength characters');
    }

    // Description length validation
    final descMaxLength = validation?.descriptionMaxLength ?? 500;
    if (service.description != null && service.description!.length > descMaxLength) {
      errors.add('Description exceeds maximum length of $descMaxLength characters');
    }

    // Duration range validation
    final durationRange = validation?.durationRange;
    if (durationRange != null && durationRange.length >= 2) {
      final min = durationRange[0];
      final max = durationRange[1];
      if (service.durationMinutes < min || service.durationMinutes > max) {
        errors.add('Duration must be between $min and $max minutes');
      }
    }

    // Price range validation
    final priceRange = validation?.priceRange;
    if (priceRange != null && priceRange.length >= 2) {
      final min = priceRange[0];
      final max = priceRange[1];
      if (service.basePriceCents < min || service.basePriceCents > max) {
        final minDollars = (min / 100).toStringAsFixed(2);
        final maxDollars = (max / 100).toStringAsFixed(2);
        errors.add('Price must be between \$$minDollars and \$$maxDollars');
      }
    }

    // Business logic warnings
    if (service.durationMinutes > 180) {
      warnings.add('Service duration over 3 hours - ensure this is correct');
    }

    if (service.basePriceCents > 20000) { // $200
      warnings.add('Service price over \$200 - ensure this is correct');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate collection uniqueness and foreign keys
  static ValidationResult validateCollection(List<ServiceSeed> services, ServicesValidation? validation, List<ServiceCategorySeed>? categories) {
    final errors = <String>[];
    final warnings = <String>[];

    // Uniqueness validation
    final uniqueConstraints = validation?.uniqueConstraints ?? ['name'];
    for (final constraint in uniqueConstraints) {
      if (constraint == 'name') {
        final names = services.map((s) => s.name.toLowerCase().trim()).toList();
        final duplicateNames = _findDuplicates(names);
        if (duplicateNames.isNotEmpty) {
          errors.add('Duplicate service names found: ${duplicateNames.join(', ')}');
        }
      }
    }

    // Foreign key validation
    if (categories != null) {
      final validCategoryIds = categories.map((c) => c.id).toSet();
      final invalidServices = services.where((s) => !validCategoryIds.contains(s.categoryId)).toList();
      
      if (invalidServices.isNotEmpty) {
        final invalidIds = invalidServices.map((s) => '${s.name} (category ${s.categoryId})').join(', ');
        errors.add('Services reference invalid category IDs: $invalidIds');
      }
    }

    // Business logic warnings
    final inactiveServices = services.where((s) => !s.isActive).length;
    if (inactiveServices > services.length * 0.5) {
      warnings.add('More than 50% of services are inactive - verify this is intentional');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}

/// Schema version validator
class SchemaValidator {
  static const List<String> supportedVersions = ['1.0'];

  /// Validate schema version compatibility
  static ValidationResult validateVersion(String schemaVersion) {
    if (!supportedVersions.contains(schemaVersion)) {
      return ValidationResult.invalid([
        'Unsupported schema version: $schemaVersion. Supported versions: ${supportedVersions.join(', ')}'
      ]);
    }
    return ValidationResult.valid();
  }

  /// Validate creation date
  static ValidationResult validateCreationDate(DateTime createdDate) {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));
    final oneYearFromNow = now.add(const Duration(days: 365));

    if (createdDate.isBefore(oneYearAgo)) {
      return ValidationResult.invalid([], ['Seed file is over 1 year old - consider updating']);
    }

    if (createdDate.isAfter(oneYearFromNow)) {
      return ValidationResult.invalid(['Creation date is in the future']);
    }

    return ValidationResult.valid();
  }
}

/// Helper function to find duplicates in a list
List<T> _findDuplicates<T>(List<T> list) {
  final seen = <T>{};
  final duplicates = <T>{};
  
  for (final item in list) {
    if (seen.contains(item)) {
      duplicates.add(item);
    } else {
      seen.add(item);
    }
  }
  
  return duplicates.toList();
}