// lib/core/utils/debouncer.dart
// Utility class for debouncing function calls to prevent excessive API calls or operations. Delays execution until after a period of inactivity, commonly used for search inputs and form validation.
// Usage: ACTIVE - Used for search debouncing and form input optimization

import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class for debouncing function calls.
/// 
/// This is useful for scenarios where you want to delay the execution of a function
/// until after a certain period of inactivity, such as search inputs or API calls.
/// 
/// Example usage:
/// ```dart
/// final _debouncer = Debouncer(milliseconds: 500);
/// 
/// void onSearchChanged(String query) {
///   _debouncer.run(() {
///     // This will only execute 500ms after the user stops typing
///     performSearch(query);
///   });
/// }
/// ```
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({
    this.milliseconds = 500,
  });

  /// Runs the provided action after the specified delay.
  /// If called again before the delay expires, the previous call is cancelled.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending debounced calls.
  void cancel() {
    _timer?.cancel();
  }

  /// Disposes of the debouncer and cancels any pending calls.
  void dispose() {
    _timer?.cancel();
  }
}

/// A debouncer that can be used with ValueNotifier or ChangeNotifier.
/// 
/// This variant is useful when you need to debounce changes to a value
/// and want to be notified when the debounced value changes.
/// 
/// Example usage:
/// ```dart
/// final _searchDebouncer = ValueDebouncer<String>(
///   duration: Duration(milliseconds: 300),
///   value: '',
/// );
/// 
/// // In your widget
/// TextField(
///   onChanged: (value) => _searchDebouncer.value = value,
/// )
/// 
/// // Listen to debounced changes
/// _searchDebouncer.addListener(() {
///   performSearch(_searchDebouncer.debouncedValue);
/// });
/// ```
class ValueDebouncer<T> extends ChangeNotifier {
  final Duration duration;
  Timer? _timer;
  T _value;
  T _debouncedValue;

  ValueDebouncer({
    required this.duration,
    required T initialValue,
  })  : _value = initialValue,
        _debouncedValue = initialValue;

  T get value => _value;
  T get debouncedValue => _debouncedValue;

  set value(T newValue) {
    _value = newValue;
    _timer?.cancel();
    _timer = Timer(duration, () {
      _debouncedValue = _value;
      notifyListeners();
    });
  }

  void cancel() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// A mixin that provides debouncing functionality to any class.
/// 
/// Example usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyWidgetState extends State<MyWidget> with DebouncerMixin {
///   @override
///   void initState() {
///     super.initState();
///     setupDebouncer(milliseconds: 300);
///   }
/// 
///   void onSearchChanged(String query) {
///     debounce(() {
///       // Perform search
///     });
///   }
/// }
/// ```
mixin DebouncerMixin {
  Debouncer? _debouncer;

  void setupDebouncer({int milliseconds = 500}) {
    _debouncer = Debouncer(milliseconds: milliseconds);
  }

  void debounce(VoidCallback action) {
    if (_debouncer == null) {
      throw StateError('Debouncer not initialized. Call setupDebouncer() first.');
    }
    _debouncer!.run(action);
  }

  void cancelDebounce() {
    _debouncer?.cancel();
  }

  void disposeDebouncer() {
    _debouncer?.dispose();
  }
}