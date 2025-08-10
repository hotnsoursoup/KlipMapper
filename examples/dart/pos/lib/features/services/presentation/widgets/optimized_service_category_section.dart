// lib/features/services/presentation/widgets/optimized_service_category_section.dart
// Performance-optimized service category section widget with RepaintBoundary isolation and strategic Observer placement. Efficiently displays service categories with minimal rebuilds.
// Usage: ACTIVE - Core services screen component for displaying service categories with optimized performance

import 'package:flutter/material.dart';
// MobX import removed - needs Riverpod conversion
import '../../../shared/domain/models/service_domain.dart';
import '../../../shared/domain/models/service_category_domain.dart';
import '../../data/service_category_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Optimized service category section that minimizes rebuilds
class OptimizedServiceCategorySection extends StatelessWidget {
  final ServiceCategoryDomain category;
  final ServiceCategoryStore store;
  final Function(ServiceDomain) onServiceTap;
  final Function(ServiceDomain) onServiceDelete;
  final VoidCallback onAddService;

  const OptimizedServiceCategorySection({
    super.key,
    required this.category,
    required this.store,
    required this.onServiceTap,
    required this.onServiceDelete,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _CategoryHeader(
              category: category,
              store: store,
              onAddService: onAddService,
            ),
            _CategoryContent(
              category: category,
              store: store,
              onServiceTap: onServiceTap,
              onServiceDelete: onServiceDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Separated header widget to isolate rebuilds
class _CategoryHeader extends StatelessWidget {
  final ServiceCategoryDomain category;
  final ServiceCategoryStore store;
  final VoidCallback onAddService;

  const _CategoryHeader({
    required this.category,
    required this.store,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = store.getCategoryColor(category.id);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => store.toggleCategoryExpanded(category.id),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              
              // Category name
              Expanded(
                child: Text(
                  category.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Service count - Observer only for this part
              Observer(
                builder: (_) {
                  final services = store.servicesByCategory[category.id] ?? [];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    constraints: const BoxConstraints(minWidth: 32),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      services.length > 99 ? '99+' : '${services.length}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              
              const SizedBox(width: 12),
              
              // Add service button
              _AddServiceButton(
                onPressed: onAddService,
                color: categoryColor,
              ),
              
              const SizedBox(width: 8),
              
              // Expansion indicator - Observer only for rotation
              Observer(
                builder: (_) {
                  final isExpanded = store.expandedCategories[category.id] ?? false;
                  return AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Const widget for add service button
class _AddServiceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const _AddServiceButton({
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.add,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Category content with expansion animation
class _CategoryContent extends StatelessWidget {
  final ServiceCategoryDomain category;
  final ServiceCategoryStore store;
  final Function(ServiceDomain) onServiceTap;
  final Function(ServiceDomain) onServiceDelete;

  const _CategoryContent({
    required this.category,
    required this.store,
    required this.onServiceTap,
    required this.onServiceDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final isExpanded = store.expandedCategories[category.id] ?? false;
        final services = store.filteredServices[category.id] ?? [];
        
        return AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildExpandedContent(services),
          crossFadeState: isExpanded 
            ? CrossFadeState.showSecond 
            : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  Widget _buildExpandedContent(List<ServiceDomain> services) {
    if (services.isEmpty) {
      return const _EmptyServicesWidget();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 16),
            color: AppColors.border.withValues(alpha: 0.1),
          ),
          
          // Service list with keys for efficient updates
          ...services.map((service) => OptimizedServiceItem(
            key: ValueKey(service.id),
            service: service,
            categoryColor: store.getCategoryColor(category.id),
            onTap: () => onServiceTap(service),
            onDelete: () => onServiceDelete(service),
          ),),
        ],
      ),
    );
  }
}

/// Const widget for empty state
class _EmptyServicesWidget extends StatelessWidget {
  const _EmptyServicesWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 16),
            color: AppColors.border.withValues(alpha: 0.1),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No services in this category yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Optimized service item with RepaintBoundary
class OptimizedServiceItem extends StatelessWidget {
  final ServiceDomain service;
  final Color categoryColor;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const OptimizedServiceItem({
    super.key,
    required this.service,
    required this.categoryColor,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              height: 100,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            
            // Service content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    
                    // Price and duration pills
                    _ServiceMetrics(
                      price: service.basePrice,
                      duration: service.durationMinutes,
                    ),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            _ServiceActions(
              onEdit: onTap,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Const widget for service metrics
class _ServiceMetrics extends StatelessWidget {
  final double price;
  final int duration;

  const _ServiceMetrics({
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.attach_money,
                size: 14,
                color: AppColors.successGreen,
              ),
              Text(
                price.toStringAsFixed(2),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '$duration min',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Const widget for service actions
class _ServiceActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceActions({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActionButton(
            onPressed: onEdit,
            icon: Icons.edit,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 8),
          _ActionButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            color: AppColors.errorRed,
          ),
        ],
      ),
    );
  }
}

/// Const widget for action buttons
class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}