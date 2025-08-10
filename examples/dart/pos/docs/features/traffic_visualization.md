# Traffic Visualization Documentation

## Overview
The Today's Schedule widget provides a visual representation of appointment traffic throughout the business day, helping staff identify peak hours and manage resources effectively.

## Architecture

### Core Components

#### 1. TrafficDataPoint Model (`/lib/features/appointments/data/models/traffic_data_point.dart`)
- **Purpose**: Data structure for representing appointment density at specific time intervals
- **Key Properties**:
  - `time`: DateTime for the time slot
  - `appointmentCount`: Number of appointments in this slot
  - `density`: Normalized value (0.0-1.0) for visualization
  - `categoryCounts`: Breakdown by service category
  - `appointments`: List of AppointmentSlot objects

#### 2. AppointmentTrafficCalculator (`/lib/features/appointments/services/appointment_traffic_calculator.dart`)
- **Purpose**: Service for calculating traffic data from appointments
- **Key Features**:
  - 15-minute interval bucketing
  - Overlapping appointment detection
  - Peak hour identification
  - Walk-in traffic estimation
  - Business hours boundary detection

#### 3. TrafficGraph Widget (`/lib/features/appointments/presentation/widgets/traffic_graph.dart`)
- **Purpose**: Visual component for rendering the traffic graph
- **Key Features**:
  - CustomPainter for smooth curved lines
  - Bezier curve smoothing
  - Gradient fill under curves
  - Interactive tooltips
  - Current time indicator
  - Responsive sizing

#### 4. TodaysScheduleWidget (`/lib/features/dashboard/presentation/widgets/todays_schedule_widget.dart`)
- **Purpose**: Dashboard widget integrating traffic visualization
- **Key Features**:
  - Real-time updates from AppointmentsStore
  - Expand/collapse animations
  - Quick statistics display
  - Peak hours information
  - Empty and loading states

## Usage Example

```dart
// Basic usage in dashboard
const TodaysScheduleWidget()

// Advanced usage with custom configuration
TrafficGraph(
  trafficData: calculatedTrafficData,
  isExpanded: true,
  height: 300,
  showCurrentTimeIndicator: true,
  showCategoryIcons: true,
  animateDataChanges: true,
  onDataPointTap: (point, position) {
    // Handle tap on data point
    showAppointmentDetails(point);
  },
)
```

## Traffic Calculation Algorithm

### 15-Minute Interval Bucketing
The system divides the business day into 15-minute intervals and calculates appointment density for each:

1. Generate time slots from business start to end
2. For each slot, find overlapping appointments
3. Count appointments and categorize by service type
4. Normalize density values based on peak count

### Overlapping Detection
```dart
bool _timesOverlap(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
  return start1.isBefore(end2) && start2.isBefore(end1);
}
```

### Walk-in Estimation
Based on historical patterns, the system can estimate walk-in traffic:
- 11 AM - 15% increase
- 12 PM - 20% increase
- 1 PM - 25% increase (peak lunch hour)
- 2 PM - 20% increase
- 3 PM - 15% increase
- 5-6 PM - 10-15% increase (after work)

## Performance Optimizations

### Following UI Bible Principles

1. **RepaintBoundary Usage**
   - Main graph wrapped in RepaintBoundary
   - Isolates repaints to graph area only
   - Prevents unnecessary parent widget rebuilds

2. **Strategic Observer Placement (MobX)**
   - Only wrap dynamic data in Observer
   - Static UI elements remain const
   - Minimal rebuild scope

3. **Const Constructors**
   - All static widgets use const constructors
   - Reduces widget tree rebuilding
   - Improves performance

4. **AnimatedBuilder for Animations**
   - Isolates animation rebuilds
   - Only rebuilds animated elements
   - Smooth 60fps animations

## Customization Options

### Graph Appearance
- `height`: Base height of the graph (doubles when expanded)
- `padding`: Padding around the graph content
- `iconSizeBase`: Base size for appointment icons
- `scaleByDuration`: Scale icons based on appointment duration

### Data Display
- `showCurrentTimeIndicator`: Display vertical line at current time
- `showCategoryIcons`: Show service category icons on appointments
- `animateDataChanges`: Animate transitions when data updates
- `showTechnicianRows`: Organize appointments by technician

### Interactivity
- `onDataPointTap`: Callback for handling taps on data points
- Automatic tooltips on hover/tap
- Expand/collapse for detailed view

## Testing

### Unit Tests
Located in `/test/features/appointments/services/appointment_traffic_calculator_test.dart`

Test coverage includes:
- Time slot generation
- Appointment counting and density calculation
- Overlapping appointment handling
- Peak hour detection
- Walk-in estimation
- Edge cases (midnight appointments, zero duration, etc.)

### Integration Points

The traffic visualization integrates with:
- **AppointmentsStore**: Real-time appointment data
- **SettingsManager**: Business hours configuration
- **ServiceCategories**: Category colors and icons
- **LookupService**: Technician information

## Best Practices

1. **Always use RepaintBoundary** for the main graph container
2. **Minimize Observer scope** - only wrap data that changes
3. **Use const constructors** wherever possible
4. **Precompute traffic data** - don't calculate in build methods
5. **Cache calculations** when appointments haven't changed
6. **Test with large datasets** to ensure smooth performance

## Future Enhancements

Potential improvements for future iterations:
- Historical traffic comparison
- Predictive traffic based on booking patterns
- Resource allocation suggestions
- Heat map visualization option
- Export traffic reports
- Multi-day traffic comparison
- Seasonal pattern recognition

## Troubleshooting

### Common Issues

1. **Janky animations**
   - Check for missing RepaintBoundary
   - Verify const constructors are used
   - Profile with Flutter DevTools

2. **Incorrect traffic calculation**
   - Verify appointment date/time parsing
   - Check timezone handling
   - Confirm business hours configuration

3. **Missing appointments**
   - Check appointment status filters
   - Verify date range selection
   - Confirm store data is loaded

### Debug Mode

Enable debug visualization:
```dart
// In TrafficGraph widget
if (kDebugMode) {
  print('Traffic data points: ${trafficData.dataPoints.length}');
  print('Peak count: ${trafficData.peakAppointmentCount}');
}
```

## Related Documentation

- [Appointments Store Documentation](./appointments_store.md)
- [Dashboard Architecture](./dashboard_architecture.md)
- [Performance Guidelines](../performance/ui_optimization.md)
- [MobX State Management](../state_management/mobx_patterns.md)