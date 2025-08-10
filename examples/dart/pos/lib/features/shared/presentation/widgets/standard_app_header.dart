// lib/features/shared/presentation/widgets/standard_app_header.dart
// Standard application header widget providing consistent navigation and branding across all screens. Features back navigation, screen titles, and optional action buttons with unified styling.
// Usage: ACTIVE - Reusable header component used across all major application screens for consistent navigation UX

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/debouncer.dart';

/// Standardized AppBar component for consistent header styling across all screens
/// 
/// Features:
/// - Automatic theme integration
/// - Consistent button placement and styling
/// - Standardized title formatting
/// - Optional primary action button
/// - Optional refresh functionality
/// - Debounced search functionality
/// - Accessibility support
/// - Performance optimized with RepaintBoundary
class StandardAppHeader extends StatefulWidget implements PreferredSizeWidget {
  /// Screen title (e.g., "Customer Management")
  final String title;
  
  /// Primary action button (rightmost position)
  final Widget? primaryAction;
  
  /// Secondary actions (middle positions)
  final List<Widget>? secondaryActions;
  
  /// Disable back button (for main navigation screens)
  final bool automaticallyImplyLeading;
  
  /// Custom leading widget (overrides automaticallyImplyLeading)
  final Widget? leading;
  
  /// Search functionality
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final String? searchHint;
  final String? searchValue;
  final bool showSearch;

  const StandardAppHeader({
    super.key,
    required this.title,
    this.primaryAction,
    this.secondaryActions,
    this.automaticallyImplyLeading = false,
    this.leading,
    this.onSearchChanged,
    this.onSearchClear,
    this.searchHint,
    this.searchValue,
    this.showSearch = false,
  });

  /// Factory constructor for screens with a primary "Add" action
  factory StandardAppHeader.withAddAction({
    Key? key,
    required String title,
    required String addButtonLabel,
    required VoidCallback onAdd,
    IconData addIcon = Icons.add,
    List<Widget>? secondaryActions,
    bool automaticallyImplyLeading = false,
    ValueChanged<String>? onSearchChanged,
    VoidCallback? onSearchClear,
    String? searchHint,
    String? searchValue,
    bool showSearch = false,
  }) {
    return StandardAppHeader(
      key: key,
      title: title,
      secondaryActions: secondaryActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      onSearchChanged: onSearchChanged,
      onSearchClear: onSearchClear,
      searchHint: searchHint,
      searchValue: searchValue,
      showSearch: showSearch,
      primaryAction: _buildPrimaryActionButton(
        label: addButtonLabel,
        icon: addIcon,
        onPressed: onAdd,
      ),
    );
  }

  /// Factory constructor for screens with navigation toggle
  factory StandardAppHeader.withNavigation({
    Key? key,
    required String title,
    required String navigationLabel,
    required VoidCallback onNavigate,
    IconData navigationIcon = Icons.calendar_today,
    String? addButtonLabel,
    VoidCallback? onAdd,
    bool automaticallyImplyLeading = false,
    ValueChanged<String>? onSearchChanged,
    VoidCallback? onSearchClear,
    String? searchHint,
    String? searchValue,
    bool showSearch = false,
  }) {
    final actions = <Widget>[];
    
    // Add navigation button
    actions.add(_buildNavigationButton(
      label: navigationLabel,
      icon: navigationIcon,
      onPressed: onNavigate,
    ),);
    
    return StandardAppHeader(
      key: key,
      title: title,
      secondaryActions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      onSearchChanged: onSearchChanged,
      onSearchClear: onSearchClear,
      searchHint: searchHint,
      searchValue: searchValue,
      showSearch: showSearch,
      primaryAction: addButtonLabel != null && onAdd != null
        ? _buildPrimaryActionButton(
            label: addButtonLabel,
            icon: Icons.add,
            onPressed: onAdd,
          )
        : null,
    );
  }

  /// Build primary action button with consistent styling
  static Widget _buildPrimaryActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Builder(
      builder: (context) {
        return TextButton.icon(
          icon: Icon(icon, size: 20), // Icon with static size
          label: Text(label),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // const padding
            textStyle: AppTextStyles.buttonText,
          ),
        );
      },
    );
  }
  
  /// Build colored action button for header
  static Widget buildColoredAction({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color? foregroundColor,
    double iconSize = 18,
    EdgeInsets? padding,
    String? tooltip,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor ?? Colors.white,
        backgroundColor: backgroundColor,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
    );
  }
  
  /// Build outlined action button for header
  static Widget buildOutlinedAction({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    double iconSize = 18,
    EdgeInsets? padding,
    Color? backgroundColor,
    String? tooltip,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.7), width: 1),
        backgroundColor: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
  
  /// Build subtle action button for header
  static Widget buildSubtleAction({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? foregroundColor,
    double iconSize = 18,
    EdgeInsets? padding,
    String? tooltip,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
  
  /// Build icon-only action button for header
  static Widget buildIconAction({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    double size = 24,
    String? tooltip,
    Color? backgroundColor,
  }) {
    if (backgroundColor != null) {
      return Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                size: size,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: size),
      style: IconButton.styleFrom(
        foregroundColor: color ?? Colors.white.withValues(alpha: 0.9),
      ),
      tooltip: tooltip,
    );
  }

  /// Build navigation button with consistent styling
  static Widget _buildNavigationButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Builder(
      builder: (context) {
        return TextButton.icon(
          icon: Icon(icon, size: 20), // Icon with static size
          label: Text(label),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // const padding
            textStyle: AppTextStyles.buttonText,
          ),
        );
      },
    );
  }

  @override
  State<StandardAppHeader> createState() => _StandardAppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StandardAppHeaderState extends State<StandardAppHeader> {
  final _searchDebouncer = Debouncer(milliseconds: 300);
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue ?? '');
  }

  @override
  void didUpdateWidget(StandardAppHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchValue != oldWidget.searchValue) {
      _searchController.text = widget.searchValue ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Performance optimization: RepaintBoundary isolates header paint operations
    return AppBar(
      title: RepaintBoundary(
        child: _HeaderTitle(title: widget.title),
      ),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: widget.leading,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    
    // Add secondary actions first
    if (widget.secondaryActions != null) {
      actions.addAll(widget.secondaryActions!);
    }
    
    // Add primary action button 
    if (widget.primaryAction != null) {
      actions.add(
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: widget.primaryAction!,
        ),
      );
    }
    
    // Add search widget LAST (rightmost position)
    if (widget.showSearch) {
      actions.add(_buildCompactSearchWidget(context));
    }
    
    return actions;
  }

  Widget _buildCompactSearchWidget(BuildContext context) {
    return Container(
      width: 280, // Fixed width that fits well in header
      height: 36,
      margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {}); // Update suffix icon visibility
          _searchDebouncer.run(() {
            widget.onSearchChanged?.call(value);
          });
        },
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: widget.searchHint ?? 'Search...',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.7),
            size: 18,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 16,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchDebouncer.cancel();
                    setState(() {}); // Update suffix icon visibility
                    widget.onSearchClear?.call();
                    widget.onSearchChanged?.call('');
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}

/// Optimized title widget following UI Bible const constructor principles
class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use const-optimized text styling
    return Text(
      title,
      style: AppTextStyles.headline2.copyWith(
        color: theme.appBarTheme.foregroundColor,
      ),
    );
  }
}

/// Helper extension for common header configurations
extension StandardAppHeaderConfig on StandardAppHeader {
  /// Common configuration for management screens
  static StandardAppHeader management({
    required String entityName,
    required String addButtonLabel,
    required VoidCallback onAdd,
  }) {
    return StandardAppHeader.withAddAction(
      title: '$entityName Management',
      addButtonLabel: addButtonLabel,
      onAdd: onAdd,
    );
  }

  /// Common configuration for screens with calendar integration
  static StandardAppHeader withCalendar({
    required String title,
    required VoidCallback onCalendar,
    String? addButtonLabel,
    VoidCallback? onAdd,
  }) {
    return StandardAppHeader.withNavigation(
      title: title,
      navigationLabel: 'Calendar',
      onNavigate: onCalendar,
      addButtonLabel: addButtonLabel,
      onAdd: onAdd,
    );
  }
}

/// Predefined button styles for common actions
class HeaderActionStyles {
  // Primary actions
  static Widget checkInButton(VoidCallback onPressed) => 
    StandardAppHeader.buildColoredAction(
      label: 'New Check-in',
      icon: Icons.person_add,
      onPressed: onPressed,
      backgroundColor: const Color(0xFF4338CA), // Indigo-700 - professional and distinctive
    );
    
  static Widget checkoutButton(VoidCallback onPressed) =>
    StandardAppHeader.buildColoredAction(
      label: 'Checkout',
      icon: Icons.shopping_cart_checkout,
      onPressed: onPressed,
      backgroundColor: AppColors.successGreen,
    );
    
  static Widget calendarButton(VoidCallback onPressed) =>
    StandardAppHeader.buildColoredAction(
      label: 'Calendar',
      icon: Icons.calendar_today,
      onPressed: onPressed,
      backgroundColor: AppColors.servicePurple,
    );
    
  // Secondary actions
  static Widget registerButton(VoidCallback onPressed) =>
    StandardAppHeader.buildIconAction(
      icon: Icons.point_of_sale,
      onPressed: onPressed,
      backgroundColor: AppColors.serviceOrange.withValues(alpha: 0.9),
      color: Colors.white,
      tooltip: 'Cash Register',
      size: 20,
    );
    
  static Widget saveButton(VoidCallback onPressed) =>
    StandardAppHeader.buildColoredAction(
      label: 'Save',
      icon: Icons.save,
      onPressed: onPressed,
      backgroundColor: AppColors.primaryBlue,
    );
    
  static Widget cancelButton(VoidCallback onPressed) =>
    StandardAppHeader.buildSubtleAction(
      label: 'Cancel',
      icon: Icons.close,
      onPressed: onPressed,
    );
    
  static Widget refreshButton(VoidCallback onPressed) =>
    StandardAppHeader.buildIconAction(
      icon: Icons.refresh,
      onPressed: onPressed,
      tooltip: 'Refresh',
    );
    
  static Widget settingsButton(VoidCallback onPressed) =>
    StandardAppHeader.buildIconAction(
      icon: Icons.settings,
      onPressed: onPressed,
      tooltip: 'Settings',
    );
    
  // Custom colored button
  static Widget customButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    bool outlined = false,
  }) {
    if (outlined) {
      return StandardAppHeader.buildOutlinedAction(
        label: label,
        icon: icon,
        onPressed: onPressed,
        color: color,
      );
    }
    return StandardAppHeader.buildColoredAction(
      label: label,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: color,
    );
  }
}