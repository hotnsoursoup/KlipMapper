// lib/features/dashboard/presentation/widgets/service_selection_widget.dart
// Service selection widget for ticket creation with category-organized service display. Features expandable categories, service search, pricing display, and multi-service selection for comprehensive ticket management.
// Usage: ACTIVE - Core component in check-in dialogs and ticket creation workflows

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/config/service_categories.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/models/technician_model.dart';
import '../../../shared/presentation/widgets/service_pill.dart';

/// Helper class to track service and technician assignment
class ServiceSelection {
  final Service service;
  Technician? technician;

  ServiceSelection({
    required this.service,
    this.technician,
  });
}

/// A comprehensive widget for selecting services and assigning technicians.
/// 
/// Features:
/// * Service browsing with category filtering
/// * Visual service pills with categories and pricing
/// * Technician assignment per service with filtering capabilities
/// * Auto-assignment option to use same technician across services
/// * Support for both individual and group member service selection
/// * Add/remove services with visual feedback
/// * Category-based organization with color coding
/// * Price display and duration information
/// 
/// Usage:
/// ```dart
/// ServiceSelectionWidget(
///   selectedServices: selectedServices,
///   availableServices: allServices,
///   availableTechnicians: technicians,
///   onServiceAdded: (service) => _addService(service),
///   onServiceRemoved: (service) => _removeService(service),
///   onTechnicianAssigned: (service, tech) => _assignTech(service, tech),
///   isPrimary: true, // Primary customer vs group member
/// )
/// ```
class ServiceSelectionWidget extends StatefulWidget {
  final List<ServiceSelection> selectedServices;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final Function(ServiceSelection) onServiceAdded;
  final Function(ServiceSelection) onServiceRemoved;
  final Function(ServiceSelection, Technician?) onTechnicianAssigned;
  final bool isPrimary;
  final String? memberName;

  const ServiceSelectionWidget({
    super.key,
    required this.selectedServices,
    required this.availableServices,
    required this.availableTechnicians,
    required this.onServiceAdded,
    required this.onServiceRemoved,
    required this.onTechnicianAssigned,
    this.isPrimary = false,
    this.memberName,
  });

  @override
  State<ServiceSelectionWidget> createState() => _ServiceSelectionWidgetState();
}

class _ServiceSelectionWidgetState extends State<ServiceSelectionWidget> {
  String? _selectedCategoryFilter; // Changed to string for category keys
  Technician? _firstAssignedTech; // Track the first technician assigned

  @override
  void initState() {
    super.initState();
    _updateFirstAssignedTech();
  }

  @override
  void didUpdateWidget(ServiceSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedServices != widget.selectedServices) {
      _updateFirstAssignedTech();
    }
  }

  void _updateFirstAssignedTech() {
    // Find the first technician that was assigned to any service
    for (var selection in widget.selectedServices) {
      if (selection.technician != null) {
        _firstAssignedTech = selection.technician;
        break;
      }
    }
  }

  List<Service> get _filteredServices {
    if (_selectedCategoryFilter == null) {
      return widget.availableServices;
    }
    
    return widget.availableServices.where((service) {
      if (service.categoryId == null) return _selectedCategoryFilter == 'other';
      
      // Map categoryId to category key
      final categoryKey = ServiceCategories.getCategory(service.categoryId.toString()).id;
      return categoryKey == _selectedCategoryFilter;
    }).toList();
  }

  Map<String, List<Service>> get _servicesByCategory {
    final Map<String, List<Service>> grouped = {};
    
    for (var service in widget.availableServices) {
      String categoryKey;
      if (service.categoryId == null) {
        categoryKey = 'other';
      } else {
        categoryKey = ServiceCategories.getCategory(service.categoryId.toString()).id;
      }
      
      grouped[categoryKey] ??= [];
      grouped[categoryKey]!.add(service);
    }
    
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected services display
        if (widget.selectedServices.isNotEmpty) ...[
          ...widget.selectedServices.map((selection) => 
            _buildServiceItem(selection),
          ),
          const SizedBox(height: 12),
        ],
        
        // Category filter pills
        _buildCategoryFilters(),
        const SizedBox(height: 16),
        
        // Service grid
        _buildServiceGrid(),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    final categoryGroups = _servicesByCategory;
    final categories = ServiceCategories.getAllCategories()
        .where((category) => categoryGroups.containsKey(category.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Category',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // All categories chip
            _buildCategoryChip(
              null,
              'All',
              AppColors.textSecondary,
              categoryGroups.values.fold(0, (sum, services) => sum + services.length),
            ),
            // Individual category chips
            ...categories.map((category) => _buildCategoryChip(
              category.id,
              category.displayName,
              category.color,
              categoryGroups[category.id]?.length ?? 0,
            ),),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String? categoryKey, String label, Color color, int count) {
    final isSelected = _selectedCategoryFilter == categoryKey;
    
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategoryFilter = selected ? categoryKey : null;
        });
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? color : color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      side: BorderSide(
        color: isSelected ? color : color.withValues(alpha: 0.3),
        width: isSelected ? 2 : 1,
      ),
    );
  }

  Widget _buildServiceGrid() {
    final services = _filteredServices;
    
    if (services.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(
            _selectedCategoryFilter == null 
                ? 'No services available'
                : 'No services in this category',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isSelected = widget.selectedServices.any((s) => s.service.id == service.id);
        
        return _buildServiceButton(service, isSelected);
      },
    );
  }

  Widget _buildServiceButton(Service service, bool isSelected) {
    return InkWell(
      onTap: isSelected ? null : () => _onServiceSelected(service),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.successGreen.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? AppColors.successGreen
                : AppColors.border.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.successGreen : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                ServicePill(
                  serviceName: ServiceCategories.getCategory(service.categoryId.toString() ?? 'other').displayName,
                  categoryId: service.categoryId,
                  isExtraSmall: true,
                ),
                const Spacer(),
                Text(
                  '\$${service.price.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onServiceSelected(Service service) async {
    // If this is the first service being selected, show technician selection
    if (widget.selectedServices.isEmpty || _firstAssignedTech == null) {
      await _showTechnicianSelection(service);
    } else {
      // Auto-assign to first technician if they can perform this service
      final canPerform = await _canTechnicianPerformService(_firstAssignedTech!, service);
      
      final selection = ServiceSelection(
        service: service,
        technician: canPerform ? _firstAssignedTech : null,
      );
      
      widget.onServiceAdded(selection);
      
      // If the first tech can't perform this, show selection dialog
      if (!canPerform) {
        await _showTechnicianSelection(service, selection);
      }
    }
  }

  Future<void> _showTechnicianSelection(Service service, [ServiceSelection? existingSelection]) async {
    // Get technicians who can perform this service, sorted by availability
    final compatibleTechs = await _getCompatibleTechnicians(service);
    
    if (!mounted) return;
    
    if (compatibleTechs.isEmpty) {
      // No one can perform this service
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No technicians available for ${service.name}'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    final selectedTech = await showDialog<Technician>(
      context: context,
      builder: (context) => _buildTechnicianSelectionDialog(service, compatibleTechs),
    );

    if (selectedTech != null) {
      ServiceSelection selection;
      
      if (existingSelection != null) {
        // Update existing selection
        existingSelection.technician = selectedTech;
        widget.onTechnicianAssigned(existingSelection, selectedTech);
        return;
      } else {
        // Create new selection
        selection = ServiceSelection(service: service, technician: selectedTech);
        widget.onServiceAdded(selection);
      }
      
      // If this is the first technician assignment, auto-assign them to compatible services
      if (_firstAssignedTech == null) {
        _firstAssignedTech = selectedTech;
        await _autoAssignCompatibleServices(selectedTech);
      }
    }
  }

  Future<List<Technician>> _getCompatibleTechnicians(Service service) async {
    // Get all available technicians sorted by availability
    final availableTechs = widget.availableTechnicians
        .where((tech) => tech.isAvailable)
        .toList();
    
    // Sort by availability (available first, then by turn number)
    availableTechs.sort((a, b) {
      if (a.canAcceptNewTicket && !b.canAcceptNewTicket) return -1;
      if (!a.canAcceptNewTicket && b.canAcceptNewTicket) return 1;
      return a.turnNumber.compareTo(b.turnNumber);
    });

    // In a full implementation, this would check service capabilities
    // For now, assume all available techs can do any service
    return availableTechs;
  }

  Future<bool> _canTechnicianPerformService(Technician tech, Service service) async {
    // Simplified capability check - in reality this would check the technician's capabilities
    // For now, return true for available technicians
    return tech.isAvailable;
  }

  Future<void> _autoAssignCompatibleServices(Technician tech) async {
    // Auto-assign the selected technician to any other unassigned services they can perform
    for (var selection in widget.selectedServices) {
      if (selection.technician == null) {
        final canPerform = await _canTechnicianPerformService(tech, selection.service);
        if (canPerform) {
          selection.technician = tech;
          widget.onTechnicianAssigned(selection, tech);
        }
      }
    }
  }

  Widget _buildTechnicianSelectionDialog(Service service, List<Technician> technicians) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Technician',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 8),
            Text(
              'for ${service.name}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            ...technicians.map((tech) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(tech.avatarColor.replaceFirst('#', '0xFF'))),
                  child: Text(
                    tech.avatarInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(tech.displayName),
                subtitle: Text(
                  tech.canAcceptNewTicket ? 'Available' : 'Busy (turn ${tech.turnNumber})',
                  style: TextStyle(
                    color: tech.canAcceptNewTicket ? AppColors.successGreen : AppColors.warningOrange,
                  ),
                ),
                trailing: tech.canAcceptNewTicket 
                    ? Icon(Icons.check_circle, color: AppColors.successGreen)
                    : Icon(Icons.schedule, color: AppColors.warningOrange),
                onTap: () => Navigator.of(context).pop(tech),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
                ),
              ),
            ),),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceSelection selection) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Service info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ServicePill(
                      serviceName: ServiceCategories.getCategory(selection.service.categoryId.toString() ?? 'other').displayName,
                      categoryId: selection.service.categoryId,
                      isExtraSmall: true,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selection.service.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${selection.service.price.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • ${selection.service.durationMinutes} min',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // Technician assignment
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (selection.technician != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(int.parse(selection.technician!.avatarColor.replaceFirst('#', '0xFF'))),
                        child: Text(
                          selection.technician!.avatarInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selection.technician!.displayName,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => _reassignTechnician(selection),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Reassign',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ] else ...[
                OutlinedButton(
                  onPressed: () => _reassignTechnician(selection),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warningOrange,
                    side: BorderSide(color: AppColors.warningOrange),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: Text(
                    'Assign Tech',
                    style: AppTextStyles.labelSmall,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: 8),
          
          // Remove service button
          IconButton(
            onPressed: () => widget.onServiceRemoved(selection),
            icon: const Icon(Icons.close, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              padding: const EdgeInsets.all(4),
              minimumSize: Size.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _reassignTechnician(ServiceSelection selection) async {
    await _showTechnicianSelection(selection.service, selection);
  }
}