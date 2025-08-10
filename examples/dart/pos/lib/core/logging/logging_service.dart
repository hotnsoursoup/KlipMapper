// lib/core/logging/logging_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';
import 'riverpod_observer.dart';
import 'log_config.dart';
import 'log_level.dart';
import 'log_entry.dart';
import 'pos_logger.dart';
import 'remote_uploader.dart';

typedef JsonMap = Map<String, Object?>;

class LoggingService {
  LoggingService(this._config) : _logger = PosLogger(_config);

  LogConfig _config;
  final PosLogger _logger;

  JsonMap baseContext = {};
  String? _troubleshootCorr;

  bool _autoUploadCritical = true;
  Timer? _advancedTtlTimer;

  Future<void> initialize() async {
    // Register a listener to auto-upload diagnostics on critical errors
    PosLogger.addEntryListener(_onEntryProcessed);
    // Propagate any pre-set base context to engine
    if (baseContext.isNotEmpty) {
      _logger.setBaseContext(baseContext);
    }
    // TODO(admin-activation): Wire this service to your remote admin/screen-sharing
    // control flow. Example triggers:
    //  - On remote admin command: enableAdvancedTracing(ttl: ..., reason: ...)
    //  - On screen-sharing start: enableAdvancedTracing(...)
    //  - On session end or admin stop: disableAdvancedTracing(...)
  }

  LogConfig get config => _config;
  PosLogger get engine => _logger;

  /// Build a Riverpod observer for provider tracing.
  /// Pass this to ProviderScope(observers:[...]) when enabled.
  ProviderObserver tracingObserver() => TracingObserver(_logger);

  void updateConfig(LogConfig cfg) {
    _config = cfg;
    _logger.config = cfg;
  }

  void setAutoUploadCritical(bool enabled) => _autoUploadCritical = enabled;

  void setBaseContext(JsonMap ctx) {
    baseContext = {...baseContext, ...ctx};
    _logger.setBaseContext(baseContext);
  }

  void clearBaseContext() {
    baseContext = {};
    _logger.setBaseContext(baseContext);
  }

  void mergeBaseContext(JsonMap ctx) => setBaseContext(ctx);

  void enableTroubleshootingMode({
    Duration ttl = const Duration(minutes: 15),
    String? reason,
  }) {
    final prev = _config;
    _config = LogConfig.troubleshooting(
      deviceId: prev.deviceId, storeId: prev.storeId);
    _logger.config = _config;
    _troubleshootCorr =
      '${DateTime.now().microsecondsSinceEpoch}-ts';

    unawaited(_logger.log(
      level: LogLevel.info,
      message: 'Trace session started',
      category: 'trace',
      data: {'reason': reason, 'corr': _troubleshootCorr},
      correlationId: _troubleshootCorr,
    ));

    _advancedTtlTimer?.cancel();
    _advancedTtlTimer = Timer(ttl, () {
      _config = prev;
      _logger.config = _config;
      unawaited(_logger.log(
        level: LogLevel.info,
        message: 'Trace session stopped',
        category: 'trace',
        correlationId: _troubleshootCorr,
      ));
      _troubleshootCorr = null;
    });
  }

  // Admin-only: convenience alias for advanced tracing activation
  void enableAdvancedTracing({
    Duration ttl = const Duration(minutes: 15),
    String? reason,
  }) => enableTroubleshootingMode(ttl: ttl, reason: reason);

  void disableAdvancedTracing({String? reason}) {
    _advancedTtlTimer?.cancel();
    _advancedTtlTimer = null;
    final corr = _troubleshootCorr;
    if (corr != null) {
      unawaited(_logger.log(
        level: LogLevel.info,
        message: 'Trace session stopped (manual)',
        category: 'trace',
        correlationId: corr,
        data: {'reason': reason},
      ));
    }
    // Restore defaults
    _config = LogConfig.production(deviceId: _config.deviceId, storeId: _config.storeId);
    _logger.config = _config;
    _troubleshootCorr = null;
  }

  // Collect recent logs and send to remote API (stubbed uploader)
  Future<void> collectAndUploadDiagnostics({
    String? userNotes,
    Duration window = const Duration(minutes: 10),
  }) async {
    try {
      final end = DateTime.now();
      final start = end.subtract(window);
      final recent = await exportLogs(start: start, end: end, minLevel: LogLevel.debug, max: 2000);
      final payload = {
        'meta': {
          'deviceId': _config.deviceId,
          'storeId': _config.storeId,
          'sessionId': baseContext['sessionId'] ?? '',
          'generatedAt': DateTime.now().toIso8601String(),
          if (userNotes != null) 'notes': userNotes,
        },
        'entries': recent.map((e) => e.toMap()).toList(),
      };
      // TODO(api): Implement authenticated upload with retries/backoff,
      // compression (gzip/zip) for large payloads, and server-side correlation.
      // Add request signing or token-based auth to protect sensitive data.
      await RemoteUploader.uploadDiagnostics(payload);
      unawaited(_logger.log(
        level: LogLevel.info,
        message: 'Diagnostics uploaded',
        category: 'diagnostics',
        data: {'count': recent.length},
      ));
    } catch (e, st) {
      unawaited(_logger.log(
        level: LogLevel.error,
        message: 'Diagnostics upload failed',
        category: 'diagnostics',
        exception: e,
        stack: st,
      ));
    }
  }

  void _onEntryProcessed(LogEntry entry) {
    if (!_autoUploadCritical) return;
    // Upload on fatal errors immediately; optionally widen to specific categories
    if (entry.level == LogLevel.fatal) {
      // TODO(policy): Add throttling/de-dupe to avoid repeated uploads
      // for the same fault signature within a short window.
      unawaited(_uploadCritical(entry));
    }
  }

  Future<void> _uploadCritical(LogEntry entry) async {
    try {
      final end = DateTime.now();
      final start = end.subtract(const Duration(minutes: 5));
      final recent = await exportLogs(start: start, end: end, max: 2000);
      final payload = {
        'meta': {
          'deviceId': _config.deviceId,
          'storeId': _config.storeId,
          'trigger': 'critical_error',
          'entryId': entry.id,
          'category': entry.category,
          'timestamp': entry.timestamp.toIso8601String(),
        },
        'triggerEntry': entry.toMap(),
        'entries': recent.map((e) => e.toMap()).toList(),
      };
      // TODO(api): Implement a smaller/faster critical upload variant (single
      // entry + short window context). Include incident/ticket correlation.
      await RemoteUploader.uploadDiagnostics(payload);
      unawaited(_logger.log(
        level: LogLevel.info,
        message: 'Critical diagnostics uploaded',
        category: 'diagnostics',
        data: {'triggerId': entry.id, 'count': recent.length},
      ));
    } catch (e, st) {
      unawaited(_logger.log(
        level: LogLevel.error,
        message: 'Critical diagnostics upload failed',
        category: 'diagnostics',
        exception: e,
        stack: st,
      ));
    }
  }

  void installRuntimeHooks() {
    if (_config.captureFlutterErrors) {
      FlutterError.onError = (details) {
        unawaited(_logger.log(
          level: LogLevel.error,
          message: 'FlutterError',
          category: 'flutter',
          data: {
            'library': details.library,
            'context': details.context?.toDescription(),
          },
          exception: details.exception,
          stack: details.stack,
        ));
      };
    }

    runZonedGuarded<void>(
      () {},
      (e, st) {
        unawaited(_logger.log(
          level: LogLevel.error,
          message: 'Uncaught zone error',
          category: 'zone',
          exception: e,
          stack: st,
        ));
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          if (_config.capturePrint) {
            unawaited(_logger.log(
              level: LogLevel.info,
              message: line,
              category: 'stdout',
              logger: 'print',
            ));
          }
          parent.print(zone, line);
        },
      ),
    );

    if (_config.lifecycleFlushOnPause) {
      WidgetsBinding.instance.addObserver(
        _LifecycleObserver(_logger));
    }
  }

  Future<List<LogEntry>> exportLogs({
    DateTime? start,
    DateTime? end,
    LogLevel? minLevel,
    String? category,
    String? correlationId,
    int max = 2000,
  }) => _logger.readLogsFromFiles(
        start: start,
        end: end,
        minLevel: minLevel,
        category: category,
        correlationId: correlationId,
        max: max,
      );

  List<LogEntry> getRecent({int limit = 200}) =>
      _logger.getRecentLogs(limit: limit);

  Future<void> dispose() async {
    await _logger.dispose();
  }
}

class _LifecycleObserver with WidgetsBindingObserver {
  _LifecycleObserver(this._logger);
  final PosLogger _logger;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_logger.dispose());
    }
  }
}
