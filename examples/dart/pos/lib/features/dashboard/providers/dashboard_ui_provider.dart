// lib/features/dashboard/providers/dashboard_ui_provider.dart
// Modern Riverpod provider for dashboard UI state management including dialog states, notifications, and auto-dismissal timers.
// Handles check-in dialogs, ticket detail dialogs, and temporary success/error notifications with immutable state patterns.
// Usage: ACTIVE - Core dashboard UI state management used throughout dashboard screens

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../utils/error_logger.dart';

part 'dashboard_ui_provider.g.dart';
part 'dashboard_ui_provider.freezed.dart';

/// Dashboard UI state provider using pure Riverpod.
/// This Notifier manages the immutable DashboardUIState.
@riverpod
class DashboardUI extends _$DashboardUI {
  Timer? _notificationTimer;

  @override
  DashboardUIState build() {
    // Cleanup timer on dispose
    ref.onDispose(() {
      _notificationTimer?.cancel();
    });
    return const DashboardUIState();
  }

  // Methods to update the immutable state
  void openCheckInDialog() => state = state.copyWith(isCheckInDialogOpen: true);
  void closeCheckInDialog() =>
      state = state.copyWith(isCheckInDialogOpen: false);

  void openTicketDetailsDialog(String ticketId) {
    state = state.copyWith(
      selectedTicketId: ticketId,
      isTicketDetailsDialogOpen: true,
    );
  }

  void closeTicketDetailsDialog() {
    state = state.copyWith(
      selectedTicketId: null,
      isTicketDetailsDialogOpen: false,
    );
  }

  void showSuccessNotification(String message) {
    _showNotification(message, NotificationType.success);
  }

  void showErrorNotification(String message) {
    _showNotification(message, NotificationType.error);
  }

  void _showNotification(String message, NotificationType type) {
    _notificationTimer?.cancel();
    state = state.copyWith(
      notificationMessage: message,
      notificationType: type,
      notificationTimestamp: DateTime.now(),
    );

    if (type != NotificationType.error) {
      final timestamp = state.notificationTimestamp;
      _notificationTimer = Timer(const Duration(seconds: 5), () {
        if (state.notificationTimestamp == timestamp) {
          dismissNotification();
        }
      });
    }
  }

  void dismissNotification() {
    _notificationTimer?.cancel();
    state = state.copyWith(
      notificationMessage: null,
      notificationType: null,
      notificationTimestamp: null,
    );
  }

  void resetToDefaults() {
    _notificationTimer?.cancel();
    state = const DashboardUIState();
  }
}

// State model remains the same
@freezed
class DashboardUIState with _$DashboardUIState {
  const factory DashboardUIState({
    @Default(false) bool isCheckInDialogOpen,
    @Default(false) bool isTicketDetailsDialogOpen,
    String? selectedTicketId,
    String? notificationMessage,
    NotificationType? notificationType,
    DateTime? notificationTimestamp,
  }) = _DashboardUIState;
}

enum NotificationType { success, error, warning, info }

// Computed providers can also be simplified
@riverpod
bool hasOpenDialogs(HasOpenDialogsRef ref) {
  // Select and watch only the properties you need for efficiency
  final isCheckInOpen =
      ref.watch(dashboardUIProvider.select((s) => s.isCheckInDialogOpen));
  final isTicketDetailsOpen =
      ref.watch(dashboardUIProvider.select((s) => s.isTicketDetailsDialogOpen));
  return isCheckInOpen || isTicketDetailsOpen;
}
