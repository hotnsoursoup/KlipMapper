// lib/core/logging/riverpod_observer.dart
import 'package:riverpod/riverpod.dart';
import 'pos_logger.dart';
import 'log_level.dart';

class TracingObserver extends ProviderObserver {
  TracingObserver(this._logger);
  final PosLogger _logger;
  // TODO(admin-activation): Only register this observer when advanced tracing
  // is enabled by an admin/session flag to reduce noise in production.

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _logger.log(
      level: LogLevel.trace,
      message: 'provider update',
      category: 'provider',
      data: {
        'provider': context.provider.name ?? context.provider.runtimeType.toString(),
        'prev': '$previousValue',
        'next': '$newValue',
      },
    );
  }
}
