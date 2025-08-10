// lib/features/shared/presentation/widgets/compact_services_display.dart
// Compact services display widget showing service pills in a space-efficient layout. Used for displaying selected services in tickets, appointments, and summary views.
// Usage: ACTIVE - Reusable component for service display across tickets, appointments, and dashboard components

import 'package:flutter/material.dart';
import '../../../shared/data/models/service_model.dart';
import 'service_pill.dart';
import 'service_category_icon.dart';

/// A space-efficient widget to display services
/// Shows 1-2 service pills, then icons for additional services
class CompactServicesDisplay extends StatelessWidget {
  final List<Service> services;
  final int maxPillsToShow;
  final bool useExtraSmallPills;

  const CompactServicesDisplay({
    super.key,
    required this.services,
    this.maxPillsToShow = 2,
    this.useExtraSmallPills = true,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    final pillsToShow = services.take(maxPillsToShow).toList();
    final iconsToShow = services.skip(maxPillsToShow).toList();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Show first few services as pills
        ...pillsToShow.map((service) => ServicePill(
          serviceName: service.name,
          categoryId: service.categoryId,
          isSmall: !useExtraSmallPills,
          isExtraSmall: useExtraSmallPills,
        ),),
        
        // Show remaining services as compact icons
        ...iconsToShow.map((service) => ServiceCategoryIcon(
          categoryId: service.categoryId,
          serviceName: service.name,
          size: 22,
        ),),
      ],
    );
  }
}

/// Alternative ultra-compact version that shows all services as icons
class UltraCompactServicesDisplay extends StatelessWidget {
  final List<Service> services;
  final double iconSize;

  const UltraCompactServicesDisplay({
    super.key,
    required this.services,
    this.iconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: services.map((service) => ServiceCategoryIcon(
        categoryId: service.categoryId,
        serviceName: service.name,
        size: iconSize,
      ),).toList(),
    );
  }
}