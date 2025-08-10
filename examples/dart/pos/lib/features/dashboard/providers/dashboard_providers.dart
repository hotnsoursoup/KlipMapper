// lib/features/dashboard/providers/dashboard_providers.dart
// Pure Riverpod 3.0 pattern dashboard providers orchestrator with composite async state handling for multiple providers.
// Usage: ACTIVE - Main dashboard state orchestration replacing previous MobX hybrid architecture
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the pure Riverpod providers you've already created.
// We no longer need to import the MobX stores.
import 'queue_management_provider.dart';
import 'employee_status_provider.dart';

/// This file replaces the old dashboard_providers.dart.
/// It demonstrates the pure Riverpod 3.0 pattern by consuming
/// Notifier and AsyncNotifier states directly, removing the need
/// for a hybrid architecture with MobX.

// The old Provider<SomeStore> definitions are no longer needed.
// We will directly use the auto-generated providers like:
// - dashboardUIProvider
// - queueManagementProvider
// - employeeStatusProvider
// - ticketAssignmentProvider

// The WidgetRef extensions are no longer necessary, as we will use
// ref.watch() and ref.read() directly on the generated providers.

/// A modern consumer widget for the dashboard that handles multiple
/// asynchronous states from different providers.
class AsyncDashboardConsumer extends ConsumerWidget {
  final Widget Function(
    BuildContext context,
    WidgetRef ref,
  ) builder;

  const AsyncDashboardConsumer({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all the necessary asynchronous providers.
    final queueAsync = ref.watch(queueManagementProvider);
    final techStatusAsync = ref.watch(employeeStatusProvider);
    // Add other async providers here if needed, e.g., appointments.

    // Combine the states. If any are loading, show a loading indicator.
    if (queueAsync.isLoading || techStatusAsync.isLoading) {
      return const _DefaultLoadingWidget();
    }

    // If any have an error, show an error message.
    // This handles the first error encountered.
    final error = queueAsync.error ?? techStatusAsync.error;
    final stack = queueAsync.stackTrace ?? techStatusAsync.stackTrace;
    if (error != null) {
      return _DefaultErrorWidget(
        error: error,
        onRetry: () {
          // Refresh all providers that had an error.
          if (queueAsync.hasError) ref.invalidate(queueManagementProvider);
          if (techStatusAsync.hasError)
            ref.invalidate(employeeStatusProvider);
        },
      );
    }

    // If all data is available, build the main UI.
    // The individual states can be accessed inside the builder using ref.watch().
    return builder(context, ref);
  }
}

/// Default loading widget for async operations
class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Dashboard...'),
          ],
        ),
      ),
    );
  }
}

/// Default error widget for async operations
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error Loading Dashboard',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
