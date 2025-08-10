// lib/features/services/presentation/widgets/service_category_dialog.dart
// Service category creation dialog with color selection, icon picker, and real-time preview.
// Features expanded color palette, suggested icons based on category names, and live preview functionality.
// Usage: ACTIVE - Used in services management for creating new service categories with visual customization

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'service_category_icon_picker.dart';

class ServiceCategoryDialog extends StatefulWidget {
  final Function(String name, String color, IconData icon) onSave;

  const ServiceCategoryDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<ServiceCategoryDialog> createState() => _ServiceCategoryDialogState();
}

class _ServiceCategoryDialogState extends State<ServiceCategoryDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _selectedColor = AppColors.primaryBlue;
  IconData _selectedIcon = Icons.more_horiz;
  bool _showIconPicker = false;
  
  // Expanded color palette - 20 professional colors
  final List<Color> _colorOptions = [
    // Blues
    const Color(0xFF2196F3), // Blue
    const Color(0xFF03A9F4), // Light Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF3F51B5), // Indigo
    
    // Greens
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFF009688), // Teal
    const Color(0xFF00796B), // Dark Teal
    
    // Purples & Pinks
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFFE91E63), // Pink
    const Color(0xFFFF4081), // Pink Accent
    
    // Oranges & Yellows
    const Color(0xFFFF9800), // Orange
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFFFFC107), // Amber
    const Color(0xFFFFEB3B), // Yellow
    
    // Reds & Browns
    const Color(0xFFF44336), // Red
    const Color(0xFF795548), // Brown
    const Color(0xFF9E9E9E), // Grey
    const Color(0xFF607D8B), // Blue Grey
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        // Update suggested icon when name changes
        final suggestedIcon = ServiceCategoryIconPicker.suggestedIcons[
          _nameController.text.toLowerCase()
        ];
        if (suggestedIcon != null && _selectedIcon == Icons.more_horiz) {
          _selectedIcon = suggestedIcon;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Service Category',
                  style: AppTextStyles.headline2,
                ),
                const SizedBox(height: 24),
                
                // Name input
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g., Hair, Massage, Makeup',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category name';
                    }
                    if (value.trim().length < 2) {
                      return 'Category name must be at least 2 characters';
                    }
                    if (value.trim().length > 30) {
                      return 'Category name must be less than 30 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Color selection
                Text(
                  'Select Color',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colorOptions.map((color) {
                    final isSelected = _selectedColor == color;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.darkNavy : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Icon Selection Section
                Text(
                  'Select Icon',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showIconPicker = !_showIconPicker;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _selectedColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            _selectedIcon,
                            color: _selectedColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tap to change icon',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Icon(
                          _showIconPicker ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showIconPicker) ...[
                  const SizedBox(height: 12),
                  ServiceCategoryIconPicker(
                    categoryName: _nameController.text.isEmpty ? 'New Category' : _nameController.text,
                    currentIcon: _selectedIcon,
                    onIconSelected: (icon) {
                      setState(() {
                        _selectedIcon = icon;
                        _showIconPicker = false;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                
                // Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Preview:',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedIcon,
                              size: 16,
                              color: _selectedColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _nameController.text.isEmpty ? 'Category Name' : _nameController.text,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: _selectedColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Add Category'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final colorHex = _colorToHex(_selectedColor);
      
      widget.onSave(name, colorHex, _selectedIcon);
      Navigator.pop(context);
    }
  }
}