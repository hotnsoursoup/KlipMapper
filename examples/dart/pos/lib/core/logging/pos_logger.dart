// lib/core/logging/pos_logger.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'log_entry.dart';
import 'log_level.dart';
import 'log_config.dart';
import 'redaction.dart';

typedef JsonMap = Map<String, Object?>;

class PosLogger {
  PosLogger(this.config)
      : _rnd = Random(),
        _redactor = buildRedactor(config.redaction) {
    _rotationAnchor = _computeNextRotation();
    _remoteTicker = Timer.periodic(
      Duration(seconds: config.remote.flushIntervalSec),
      (_) => _flushRemoteQueue(),
    );
  }

  LogConfig config;
  // Global entry listeners for observability hooks (e.g., auto-upload on critical)
  static final List<void Function(LogEntry)> _entryListeners = <void Function(LogEntry)>[];
  final Random _rnd;
  final Redactor _redactor;

  JsonMap baseContext = {};

  IOSink? _sink;
  File? _file;
  int _writtenBytes = 0;
  DateTime _rotationAnchor = DateTime.now();

  final List<LogEntry> _remoteQueue = [];
  Timer? _remoteTicker;

  final List<LogEntry> _ring = [];
  static const int _ringMax = 1000;

  void setBaseContext(JsonMap ctx) {
    baseContext = {...baseContext, ...ctx};
  }

  DateTime _computeNextRotation() {
    if (!config.rotateDaily) return DateTime.now().add(const Duration(days: 3650));
    final parts = config.rotationTime.split(':');
    final hh = int.tryParse(parts.elementAt(0)) ?? 0;
    final mm = int.tryParse(parts.elementAt(1)) ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, hh, mm);
    return now.isBefore(today)
        ? today
        : today.add(const Duration(days: 1));
  }

  bool _sampledIn(LogLevel lvl) {
    if (lvl == LogLevel.trace) {
      return _rnd.nextDouble() <= config.sampleTraceProbability;
    }
    if (lvl == LogLevel.debug) {
      return _rnd.nextDouble() <= config.sampleDebugProbability;
    }
    return true;
  }

  bool _categoryAllowed(String? category) {
    final inc = config.includeCats;
    final exc = config.excludeCats;
    if (inc != null && category != null && !inc.contains(category)) return false;
    if (exc != null && category != null && exc.contains(category)) return false;
    return true;
  }

  Future<void> _ensureFileOpen() async {
    if (!config.file) return;
    if (_sink != null) return;
    final dir = await getApplicationSupportDirectory();
    final logDir = Directory('${dir.path}/logs');
    if (!await logDir.exists()) await logDir.create(recursive: true);
    _file = File('${logDir.path}/app.log');
    if (!await _file!.exists()) await _file!.create(recursive: true);
    _writtenBytes = await _file!.length();
    _sink = _file!.openWrite(mode: FileMode.append);
  }

  Future<void> _rotateIfNeeded() async {
    if (!config.file) return;
    final now = DateTime.now();
    if (_writtenBytes >= config.maxFileBytes || now.isAfter(_rotationAnchor)) {
      await _sink?.flush();
      await _sink?.close();
      final f = _file;
      if (f != null) {
        final ts = now.toIso8601String().replaceAll(':','-').split('.').first;
        final rotated = File('${f.path}.$ts');
        try { await f.rename(rotated.path); }
        catch (_) { await f.copy(rotated.path); await f.writeAsString(''); }
      }
      _sink = null;
      _file = null;
      _rotationAnchor = _computeNextRotation();
      await _ensureFileOpen();
      _writtenBytes = 0;
    }
  }

  void _recordToRing(LogEntry e) {
    _ring.add(e);
    if (_ring.length > _ringMax) _ring.removeAt(0);
  }

  Future<void> log({
    required LogLevel level,
    required String message,
    String? category,
    String? logger,
    JsonMap? data,
    Object? exception,
    StackTrace? stack,
    String? correlationId,
    String? spanId,
  }) async {
    if (!config.minLevel.enables(level)) return;
    if (!_sampledIn(level)) return;
    if (!_categoryAllowed(category)) return;

    final merged = {
      if (baseContext.isNotEmpty) ...baseContext,
      if (data != null) ...data,
    };
    final redMsg = _redactor.redactText(message);
    final redMap = merged.isEmpty ? null : _redactor.redactMap(merged.cast());
    final redErr = exception == null ? null : _redactor.redactText('$exception');
    final redSt = stack == null ? null : _redactor.redactText(stack.toString());

    final id = '${DateTime.now().microsecondsSinceEpoch}'
              '-${_rnd.nextInt(0x7fffffff)}';

    final entry = LogEntry(
      id: id,
      timestamp: DateTime.now(),
      level: level,
      message: redMsg,
      category: category,
      logger: logger,
      data: redMap,
      error: redErr,
      stack: redSt,
      correlationId: correlationId,
      spanId: spanId,
      redactionState: (redMap != null || redErr != null || redSt != null)
          ? {'redacted': true} : null,
    );

    // Notify listeners before routing to sinks
    for (final listener in List<void Function(LogEntry)>.from(_entryListeners)) {
      try { listener(entry); } catch (_) {}
    }

    if (config.console) {
      final line = '${entry.timestamp.toIso8601String()}'
                   ' [${level.name.toUpperCase()}]'
                   '${logger != null ? ' $logger' : ''}'
                   '${category != null ? ' {$category}' : ''} '
                   '${entry.message}';
      debugPrint(line);
    }

    if (config.file) {
      await _ensureFileOpen();
      final jsonLine = entry.toJson();
      _sink!.writeln(jsonLine);
      _writtenBytes += jsonLine.length + 1;
      await _rotateIfNeeded();
    }

    if (config.remote.enabled) {
      _remoteQueue.add(entry);
    }

    _recordToRing(entry);
  }

  // Manage listeners
  static void addEntryListener(void Function(LogEntry) listener) {
    _entryListeners.add(listener);
  }
  static void removeEntryListener(void Function(LogEntry) listener) {
    _entryListeners.remove(listener);
  }

  Future<void> _flushRemoteQueue() async {
    if (!config.remote.enabled) return;
    if (_remoteQueue.isEmpty) return;
    // TODO(api): Implement remote queue flush (HTTP POST) with batching,
    // retries/backoff, offline queueing, and request signing.
    _remoteQueue.clear();
  }

  Future<void> dispose() async {
    await _flushRemoteQueue();
    await _sink?.flush();
    await _sink?.close();
    _remoteTicker?.cancel();
  }

  Future<List<LogEntry>> readLogsFromFiles({
    DateTime? start,
    DateTime? end,
    LogLevel? minLevel,
    String? category,
    String? correlationId,
    int max = 1000,
  }) async {
    final dir = await getApplicationSupportDirectory();
    final logDir = Directory('${dir.path}/logs');
    if (!await logDir.exists()) return [];
    final files = await logDir
        .list()
        .where((e) => e is File && e.path.contains('app.log'))
        .cast<File>()
        .toList();

    final out = <LogEntry>[];
    for (final f in files) {
      try {
        final lines = await f.readAsLines();
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          try {
            final m = LogEntry.fromMap(
              (jsonDecode(line) as Map).cast<String, Object?>());
            if (start != null && m.timestamp.isBefore(start)) continue;
            if (end != null && m.timestamp.isAfter(end)) continue;
            if (minLevel != null && !minLevel.enables(m.level)) continue;
            if (category != null && m.category != category) continue;
            if (correlationId != null && m.correlationId != correlationId) {
              continue;
            }
            out.add(m);
            if (out.length >= max) return out;
          } catch (_) {}
        }
      } catch (_) {}
    }
    return out;
  }

  List<LogEntry> getRecentLogs({int limit = 200}) {
    final s = _ring.length <= limit ? 0 : _ring.length - limit;
    return _ring.sublist(s);
  }
}
