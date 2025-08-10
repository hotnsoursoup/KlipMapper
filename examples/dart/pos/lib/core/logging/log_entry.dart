// lib/core/logging/log_entry.dart
import 'dart:convert';
import 'log_level.dart';

typedef JsonMap = Map<String, Object?>;

class LogEntry {
  LogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.category,
    this.logger,
    this.data,
    this.error,
    this.stack,
    this.correlationId,
    this.spanId,
    this.redactionState,
  });

  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? category;
  final String? logger;
  final JsonMap? data;
  final String? error;
  final String? stack;
  final String? correlationId;
  final String? spanId;
  final JsonMap? redactionState;

  JsonMap toMap() => {
    'id': id,
    't': timestamp.toIso8601String(),
    'lvl': level.name,
    'msg': message,
    if (category != null) 'cat': category,
    if (logger != null) 'log': logger,
    if (data != null) 'data': data,
    if (error != null) 'err': error,
    if (stack != null) 'st': stack,
    if (correlationId != null) 'corr': correlationId,
    if (spanId != null) 'span': spanId,
    if (redactionState != null) 'red': redactionState,
  };

  String toJson() => jsonEncode(toMap());

  factory LogEntry.fromMap(JsonMap m) => LogEntry(
    id: m['id'] as String,
    timestamp: DateTime.parse(m['t'] as String),
    level: LogLevel.values.firstWhere(
      (v) => v.name == (m['lvl'] as String)),
    message: m['msg'] as String,
    category: m['cat'] as String?,
    logger: m['log'] as String?,
    data: (m['data'] as Map?)?.cast<String, Object?>(),
    error: m['err'] as String?,
    stack: m['st'] as String?,
    correlationId: m['corr'] as String?,
    spanId: m['span'] as String?,
    redactionState: (m['red'] as Map?)?.cast<String, Object?>(),
  );
}
