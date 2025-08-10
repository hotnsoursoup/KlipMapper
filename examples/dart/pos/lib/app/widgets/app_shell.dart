// lib/app/widgets/app_shell.dart
// Main application shell providing navigation sidebar and layout wrapper for all screens. Features expandable navigation rail with icons/labels, privileged access controls, and consistent app structure.
// Usage: ACTIVE - Shell wrapper used by go_router for all main application screens

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/privileged_operations.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  
  const AppShell({
    super.key,
    required this.child,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isExtended = false;
  int? _hoveredIndex;
  bool _isExitHovered = false;
  
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Calendar',
      route: '/calendar',
    ),
    NavigationItem(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      label: 'Appointments',
      route: '/appointments',
    ),
    NavigationItem(
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
      label: 'Checkout',
      route: '/checkout',
    ),
    NavigationItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Tickets',
      route: '/tickets',
    ),
    NavigationItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Customers',
      route: '/customers',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Employees',
      route: '/employees',
    ),
    NavigationItem(
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      label: 'Services',
      route: '/services',
    ),
    NavigationItem(
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
      label: 'Reports',
      route: '/reports',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      route: '/settings',
    ),
  ];

  String get _currentRoute => GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

  int get _selectedIndex {
    final index = _navigationItems.indexWhere((item) => item.route == _currentRoute);
    return index >= 0 ? index : 0;
  }

  /// Handle navigation with manager PIN requirement for sensitive areas
  Future<void> _handleNavigation(String route) async {
    // Settings requires manager PIN
    if (route == '/settings') {
      final authorized = await PrivilegedOperations.requestAuthorization(
        context: context,
        operation: PrivilegedOperation.accessSettings,
        currentEmployeeId: 0, // No specific employee context
      );
      
      if (!authorized) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Manager authorization required to access Settings'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
        return;
      }
    }

    // Navigate to the route if authorized or not protected
    if (mounted) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content area with left padding for fixed nav
          Padding(
            padding: const EdgeInsets.only(left: 72),
            child: widget.child,
          ),
          
          // Fixed Navigation Rail (always 72px wide)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isExtended = true),
              onExit: (_) => setState(() => _isExtended = false),
              child: Container(
                width: 72,
                color: const Color(0xFF1A1D2E),
                child: Column(
                  children: [
                    // Fixed Logo Section
                    _buildLogo(),
                    // Navigation Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _navigationItems.length,
                        itemBuilder: (context, index) {
                          return _buildNavItem(_navigationItems[index], index);
                        },
                      ),
                    ),
                    // Exit button anchored at bottom
                    _buildExitButton(),
                  ],
                ),
              ),
            ),
          ),
          
          // Overlay labels when expanded
          if (_isExtended)
            Positioned(
              left: 72,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isExtended = true),
                onExit: (_) => setState(() => _isExtended = false),
                child: Container(
                  width: 220, // Width to accommodate "Appointments" text fully
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1D2E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Logo text overlay
                      Container(
                        height: 64,
                        padding: const EdgeInsets.only(left: 12, right: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A1D2E), // Changed to match navbar background
                          // Removed border divider
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Luxe Nails',
                            style: AppTextStyles.headline3.copyWith(
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Navigation labels overlay
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _navigationItems.length,
                          itemBuilder: (context, index) {
                            return _buildNavLabelOverlay(_navigationItems[index], index);
                          },
                        ),
                      ),
                      const SizedBox.shrink(), // No exit button overlay needed
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 64,
      width: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D2E), // Changed to match navbar background
        // Removed border divider
      ),
      child: const Icon(
        Icons.spa,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, int index) {
    final isSelected = _selectedIndex == index;
    
    return Container(
      height: 56,
      width: 72,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        // Hide highlight when navigation is extended - unified highlight will cover both areas
        color: (isSelected && !_isExtended) 
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _handleNavigation(item.route),
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            isSelected ? item.selectedIcon : item.icon,
            color: isSelected 
              ? Colors.white 
              : Colors.white.withValues(alpha: 0.7),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildNavLabelOverlay(NavigationItem item, int index) {
    final isSelected = _selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Transform.translate(
        offset: const Offset(-72, 0), // Extend back exactly to cover nav rail (72px)
        child: Container(
          height: 56,
          width: 292, // Width to cover navigation rail (72px) + overlay area (220px)
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Material(
            color: isSelected 
              ? AppColors.primaryBlue.withValues(alpha: 0.2) // Blue highlight like check-in button
              : isHovered
                ? Colors.white.withValues(alpha: 0.1) // Subtle hover effect
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => _handleNavigation(item.route),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.only(left: 72, right: 4), // Text starts right after nav rail edge
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected 
                        ? Colors.white 
                        : Colors.white.withValues(alpha: isHovered ? 1.0 : 0.8),
                      fontWeight: isSelected 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isExitHovered = true),
      onExit: (_) => setState(() => _isExitHovered = false),
      child: Container(
        height: 56,
        width: 72,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Material(
          // Only show hover effect when extended, no highlight when collapsed
          color: _isExtended 
            ? (_isExitHovered ? Colors.red.withValues(alpha: 0.2) : Colors.transparent)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: _showExitConfirmationDialog,
            borderRadius: BorderRadius.circular(8),
            child: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _showExitConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text('Exit Application'),
          ],
        ),
        content: const Text(
          'Are you sure you want to exit the application?\n\nAny unsaved changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      SystemNavigator.pop();
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}