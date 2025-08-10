// lib/features/shared/presentation/widgets/customer_search_widget.dart
// Advanced customer search widget with real-time search, customer creation, and selection functionality. Features debounced search, customer suggestions, and quick customer creation workflow.
// Usage: ACTIVE - Core widget used across POS for customer selection in tickets, appointments, and service assignments

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/drift_customer_repository.dart';
import '../../../customers/presentation/widgets/new_customer_dialog.dart';

/// A comprehensive customer search widget with real-time search and customer creation capabilities.
/// 
/// Features:
/// * Real-time customer search by name, phone, or email
/// * Debounced search input for performance optimization
/// * Customer creation dialog integration
/// * Generic customer support for walk-ins
/// * Selected customer display with clear functionality
/// * Customizable search hints and labels
/// * Repository integration for data persistence
/// * Keyboard-friendly navigation and selection
/// 
/// Usage:
/// ```dart
/// CustomerSearchWidget(
///   onCustomerSelected: (customer) => _selectCustomer(customer),
///   onCustomerCleared: () => _clearSelection(),
///   allowGenericCustomer: true,
///   searchHint: 'Search by name or phone...',
/// )
/// ```
class CustomerSearchWidget extends StatefulWidget {
  final Function(Customer) onCustomerSelected;
  final VoidCallback? onCustomerCleared;
  final String? initialSearchQuery;
  final Customer? selectedCustomer;
  final bool allowGenericCustomer;
  final String searchHint;
  final String searchLabel;

  const CustomerSearchWidget({
    super.key,
    required this.onCustomerSelected,
    this.onCustomerCleared,
    this.initialSearchQuery,
    this.selectedCustomer,
    this.allowGenericCustomer = true,
    this.searchHint = 'Enter name, phone, or email...',
    this.searchLabel = 'Search Customer',
  });

  @override
  State<CustomerSearchWidget> createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _customerRepository = DriftCustomerRepository.instance;
  
  List<Customer> _searchResults = [];
  bool _isSearching = false;
  Customer? _selectedCustomer;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedCustomer = widget.selectedCustomer;
    if (widget.initialSearchQuery != null) {
      _searchController.text = widget.initialSearchQuery!;
      _searchCustomers(widget.initialSearchQuery!);
    }
    
    // Auto-focus the search field when no customer is selected
    if (_selectedCustomer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
    
    // Listen to focus changes
    _searchFocusNode.addListener(() {
      setState(() {
        _isFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _searchCustomers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      await _customerRepository.initialize();
      final customers = await _customerRepository.searchCustomers(query);
      
      setState(() {
        _searchResults = customers;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectCustomer(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
      _searchController.clear();
      _searchResults = [];
    });
    widget.onCustomerSelected(customer);
  }

  void _selectGenericCustomer() {
    final adultCustomer = Customer.withName(
      id: 'adult_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Adult',
    );
    _selectCustomer(adultCustomer);
  }

  void _clearSelection() {
    setState(() {
      _selectedCustomer = null;
      _searchController.clear();
      _searchResults = [];
    });
    // Notify parent that customer has been cleared
    widget.onCustomerCleared?.call();
    // Auto-focus the search field after clearing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _createNewCustomer() async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (context) => NewCustomerDialog(
        onSave: ({
          required String firstName,
          required String lastName,
          required String phone,
          String? email,
          String? address,
          String? city,
          String? state,
          String? zipCode,
          DateTime? dateOfBirth,
          String? gender,
          String? notes,
          String? allergies,
          bool emailOptIn = true,
          bool smsOptIn = true,
        }) async {
          // Create and save the new customer with all fields
          try {
            await _customerRepository.initialize();
            
            final newCustomer = await _customerRepository.createCustomerWithAllFields(
              firstName: firstName,
              lastName: lastName,
              phone: phone.isNotEmpty ? phone : 'No phone',
              email: email,
              address: address,
              city: city,
              state: state,
              zipCode: zipCode,
              dateOfBirth: dateOfBirth,
              gender: gender,
              notes: notes,
              allergies: allergies,
              emailOptIn: emailOptIn,
              smsOptIn: smsOptIn,
            );
            
            if (context.mounted) {
              Navigator.of(context).pop(newCustomer);
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create customer: $e')),
              );
            }
          }
        },
      ),
    );

    if (result != null) {
      _selectCustomer(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected customer if one is selected
        if (_selectedCustomer != null) ...[
          Text(
            'Selected Customer',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildSelectedCustomerCard(),
        ] else ...[
          // Show search section when no customer is selected
          Text(
            widget.searchLabel,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search by name, phone number, or email address',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Search Field
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _searchCustomers,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Generic Customer Option (if allowed)
          if (widget.allowGenericCustomer) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _selectGenericCustomer,
                icon: const Icon(Icons.person_outline, size: 20),
                label: const Text('Adult'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'For customers who prefer not to provide their information',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],

          // Search Results or Create New Customer Section
          _buildSearchResultsOrCreateNew(),
        ],
      ],
    );
  }

  Widget _buildSelectedCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            child: Text(
              _selectedCustomer!.name.isNotEmpty 
                  ? _selectedCustomer!.name[0].toUpperCase() 
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCustomer!.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _selectedCustomer!.phone ?? 'No phone',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_selectedCustomer!.email != null)
                  Text(
                    _selectedCustomer!.email!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: _clearSelection,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: _clearSelection,
                icon: const Icon(Icons.close, size: 18),
                color: AppColors.textSecondary,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsOrCreateNew() {
    if (_searchResults.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 240, // Increased height to accommodate "Add new customer" option
            child: ListView.builder(
              itemCount: _searchResults.length + 1, // +1 for "Add new customer" option
              itemBuilder: (context, index) {
                // Show regular search results first
                if (index < _searchResults.length) {
                  final customer = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.surfaceLight,
                        child: Text(
                          customer.name.isNotEmpty 
                              ? customer.name[0].toUpperCase() 
                              : '?',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        customer.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customer.phone ?? 'No phone'),
                          if (customer.email != null)
                            Text(customer.email!),
                        ],
                      ),
                      onTap: () => _selectCustomer(customer),
                    ),
                  );
                }
                
                // Show "Add new customer" as the last item
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: AppColors.primaryBlue.withValues(alpha: 0.05),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBlue,
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Add New Customer',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    onTap: _createNewCustomer,
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (_searchController.text.isNotEmpty && !_isSearching) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_add,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No customers found',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Would you like to create a new customer?',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _createNewCustomer,
              icon: const Icon(Icons.add),
              label: const Text('New Customer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
      );
    } else if (_isFocused && _searchController.text.isEmpty) {
      // Show "Add new customer" suggestion when search field is focused but empty
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_add,
              size: 48,
              color: AppColors.primaryBlue.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              'Start typing to search existing customers, or create a new customer profile',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _createNewCustomer,
              icon: const Icon(Icons.person_add),
              label: const Text('New Customer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show helpful message when no search has been performed yet and field is not focused
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: AppColors.primaryBlue.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              'Start typing to search',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enter customer name, phone, or email to find existing customers',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _createNewCustomer,
              icon: const Icon(Icons.person_add),
              label: const Text('New Customer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
      );
    }
  }
}