// lib/core/logging/log_level.dart
enum LogLevel { trace, debug, info, warn, error, fatal, off }

extension LogLevelX on LogLevel {
  int get weight => switch (this) {
        LogLevel.trace => 10,
        LogLevel.debug => 20,
        LogLevel.info => 30,
        LogLevel.warn => 40,
        LogLevel.error => 50,
        LogLevel.fatal => 60,
        LogLevel.off => 99,
      };
  bool enables(LogLevel level) => level.weight >= weight;
}
