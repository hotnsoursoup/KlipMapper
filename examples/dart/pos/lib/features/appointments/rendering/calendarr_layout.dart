/// calendar_layout.dart
/// Pure layout math for calendar timelines/grids.
/// No Flutter/Riverpod imports — safe to use anywhere.
///
/// - Single column:  use `computeBlocks(...)`.
/// - Multi column:   use `computeColumnBlocks(...)`.
///
/// Coordinates:
///   top/height are in pixels, using `pixelsPerMinute`.
///   Day origin is midnight of `day` (00:00).
///
/// Notes:
/// - Greedy lane assignment (stable) to avoid overlaps in the same lane.
/// - Clamps very short events to `kMinBlockHeight`.
/// - Handles cross-day spans by clipping to the given day.
/// - Keep caching/memoization in your provider layer.

/// Minimal appointment span the layout needs.
class AppointmentSpan {
  final String id;
  final DateTime start; // may be outside this day; we clip
  final DateTime end;   // may be outside this day; we clip
  final String? column; // optional: for multi-column grouping (e.g., technicianId)

  const AppointmentSpan({
    required this.id,
    required this.start,
    required this.end,
    this.column,
  });

  /// Convenience helper if you store scheduled times under different names.
  AppointmentSpan copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    String? column,
  }) {
    return AppointmentSpan(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      column: column ?? this.column,
    );
    }
}

class BlockRect {
  final String id;
  final double top;      // px from day start
  final double height;   // px
  final int lane;        // 0..laneCount-1

  const BlockRect({
    required this.id,
    required this.top,
    required this.height,
    required this.lane,
  });
}

class LayoutResult {
  final List<BlockRect> rects;
  final int laneCount;
  const LayoutResult(this.rects, this.laneCount);
}

class ColumnLayoutResult {
  /// Per-column layout result. Key is the column identifier (e.g., technicianId).
  final Map<String, LayoutResult> byColumn;
  const ColumnLayoutResult(this.byColumn);

  /// Convenience aggregation if you need to iterate all rects regardless of column.
  Iterable<BlockRect> get allRects sync* {
    for (final lr in byColumn.values) {
      yield* lr.rects;
    }
  }
}

/// Minimal vertical size for event blocks so short events are still grabbable.
const double kMinBlockHeight = 16.0;

/// Returns midnight for the given day (00:00).
DateTime dayStartOf(DateTime day) => DateTime(day.year, day.month, day.day);

/// Returns midnight of the next day (exclusive end).
DateTime dayEndExclusiveOf(DateTime day) => dayStartOf(day).add(const Duration(days: 1));

/// Converts a timestamp to vertical Y position (px) from day start.
double yOf(DateTime t, DateTime day, double pixelsPerMinute) {
  final base = dayStartOf(day);
  final minutes = t.difference(base).inMinutes;
  return minutes * pixelsPerMinute;
}

/// Converts vertical Y (px) to a timestamp on `day`.
DateTime timeAt(double y, DateTime day, double pixelsPerMinute) {
  final base = dayStartOf(day);
  final minutes = (y / pixelsPerMinute).round();
  return base.add(Duration(minutes: minutes));
}

/// Core lane assignment and rect computation for a single column/day.
/// - Clips events to [day, day+1).
/// - Assigns non-overlapping events to the same lane.
/// - Returns positioned rects with lane indices.
LayoutResult computeBlocks({
  required List<AppointmentSpan> items,
  required DateTime day,
  required double pixelsPerMinute,
  double minBlockHeight = kMinBlockHeight,
}) {
  if (items.isEmpty) return const LayoutResult(<BlockRect>[], 0);

  final dayStart = dayStartOf(day);
  final dayEndEx = dayEndExclusiveOf(day);

  // 1) Clip spans to the day window and drop anything fully outside.
  final clipped = <AppointmentSpan>[];
  for (final it in items) {
    final s = it.start.isBefore(dayStart) ? dayStart : it.start;
    final e = it.end.isAfter(dayEndEx) ? dayEndEx : it.end;
    if (s.isBefore(e)) {
      clipped.add(AppointmentSpan(id: it.id, start: s, end: e, column: it.column));
    }
  }
  if (clipped.isEmpty) return const LayoutResult(<BlockRect>[], 0);

  // 2) Sort by start time, stable.
  clipped.sort((a, b) => a.start.compareTo(b.start));

  // 3) Greedy lane assignment.
  final lanes = <List<AppointmentSpan>>[]; // each lane holds non-overlapping items
  bool overlaps(AppointmentSpan a, AppointmentSpan b) =>
      a.start.isBefore(b.end) && b.start.isBefore(a.end);

  for (final item in clipped) {
    var placed = false;
    for (final lane in lanes) {
      final last = lane.isEmpty ? null : lane.last;
      if (last == null || !overlaps(item, last)) {
        lane.add(item);
        placed = true;
        break;
      }
    }
    if (!placed) {
      lanes.add([item]);
    }
  }

  // 4) Compute rects.
  final rects = <BlockRect>[];
  for (var laneIndex = 0; laneIndex < lanes.length; laneIndex++) {
    for (final it in lanes[laneIndex]) {
      final top = yOf(it.start, day, pixelsPerMinute);
      final height = (it.end.difference(it.start).inMinutes * pixelsPerMinute)
          .clamp(minBlockHeight, double.infinity);
      rects.add(BlockRect(id: it.id, top: top, height: height, lane: laneIndex));
    }
  }

  return LayoutResult(rects, lanes.length);
}

/// Multi-column variant: group items by `column` (e.g., technician),
/// then compute independent lane layouts for each column.
///
/// `columnOrder` lets you enforce a fixed order (e.g., visible techs).
/// If omitted, columns are derived from the data in ascending key order.
ColumnLayoutResult computeColumnBlocks({
  required List<AppointmentSpan> items,
  required DateTime day,
  required double pixelsPerMinute,
  List<String>? columnOrder,
  double minBlockHeight = kMinBlockHeight,
}) {
  if (items.isEmpty) return const ColumnLayoutResult(<String, LayoutResult>{});

  // 1) Group by column key (null/empty → use a default key).
  const String _defaultColumn = '_';
  final map = <String, List<AppointmentSpan>>{};
  for (final it in items) {
    final key = (it.column == null || it.column!.isEmpty) ? _defaultColumn : it.column!;
    (map[key] ??= <AppointmentSpan>[]).add(it);
  }

  // 2) Sort columns by explicit order or lexicographic key.
  final keys = columnOrder ??
      (map.keys.toList()..sort());

  // 3) Compute per-column blocks.
  final out = <String, LayoutResult>{};
  for (final key in keys) {
    final list = map[key] ?? const <AppointmentSpan>[];
    out[key] = computeBlocks(
      items: list,
      day: day,
      pixelsPerMinute: pixelsPerMinute,
      minBlockHeight: minBlockHeight,
    );
  }

  return ColumnLayoutResult(out);
}
