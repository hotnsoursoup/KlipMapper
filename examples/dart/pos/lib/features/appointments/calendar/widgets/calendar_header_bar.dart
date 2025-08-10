// lib/features/appointments/calendar/widgets/calendar_header_bar.dart
// Header bar widget for calendar grid displaying technician names with pagination controls.
// Provides navigation between pages of technicians when there are too many to display at once.
// Usage: ACTIVE - Header component for appointment calendar grid layouts

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/employee_model.dart';

class CalendarHeaderBar extends StatelessWidget {
  const CalendarHeaderBar({
    super.key,
    required this.height,
    required this.timeColumnWidth,
    required this.technicians,
    required this.pageTechnicians,
    required this.currentPage,
    required this.techniciansPerPage,
    this.onPageChanged,
  });

  final double height;
  final double timeColumnWidth;
  final List<Employee> technicians;
  final List<Employee> pageTechnicians;
  final int currentPage;
  final int techniciansPerPage;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final totalPages = (technicians.length / techniciansPerPage).ceil();
    final canGoLeft = currentPage > 0;
    final canGoRight = currentPage < totalPages - 1;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            // Left pagination control
            Container(
              width: timeColumnWidth,
              padding: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                ),
              ),
              child: IconButton(
                onPressed: canGoLeft ? () => onPageChanged?.call(currentPage - 1) : null,
                icon: Icon(
                  Icons.chevron_left,
                  size: 28, 
                  color: canGoLeft 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ),
            
            // Technician headers
            Expanded(
              child: Row(
                children: pageTechnicians
                    .map((technician) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: AppColors.border.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                technician.fullName,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600, 
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            
            // Right pagination control
            Container(
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                ),
              ),
              child: IconButton(
                onPressed: canGoRight ? () => onPageChanged?.call(currentPage + 1) : null,
                icon: Icon(
                  Icons.chevron_right,
                  size: 28, 
                  color: canGoRight 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}