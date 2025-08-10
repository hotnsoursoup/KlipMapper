// lib/features/services/presentation/widgets/dynamic_service_form_dialog.dart
// Dynamic service form dialog with real-time category integration and validation support.
// Provides both create and edit modes with pre-populated category selection and form validation.
// Usage: ACTIVE - Used in services management screens for service creation/editing workflows

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/domain/models/service_domain.dart';
import '../../../shared/data/repositories/drift_service_repository.dart';
import '../../../../core/config/service_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DynamicServiceFormDialog extends StatefulWidget {
  final ServiceDomain? service;
  final List<ServiceCategoryWithCount> categories;
  final int? preselectedCategoryId;
  final Function(String name, int categoryId, double price, int duration) onSave;

  const DynamicServiceFormDialog({
    super.key,
    this.service,
    required this.categories,
    this.preselectedCategoryId,
    required this.onSave,
  });

  @override
  State<DynamicServiceFormDialog> createState() => _DynamicServiceFormDialogState();
}

class _DynamicServiceFormDialogState extends State<DynamicServiceFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late int _selectedCategoryId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(
      text: widget.service?.basePrice.toStringAsFixed(2) ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.durationMinutes.toString() ?? '',
    );
    
    // Initialize selected category
    if (widget.service != null) {
      _selectedCategoryId = widget.service!.categoryId;
    } else if (widget.preselectedCategoryId != null) {
      _selectedCategoryId = widget.preselectedCategoryId!;
    } else if (widget.categories.isNotEmpty) {
      _selectedCategoryId = widget.categories.first.id;
    } else {
      _selectedCategoryId = 1; // Default fallback
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(ServiceCategoryWithCount category) {
    try {
      final configColor = ServiceCategories.getCategoryColorById(category.id);
      if (configColor != null) {
        return configColor;
      } else if (category.color.startsWith('#')) {
        return Color(int.parse(category.color.substring(1), radix: 16) | 0xFF000000);
      }
    } catch (e) {
      // Fallback to default
    }
    return AppColors.textSecondary;
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
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories.map((category) {
                  final color = _getCategoryColor(category);
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${category.name} (${category.serviceCount} services)'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
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
      
      widget.onSave(name, _selectedCategoryId, price, duration);
      Navigator.pop(context);
    }
  }
}