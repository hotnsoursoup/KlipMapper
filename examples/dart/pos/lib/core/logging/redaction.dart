// lib/core/logging/redaction.dart
typedef JsonMap = Map<String, Object?>;

class RedactionConfig {
  const RedactionConfig({
    this.maskedKeys = const {'password','pin','token','secret','ssn',
                             'cardNumber'},
    this.regexPatterns = const [
      r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',
      r'(?<!\d)\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{1,4}(?!\d)',
    ],
    this.keyMask = '***',
    this.regexMask = '[redacted]',
  });

  final Set<String> maskedKeys;
  final List<String> regexPatterns;
  final String keyMask;
  final String regexMask;

  JsonMap toJson() => {
    'maskedKeys': maskedKeys.toList(),
    'regexPatterns': regexPatterns,
    'keyMask': keyMask,
    'regexMask': regexMask,
  };

  factory RedactionConfig.fromJson(Map<String, Object?> json) =>
      RedactionConfig(
        maskedKeys: Set<String>.from(json['maskedKeys'] as List? ?? const []),
        regexPatterns: List<String>.from(
            json['regexPatterns'] as List? ?? const []),
        keyMask: (json['keyMask'] as String?) ?? '***',
        regexMask: (json['regexMask'] as String?) ?? '[redacted]',
      );

  RedactionConfig copyWith({
    Set<String>? maskedKeys,
    List<String>? regexPatterns,
    String? keyMask,
    String? regexMask,
  }) => RedactionConfig(
        maskedKeys: maskedKeys ?? this.maskedKeys,
        regexPatterns: regexPatterns ?? this.regexPatterns,
        keyMask: keyMask ?? this.keyMask,
        regexMask: regexMask ?? this.regexMask,
      );
}

abstract class Redactor {
  String redactText(String text);
  JsonMap redactMap(JsonMap map);
}

class KeyRedactor implements Redactor {
  KeyRedactor(this.keys, {this.mask = '***'});
  final Set<String> keys;
  final String mask;

  @override
  String redactText(String text) => text;

  @override
  JsonMap redactMap(JsonMap map) {
    final out = <String, Object?>{};
    map.forEach((k, v) {
      if (keys.contains(k)) {
        out[k] = mask;
      } else if (v is Map<String, Object?>) {
        out[k] = redactMap(v.cast<String, Object?>());
      } else {
        out[k] = v;
      }
    });
    return out;
  }
}

class PatternRedactor implements Redactor {
  PatternRedactor(this.patterns, {this.mask = '[redacted]'});
  final List<RegExp> patterns;
  final String mask;

  @override
  String redactText(String text) {
    var t = text;
    for (final p in patterns) {
      t = t.replaceAll(p, mask);
    }
    return t;
  }

  @override
  JsonMap redactMap(JsonMap map) {
    final out = <String, Object?>{};
    map.forEach((k, v) {
      if (v is String) {
        out[k] = redactText(v);
      } else if (v is Map<String, Object?>) {
        out[k] = redactMap(v.cast<String, Object?>());
      } else {
        out[k] = v;
      }
    });
    return out;
  }
}

class CompositeRedactor implements Redactor {
  CompositeRedactor(this._list);
  final List<Redactor> _list;

  @override
  String redactText(String text) =>
      _list.fold(text, (t, r) => r.redactText(t));

  @override
  JsonMap redactMap(JsonMap map) =>
      _list.fold(map, (m, r) => r.redactMap(m));
}

Redactor buildRedactor(RedactionConfig cfg) => CompositeRedactor([
  KeyRedactor(cfg.maskedKeys, mask: cfg.keyMask),
  PatternRedactor(
    [for (final s in cfg.regexPatterns) RegExp(s, caseSensitive: false)],
    mask: cfg.regexMask,
  ),
]);
