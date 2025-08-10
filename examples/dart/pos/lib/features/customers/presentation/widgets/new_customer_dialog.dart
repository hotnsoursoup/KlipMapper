// lib/features/customers/presentation/widgets/new_customer_dialog.dart
// Comprehensive customer creation and editing dialog with conditional field collection based on business settings.
// Features form validation, phone formatting, field capitalization, and privacy preference management with settings integration.
// Usage: ACTIVE - Primary customer CRUD interface with dynamic form fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/field_validators.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../providers/customers_provider.dart';

class NewCustomerDialog extends ConsumerStatefulWidget {
  final Customer? customer; // For editing existing customer
  
  const NewCustomerDialog({
    super.key,
    this.customer,
  });

  @override
  ConsumerState<NewCustomerDialog> createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends ConsumerState<NewCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _notesController = TextEditingController();
  final _allergiesController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _dateOfBirth;
  bool _emailOptIn = true;
  bool _smsOptIn = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      // Populate fields for editing
      _firstNameController.text = widget.customer!.firstName;
      _lastNameController.text = widget.customer!.lastName;
      _phoneController.text = widget.customer!.phone ?? '';
      _emailController.text = widget.customer!.email ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _cityController.text = widget.customer!.city ?? '';
      _stateController.text = widget.customer!.state ?? '';
      _zipController.text = widget.customer!.zipCode ?? '';
      _notesController.text = widget.customer!.notes ?? '';
      _allergiesController.text = widget.customer!.allergies ?? '';
      
      _selectedGender = widget.customer!.gender;
      _dateOfBirth = widget.customer!.dateOfBirth != null 
          ? DateTime.tryParse(widget.customer!.dateOfBirth!) 
          : null;
      _emailOptIn = widget.customer!.emailOptIn ?? true;
      _smsOptIn = widget.customer!.smsOptIn ?? true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _notesController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch customer collection settings
    final collectionSettings = ref.watch(customerCollectionSettingsProvider);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.customer != null ? 'Edit Customer' : 'New Customer',
                    style: AppTextStyles.headline2,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Make form scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name fields - First and Last Name side by side
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              autofocus: true,
                              style: AppTextStyles.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'First Name *',
                                labelStyle: AppTextStyles.labelMedium,
                                hintText: 'Enter first name',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) => FieldValidators.validateName(value, fieldName: 'First name'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              style: AppTextStyles.bodyMedium,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: AppTextStyles.labelMedium,
                                hintText: 'Enter last name',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Phone and Email row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              style: AppTextStyles.bodyMedium,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number *',
                                labelStyle: AppTextStyles.labelMedium,
                                hintText: 'Enter phone number',
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) => FieldValidators.validatePhone(value),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              style: AppTextStyles.bodyMedium,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: AppTextStyles.labelMedium,
                                hintText: 'Enter email address',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) => FieldValidators.validateEmail(value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Address field - conditional based on settings
                      if (collectionSettings.collectAddress) ...[ 
                        TextFormField(
                          controller: _addressController,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: AppTextStyles.labelMedium,
                            hintText: 'Enter street address',
                            prefixIcon: const Icon(Icons.home),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => FieldValidators.validateAddress(value),
                        ),
                        const SizedBox(height: 16),
                        
                        // City, State, Zip row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _cityController,
                                style: AppTextStyles.bodyMedium,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  labelStyle: AppTextStyles.labelMedium,
                                  hintText: 'Enter city',
                                  prefixIcon: const Icon(Icons.location_city),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => FieldValidators.validateCity(value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _stateController,
                                style: AppTextStyles.bodyMedium,
                                decoration: InputDecoration(
                                  labelText: 'State',
                                  labelStyle: AppTextStyles.labelMedium,
                                  hintText: 'State',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => FieldValidators.validateState(value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _zipController,
                                style: AppTextStyles.bodyMedium,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Zip',
                                  labelStyle: AppTextStyles.labelMedium,
                                  hintText: 'Zip Code',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => FieldValidators.validateZipCode(value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Date of Birth and Gender row - conditional based on settings
                      if (collectionSettings.collectDateOfBirth || collectionSettings.collectGender) ...[ 
                        Row(
                          children: [
                            if (collectionSettings.collectDateOfBirth) 
                              Expanded(
                                child: InkWell(
                                  onTap: _selectDateOfBirth,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Date of Birth',
                                      labelStyle: AppTextStyles.labelMedium,
                                      prefixIcon: const Icon(Icons.cake),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _dateOfBirth != null 
                                        ? '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}'
                                        : 'Select date',
                                      style: _dateOfBirth != null 
                                        ? AppTextStyles.bodyMedium 
                                        : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ),
                                ),
                              ),
                            if (collectionSettings.collectDateOfBirth && collectionSettings.collectGender)
                              const SizedBox(width: 16),
                            if (collectionSettings.collectGender)
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  style: AppTextStyles.bodyMedium,
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    labelStyle: AppTextStyles.labelMedium,
                                    prefixIcon: const Icon(Icons.person_pin),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: ['Male', 'Female', 'Other', 'Prefer not to say'].map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Allergies field - conditional based on settings
                      if (collectionSettings.collectAllergies) ...[ 
                        TextFormField(
                          controller: _allergiesController,
                          style: AppTextStyles.bodyMedium,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Allergies',
                            labelStyle: AppTextStyles.labelMedium,
                            hintText: 'Any allergies or sensitivities',
                            prefixIcon: const Icon(Icons.warning),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => FieldValidators.validateAllergies(value),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Notes field
                      TextFormField(
                        controller: _notesController,
                        style: AppTextStyles.bodyMedium,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          labelStyle: AppTextStyles.labelMedium,
                          hintText: 'Any additional notes about the customer',
                          prefixIcon: const Icon(Icons.note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) => FieldValidators.validateNotes(value),
                      ),
                      const SizedBox(height: 16),
                      
                      // Communication preferences
                      Text(
                        'Communication Preferences',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('Email notifications'),
                        subtitle: const Text('Receive appointment reminders and promotions via email'),
                        value: _emailOptIn,
                        onChanged: (value) {
                          setState(() {
                            _emailOptIn = value ?? true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text('SMS notifications'),
                        subtitle: const Text('Receive appointment reminders via text message'),
                        value: _smsOptIn,
                        onChanged: (value) {
                          setState(() {
                            _smsOptIn = value ?? true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : () => _saveCustomer(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.customer != null ? 'Update' : 'Create',
                            style: AppTextStyles.buttonText,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _saveCustomer(BuildContext context) async {
    // Get settings to check validation requirements
    final collectionSettings = ref.read(customerCollectionSettingsProvider);
    
    // Validate date of birth if it's being collected
    if (collectionSettings.collectDateOfBirth) {
      final dobError = FieldValidators.validateDateOfBirth(_dateOfBirth);
      if (dobError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dobError)),
        );
        return;
      }
    }
    
    // Validate gender if it's being collected
    if (collectionSettings.collectGender) {
      final genderError = FieldValidators.validateGender(_selectedGender);
      if (genderError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(genderError)),
        );
        return;
      }
    }
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      
      try {
        // Format phone number using validator utility
        final String phone = FieldValidators.formatPhoneNumber(_phoneController.text);
        
        // Create customer object
        final customer = Customer(
          id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          firstName: FieldValidators.capitalizeWords(_firstNameController.text.trim()),
          lastName: FieldValidators.capitalizeWords(_lastNameController.text.trim()),
          phone: phone,
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          address: collectionSettings.collectAddress 
              ? (_addressController.text.trim().isEmpty ? null : FieldValidators.capitalizeWords(_addressController.text.trim()))
              : null,
          city: collectionSettings.collectAddress 
              ? (_cityController.text.trim().isEmpty ? null : FieldValidators.capitalizeWords(_cityController.text.trim()))
              : null,
          state: collectionSettings.collectAddress 
              ? (_stateController.text.trim().isEmpty ? null : _stateController.text.trim().toUpperCase())
              : null,
          zipCode: collectionSettings.collectAddress 
              ? (_zipController.text.trim().isEmpty ? null : FieldValidators.formatZipCode(_zipController.text.trim()))
              : null,
          dateOfBirth: collectionSettings.collectDateOfBirth 
              ? _dateOfBirth?.toIso8601String()
              : null,
          gender: collectionSettings.collectGender ? _selectedGender : null,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          allergies: collectionSettings.collectAllergies 
              ? (_allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim())
              : null,
          emailOptIn: _emailOptIn,
          smsOptIn: _smsOptIn,
          isActive: widget.customer?.isActive ?? true,
          createdAt: widget.customer?.createdAt ?? DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
        
        // Call the appropriate provider method
        final customersNotifier = ref.read(customersListProvider.notifier);
        if (widget.customer != null) {
          await customersNotifier.updateCustomer(customer);
        } else {
          await customersNotifier.addCustomer(customer);
        }
        
        if (context.mounted) {
          Navigator.of(context).pop(customer);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save customer: $e'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }
}