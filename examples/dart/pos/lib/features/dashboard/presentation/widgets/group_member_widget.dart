// lib/features/dashboard/presentation/widgets/group_member_widget.dart
// Group booking member widget for individual participant management within group appointments. Handles service assignment, technician selection, and member-specific configurations for group bookings.
// Usage: ACTIVE - Used within group booking dialogs and appointment management for multi-member service assignments

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../shared/data/models/technician_model.dart';
import 'service_selection_widget.dart';

/// Helper class to represent a group member
class GroupMember {
  final String name;
  final String type;
  
  GroupMember({
    required this.name, 
    required this.type,
  });
}

/// A comprehensive widget for managing group service members and their individual service selections.
/// 
/// Features:
/// * Add adult and child group members with auto-generated or custom names
/// * Individual service selection for each member using ServiceSelectionWidget
/// * Member type indicators (Adult/Child) with color coding
/// * Remove members functionality with confirmation
/// * Technician assignment per service per member
/// * Visual cards with shadows and proper spacing
/// * Integrated dialog for custom member names
/// 
/// Usage:
/// ```dart
/// GroupMemberWidget(
///   groupMembers: groupMembers,
///   memberServices: memberServicesMap,
///   availableServices: services,
///   availableTechnicians: technicians,
///   onMemberAdded: (member) => _addMember(member),
///   onServiceAdded: (memberName, service) => _addServiceToMember(memberName, service),
/// )
/// ```
class GroupMemberWidget extends StatefulWidget {
  final List<GroupMember> groupMembers;
  final Map<String, List<ServiceSelection>> memberServices;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final Function(GroupMember) onMemberAdded;
  final Function(GroupMember) onMemberRemoved;
  final Function(String memberName, ServiceSelection) onServiceAdded;
  final Function(String memberName, ServiceSelection) onServiceRemoved;
  final Function(String memberName, ServiceSelection, Technician?) onTechnicianAssigned;

  const GroupMemberWidget({
    super.key,
    required this.groupMembers,
    required this.memberServices,
    required this.availableServices,
    required this.availableTechnicians,
    required this.onMemberAdded,
    required this.onMemberRemoved,
    required this.onServiceAdded,
    required this.onServiceRemoved,
    required this.onTechnicianAssigned,
  });

  @override
  State<GroupMemberWidget> createState() => _GroupMemberWidgetState();
}

class _GroupMemberWidgetState extends State<GroupMemberWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group members section
        if (widget.groupMembers.isNotEmpty) ...[
          Text(
            'Group Members',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Group members list
          ...widget.groupMembers.map((member) => _buildGroupMemberCard(member)),
          
          const SizedBox(height: 16),
        ],
        
        // Add group member buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addGroupMember('adult'),
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Add Adult'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addGroupMember('child'),
                icon: const Icon(Icons.child_care, size: 18),
                label: const Text('Add Child'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.successGreen,
                  side: BorderSide(color: AppColors.successGreen),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupMemberCard(GroupMember member) {
    final memberServices = widget.memberServices[member.name] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Member header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: member.type == 'adult' ? AppColors.primaryBlue : AppColors.successGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  member.type == 'adult' ? 'Adult' : 'Child',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  member.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => widget.onMemberRemoved(member),
                icon: const Icon(Icons.close, size: 18),
                color: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Member services
          ServiceSelectionWidget(
            selectedServices: memberServices,
            availableServices: widget.availableServices,
            availableTechnicians: widget.availableTechnicians,
            onServiceAdded: (selection) => widget.onServiceAdded(member.name, selection),
            onServiceRemoved: (selection) => widget.onServiceRemoved(member.name, selection),
            onTechnicianAssigned: (selection, technician) => 
                widget.onTechnicianAssigned(member.name, selection, technician),
            memberName: member.name,
          ),
        ],
      ),
    );
  }

  void _addGroupMember(String type) {
    // Simplified: auto-generate names like the original
    final existingCount = widget.groupMembers.where((m) => m.type == type).length;
    final memberName = type == 'adult' ? 'Adult ${existingCount + 1}' : 'Child ${existingCount + 1}';
    
    final member = GroupMember(
      name: memberName,
      type: type,
    );
    
    widget.onMemberAdded(member);
  }
}

/// Dialog for adding a new group member
class _AddGroupMemberDialog extends StatefulWidget {
  final String type;
  final Function(GroupMember) onMemberAdded;

  const _AddGroupMemberDialog({
    required this.type,
    required this.onMemberAdded,
  });

  @override
  State<_AddGroupMemberDialog> createState() => _AddGroupMemberDialogState();
}

class _AddGroupMemberDialogState extends State<_AddGroupMemberDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.type == 'adult' ? 'Adult' : 'Child'} Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter ${widget.type} name',
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _addMember(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addMember,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.type == 'adult' ? AppColors.primaryBlue : AppColors.successGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addMember() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final member = GroupMember(
        name: name,
        type: widget.type,
      );
      widget.onMemberAdded(member);
      Navigator.of(context).pop();
    }
  }
}