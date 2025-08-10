// lib/features/appointments/presentation/widgets/appointment_week_chart_view.dart
// Chart-based weekly appointment visualization with graphical representation of appointment density and patterns.
// Features statistical charts, appointment distribution analysis, and visual appointment flow insights.
// Usage: ACTIVE - Analytics view for appointment trends and scheduling patterns

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/providers/appointment_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../shared/data/models/appointment_model.dart';

/// Stacked bar chart view showing appointment density by time periods
/// Morning (7AM-12PM), Early Afternoon (12PM-4PM), Late Afternoon (4PM-10PM)
class AppointmentWeekChartView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final Function(Appointment) onAppointmentTap;
  final bool anchorToToday;

  const AppointmentWeekChartView({
    super.key,
    required this.selectedDate,
    required this.onAppointmentTap,
    this.anchorToToday = false,
  });

  @override
  ConsumerState<AppointmentWeekChartView> createState() => _AppointmentWeekChartViewState();
}

class _AppointmentWeekChartViewState extends ConsumerState<AppointmentWeekChartView> {
  static const double _barWidth = 60;
  static const double _barSpacing = 20;

  @override
  Widget build(BuildContext context) {
    // Week anchor
    final DateTime weekStart = widget.anchorToToday
        ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
        : _getWeekStart(widget.selectedDate);
    final weekAppointments = ref.watch(weekAppointmentsForCalendarStreamProvider(weekStart)).value ?? const <Appointment>[];

    // Calculate the 7 days of the week
    final weekDays = List.generate(7, (index) => weekStart.add(Duration(days: index)));

    // Calculate appointment data for each day
    final chartData = weekDays.map((day) => _calculateDayData(day, weekAppointments)).toList();
    final maxTotal = chartData.fold<int>(0, (max, data) {
      final total = data['total'] ?? 0;
      return total > max ? total : max;
    });

    return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Title
              Text(
                'Weekly Appointment Distribution',
                style: AppTextStyles.headline3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Appointments by time period: Morning, Early Afternoon, Late Afternoon',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Legend
              _buildLegend(),
              const SizedBox(height: 24),
              
              // Chart
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use 70% of available height for chart area
                    final maxBarHeight = constraints.maxHeight * 0.7;
                    
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: maxBarHeight + 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: weekDays.asMap().entries.map((entry) {
                            final index = entry.key;
                            final day = entry.value;
                            final data = chartData[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: _barSpacing / 2),
                              child: _buildDayBar(day, data, maxTotal, maxBarHeight),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Morning (7AM-12PM)', const Color(0xFF4CAF50)),
        const SizedBox(width: 24),
        _buildLegendItem('Early Afternoon (12PM-4PM)', const Color(0xFF2196F3)),
        const SizedBox(width: 24),
        _buildLegendItem('Late Afternoon (4PM-10PM)', const Color(0xFF9C27B0)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDayBar(DateTime day, Map<String, int> data, int maxTotal, double maxBarHeight) {
    final isToday = _isSameDay(day, DateTime.now());
    final storeHours = ref.read(storeHoursSettingProvider);
    final isStoreOpen = _isStoreOpenOnDay(day, storeHours);
    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdayName = weekdayNames[day.weekday - 1];
    
    final morning = data['morning'] ?? 0;
    final earlyAfternoon = data['earlyAfternoon'] ?? 0;
    final lateAfternoon = data['lateAfternoon'] ?? 0;
    final total = data['total'] ?? 0;

    // Calculate heights proportional to max total
    final barHeight = maxTotal > 0 ? (maxBarHeight * total / maxTotal) : 0.0;
    final morningHeight = maxTotal > 0 ? (barHeight * morning / (total > 0 ? total : 1)) : 0.0;
    final earlyAfternoonHeight = maxTotal > 0 ? (barHeight * earlyAfternoon / (total > 0 ? total : 1)) : 0.0;
    final lateAfternoonHeight = maxTotal > 0 ? (barHeight * lateAfternoon / (total > 0 ? total : 1)) : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Total count label
        Container(
          height: 24,
          child: total > 0 ? Text(
            '$total',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ) : const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        
        // Stacked bar
        Container(
          width: _barWidth,
          height: maxBarHeight,
          child: !isStoreOpen 
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _barWidth,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'CLOSED',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              )
            : total == 0
              ? Center(
                  child: Container(
                    width: _barWidth,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Late Afternoon (top)
                    if (lateAfternoonHeight > 0)
                      Container(
                        width: _barWidth,
                        height: lateAfternoonHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: lateAfternoonHeight > 20 ? Center(
                          child: Text(
                            '$lateAfternoon',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ) : const SizedBox.shrink(),
                      ),
                    // Early Afternoon (middle)
                    if (earlyAfternoonHeight > 0)
                      Container(
                        width: _barWidth,
                        height: earlyAfternoonHeight,
                        color: const Color(0xFF2196F3),
                        child: earlyAfternoonHeight > 20 ? Center(
                          child: Text(
                            '$earlyAfternoon',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ) : const SizedBox.shrink(),
                      ),
                    // Morning (bottom)
                    if (morningHeight > 0)
                      Container(
                        width: _barWidth,
                        height: morningHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(4),
                            bottomRight: const Radius.circular(4),
                            topLeft: earlyAfternoonHeight == 0 && lateAfternoonHeight == 0 ? const Radius.circular(4) : Radius.zero,
                            topRight: earlyAfternoonHeight == 0 && lateAfternoonHeight == 0 ? const Radius.circular(4) : Radius.zero,
                          ),
                        ),
                        child: morningHeight > 20 ? Center(
                          child: Text(
                            '$morning',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ) : const SizedBox.shrink(),
                      ),
                  ],
                ),
        ),
        
        const SizedBox(height: 12),
        
        // Day label
        Text(
          weekdayName,
          style: AppTextStyles.labelMedium.copyWith(
            color: isToday ? AppColors.primaryBlue : AppColors.textSecondary,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${day.month}/${day.day}',
          style: AppTextStyles.labelSmall.copyWith(
            color: isToday ? AppColors.primaryBlue : AppColors.textPrimary,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Map<String, int> _calculateDayData(DateTime day, List<Appointment> weekAppointments) {
    final dayAppointments = weekAppointments.where((appointment) {
      return _isSameDay(appointment.appointmentDate, day);
    }).toList();

    int morning = 0;     // 7AM-12PM
    int earlyAfternoon = 0; // 12PM-4PM  
    int lateAfternoon = 0;  // 4PM-10PM

    for (final appointment in dayAppointments) {
      final hour = appointment.appointmentDate.hour;
      
      if (hour >= 7 && hour < 12) {
        morning++;
      } else if (hour >= 12 && hour < 16) {
        earlyAfternoon++;
      } else if (hour >= 16 && hour < 22) {
        lateAfternoon++;
      }
    }

    return {
      'morning': morning,
      'earlyAfternoon': earlyAfternoon,
      'lateAfternoon': lateAfternoon,
      'total': morning + earlyAfternoon + lateAfternoon,
    };
  }

  /// Check if store is open on a specific day
  bool _isStoreOpenOnDay(DateTime day, StoreHours storeHours) {
    final dayName = _getDayName(day.weekday);
    final dayHours = storeHours.hours[dayName];
    return dayHours != null && dayHours.isOpen;
  }

  /// Get the start of the week (Monday) for a given date
  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysFromMonday));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getDayName(int weekday) {
    const List<String> dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return dayNames[weekday - 1];
  }
}
