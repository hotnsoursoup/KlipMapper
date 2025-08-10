// lib/features/appointments/data/models/calendar_view_mode.dart
// Calendar view mode enumeration defining different display formats with configuration properties.
// Includes display names, day counts, time slot visibility, and layout characteristics.
// Usage: ACTIVE - Calendar view switching, UI layout configuration, and display mode management

/// Different view modes for the calendar
enum CalendarViewMode {
  day,
  week,
  weekGrid,
  weekChart,
  month,
  agenda,
}

extension CalendarViewModeExtension on CalendarViewMode {
  /// Display name for the view mode
  String get displayName {
    switch (this) {
      case CalendarViewMode.day:
        return 'Day';
      case CalendarViewMode.week:
        return 'Week';
      case CalendarViewMode.weekGrid:
        return 'Week Grid';
      case CalendarViewMode.weekChart:
        return 'Week Chart';
      case CalendarViewMode.month:
        return 'Month';
      case CalendarViewMode.agenda:
        return 'Agenda';
    }
  }

  /// Icon name for the view mode
  String get iconName {
    switch (this) {
      case CalendarViewMode.day:
        return 'today';
      case CalendarViewMode.week:
        return 'view_week';
      case CalendarViewMode.weekGrid:
        return 'grid_view';
      case CalendarViewMode.weekChart:
        return 'bar_chart';
      case CalendarViewMode.month:
        return 'view_module';
      case CalendarViewMode.agenda:
        return 'view_agenda';
    }
  }

  /// Number of days to display
  int get dayCount {
    switch (this) {
      case CalendarViewMode.day:
        return 1;
      case CalendarViewMode.week:
      case CalendarViewMode.weekGrid:
      case CalendarViewMode.weekChart:
        return 7;
      case CalendarViewMode.month:
        return 30; // Approximate
      case CalendarViewMode.agenda:
        return 7; // Show week's worth in agenda
    }
  }

  /// Whether this view shows time slots
  bool get showTimeSlots {
    switch (this) {
      case CalendarViewMode.day:
      case CalendarViewMode.week:
      case CalendarViewMode.weekGrid:
        return true;
      case CalendarViewMode.weekChart:
      case CalendarViewMode.month:
      case CalendarViewMode.agenda:
        return false;
    }
  }

  /// Whether this view shows multiple days
  bool get isMultiDay => this != CalendarViewMode.day;

  /// Whether this view is compact (shows less detail)
  bool get isCompact {
    switch (this) {
      case CalendarViewMode.month:
      case CalendarViewMode.agenda:
      case CalendarViewMode.weekChart:
        return true;
      case CalendarViewMode.day:
      case CalendarViewMode.week:
      case CalendarViewMode.weekGrid:
        return false;
    }
  }
}