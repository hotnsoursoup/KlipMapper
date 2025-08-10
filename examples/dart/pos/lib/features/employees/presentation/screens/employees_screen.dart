// lib/features/employees/presentation/screens/employees_screen.dart
// Riverpod v3-compliant full rebuild of EmployeesScreen with full feature parity

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/privileged_operations.dart';
import '../../../shared/data/models/employee_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../providers/employees_provider.dart';
import '../../widgets/employee_grid_card.dart';
import '../../widgets/employee_details_dialog.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(employeeRoleFilterProvider);
    final status = ref.watch(employeeStatusFilterProvider);
    final search = ref.watch(employeeSearchQueryProvider);

    final filteredEmployees = ref.watch(
      employeesByFilterProvider(
        EmployeeFilter(
          role: role != 'All' ? role : null,
          status: status != 'All' ? status : null,
          search: search.isNotEmpty ? search : null,
        ),
      ),
    );

    final stats = ref.watch(employeeStatisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: StandardAppHeader.withAddAction(
        title: 'Employees',
        addButtonLabel: 'Add Employee',
        onAdd: () => _showAddEmployeeDialog(context, ref),
        showSearch: true,
        onSearchChanged: (q) =>
            ref.read(employeeSearchQueryProvider.notifier).setQuery(q),
        onSearchClear: () =>
            ref.read(employeeSearchQueryProvider.notifier).setQuery(''),
        searchValue: search,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStatCard(
                  'Total',
                  stats.totalCount,
                  Icons.people,
                  AppColors.primaryBlue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Active',
                  stats.activeCount,
                  Icons.check_circle,
                  AppColors.successGreen,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Technicians',
                  stats.technicianCount,
                  Icons.handyman,
                  AppColors.servicePurple,
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: filteredEmployees.isEmpty
                ? Center(child: Text('No employees found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.2,
                        ),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return EmployeeGridCard(
                        employee: employee,
                        onEdit: () =>
                            _showEditEmployeeDialog(context, ref, employee),
                        onDelete: () =>
                            _confirmDeleteEmployee(context, ref, employee),
                        onToggleActive: () =>
                            _toggleEmployeeStatus(ref, employee),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => EmployeeDetailsDialog(
        onSave: (employee) async {
          await ref
              .read(employeesMasterProvider.notifier)
              .addEmployee(employee);
        },
      ),
    );
  }

  void _showEditEmployeeDialog(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
  ) async {
    final authorized = await PrivilegedOperations.requestAuthorization(
      context: context,
      operation: PrivilegedOperation.editEmployeeData,
      currentEmployeeId: 0,
    );

    if (!authorized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Manager authorization required.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => EmployeeDetailsDialog(
        employee: employee,
        onSave: (updated) async {
          await ref
              .read(employeesMasterProvider.notifier)
              .updateEmployee(updated);
        },
      ),
    );
  }

  void _confirmDeleteEmployee(
    BuildContext context,
    WidgetRef ref,
    Employee e,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${e.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(employeesMasterProvider.notifier).deleteEmployee(e.id);
    }
  }

  Future<void> _toggleEmployeeStatus(WidgetRef ref, Employee e) async {
    final newStatus = e.status == 'active' ? 'inactive' : 'active';
    await ref
        .read(employeesMasterProvider.notifier)
        .updateEmployee(e.copyWith(status: newStatus));
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: AppTextStyles.headline3),
              Text(label, style: AppTextStyles.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/utils/privileged_operations.dart';
// import '../../../shared/data/models/employee_model.dart';
// import '../../../shared/presentation/widgets/standard_app_header.dart';
// import '../../providers/employees_provider.dart';
// import '../widgets/employee_details_dialog.dart';
// import '../widgets/employee_grid_card.dart';

// class EmployeesScreen extends ConsumerStatefulWidget {
//   const EmployeesScreen({super.key});

//   @override
//   ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
// }

// class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
//   final _searchController = TextEditingController();
//   String _selectedRole = 'All';
//   String _selectedStatus = 'Active';

//   // Clock-in order data
//   // TODO: Implement clock-in order with Riverpod
//   Timer? _refreshTimer;

//   @override
//   void initState() {
//     super.initState();
//     // TODO: Initialize providers
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _refreshTimer?.cancel();
//     super.dispose();
//   }

//   /// Load employee statuses in batch using the centralized store
//   Future<void> _loadEmployeeStatuses() async {
//     final employees = _store.employees;
//     if (employees.isNotEmpty) {
//       await _employeeStatusStore.loadAllEmployeeStatuses(employees);
//     }
//   }

//   /// Load today's clock-in order
//   Future<void> _loadClockInOrder() async {
//     try {
//       final clockInOrder = await _clockInOrderService.getTodayClockInOrder();
//       if (mounted) {
//         setState(() {
//           _clockInOrder = clockInOrder;
//           _isLoadingClockInOrder = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingClockInOrder = false;
//         });
//       }
//     }
//   }

//   void _showAddEmployeeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => EmployeeDetailsDialog(
//         onSave: (employee) async {
//           await _store.addEmployee(employee);
//           // Refresh employee statuses after adding
//           await _loadEmployeeStatuses();
//         },
//       ),
//     );
//   }

//   void _showEditEmployeeDialog(Employee employee) async {
//     // Require manager PIN authorization for editing employee details
//     final authorized = await PrivilegedOperations.requestAuthorization(
//       context: context,
//       operation: PrivilegedOperation.editEmployeeData,
//       currentEmployeeId: 0, // No specific employee context
//     );

//     if (!authorized) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Manager authorization required to edit employee details'),
//             backgroundColor: AppColors.errorRed,
//           ),
//         );
//       }
//       return;
//     }

//     if (!mounted) return;

//     showDialog(
//       context: context,
//       builder: (context) => EmployeeDetailsDialog(
//         employee: employee,
//         onSave: (updatedEmployee) async {
//           await _store.updateEmployee(updatedEmployee);
//           // Refresh employee statuses after updating
//           await _loadEmployeeStatuses();
//         },
//       ),
//     );
//   }

//   List<Employee> _filterEmployees(List<Employee> employees) {
//     var filtered = employees;

//     // Filter by role
//     if (_selectedRole != 'All') {
//       filtered = filtered
//           .where((e) => e.role.toLowerCase() == _selectedRole.toLowerCase())
//           .toList();
//     }

//     // Filter by status
//     if (_selectedStatus != 'All') {
//       if (_selectedStatus == 'Active') {
//         filtered = filtered.where((e) => e.status == 'active').toList();
//       } else {
//         filtered = filtered.where((e) => e.status != 'active').toList();
//       }
//     }

//     // Filter by search
//     final query = _searchController.text.toLowerCase();
//     if (query.isNotEmpty) {
//       filtered = filtered
//           .where(
//             (e) =>
//                 e.fullName.toLowerCase().contains(query) ||
//                 e.email.toLowerCase().contains(query) ||
//                 e.role.toLowerCase().contains(query),
//           )
//           .toList();
//     }

//     return filtered;
//   }

//   /// Confirm and delete an employee
//   Future<void> _confirmDeleteEmployee(Employee employee) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Employee'),
//         content: Text('Are you sure you want to delete ${employee.fullName}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _store.deleteEmployee(employee.id);
//     }
//   }

//   /// Build the clock-in order column
//   Widget _buildClockInOrderColumn() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryBlue.withValues(alpha: 0.05),
//                   AppColors.primaryBlue.withValues(alpha: 0.02),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppColors.border.withValues(alpha: 0.2),
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.access_time,
//                   size: 18,
//                   color: AppColors.primaryBlue,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Clock-In Order',
//                     style: AppTextStyles.labelLarge.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Today',
//                   style: AppTextStyles.labelSmall.copyWith(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Clock-in list
//           Expanded(
//             child: _isLoadingClockInOrder
//                 ? const Center(child: CircularProgressIndicator())
//                 : _clockInOrder.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.schedule_outlined,
//                               size: 48,
//                               color: AppColors.textSecondary.withValues(alpha: 0.5),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               'No clock-ins today',
//                               style: AppTextStyles.bodyMedium.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.separated(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: _clockInOrder.length,
//                         separatorBuilder: (context, index) => const SizedBox(height: 8),
//                         itemBuilder: (context, index) {
//                           final entry = _clockInOrder[index];
//                           return _buildClockInEntry(entry, index + 1);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build a clock-in entry widget
//   Widget _buildClockInEntry(ClockInOrderEntry entry, int position) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.background.withValues(alpha: 0.3),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: AppColors.border.withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Position badge
//           Container(
//             width: 24,
//             height: 24,
//             decoration: BoxDecoration(
//               color: AppColors.primaryBlue,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Text(
//                 position.toString(),
//                 style: AppTextStyles.labelSmall.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Employee info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   entry.employee.fullName,
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   entry.formattedTime,
//                   style: AppTextStyles.labelSmall.copyWith(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Status indicator
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: AppColors.successGreen,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: StandardAppHeader.withAddAction(
//         title: 'Employees',
//         addButtonLabel: 'Add Employee',
//         onAdd: _showAddEmployeeDialog,
//         showSearch: true,
//         onSearchChanged: (query) {
//           _searchController.text = query;
//           setState(() {}); // Refresh UI with new search
//         },
//         onSearchClear: () {
//           _searchController.clear();
//           setState(() {}); // Refresh UI with cleared search
//         },
//         searchHint: 'Search employees...',
//         searchValue: _searchController.text,
//       ),
//       body: Column(
//         children: [
//           // Statistics section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Observer(
//               builder: (_) {
//                 final employees = _store.employees;
//                 final activeCount = employees
//                     .where((e) => e.status == 'active')
//                     .length;

//                 // Count clocked in employees using the status store
//                 final clockedInCount = employees
//                     .where((e) => _employeeStatusStore.isEmployeeClockedIn(e.id))
//                     .length;

//                 final technicianCount = employees
//                     .where(
//                         (e) => e.role.toLowerCase() == 'technician',)
//                     .length;

//                 return Row(
//                   children: [
//                     _buildStatCard(
//                         'Total Employees',
//                         employees.length.toString(),
//                         Icons.people,
//                         AppColors.primaryBlue,),
//                     const SizedBox(width: 12),
//                     _buildStatCard('Active', activeCount.toString(),
//                         Icons.check_circle, AppColors.successGreen,),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                         'Clocked In',
//                         clockedInCount.toString(),
//                         Icons.access_time,
//                         AppColors.warningOrange,),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                         'Technicians',
//                         technicianCount.toString(),
//                         Icons.handyman,
//                         AppColors.servicePurple,),
//                     const Spacer(),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // Filters section with better positioning and descriptive labels
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryBlue.withValues(alpha: 0.02),
//                   AppColors.primaryBlue.withValues(alpha: 0.05),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppColors.border.withValues(alpha: 0.1),
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Filter header
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.filter_list,
//                       size: 18,
//                       color: AppColors.primaryBlue,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Filter Employees',
//                       style: AppTextStyles.labelLarge.copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Filters row
//                 Row(
//                   children: [
//                     // Role filter with label
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Role:',
//                           style: AppTextStyles.labelMedium.copyWith(
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: AppColors.primaryBlue.withValues(alpha: 0.2),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.05),
//                                 blurRadius: 2,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedRole == 'All' ? 'All Roles' : _selectedRole,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedRole = value == 'All Roles' ? 'All' : value!;
//                               });
//                             },
//                             underline: const SizedBox.shrink(),
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontSize: 15,
//                             ),
//                             items: [
//                               'All Roles',
//                               'Admin',
//                               'Manager',
//                               'Technician',
//                               'Receptionist',
//                               'Staff',
//                             ]
//                                 .map(
//                                   (role) => DropdownMenuItem(
//                                     value: role,
//                                     child: Text(
//                                       role,
//                                       style: AppTextStyles.bodyMedium.copyWith(
//                                         color: AppColors.textPrimary,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(width: 24),

//                     // Status filter with label
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Status:',
//                           style: AppTextStyles.labelMedium.copyWith(
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: AppColors.primaryBlue.withValues(alpha: 0.2),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.05),
//                                 blurRadius: 2,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedStatus == 'All' ? 'All Statuses' : _selectedStatus,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedStatus = value == 'All Statuses' ? 'All' : value!;
//                               });
//                             },
//                             underline: const SizedBox.shrink(),
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontSize: 15,
//                             ),
//                             items: ['All Statuses', 'Active', 'Inactive']
//                                 .map(
//                                   (status) => DropdownMenuItem(
//                                     value: status,
//                                     child: Text(
//                                       status,
//                                       style: AppTextStyles.bodyMedium.copyWith(
//                                         color: AppColors.textPrimary,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Main content: Employee grid + Clock-in order column
//           Expanded(
//             child: Container(
//               color: AppColors.background.withValues(alpha: 0.3),
//               child: Row(
//                 children: [
//                   // Employee grid (left side)
//                   Expanded(
//                     flex: 3,
//                     child: Observer(
//                       builder: (_) {
//                         if (_store.isLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         final filteredEmployees = _filterEmployees(_store.employees);

//                         if (filteredEmployees.isEmpty) {
//                           return Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.people_outline,
//                                   size: 64,
//                                   color:
//                                       AppColors.textSecondary.withValues(alpha: 0.5),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   _searchController.text.isNotEmpty
//                                       ? 'No employees found matching your search'
//                                       : 'No employees found',
//                                   style: AppTextStyles.bodyLarge.copyWith(
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Add your first employee to get started',
//                                   style: AppTextStyles.bodyMedium.copyWith(
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 ElevatedButton.icon(
//                                   onPressed: _showAddEmployeeDialog,
//                                   icon: const Icon(Icons.add),
//                                   label: const Text('Add Employee'),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primaryBlue,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 24, vertical: 12,),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }

//                         return LayoutBuilder(
//                           builder: (context, constraints) {
//                             // Calculate grid columns based on available width (smaller cards)
//                             final crossAxisCount = constraints.maxWidth > 1000
//                                 ? 4
//                                 : constraints.maxWidth > 700
//                                     ? 3
//                                     : constraints.maxWidth > 500
//                                         ? 2
//                                         : 1;

//                             return GridView.builder(
//                               padding: const EdgeInsets.all(20),
//                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: crossAxisCount,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio: 2.2, // Smaller, more compact cards
//                               ),
//                               itemCount: filteredEmployees.length,
//                               itemBuilder: (context, index) {
//                                 final employee = filteredEmployees[index];
//                                 return Provider.value(
//                                   value: _employeeStatusStore,
//                                   child: EmployeeGridCard(
//                                     employee: employee,
//                                     onEdit: () => _showEditEmployeeDialog(employee),
//                                     onToggleActive: () async {
//                                       final newStatus = employee.status == 'active'
//                                           ? 'inactive'
//                                           : 'active';
//                                       final updatedEmployee =
//                                           employee.copyWith(status: newStatus);
//                                       await _store.updateEmployee(updatedEmployee);
//                                     },
//                                     onDelete: () => _confirmDeleteEmployee(employee),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),

//                   // Divider
//                   Container(
//                     width: 1,
//                     color: AppColors.border.withValues(alpha: 0.3),
//                   ),

//                   // Clock-in order column (right side)
//                   Expanded(
//                     child: _buildClockInOrderColumn(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build stat card for statistics display
//   Widget _buildStatCard(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color.withValues(alpha: 0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 18,
//               color: color,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: AppTextStyles.headline3.copyWith(
//                   color: AppColors.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 label,
//                 style: AppTextStyles.labelSmall.copyWith(
//                   color: AppColors.textSecondary,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/utils/privileged_operations.dart';
// import '../../../shared/data/models/employee_model.dart';
// import '../../../shared/presentation/widgets/standard_app_header.dart';
// import '../../providers/employees_provider.dart';
// import '../widgets/employee_details_dialog.dart';
// import '../widgets/employee_grid_card.dart';

// class EmployeesScreen extends ConsumerStatefulWidget {
//   const EmployeesScreen({super.key});

//   @override
//   ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
// }

// class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
//   final _searchController = TextEditingController();
//   String _selectedRole = 'All';
//   String _selectedStatus = 'Active';

//   // Clock-in order data
//   // TODO: Implement clock-in order with Riverpod
//   Timer? _refreshTimer;

//   @override
//   void initState() {
//     super.initState();
//     // TODO: Initialize providers
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _refreshTimer?.cancel();
//     super.dispose();
//   }

//   /// Load employee statuses in batch using the centralized store
//   Future<void> _loadEmployeeStatuses() async {
//     final employees = _store.employees;
//     if (employees.isNotEmpty) {
//       await _employeeStatusStore.loadAllEmployeeStatuses(employees);
//     }
//   }

//   /// Load today's clock-in order
//   Future<void> _loadClockInOrder() async {
//     try {
//       final clockInOrder = await _clockInOrderService.getTodayClockInOrder();
//       if (mounted) {
//         setState(() {
//           _clockInOrder = clockInOrder;
//           _isLoadingClockInOrder = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoadingClockInOrder = false;
//         });
//       }
//     }
//   }

//   void _showAddEmployeeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => EmployeeDetailsDialog(
//         onSave: (employee) async {
//           await _store.addEmployee(employee);
//           // Refresh employee statuses after adding
//           await _loadEmployeeStatuses();
//         },
//       ),
//     );
//   }

//   void _showEditEmployeeDialog(Employee employee) async {
//     // Require manager PIN authorization for editing employee details
//     final authorized = await PrivilegedOperations.requestAuthorization(
//       context: context,
//       operation: PrivilegedOperation.editEmployeeData,
//       currentEmployeeId: 0, // No specific employee context
//     );

//     if (!authorized) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content:
//                 Text('Manager authorization required to edit employee details'),
//             backgroundColor: AppColors.errorRed,
//           ),
//         );
//       }
//       return;
//     }

//     if (!mounted) return;

//     showDialog(
//       context: context,
//       builder: (context) => EmployeeDetailsDialog(
//         employee: employee,
//         onSave: (updatedEmployee) async {
//           await _store.updateEmployee(updatedEmployee);
//           // Refresh employee statuses after updating
//           await _loadEmployeeStatuses();
//         },
//       ),
//     );
//   }

//   List<Employee> _filterEmployees(List<Employee> employees) {
//     var filtered = employees;

//     // Filter by role
//     if (_selectedRole != 'All') {
//       filtered = filtered
//           .where((e) => e.role.toLowerCase() == _selectedRole.toLowerCase())
//           .toList();
//     }

//     // Filter by status
//     if (_selectedStatus != 'All') {
//       if (_selectedStatus == 'Active') {
//         filtered = filtered.where((e) => e.status == 'active').toList();
//       } else {
//         filtered = filtered.where((e) => e.status != 'active').toList();
//       }
//     }

//     // Filter by search
//     final query = _searchController.text.toLowerCase();
//     if (query.isNotEmpty) {
//       filtered = filtered
//           .where(
//             (e) =>
//                 e.fullName.toLowerCase().contains(query) ||
//                 e.email.toLowerCase().contains(query) ||
//                 e.role.toLowerCase().contains(query),
//           )
//           .toList();
//     }

//     return filtered;
//   }

//   /// Confirm and delete an employee
//   Future<void> _confirmDeleteEmployee(Employee employee) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Employee'),
//         content: Text('Are you sure you want to delete ${employee.fullName}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _store.deleteEmployee(employee.id);
//     }
//   }

//   /// Build the clock-in order column
//   Widget _buildClockInOrderColumn() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryBlue.withValues(alpha: 0.05),
//                   AppColors.primaryBlue.withValues(alpha: 0.02),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppColors.border.withValues(alpha: 0.2),
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.access_time,
//                   size: 18,
//                   color: AppColors.primaryBlue,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Clock-In Order',
//                     style: AppTextStyles.labelLarge.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Today',
//                   style: AppTextStyles.labelSmall.copyWith(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Clock-in list
//           Expanded(
//             child: _isLoadingClockInOrder
//                 ? const Center(child: CircularProgressIndicator())
//                 : _clockInOrder.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.schedule_outlined,
//                               size: 48,
//                               color: AppColors.textSecondary
//                                   .withValues(alpha: 0.5),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               'No clock-ins today',
//                               style: AppTextStyles.bodyMedium.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.separated(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: _clockInOrder.length,
//                         separatorBuilder: (context, index) =>
//                             const SizedBox(height: 8),
//                         itemBuilder: (context, index) {
//                           final entry = _clockInOrder[index];
//                           return _buildClockInEntry(entry, index + 1);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build a clock-in entry widget
//   Widget _buildClockInEntry(ClockInOrderEntry entry, int position) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.background.withValues(alpha: 0.3),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: AppColors.border.withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Position badge
//           Container(
//             width: 24,
//             height: 24,
//             decoration: BoxDecoration(
//               color: AppColors.primaryBlue,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Text(
//                 position.toString(),
//                 style: AppTextStyles.labelSmall.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Employee info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   entry.employee.fullName,
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   entry.formattedTime,
//                   style: AppTextStyles.labelSmall.copyWith(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Status indicator
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: AppColors.successGreen,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: StandardAppHeader.withAddAction(
//         title: 'Employees',
//         addButtonLabel: 'Add Employee',
//         onAdd: _showAddEmployeeDialog,
//         showSearch: true,
//         onSearchChanged: (query) {
//           _searchController.text = query;
//           setState(() {}); // Refresh UI with new search
//         },
//         onSearchClear: () {
//           _searchController.clear();
//           setState(() {}); // Refresh UI with cleared search
//         },
//         searchHint: 'Search employees...',
//         searchValue: _searchController.text,
//       ),
//       body: Column(
//         children: [
//           // Statistics section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Observer(
//               builder: (_) {
//                 final employees = _store.employees;
//                 final activeCount =
//                     employees.where((e) => e.status == 'active').length;

//                 // Count clocked in employees using the status store
//                 final clockedInCount = employees
//                     .where(
//                         (e) => _employeeStatusStore.isEmployeeClockedIn(e.id))
//                     .length;

//                 final technicianCount = employees
//                     .where(
//                       (e) => e.role.toLowerCase() == 'technician',
//                     )
//                     .length;

//                 return Row(
//                   children: [
//                     _buildStatCard(
//                       'Total Employees',
//                       employees.length.toString(),
//                       Icons.people,
//                       AppColors.primaryBlue,
//                     ),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                       'Active',
//                       activeCount.toString(),
//                       Icons.check_circle,
//                       AppColors.successGreen,
//                     ),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                       'Clocked In',
//                       clockedInCount.toString(),
//                       Icons.access_time,
//                       AppColors.warningOrange,
//                     ),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                       'Technicians',
//                       technicianCount.toString(),
//                       Icons.handyman,
//                       AppColors.servicePurple,
//                     ),
//                     const Spacer(),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // Filters section with better positioning and descriptive labels
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryBlue.withValues(alpha: 0.02),
//                   AppColors.primaryBlue.withValues(alpha: 0.05),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: AppColors.border.withValues(alpha: 0.1),
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Filter header
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.filter_list,
//                       size: 18,
//                       color: AppColors.primaryBlue,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Filter Employees',
//                       style: AppTextStyles.labelLarge.copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Filters row
//                 Row(
//                   children: [
//                     // Role filter with label
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Role:',
//                           style: AppTextStyles.labelMedium.copyWith(
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color:
//                                   AppColors.primaryBlue.withValues(alpha: 0.2),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.05),
//                                 blurRadius: 2,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedRole == 'All'
//                                 ? 'All Roles'
//                                 : _selectedRole,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedRole =
//                                     value == 'All Roles' ? 'All' : value!;
//                               });
//                             },
//                             underline: const SizedBox.shrink(),
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontSize: 15,
//                             ),
//                             items: [
//                               'All Roles',
//                               'Admin',
//                               'Manager',
//                               'Technician',
//                               'Receptionist',
//                               'Staff',
//                             ]
//                                 .map(
//                                   (role) => DropdownMenuItem(
//                                     value: role,
//                                     child: Text(
//                                       role,
//                                       style: AppTextStyles.bodyMedium.copyWith(
//                                         color: AppColors.textPrimary,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(width: 24),

//                     // Status filter with label
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Status:',
//                           style: AppTextStyles.labelMedium.copyWith(
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color:
//                                   AppColors.primaryBlue.withValues(alpha: 0.2),
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.05),
//                                 blurRadius: 2,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedStatus == 'All'
//                                 ? 'All Statuses'
//                                 : _selectedStatus,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedStatus =
//                                     value == 'All Statuses' ? 'All' : value!;
//                               });
//                             },
//                             underline: const SizedBox.shrink(),
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontSize: 15,
//                             ),
//                             items: ['All Statuses', 'Active', 'Inactive']
//                                 .map(
//                                   (status) => DropdownMenuItem(
//                                     value: status,
//                                     child: Text(
//                                       status,
//                                       style: AppTextStyles.bodyMedium.copyWith(
//                                         color: AppColors.textPrimary,
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Main content: Employee grid + Clock-in order column
//           Expanded(
//             child: Container(
//               color: AppColors.background.withValues(alpha: 0.3),
//               child: Row(
//                 children: [
//                   // Employee grid (left side)
//                   Expanded(
//                     flex: 3,
//                     child: Observer(
//                       builder: (_) {
//                         if (_store.isLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         final filteredEmployees =
//                             _filterEmployees(_store.employees);

//                         if (filteredEmployees.isEmpty) {
//                           return Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.people_outline,
//                                   size: 64,
//                                   color: AppColors.textSecondary
//                                       .withValues(alpha: 0.5),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   _searchController.text.isNotEmpty
//                                       ? 'No employees found matching your search'
//                                       : 'No employees found',
//                                   style: AppTextStyles.bodyLarge.copyWith(
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Add your first employee to get started',
//                                   style: AppTextStyles.bodyMedium.copyWith(
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 ElevatedButton.icon(
//                                   onPressed: _showAddEmployeeDialog,
//                                   icon: const Icon(Icons.add),
//                                   label: const Text('Add Employee'),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primaryBlue,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 24,
//                                       vertical: 12,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }

//                         return LayoutBuilder(
//                           builder: (context, constraints) {
//                             // Calculate grid columns based on available width (smaller cards)
//                             final crossAxisCount = constraints.maxWidth > 1000
//                                 ? 4
//                                 : constraints.maxWidth > 700
//                                     ? 3
//                                     : constraints.maxWidth > 500
//                                         ? 2
//                                         : 1;

//                             return GridView.builder(
//                               padding: const EdgeInsets.all(20),
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: crossAxisCount,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                                 childAspectRatio:
//                                     2.2, // Smaller, more compact cards
//                               ),
//                               itemCount: filteredEmployees.length,
//                               itemBuilder: (context, index) {
//                                 final employee = filteredEmployees[index];
//                                 return Provider.value(
//                                   value: _employeeStatusStore,
//                                   child: EmployeeGridCard(
//                                     employee: employee,
//                                     onEdit: () =>
//                                         _showEditEmployeeDialog(employee),
//                                     onToggleActive: () async {
//                                       final newStatus =
//                                           employee.status == 'active'
//                                               ? 'inactive'
//                                               : 'active';
//                                       final updatedEmployee =
//                                           employee.copyWith(status: newStatus);
//                                       await _store
//                                           .updateEmployee(updatedEmployee);
//                                     },
//                                     onDelete: () =>
//                                         _confirmDeleteEmployee(employee),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),

//                   // Divider
//                   Container(
//                     width: 1,
//                     color: AppColors.border.withValues(alpha: 0.3),
//                   ),

//                   // Clock-in order column (right side)
//                   Expanded(
//                     child: _buildClockInOrderColumn(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build stat card for statistics display
//   Widget _buildStatCard(
//       String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color.withValues(alpha: 0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withValues(alpha: 0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               size: 18,
//               color: color,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: AppTextStyles.headline3.copyWith(
//                   color: AppColors.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 label,
//                 style: AppTextStyles.labelSmall.copyWith(
//                   color: AppColors.textSecondary,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
