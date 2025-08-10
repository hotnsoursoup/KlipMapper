
// lib/core/utils/formatter.dart
// Centralized formatting utilities for currency, percentages, and numbers with consistent locale support. Eliminates duplicate formatting logic across UI components.
// Usage: ACTIVE - Used throughout the app for consistent currency and percentage formatting in tickets, checkout, and employee management
import 'package:intl/intl.dart';

/// A centralized utility class for formatting numbers, currency, and percentages.
/// This class helps ensure consistent formatting across the entire application
/// and avoids duplicating formatting logic in multiple UI components.
class AppFormatter {
  // Private constructor to prevent instantiation.
  AppFormatter._();

  /// Formats a double as a currency string.
  ///
  /// This method centralizes currency formatting, which was found to be
  /// duplicated across many files using manual string concatenation
  /// like `'\$${value.toStringAsFixed(2)}'`.
  ///
  /// Violations were found in:
  /// - `features/tickets/presentation/widgets/ticket_list_item.dart`
  /// - `features/checkout/presentation/widgets/checkout_dialog.dart`
  /// - `features/tickets/presentation/widgets/ticket_dialog/ticket_dialog.dart`
  /// - `features/customers/presentation/widgets/customer_details_dialog.dart`
  /// - `features/checkout/presentation/screens/checkout_screen.dart`
  /// - And many others.
  static String formatCurrency(double? value, {int decimalDigits = 2}) {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: decimalDigits,
    );
    return format.format(value ?? 0.0);
  }

  /// Formats a double as a percentage string.
  /// The `value` is expected to be a decimal (e.g., 0.15 for 15%).
  ///
  /// This method centralizes percentage formatting, which was found to be
  /// duplicated across files using manual calculations and string
  /// concatenation like `'${(value * 100).toStringAsFixed(0)}%'`.
  ///
  /// Violations were found in:
  /// - `features/employees/presentation/widgets/professional_employee_list_item.dart`
  /// - `features/checkout/data/models/discount_model.dart`
  /// - `features/checkout/data/models/checkout_state.dart`
  static String formatPercentage(double? value, {int decimalDigits = 0}) {
    final format = NumberFormat.percentPattern('en_US');
    format.maximumFractionDigits = decimalDigits;
    format.minimumFractionDigits = decimalDigits;
    return format.format(value ?? 0.0);
  }
}
