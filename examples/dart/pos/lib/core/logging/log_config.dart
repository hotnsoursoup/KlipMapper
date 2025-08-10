// lib/core/logging/log_config.dart
import 'redaction.dart';
import 'log_level.dart';

class RemoteLogConfig {
  const RemoteLogConfig({
    this.enabled = false,
    this.endpoint,
    this.batchSize = 50,
    this.flushIntervalSec = 10,
    this.maxRetries = 4,
    this.backoffBaseMs = 500,
    this.maxBatchBytes = 128 * 1024,
  });

  final bool enabled;
  final String? endpoint;
  final int batchSize;
  final int flushIntervalSec;
  final int maxRetries;
  final int backoffBaseMs;
  final int maxBatchBytes;

  Map<String, Object?> toJson() => {
    'enabled': enabled,
    'endpoint': endpoint,
    'batchSize': batchSize,
    'flushIntervalSec': flushIntervalSec,
    'maxRetries': maxRetries,
    'backoffBaseMs': backoffBaseMs,
    'maxBatchBytes': maxBatchBytes,
  };

  factory RemoteLogConfig.fromJson(Map<String, Object?> m) => RemoteLogConfig(
    enabled: (m['enabled'] as bool?) ?? false,
    endpoint: m['endpoint'] as String?,
    batchSize: (m['batchSize'] as num?)?.toInt() ?? 50,
    flushIntervalSec: (m['flushIntervalSec'] as num?)?.toInt() ?? 10,
    maxRetries: (m['maxRetries'] as num?)?.toInt() ?? 4,
    backoffBaseMs: (m['backoffBaseMs'] as num?)?.toInt() ?? 500,
    maxBatchBytes: (m['maxBatchBytes'] as num?)?.toInt() ?? 131072,
  );

  RemoteLogConfig copyWith({
    bool? enabled,
    String? endpoint,
    int? batchSize,
    int? flushIntervalSec,
    int? maxRetries,
    int? backoffBaseMs,
    int? maxBatchBytes,
  }) => RemoteLogConfig(
        enabled: enabled ?? this.enabled,
        endpoint: endpoint ?? this.endpoint,
        batchSize: batchSize ?? this.batchSize,
        flushIntervalSec: flushIntervalSec ?? this.flushIntervalSec,
        maxRetries: maxRetries ?? this.maxRetries,
        backoffBaseMs: backoffBaseMs ?? this.backoffBaseMs,
        maxBatchBytes: maxBatchBytes ?? this.maxBatchBytes,
      );
}

class LogConfig {
  LogConfig({
    this.minLevel = LogLevel.info,
    this.console = true,
    this.file = true,
    this.maxFileBytes = 2 * 1024 * 1024,
    this.rotateDaily = true,
    this.rotationTime = '00:00',
    this.includeCats,
    this.excludeCats,
    this.sampleTraceProbability = 0.05,
    this.sampleDebugProbability = 0.25,
    this.capturePrint = true,
    this.captureFlutterErrors = true,
    this.lifecycleFlushOnPause = true,
    this.providerTracingEnabled = false,
    this.redaction = const RedactionConfig(),
    this.remote = const RemoteLogConfig(),
    this.deviceId,
    this.storeId,
  });

  LogLevel minLevel;
  bool console;
  bool file;
  int maxFileBytes;
  bool rotateDaily;
  String rotationTime; // HH:mm
  Set<String>? includeCats;
  Set<String>? excludeCats;
  double sampleTraceProbability;
  double sampleDebugProbability;
  bool capturePrint;
  bool captureFlutterErrors;
  bool lifecycleFlushOnPause;
  bool providerTracingEnabled;
  RedactionConfig redaction;
  RemoteLogConfig remote;
  String? deviceId;
  String? storeId;

  Map<String, Object?> toJson() => {
    'minLevel': minLevel.name,
    'console': console,
    'file': file,
    'maxFileBytes': maxFileBytes,
    'rotateDaily': rotateDaily,
    'rotationTime': rotationTime,
    'includeCats': includeCats?.toList(),
    'excludeCats': excludeCats?.toList(),
    'sampleTraceProbability': sampleTraceProbability,
    'sampleDebugProbability': sampleDebugProbability,
    'capturePrint': capturePrint,
    'captureFlutterErrors': captureFlutterErrors,
    'lifecycleFlushOnPause': lifecycleFlushOnPause,
    'providerTracingEnabled': providerTracingEnabled,
    'redaction': redaction.toJson(),
    'remote': remote.toJson(),
    'deviceId': deviceId,
    'storeId': storeId,
  };

  factory LogConfig.fromJson(Map<String, Object?> m) => LogConfig(
    minLevel: LogLevel.values.firstWhere(
      (v) => v.name == (m['minLevel'] as String? ?? 'info'),
      orElse: () => LogLevel.info),
    console: (m['console'] as bool?) ?? true,
    file: (m['file'] as bool?) ?? true,
    maxFileBytes: (m['maxFileBytes'] as num?)?.toInt() ?? 2*1024*1024,
    rotateDaily: (m['rotateDaily'] as bool?) ?? true,
    rotationTime: (m['rotationTime'] as String?) ?? '00:00',
    includeCats: (m['includeCats'] as List?) == null
      ? null : Set<String>.from(m['includeCats'] as List),
    excludeCats: (m['excludeCats'] as List?) == null
      ? null : Set<String>.from(m['excludeCats'] as List),
    sampleTraceProbability:
      (m['sampleTraceProbability'] as num?)?.toDouble() ?? 0.05,
    sampleDebugProbability:
      (m['sampleDebugProbability'] as num?)?.toDouble() ?? 0.25,
    capturePrint: (m['capturePrint'] as bool?) ?? true,
    captureFlutterErrors: (m['captureFlutterErrors'] as bool?) ?? true,
    lifecycleFlushOnPause:
      (m['lifecycleFlushOnPause'] as bool?) ?? true,
    providerTracingEnabled:
      (m['providerTracingEnabled'] as bool?) ?? false,
    redaction: m['redaction'] is Map
      ? RedactionConfig.fromJson((m['redaction'] as Map).cast())
      : const RedactionConfig(),
    remote: m['remote'] is Map
      ? RemoteLogConfig.fromJson((m['remote'] as Map).cast())
      : const RemoteLogConfig(),
    deviceId: m['deviceId'] as String?,
    storeId: m['storeId'] as String?,
  );

  LogConfig copyWith({
    LogLevel? minLevel,
    bool? console,
    bool? file,
    int? maxFileBytes,
    bool? rotateDaily,
    String? rotationTime,
    Set<String>? includeCats,
    Set<String>? excludeCats,
    double? sampleTraceProbability,
    double? sampleDebugProbability,
    bool? capturePrint,
    bool? captureFlutterErrors,
    bool? lifecycleFlushOnPause,
    bool? providerTracingEnabled,
    RedactionConfig? redaction,
    RemoteLogConfig? remote,
    String? deviceId,
    String? storeId,
  }) => LogConfig(
        minLevel: minLevel ?? this.minLevel,
        console: console ?? this.console,
        file: file ?? this.file,
        maxFileBytes: maxFileBytes ?? this.maxFileBytes,
        rotateDaily: rotateDaily ?? this.rotateDaily,
        rotationTime: rotationTime ?? this.rotationTime,
        includeCats: includeCats ?? this.includeCats,
        excludeCats: excludeCats ?? this.excludeCats,
        sampleTraceProbability:
          sampleTraceProbability ?? this.sampleTraceProbability,
        sampleDebugProbability:
          sampleDebugProbability ?? this.sampleDebugProbability,
        capturePrint: capturePrint ?? this.capturePrint,
        captureFlutterErrors:
          captureFlutterErrors ?? this.captureFlutterErrors,
        lifecycleFlushOnPause:
          lifecycleFlushOnPause ?? this.lifecycleFlushOnPause,
        providerTracingEnabled:
          providerTracingEnabled ?? this.providerTracingEnabled,
        redaction: redaction ?? this.redaction,
        remote: remote ?? this.remote,
        deviceId: deviceId ?? this.deviceId,
        storeId: storeId ?? this.storeId,
      );

  factory LogConfig.production({
    String? deviceId, String? storeId,
  }) => LogConfig(
    minLevel: LogLevel.info,
    console: true,
    file: true,
    sampleTraceProbability: 0.01,
    sampleDebugProbability: 0.1,
    providerTracingEnabled: false,
    deviceId: deviceId, storeId: storeId,
  );

  factory LogConfig.development({
    String? deviceId, String? storeId,
  }) => LogConfig(
    minLevel: LogLevel.debug,
    console: true,
    file: true,
    sampleTraceProbability: 1.0,
    sampleDebugProbability: 1.0,
    providerTracingEnabled: true,
    deviceId: deviceId, storeId: storeId,
  );

  factory LogConfig.troubleshooting({
    String? deviceId, String? storeId,
  }) => LogConfig(
    minLevel: LogLevel.trace,
    console: true,
    file: true,
    sampleTraceProbability: 1.0,
    sampleDebugProbability: 1.0,
    providerTracingEnabled: true,
    deviceId: deviceId, storeId: storeId,
  );
}
