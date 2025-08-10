// lib/features/shared/presentation/widgets/customer_search_field.dart
// Customer search field widget with overlay-based dropdown results and real-time search functionality.
// Provides type-ahead search with repository integration and customizable input decoration.
// Usage: ACTIVE - Used across POS screens for customer selection with live search capabilities

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/drift_customer_repository.dart';

class CustomerSearchField extends StatefulWidget {
  final Function(Customer) onCustomerSelected;
  final InputDecoration? decoration;
  final String? initialValue;

  const CustomerSearchField({
    super.key,
    required this.onCustomerSelected,
    this.decoration,
    this.initialValue,
  });

  @override
  State<CustomerSearchField> createState() => _CustomerSearchFieldState();
}

class _CustomerSearchFieldState extends State<CustomerSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _customerRepository = DriftCustomerRepository.instance;
  
  List<Customer> _searchResults = [];
  bool _isSearching = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _searchResults.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onSearchChanged(String query) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
      });
      _removeOverlay();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      await _customerRepository.initialize();
      final results = await _customerRepository.searchCustomers(query);
      
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });

      if (results.isNotEmpty && _focusNode.hasFocus) {
        _showOverlay();
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // Offset below the text field
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final customer = _searchResults[index];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        customer.firstName.isNotEmpty ? customer.firstName[0] : 'C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: customer.phone != null
                        ? Text(
                            customer.phone!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          )
                        : null,
                    onTap: () {
                      _selectCustomer(customer);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectCustomer(Customer customer) {
    setState(() {
      _controller.text = '${customer.firstName} ${customer.lastName}';
    });
    _removeOverlay();
    _focusNode.unfocus();
    widget.onCustomerSelected(customer);
  }

  double _getTextFieldWidth() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300;
  }

  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          suffixIcon: _isSearching
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _searchResults = [];
                        });
                        _removeOverlay();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
        ),
        onChanged: _onSearchChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a customer';
          }
          return null;
        },
      ),
    );
  }
}