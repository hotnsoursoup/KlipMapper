// lib/core/logging/logging_mixins.dart
import 'dart:async';
import 'log_level.dart';
import 'pos_logger.dart';

typedef JsonMap = Map<String, Object?>;

mixin HasLogger {
  late final PosLogger logger;
  String? get logCategory => null;
  String? get logName => runtimeType.toString();

  Future<T> withSpan<T>(
    String name,
    FutureOr<T> Function() run, {
    JsonMap? data,
    String? correlationId,
  }) async {
    final spanId = DateTime.now().microsecondsSinceEpoch.toString();
    await logger.log(
      level: LogLevel.info,
      message: '▶ $name',
      category: logCategory,
      logger: logName,
      data: {...?data, 'span': name, 'spanId': spanId},
      correlationId: correlationId,
      spanId: spanId,
    );
    final sw = Stopwatch()..start();
    try {
      final v = await run();
      sw.stop();
      await logger.log(
        level: LogLevel.info,
        message: '✔ $name',
        category: logCategory,
        logger: logName,
        data: {'span': name, 'spanId': spanId, 'ms': sw.elapsedMilliseconds},
        correlationId: correlationId,
        spanId: spanId,
      );
      return v;
    } catch (e, st) {
      sw.stop();
      await logger.log(
        level: LogLevel.error,
        message: '✘ $name',
        category: logCategory,
        logger: logName,
        data: {'span': name, 'spanId': spanId, 'ms': sw.elapsedMilliseconds},
        exception: e,
        stack: st,
        correlationId: correlationId,
        spanId: spanId,
      );
      rethrow;
    }
  }

  Future<T> traceMethod<T>(
    String method,
    FutureOr<T> Function() run, {
    JsonMap? args,
    String? correlationId,
  }) => withSpan<T>(method, run, data: args, correlationId: correlationId);
}
