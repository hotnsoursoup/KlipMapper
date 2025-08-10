// lib/features/services/presentation/widgets/service_form_dialog.dart
// Service creation and editing dialog with comprehensive form fields for service management. Handles service details, pricing, duration, and category assignment with validation.
// Usage: ACTIVE - Primary dialog for service CRUD operations in services management screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/data/models/service_model.dart';
import '../../../../core/config/service_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A form dialog for creating and editing salon services.
/// 
/// Features:
/// * Service name, price, and duration input fields
/// * Category selection dropdown with color coding
/// * Form validation with error messages
/// * Support for both create and edit modes
/// * Numeric input formatters for price and duration
/// * Real-time form validation feedback
/// * Service category configuration integration
/// 
/// Usage:
/// ```dart
/// // Create new service
/// ServiceFormDialog(
///   categories: availableCategories,
///   onSave: (name, category, price, duration) => _createService(name, category, price, duration),
/// )
/// 
/// // Edit existing service
/// ServiceFormDialog(
///   service: existingService,
///   categories: availableCategories,
///   onSave: (name, category, price, duration) => _updateService(name, category, price, duration),
/// )
/// ```
class ServiceFormDialog extends StatefulWidget {
  final Service? service;
  final List<ServiceCategoryConfig> categories;
  final Function(String name, String category, double price, int duration) onSave;

  const ServiceFormDialog({
    super.key,
    this.service,
    required this.categories,
    required this.onSave,
  });

  @override
  State<ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<ServiceFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late String _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(
      text: widget.service?.price.toStringAsFixed(2) ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.durationMinutes.toString() ?? '',
    );
    // If editing, convert service category ID to string ID for dropdown
    if (widget.service != null) {
      // Map integer category ID to string key
      switch (widget.service!.categoryId) {
        case 1:
          _selectedCategory = 'nails';
          break;
        case 2:
          _selectedCategory = 'gel';
          break;
        case 3:
          _selectedCategory = 'acrylic';
          break;
        case 4:
          _selectedCategory = 'waxing';
          break;
        case 5:
          _selectedCategory = 'facials';
          break;
        case 6:
          _selectedCategory = 'sns';
          break;
        default:
          _selectedCategory = 'other';
      }
    } else {
      _selectedCategory = widget.categories.isNotEmpty ? widget.categories.first.id : 'other';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.service == null ? 'Add Service' : 'Edit Service',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: category.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(category.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        final duration = int.tryParse(value);
                        if (duration == null || duration <= 0) {
                          return 'Please enter valid duration';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                    child: Text(widget.service == null ? 'Add' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final duration = int.parse(_durationController.text);
      
      // Convert category ID to display name for the store
      final category = widget.categories.firstWhere(
        (c) => c.id == _selectedCategory,
        orElse: () => widget.categories.first,
      );
      
      widget.onSave(name, category.displayName, price, duration);
      Navigator.pop(context);
    }
  }
}