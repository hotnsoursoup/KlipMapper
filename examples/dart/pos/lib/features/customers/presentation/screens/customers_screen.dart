// lib/features/customers/presentation/screens/customers_screen.dart
// Primary customer management screen with searchable customer list, statistics dashboard, and CRUD operations. Implements Riverpod state management with advanced filtering, pagination, and responsive design.
// Usage: ACTIVE - Core screen accessed via main navigation menu for all customer management operations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../../core/widgets/loading_skeletons.dart';
import '../../../shared/data/models/customer_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../widgets/customer_list_item.dart';
import '../widgets/customer_details_dialog.dart';
import '../widgets/new_customer_dialog.dart';
// Assuming your provider exposes methods like createCustomer, updateCustomer, deleteCustomer, and setSortBy.
// Also assuming the provider's state is an object that holds the list of customers and derived stats.
import '../../providers/customers_provider.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();

  // --- State managed locally in the widget ---
  // Pagination
  late int _itemsPerPage;
  int _currentPage = 0;

  // Filter state
  String _selectedNameType = 'Last Name'; // 'First Name' or 'Last Name'
  String? _selectedLetter; // A-Z filter
  String _sortBy = 'name'; // Default sort
  bool _sortAscending = true; // Default sort direction

  @override
  void initState() {
    super.initState();
    // Add a listener to the search controller to update the UI on change
    _searchController.addListener(() {
      setState(() {
        _currentPage = 0; // Reset page when search query changes
      });
    });

    // Initialize items per page from settings
    _itemsPerPage = ref.read(generalSettingsProvider).defaultItemsPerPage;

    // Trigger initial data load.
    // It's often better to do this outside initState, but for fixing syntax, we'll keep it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initial fetch is handled by the provider's autoDispose nature or another mechanism.
      // This read is just to ensure it's initialized if not already.
      ref.read(customersMasterProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild the widget when customer data changes.
    final customersAsync = ref.watch(customersMasterProvider);

    return Scaffold(
      appBar: StandardAppHeader.withAddAction(
        title: 'Customers',
        addButtonLabel: 'New Customer',
        onAdd: () => _showNewCustomerDialog(),
        showSearch: true,
        onSearchChanged: (query) {
          // The listener in initState already handles calling setState.
          // No need to call it here again.
        },
        onSearchClear: () {
          _searchController.clear();
        },
        searchHint: 'Search customers...',
        searchValue: _searchController.text,
      ),
      body: Column(
        children: [
          // Stats row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            // Use the 'customersAsync' value to show stats
            child: customersAsync.when(
              data: (customerData) {
                // Assuming customerData has these properties.
                // You might need to calculate these from the customer list.
                final totalCustomers = customerData.length;
                const activeCustomers =
                    0; // Placeholder for active customer logic
                const totalRevenue = 0.0; // Placeholder for revenue logic

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Customers',
                        totalCustomers.toString(),
                        Icons.people_outline,
                        AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Active (30 days)',
                        activeCustomers.toString(), // Replace with actual data
                        Icons.trending_up,
                        AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Total Revenue',
                        '\$${totalRevenue.toStringAsFixed(0)}', // Replace with actual data
                        Icons.attach_money,
                        AppColors.serviceOrange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMembershipCard(),
                    ),
                  ],
                );
              },
              // Show loading skeletons or placeholders for stats while data is loading or in error state
              loading: () => const Row(
                children: [
                  Expanded(child: Skeleton(height: 80)),
                  SizedBox(width: 16),
                  Expanded(child: Skeleton(height: 80)),
                  SizedBox(width: 16),
                  Expanded(child: Skeleton(height: 80)),
                  SizedBox(width: 16),
                  Expanded(child: Skeleton(height: 80)),
                ],
              ),
              error: (_, __) =>
                  const Center(child: Text('Could not load stats')),
            ),
          ),
          const Divider(height: 1),
          // Customer Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Header Row
                Row(
                  children: [
                    Text('Filter Customers', style: AppTextStyles.headline3),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                                'Last Name', _selectedNameType == 'Last Name',
                                () {
                              setState(() {
                                _selectedNameType = 'Last Name';
                                _selectedLetter = null;
                              });
                            }),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                                'First Name', _selectedNameType == 'First Name',
                                () {
                              setState(() {
                                _selectedNameType = 'First Name';
                                _selectedLetter = null;
                              });
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildDropdown(
                      'Membership:',
                      'All Levels',
                      ['All Levels', 'Regular', 'Gold', 'Platinum', 'VIP'],
                      (value) {
                        // TODO: Implement membership filter logic
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sorting controls
                Row(
                  children: [
                    Text(
                      'Sort by:',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildSortButton('Name', 'name'),
                    const SizedBox(width: 8),
                    _buildSortButton('Total Spend', 'totalSpend'),
                    const SizedBox(width: 8),
                    _buildSortButton('Total Visits', 'totalVisits'),
                    const SizedBox(width: 8),
                    _buildSortButton('Last Visit', 'lastVisit'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLetterFilters(),
              ],
            ),
          ),
          const Divider(height: 1),
          // Customer list
          Expanded(
            child: customersAsync.when(
              loading: () => LoadingSkeletons.dataGridSkeleton(
                rowCount: 8,
                columnCount: 3,
              ),
              error: (error, stack) => Center(
                child: Text('Error loading customers: $error'),
              ),
              data: (allCustomers) {
                // Convert Map to List and apply all filtering and sorting locally
                final customers = _getFilteredAndSortedCustomers(allCustomers.values.toList());

                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('No customers found',
                            style: AppTextStyles.headline3
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text('Add your first customer to get started',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }

                // Calculate pagination
                final totalPages = (customers.length / _itemsPerPage).ceil();
                final startIndex = _currentPage * _itemsPerPage;
                final endIndex =
                    (startIndex + _itemsPerPage).clamp(0, customers.length);
                final paginatedCustomers =
                    customers.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: paginatedCustomers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final customer = paginatedCustomers[index];
                          // TODO: Get customer tickets from a separate provider
                          final tickets = [];

                          return CustomerListItem(
                            customer: customer,
                            totalSpent: tickets.fold(
                                0.0, (sum, t) => sum + (t.totalAmount ?? 0)),
                            visitCount: tickets.length,
                            lastVisit: tickets.isEmpty
                                ? null
                                : tickets.last.checkInTime,
                            onTap: () => _showCustomerDetails(customer),
                            onEdit: () => _editCustomer(customer),
                            onDelete: () => _deleteCustomer(customer),
                          );
                        },
                      ),
                    ),
                    if (totalPages > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border(top: BorderSide(color: AppColors.border)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _currentPage > 0
                                  ? () => setState(() => _currentPage--)
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            const SizedBox(width: 16),
                            Text('Page ${_currentPage + 1} of $totalPages',
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: _currentPage < totalPages - 1
                                  ? () => setState(() => _currentPage++)
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Customer> _getFilteredAndSortedCustomers(List<Customer> allCustomers) {
    var filteredCustomers = allCustomers;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filteredCustomers = filteredCustomers
          .where((c) =>
              c.fullName.toLowerCase().contains(query) ||
              (c.email?.toLowerCase().contains(query) ?? false) ||
              (c.phone?.contains(query) ?? false))
          .toList();
    }

    // Apply letter filter
    if (_selectedLetter != null) {
      filteredCustomers = filteredCustomers.where((c) {
        final name =
            _selectedNameType == 'First Name' ? c.firstName : c.lastName;
        return name.toUpperCase().startsWith(_selectedLetter!);
      }).toList();
    }

    // Apply sorting
    // NOTE: This is a simplified sort. For production, you'd handle different data types.
    filteredCustomers.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.fullName.compareTo(b.fullName);
          break;
        // Add cases for 'totalSpend', 'totalVisits', 'lastVisit'
        // These will require fetching the related ticket data first.
        default:
          comparison = a.fullName.compareTo(b.fullName);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredCustomers;
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // CORRECTED: Used .withValues(alpha: ) instead of .withValues()
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value,
                      style: AppTextStyles.headline3.copyWith(color: color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // CORRECTED: Used .withValues(alpha: )
              color: AppColors.servicePurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.card_membership,
                size: 24, color: AppColors.servicePurple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Memberships',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '', // TODO: Calculate membership breakdown
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.servicePurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => NewCustomerDialog(
        onSave: (customerData) async {
          // CORRECTED: Call the provider's notifier to create a customer
          await ref.read(customersMasterProvider.notifier).createCustomer(
              name: customerData['firstName'] ?? '',
              phone: customerData['phone'] ?? '');
        },
      ),
    );
  }

  void _showCustomerDetails(Customer customer) {
    // You might have a separate provider to manage the "selected customer" state
    // For now, just pass the data directly.
    showDialog(
      context: context,
      builder: (context) => CustomerDetailsDialog(
        customer: customer,
        // store: _store, // REMOVED: Pass ref or needed data directly
      ),
    );
  }

  void _editCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => NewCustomerDialog(
        customer: customer,
        onSave: (customerData) async {
          // CORRECTED: Call the provider's notifier to update the customer
          final updatedCustomer = customer.copyWith(
            firstName: customerData['firstName'],
            lastName: customerData['lastName'],
            phone: customerData['phone'],
            email: customerData['email'],
            address: customerData['address'],
            city: customerData['city'],
            state: customerData['state'],
            zipCode: customerData['zipCode'],
            dateOfBirth: customerData['dateOfBirth'], // Pass DateTime directly
            gender: customerData['gender'],
            notes: customerData['notes'],
            allergies: customerData['allergies'],
            emailOptIn: customerData['emailOptIn'],
            smsOptIn: customerData['smsOptIn'],
          );
          await ref
              .read(customersMasterProvider.notifier)
              .updateCustomer(updatedCustomer);
        },
      ),
    );
  }

  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        // CORRECTED: Used customer.fullName for consistency
        content: Text('Are you sure you want to delete ${customer.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // CORRECTED: Call the provider's notifier to delete the customer
              ref
                  .read(customersMasterProvider.notifier)
                  .deleteCustomer(customer.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        // Simplified dropdown without the custom TextMeasurementUtils
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(

            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppTextStyles.labelLarge
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildLetterFilters() {
    const letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by $_selectedNameType:',
          style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            _buildLetterButton('All', _selectedLetter == null),
            ...letters.map((letter) =>
                _buildLetterButton(letter, _selectedLetter == letter)),
          ],
        ),
      ],
    );
  }

  Widget _buildLetterButton(String letter, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLetter = letter == 'All' ? null : letter;
          _currentPage = 0; // Reset pagination
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border),
        ),
        child: Center(
          child: Text(
            letter,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(String label, String sortType) {
    // CORRECTED: Replaced Observer with local state check
    final isSelected = _sortBy == sortType;

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            // If it's already selected, just flip the direction
            _sortAscending = !_sortAscending;
          } else {
            // Otherwise, set the new sort type and default to ascending
            _sortBy = sortType;
            _sortAscending = true;
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// A simple skeleton widget for loading states
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
