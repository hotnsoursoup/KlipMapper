// lib/core/widgets/async_value_widget.dart
// Standardized widget for handling Riverpod AsyncValue states with consistent loading, error, empty, and refresh behavior. Provides unified async state management across all features.
// Usage: ACTIVE - Core widget used throughout the app for consistent async state handling in appointments, customers, employees, services, and dashboard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart' show ProviderListenable; // For fromProvider constructor
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A robust, generic widget for handling AsyncValue states, including
/// loading, error, empty, and data states with support for pull-to-refresh.
/// 
/// This widget standardizes async state handling across the app and ensures
/// consistent UI patterns for loading, error, and empty states.
/// 
/// Example usage:
/// ```dart
/// AsyncValueWidget<List<Appointment>>(
///   value: appointmentsProvider,
///   data: (context, appointments, isRefreshing) {
///     if (isRefreshing) {
///       return Stack(
///         children: [
///           AppointmentList(appointments: appointments),
///           const Positioned(
///             top: 0,
///             left: 0,
///             right: 0,
///             child: LinearProgressIndicator(),
///           ),
///         ],
///       );
///     }
///     return AppointmentList(appointments: appointments);
///   },
///   emptyBuilder: (context) => EmptyAppointmentsWidget(),
///   onRefresh: () async {
///     await ref.read(appointmentsProvider.notifier).refresh();
///   },
/// )
/// ```
class AsyncValueWidget<T> extends ConsumerWidget {
  /// Direct AsyncValue to render (common usage in widgets).
  final AsyncValue<T>? value;

  /// Optional provider to watch (use the .fromProvider constructor).
  final ProviderListenable<AsyncValue<T>>? provider;

  /// The widget builder to use when the data is successfully loaded and not empty.
  /// Receives the data and an `isRefreshing` flag for subsequent fetches.
  final Widget Function(BuildContext context, T data, bool isRefreshing) data;

  /// An optional widget builder for the loading state.
  /// Defaults to a centered CircularProgressIndicator.
  final Widget Function(BuildContext context)? loading;

  /// An optional widget builder for the error state.
  /// Defaults to a centered error message with a retry button.
  final Widget Function(BuildContext context, Object error, StackTrace stack)? error;

  /// An optional widget builder for when the data is successfully loaded but is empty.
  /// Defaults to a simple centered text message.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// An optional callback for pull-to-refresh functionality.
  final Future<void> Function()? onRefresh;

  /// Optional predicate to determine if data should be considered empty.
  /// By default, checks if data is a List and is empty.
  final bool Function(T data)? isEmpty;

  const AsyncValueWidget({
    super.key,
    required AsyncValue<T> value,
    required this.data,
    this.loading,
    this.error,
    this.emptyBuilder,
    this.onRefresh,
    this.isEmpty,
  })  : value = value,
        provider = null;

  /// Convenience constructor to pass a provider directly.
  const AsyncValueWidget.fromProvider({
    super.key,
    required ProviderListenable<AsyncValue<T>> provider,
    required this.data,
    this.loading,
    this.error,
    this.emptyBuilder,
    this.onRefresh,
    this.isEmpty,
  })  : provider = provider,
        value = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = provider != null ? ref.watch(provider!) : value!;
    
    // Check if we're refreshing (loading while having data)
    final isRefreshing = asyncValue.isRefreshing;

    final content = asyncValue.when(
      // Data state
      data: (value) {
        // Check if the data is empty using custom predicate or default logic
        final dataIsEmpty = isEmpty?.call(value) ?? _defaultIsEmpty(value);
        
        if (dataIsEmpty) {
          return emptyBuilder?.call(context) ?? _DefaultEmptyWidget();
        }
        
        // Build the main UI, passing the isRefreshing flag for subsequent refreshes
        return data(context, value, isRefreshing);
      },
      // Loading state
      loading: () => loading?.call(context) ?? _DefaultLoadingWidget(),
      // Error state
      error: (e, st) => error?.call(context, e, st) ?? _DefaultErrorWidget(
        error: e,
        stack: st,
        onRetry: () {
          if (onRefresh != null) {
            onRefresh!();
          } else {
            // Invalidate the provider to retry
            if (provider != null) {
              ref.invalidate(provider!);
            }
          }
        },
      ),
    );

    // If onRefresh is provided, wrap the content in a RefreshIndicator
    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColors.primaryBlue,
        child: content,
      );
    }
    
    return content;
  }

  bool _defaultIsEmpty(T value) {
    if (value is List) {
      return value.isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }
    if (value is Set) {
      return value.isEmpty;
    }
    if (value is String) {
      return value.isEmpty;
    }
    // For non-collection types, consider them non-empty
    return false;
  }
}

/// Default loading widget with consistent styling
class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryBlue,
      ),
    );
  }
}

/// Default empty state widget with consistent styling
class _DefaultEmptyWidget extends StatelessWidget {
  const _DefaultEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new items',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Default error widget with retry functionality
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace stack;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.stack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Extract user-friendly error message
    String errorMessage = 'An unexpected error occurred';
    
    if (error is Exception) {
      errorMessage = error.toString().replaceAll('Exception: ', '');
    } else if (error is Error) {
      errorMessage = 'A system error occurred. Please try again.';
    } else {
      errorMessage = error.toString();
    }

    // Log the full error for debugging
    debugPrint('AsyncValueWidget Error: $error');
    debugPrint('Stack trace: $stack');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension methods for AsyncValue to provide additional utilities
extension AsyncValueX<T> on AsyncValue<T> {
  /// Returns true if the AsyncValue is in a refreshing state
  /// (loading while having previous data)
  bool get isRefreshing {
    return isLoading && hasValue;
  }

  /// Returns the value if available, otherwise null
  T? get valueOrNull {
    return when(
      data: (value) => value,
      loading: () => null,
      error: (_, __) => null,
    );
  }
}
