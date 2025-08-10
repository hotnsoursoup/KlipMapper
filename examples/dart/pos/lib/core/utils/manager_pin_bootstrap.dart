// lib/core/utils/manager_pin_bootstrap.dart
// Bootstrap service ensuring at least one manager has a PIN configured for secure operations. Handles initial PIN setup flow with manager selection dialog during application startup.
// Usage: ACTIVE - Called during app initialization to ensure security prerequisites are met before allowing privileged operations
import 'package:flutter/material.dart';
import '../auth/pin_auth_service.dart';
import '../auth/widgets/pin_management_dialog.dart';
import '../utils/logger.dart';
import '../../features/shared/data/repositories/drift_employee_repository.dart';
import '../../features/shared/data/models/employee_model.dart' as model;

/// Bootstrap service for ensuring at least one manager has a PIN set up
class ManagerPinBootstrap {
  static ManagerPinBootstrap? _instance;
  static ManagerPinBootstrap get instance => _instance ??= ManagerPinBootstrap._();
  
  ManagerPinBootstrap._();
  
  final PinAuthService _pinAuthService = PinAuthService.instance;
  final DriftEmployeeRepository _employeeRepository = DriftEmployeeRepository.instance;
  
  /// Silent check for manager PIN setup (no UI, just logging)
  Future<void> checkManagerPinSetupSilently() async {
    try {
      Logger.info('Performing silent manager PIN setup check');
      
      // Get all managers/admins
      final managers = await _getManagers();
      
      if (managers.isEmpty) {
        Logger.warning('No managers found in system');
        return;
      }
      
      // Check if any manager has a PIN set up
      bool anyManagerHasPin = false;
      for (final manager in managers) {
        if (await _pinAuthService.hasPin(manager.id)) {
          anyManagerHasPin = true;
          break;
        }
      }
      
      if (anyManagerHasPin) {
        Logger.info('Manager PIN security is properly configured');
      } else {
        Logger.warning('No managers have PINs configured - system security may be compromised');
      }
      
    } catch (e, stack) {
      Logger.error('Error during silent manager PIN check', e, stack);
    }
  }

  /// Check if initial manager PIN setup is needed and show setup dialog
  Future<bool> checkAndSetupInitialManagerPin(BuildContext context) async {
    try {
      Logger.info('Checking for initial manager PIN setup requirement');
      
      // Get all managers/admins
      final managers = await _getManagers();
      
      if (managers.isEmpty) {
        Logger.warning('No managers found - skipping PIN bootstrap');
        return false;
      }
      
      // Check if any manager has a PIN set up
      bool anyManagerHasPin = false;
      for (final manager in managers) {
        if (await _pinAuthService.hasPin(manager.id)) {
          anyManagerHasPin = true;
          break;
        }
      }
      
      if (anyManagerHasPin) {
        Logger.info('At least one manager has PIN - no bootstrap needed');
        return true;
      }
      
      // Show initial setup dialog
      Logger.info('No managers have PINs - showing initial setup dialog');
      if (!context.mounted) return false;
      return await _showInitialSetupDialog(context, managers);
      
    } catch (e, stack) {
      Logger.error('Error in manager PIN bootstrap', e, stack);
      return false;
    }
  }
  
  /// Get all manager-level employees
  Future<List<model.Employee>> _getManagers() async {
    try {
      final employees = await _employeeRepository.getEmployees();
      return employees.where((emp) => 
        _isManagerRole(emp.role) && emp.status == 'active',
      ).toList();
    } catch (e, stack) {
      Logger.error('Error getting managers for bootstrap', e, stack);
      return [];
    }
  }
  
  /// Check if role is manager-level
  bool _isManagerRole(String role) {
    final lowerRole = role.toLowerCase();
    return lowerRole == 'manager' || 
           lowerRole == 'admin' || 
           lowerRole == 'owner';
  }
  
  /// Show initial manager PIN setup dialog
  Future<bool> _showInitialSetupDialog(BuildContext context, List<model.Employee> managers) async {
    if (!context.mounted) return false;
    
    // Show selection dialog if multiple managers
    final selectedManager = managers.length == 1 
        ? managers.first 
        : await _showManagerSelectionDialog(context, managers);
    
    if (selectedManager == null || !context.mounted) {
      return false;
    }
    
    // Show setup dialog for selected manager
    return await _showManagerPinSetupDialog(context, selectedManager);
  }
  
  /// Show manager selection dialog
  Future<model.Employee?> _showManagerSelectionDialog(BuildContext context, List<model.Employee> managers) async {
    return showDialog<model.Employee>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ManagerSelectionDialog(managers: managers),
    );
  }
  
  /// Show PIN setup dialog for selected manager
  Future<bool> _showManagerPinSetupDialog(BuildContext context, model.Employee manager) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.setNew(
        employeeId: manager.id,
        employeeName: manager.fullName,
        onComplete: (success) {
          if (success) {
            Logger.info('Initial manager PIN setup completed for employee ${manager.id}');
          } else {
            Logger.warning('Initial manager PIN setup failed');
          }
        },
      ),
    ) ?? false;
  }
  
  /// Force setup dialog - useful for settings screen
  Future<bool> forceManagerPinSetup(BuildContext context) async {
    final managers = await _getManagers();
    if (managers.isEmpty) return false;
    
    if (!context.mounted) return false;
    return await _showInitialSetupDialog(context, managers);
  }
}

/// Manager selection dialog widget
class _ManagerSelectionDialog extends StatefulWidget {
  final List<model.Employee> managers;
  
  const _ManagerSelectionDialog({required this.managers});
  
  @override
  State<_ManagerSelectionDialog> createState() => _ManagerSelectionDialogState();
}

class _ManagerSelectionDialogState extends State<_ManagerSelectionDialog> {
  model.Employee? _selectedManager;
  
  @override
  void initState() {
    super.initState();
    _selectedManager = widget.managers.isNotEmpty ? widget.managers.first : null;
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initial Setup Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Select a manager to set up initial PIN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'At least one manager must have a PIN for secure operations. Select which manager should set up the initial PIN:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<model.Employee>(

                value: _selectedManager,
                isExpanded: true,
                onChanged: (model.Employee? value) {
                  setState(() {
                    _selectedManager = value;
                  });
                },
                items: widget.managers.map((model.Employee manager) {
                  return DropdownMenuItem<model.Employee>(
                    value: manager,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getRoleColor(manager.role).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              manager.fullName.length >= 2 ? manager.fullName.substring(0, 2).toUpperCase() : manager.fullName.toUpperCase(),
                              style: TextStyle(
                                color: _getRoleColor(manager.role),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manager.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                manager.role,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedManager != null 
              ? () => Navigator.of(context).pop(_selectedManager)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Continue'),
        ),
      ],
    );
  }
  
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
      case 'owner':
        return Colors.red;
      case 'manager':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}