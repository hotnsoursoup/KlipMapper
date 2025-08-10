// lib/features/appointments/presentation/widgets/appointment_icon_overlay.dart
// Overlay widget for displaying appointment icons on traffic graphs with technician row layout and service category filtering.
// Features scalable icons, appointment positioning, overlap detection, and interactive appointment selection.
// Usage: ACTIVE - Used in traffic analysis and appointment visualization charts

import 'package:flutter/material.dart';
import '../../data/models/traffic_data_point.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/service_categories.dart';

/// Widget that overlays appointment icons on the traffic graph
class AppointmentIconOverlay extends StatelessWidget {
  final DayTrafficData trafficData;
  final Size graphSize;
  final bool showTechnicianRows;
  final bool stackOverlapping;
  final Function(AppointmentSlot)? onAppointmentTap;
  final double iconSizeBase;
  final bool scaleByDuration;
  
  const AppointmentIconOverlay({
    super.key,
    required this.trafficData,
    required this.graphSize,
    this.showTechnicianRows = true,
    this.stackOverlapping = true,
    this.onAppointmentTap,
    this.iconSizeBase = 24.0,
    this.scaleByDuration = true,
  });
  
  @override
  Widget build(BuildContext context) {
    if (trafficData.dataPoints.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Group appointments by technician for row layout
    final appointmentsByTechnician = _groupAppointmentsByTechnician();
    
    if (showTechnicianRows) {
      return _buildTechnicianRowLayout(appointmentsByTechnician);
    } else {
      return _buildSimpleOverlay();
    }
  }
  
  Map<String, List<AppointmentSlot>> _groupAppointmentsByTechnician() {
    final Map<String, List<AppointmentSlot>> grouped = {};
    
    for (final dataPoint in trafficData.dataPoints) {
      for (final appointment in dataPoint.appointments) {
        final techId = appointment.technicianId;
        grouped.putIfAbsent(techId, () => []);
        
        // Check if this appointment is already in the list
        final exists = grouped[techId]!.any((apt) => apt.id == appointment.id);
        if (!exists) {
          grouped[techId]!.add(appointment);
        }
      }
    }
    
    return grouped;
  }
  
  Widget _buildTechnicianRowLayout(Map<String, List<AppointmentSlot>> appointmentsByTechnician) {
    final technicianIds = appointmentsByTechnician.keys.toList()..sort();
    final rowHeight = graphSize.height / (technicianIds.length + 1);
    
    return Stack(
      children: technicianIds.asMap().entries.map((entry) {
        final index = entry.key;
        final techId = entry.value;
        final appointments = appointmentsByTechnician[techId]!;
        
        return Positioned(
          top: rowHeight * index,
          left: 0,
          right: 0,
          height: rowHeight,
          child: _buildTechnicianRow(
            techId: techId,
            appointments: appointments,
            rowHeight: rowHeight,
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildTechnicianRow({
    required String techId,
    required List<AppointmentSlot> appointments,
    required double rowHeight,
  }) {
    // Get technician name from the appointment data itself
    // since we don't have LookupService with getTechnicianById
    final technicianName = appointments.isNotEmpty 
        ? appointments.first.technicianName 
        : 'Tech $techId';
    
    return Row(
      children: [
        // Technician label
        if (showTechnicianRows)
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                technicianName,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        
        // Appointments timeline
        Expanded(
          child: Stack(
            children: appointments.map((appointment) {
              return _buildAppointmentIcon(
                appointment: appointment,
                rowHeight: rowHeight,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAppointmentIcon({
    required AppointmentSlot appointment,
    required double rowHeight,
  }) {
    // Calculate position based on time
    final startMinutes = trafficData.businessStartTime.hour * 60 + 
                         trafficData.businessStartTime.minute;
    final endMinutes = trafficData.businessEndTime.hour * 60 + 
                       trafficData.businessEndTime.minute;
    final appointmentStartMinutes = appointment.startTime.hour * 60 + 
                                    appointment.startTime.minute;
    final appointmentEndMinutes = appointment.endTime.hour * 60 + 
                                  appointment.endTime.minute;
    
    final totalMinutes = endMinutes - startMinutes;
    final startProgress = (appointmentStartMinutes - startMinutes) / totalMinutes;
    final endProgress = (appointmentEndMinutes - startMinutes) / totalMinutes;
    final widthProgress = endProgress - startProgress;
    
    // Calculate icon size based on duration if enabled
    double iconSize = iconSizeBase;
    if (scaleByDuration) {
      final durationMinutes = appointmentEndMinutes - appointmentStartMinutes;
      iconSize = (iconSizeBase * (durationMinutes / 30)).clamp(16.0, 32.0);
    }
    
    // Get service category for icon
    final category = ServiceCategories.getCategory(appointment.categoryId);
    final icon = category.icon ?? Icons.circle;
    final color = category.color;
    
    return Positioned(
      left: startProgress * (graphSize.width - 60), // Account for label width
      width: widthProgress * (graphSize.width - 60),
      top: (rowHeight - iconSize) / 2,
      child: GestureDetector(
        onTap: () => onAppointmentTap?.call(appointment),
        child: Container(
          height: iconSize,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(3),
                  ),
                ),
                child: Icon(
                  icon,
                  size: iconSize * 0.6,
                  color: color,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    appointment.customerName,
                    style: TextStyle(
                      fontSize: 9,
                      color: color.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSimpleOverlay() {
    final allAppointments = <AppointmentSlot>[];
    
    for (final dataPoint in trafficData.dataPoints) {
      for (final appointment in dataPoint.appointments) {
        if (!allAppointments.any((apt) => apt.id == appointment.id)) {
          allAppointments.add(appointment);
        }
      }
    }
    
    return Stack(
      children: allAppointments.map((appointment) {
        return _buildSimpleAppointmentIcon(appointment);
      }).toList(),
    );
  }
  
  Widget _buildSimpleAppointmentIcon(AppointmentSlot appointment) {
    // Calculate position
    final startMinutes = trafficData.businessStartTime.hour * 60 + 
                         trafficData.businessStartTime.minute;
    final endMinutes = trafficData.businessEndTime.hour * 60 + 
                       trafficData.businessEndTime.minute;
    final appointmentMinutes = appointment.startTime.hour * 60 + 
                               appointment.startTime.minute;
    
    final progress = (appointmentMinutes - startMinutes) / (endMinutes - startMinutes);
    final xPosition = progress * graphSize.width;
    
    // Get service category for icon
    final category = ServiceCategories.getCategory(appointment.categoryId);
    final icon = category.icon ?? Icons.circle;
    final color = category.color;
    
    return Positioned(
      left: xPosition - iconSizeBase / 2,
      bottom: 20,
      child: GestureDetector(
        onTap: () => onAppointmentTap?.call(appointment),
        child: Container(
          width: iconSizeBase,
          height: iconSizeBase,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: iconSizeBase * 0.6,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying a legend of service categories
class ServiceCategoryLegend extends StatelessWidget {
  final bool horizontal;
  final double iconSize;
  
  const ServiceCategoryLegend({
    super.key,
    this.horizontal = true,
    this.iconSize = 16,
  });
  
  @override
  Widget build(BuildContext context) {
    final categories = ServiceCategories.getAllCategories();
    
    if (horizontal) {
      return Wrap(
        spacing: 16,
        runSpacing: 8,
        children: categories.map((category) {
          return _buildLegendItem(category);
        }).toList(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildLegendItem(category),
          );
        }).toList(),
      );
    }
  }
  
  Widget _buildLegendItem(ServiceCategoryConfig category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: category.color,
              width: 1,
            ),
          ),
          child: Icon(
            category.icon,
            size: iconSize * 0.7,
            color: category.color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          category.name,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

/// Widget for filtering appointments by technician or category
class AppointmentFilterChips extends StatelessWidget {
  final Set<String> selectedTechnicians;
  final Set<String> selectedCategories;
  final Function(String techId, bool selected)? onTechnicianToggle;
  final Function(String categoryId, bool selected)? onCategoryToggle;
  
  const AppointmentFilterChips({
    super.key,
    required this.selectedTechnicians,
    required this.selectedCategories,
    this.onTechnicianToggle,
    this.onCategoryToggle,
  });
  
  @override
  Widget build(BuildContext context) {
    // We don't have access to all technicians here, so we'll just show categories
    final categories = ServiceCategories.getAllCategories();
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        
        // Category chips
        ...categories.map((category) {
          final isSelected = selectedCategories.contains(category.id);
          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.icon,
                  size: 14,
                  color: isSelected ? category.color : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(category.name),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              onCategoryToggle?.call(category.id, selected);
            },
            selectedColor: category.color.withValues(alpha: 0.2),
            checkmarkColor: category.color,
            labelStyle: TextStyle(
              fontSize: 12,
              color: isSelected ? category.color : Colors.grey,
            ),
          );
        }),
      ],
    );
  }
}