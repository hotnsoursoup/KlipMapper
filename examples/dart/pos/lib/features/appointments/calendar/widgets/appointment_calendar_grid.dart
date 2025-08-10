// lib/features/appointments/calendar/rendering/appointment_calendar_grid.dart
// Day view timeline with technician columns.
// UI unchanged: same paddings, widths, callbacks. Internals use shared layout + viewport.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/models/appointment_model.dart' as domain;
import '../../../shared/data/models/appointment_model.dart';
import '../../domain/adapters/calendar_appointment_adapter.dart'; // toCalendarAppointment(...)
// === Providers (adjust these imports to your actual paths) ===
import '../../domain/providers/appointment_providers.dart'
    show selectedDateProvider, selectedDateAppointmentsStreamProvider, appointmentRepositoryProvider;
import '../../domain/providers/appointment_vm_provider.dart';
import '../../domain/providers/calendar_layout_provider.dart';
import '../../domain/providers/calendar_viewport_state.dart';
// If you already have a technician order provider, import it instead and remove the fallback below.
import '../../domain/providers/technician_providers.dart' show technicianIdsForCalendarProvider;
import '../../presentation/widgets/appointment_block.dart' show AppointmentBlock;
// === Pure layout math ===
import '../rendering/calendar_layout.dart';

// === Optional global overlay (now line, selection band). If you don’t have this, comment it out. ===
class CalendarGlobalOverlay extends StatelessWidget {
  final DateTime day;
  final double pixelsPerMinute;
  const CalendarGlobalOverlay({super.key, required this.day, required this.pixelsPerMinute});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        ignoring: true,
        child: CustomPaint(
          painter: _GlobalOverlayPainter(day: day, ppm: pixelsPerMinute),
        ),
      ),
    );
  }
}

class _GlobalOverlayPainter extends CustomPainter {
  final DateTime day;
  final double ppm;
  _GlobalOverlayPainter({required this.day, required this.ppm});

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    if (now.year == day.year && now.month == day.month && now.day == day.day) {
      final minutes = now.difference(DateTime(day.year, day.month, day.day)).inMinutes;
      final y = minutes * ppm;
      final p = Paint()
        ..strokeWidth = 1
        ..color = const Color(0x66FF3B30);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GlobalOverlayPainter oldDelegate) => oldDelegate.day != day || oldDelegate.ppm != ppm;
}

// === Your existing block/tile widget ===
// Keep using your own AppointmentBlock.
// If the constructor differs, just map the vm fields 1:1.
class AppointmentBlock extends StatelessWidget {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String status;
  final String? technicianId;
  final VoidCallback? onTap;

  const AppointmentBlock({
    super.key,
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.status,
    this.technicianId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Replace with your real block. This is just a placeholder to keep this file self-contained.
    return Material(
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
                ' - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Public API stays the same ===
class AppointmentCalendarGrid extends ConsumerStatefulWidget {
  final int currentPage;
  final void Function(int page)? onPageChanged;
  final void Function(Appointment appointment) onAppointmentTap;
  final void Function({DateTime? selectedTime, String? selectedTechnicianId}) onTimeSlotTap;
  final Set<String> selectedServiceCategories;

  const AppointmentCalendarGrid({
    super.key,
    required this.currentPage,
    required this.onAppointmentTap,
    required this.onTimeSlotTap,
    this.onPageChanged,
    this.selectedServiceCategories = const <String>{},
  });

  @override
  ConsumerState<AppointmentCalendarGrid> createState() => _AppointmentCalendarGridState();
}

class _AppointmentCalendarGridState extends ConsumerState<AppointmentCalendarGrid> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  // Tweak these to match your existing layout
  static const double _columnWidth = 240.0; // total width per technician column
  static const double _tileWidth = 232.0; // inner tile width
  static const double _columnGap = 8.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      ref.read(calendarViewportStateProvider.notifier).setOffset(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Keep the viewport height in sync for visible range and layout memoization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render = context.findRenderObject();
      if (render is RenderBox) {
        ref.read(calendarViewportStateProvider.notifier).setExtent(render.size.height);
      }
    });

    final day = ref.watch(selectedDateProvider);
    final vp = ref.watch(calendarViewportStateProvider);

    // Appointments stream for the selected day (you already have this provider)
    final apptsAsync = ref.watch(selectedDateAppointmentsStreamProvider);

    return apptsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load: $e')),
      data: (appointments) {
        // Filter by selected categories (same UI; logic-only)
        final filtered = widget.selectedServiceCategories.isEmpty
            ? appointments
            : appointments
                  .where(
                    (a) => (a.services ?? const []).any((s) => widget.selectedServiceCategories.contains(s.categoryId)),
                  )
                  .toList();

        // Build spans with a column key per technician (assigned or requested).
        final spans = filtered
            .map(
              (a) => AppointmentSpan(
                id: a.id,
                start: a.scheduledStartTime,
                end: a.scheduledEndTime,
                column: a.assignedTechnicianId ?? a.requestedTechnicianId ?? '',
              ),
            )
            .toList(growable: false);

        // Technician order: prefer your provider; fallback to order derived from data.
        final techIds = ref
            .watch(technicianIdsForCalendarProvider)
            .maybeWhen(data: (ids) => ids, orElse: () => spans.map((s) => s.column ?? '').toSet().toList());

        // Page the technicians (UI unchanged — same currentPage usage)
        const int perPage = 4; // <- keep whatever your UI uses now
        final pageCount = (techIds.isEmpty) ? 1 : ((techIds.length + perPage - 1) ~/ perPage);
        final current = widget.currentPage.clamp(0, pageCount - 1);
        final pageTechIds = techIds.skip(current * perPage).take(perPage).toList();

        // Layout for the *visible* tech columns only
        final pageSpans = spans.where((s) => pageTechIds.contains(s.column ?? '')).toList();
        final layoutByCol = computeColumnBlocks(
          items: pageSpans,
          day: day,
          pixelsPerMinute: vp.pixelsPerMinute,
          columnOrder: pageTechIds,
        );

        // Column positions
        double leftForColumnIndex(int index) => index * (_columnWidth + _columnGap);

        // Total content width
        final contentWidth = pageTechIds.length * (_columnWidth + _columnGap) - _columnGap;

        return Stack(
          children: [
            // 1) Appointment tiles positioned in each column by (lane, rect.top/height)
            //    UI stays the same — we only feed position and the same props.
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // height controlled by ListView-like scroll; choose a tall box
                    // based on pixelsPerMinute (24 hours * 60 minutes * ppm)
                    minHeight: (24 * 60 * vp.pixelsPerMinute).ceilToDouble(),
                    minWidth: contentWidth,
                  ),
                  child: Stack(
                    children: [
                      // Appointment blocks
                      for (var colIndex = 0; colIndex < pageTechIds.length; colIndex++)
                        ..._buildColumnBlocks(
                          ref: ref,
                          rects: layoutByCol.byColumn[pageTechIds[colIndex]]?.rects ?? const <BlockRect>[],
                          columnLeft: leftForColumnIndex(colIndex),
                          onTap: widget.onAppointmentTap,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // 2) Global overlay (now line across all visible columns). Purely visual.
            Positioned.fill(
              child: CalendarGlobalOverlay(day: day, pixelsPerMinute: vp.pixelsPerMinute),
            ),

            // 3) Optional: page controls (if you already render them outside, remove this)
            if (pageCount > 1)
              Positioned(
                right: 12,
                top: 12,
                child: Row(
                  children: List.generate(pageCount, (i) {
                    final active = i == current;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: widget.onPageChanged == null ? null : () => widget.onPageChanged!(i),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active ? Colors.black87 : Colors.black26,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Widget> _buildColumnBlocks({
    required WidgetRef ref,
    required List<BlockRect> rects,
    required double columnLeft,
    required void Function(domain.Appointment appointment) onTap,
  }) {
    // Use the latest stream snapshot so tiles reflect live updates.
    final list = ref
        .watch(selectedDateAppointmentsStreamProvider)
        .maybeWhen(data: (a) => a, orElse: () => const <domain.Appointment>[]);

    return rects.map((r) {
      // lane → horizontal offset inside the column; keep your original lane width
      const double laneWidth = _tileWidth; // single lane per column; adjust if you split further
      final double left = columnLeft + (r.lane * laneWidth);

      // Resolve the domain appointment for this rect
      final a = list.firstWhere(
        (x) => x.id == r.id,
        orElse: () => domain.Appointment(
          id: r.id,
          customerId: 'unknown',
          appointmentDate: DateTime.now(),
          appointmentTime: '00:00',
          durationMinutes: 30,
          serviceIds: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Adapt domain → calendar UI model for your AppointmentBlock
      final cal = toCalendarAppointment(a);

      return Positioned(
        top: r.top,
        left: left,
        width: _tileWidth,
        height: r.height,
        child: RepaintBoundary(
          child: AppointmentBlock(
            id: cal.id,
            title: cal.customer.name,
            start: cal.startTime,
            end: cal.endTime,
            status: cal.status.toString(),
            technicianId: cal.technicianId,
            onTap: () async {
              // Optionally fetch a fully-populated record for the dialog
              final repo = ref.read(appointmentRepositoryProvider);
              await repo.initialize();
              final full = await repo.getAppointmentById(cal.id) ?? a;
              onTap(full); // hand off to the screen’s dialog handler
            },
            // Keep defaults; wire selection/drag later if you add that state
            isSelected: false,
            isDragging: false,
          ),
        ),
      );
    }).toList();
  }

  @override
  bool get wantKeepAlive => true;
}
