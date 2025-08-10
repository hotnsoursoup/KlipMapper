// lib/features/customers/providers/customers_provider.dart
// Comprehensive customer management providers with search, filtering, sorting, caching, and ticket integration following MobX store patterns.
// Includes customer statistics, revenue tracking, membership analysis, and complete CRUD operations with 10-minute cache TTL.
// Usage: ACTIVE - Primary customer state management for customers screen, analytics, and related features

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/data/models/customer_model.dart';
import '../../shared/data/models/ticket_model.dart';
import '../../shared/data/repositories/drift_customer_repository.dart';
import '../../shared/data/repositories/drift_ticket_repository.dart';
import '../../../core/utils/app_logger.dart';

part 'customers_provider.g.dart';
part 'customers_provider.freezed.dart';

// ========== REPOSITORY PROVIDERS ==========

@Riverpod(keepAlive: true)
DriftCustomerRepository customerRepository(Ref ref) {
  return DriftCustomerRepository.instance;
}

@Riverpod(keepAlive: true)
DriftTicketRepository ticketRepository(Ref ref) {
  return DriftTicketRepository.instance;
}

// ========== MAIN CUSTOMERS PROVIDER ==========

/// Master customers provider with comprehensive state management and 10-minute cache TTL
@Riverpod(keepAlive: true)
class CustomersMaster extends _$CustomersMaster {
  // Cache TTL - 10 minutes (customers don't change frequently)
  static const Duration _cacheTtl = Duration(minutes: 10);
  
  DateTime? _lastLoaded;
  Map<String, List<Ticket>> _customerTickets = {};
  
  @override
  Future<Map<String, Customer>> build() async {
    return _loadCustomers();
  }
  
  /// Check if should use existing data based on cache TTL
  bool _shouldUseExistingData() {
    return _lastLoaded != null && DateTime.now().difference(_lastLoaded!) < _cacheTtl;
  }
  
  /// Load customers from database with cache management
  Future<Map<String, Customer>> _loadCustomers({bool forceRefresh = false}) async {
    try {
      // Use cached data if available and not expired (unless force refresh)
      if (!forceRefresh && _shouldUseExistingData()) {
        final currentData = state.value;
        if (currentData != null && currentData.isNotEmpty) {
          AppLogger.logInfo('CustomersMaster: Using cached data (age: ${DateTime.now().difference(_lastLoaded!).inMinutes} minutes)');
          return currentData;
        }
      }
      
      final customerRepo = ref.read(customerRepositoryProvider);
      final ticketRepo = ref.read(ticketRepositoryProvider);
      
      await customerRepo.initialize();
      await ticketRepo.initialize();
      
      final customers = await customerRepo.getCustomers();
      final customersMap = {for (final customer in customers) customer.id: customer};
      
      AppLogger.logInfo('CustomersMaster: Loaded ${customers.length} customers from database');
      
      // Pre-load tickets for all customers
      _customerTickets = {};
      int totalTickets = 0;
      for (final customer in customers) {
        final tickets = await ticketRepo.getTicketsByCustomerId(customer.id);
        _customerTickets[customer.id] = tickets;
        totalTickets += tickets.length;
      }
      
      AppLogger.logInfo('CustomersMaster: Loaded $totalTickets total tickets across all customers');
      
      // Update cache timestamp
      _lastLoaded = DateTime.now();
      
      return customersMap;
    } catch (e, stack) {
      AppLogger.logError('Failed to load customers', e, stack);
      throw Exception('Failed to load customers: $e');
    }
  }
  
  /// Invalidate cache and force refresh
  void invalidateCache() {
    _lastLoaded = null;
  }
  
  /// Refresh customers by bypassing cache
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadCustomers(forceRefresh: true));
  }
  
  /// Create a new customer
  Future<Customer> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? notes,
  }) async {
    try {
      final repo = ref.read(customerRepositoryProvider);
      final customer = await repo.createCustomerLegacy(
        name: name,
        phone: phone,
        email: email,
        notes: notes,
      );
      
      // Update local state
      state.whenData((customers) {
        final updated = Map<String, Customer>.from(customers);
        updated[customer.id] = customer;
        state = AsyncValue.data(updated);
      });
      
      // Initialize empty tickets for new customer
      _customerTickets[customer.id] = [];
      
      // Update cache timestamp
      _lastLoaded = DateTime.now();
      
      AppLogger.logInfo('CustomersMaster: Created new customer ${customer.name}');
      return customer;
    } catch (e, stack) {
      AppLogger.logError('Failed to create customer', e, stack);
      rethrow;
    }
  }
  
  /// Update an existing customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      final repo = ref.read(customerRepositoryProvider);
      await repo.updateCustomer(customer);
      
      // Update local state
      state.whenData((customers) {
        final updated = Map<String, Customer>.from(customers);
        updated[customer.id] = customer;
        state = AsyncValue.data(updated);
      });
      
      // Update cache timestamp
      _lastLoaded = DateTime.now();
      
      AppLogger.logInfo('CustomersMaster: Updated customer ${customer.name}');
    } catch (e, stack) {
      AppLogger.logError('Failed to update customer', e, stack);
      rethrow;
    }
  }
  
  /// Delete a customer
  Future<void> deleteCustomer(String customerId) async {
    try {
      final repo = ref.read(customerRepositoryProvider);
      await repo.deleteCustomer(customerId);
      
      // Update local state
      state.whenData((customers) {
        final updated = Map<String, Customer>.from(customers);
        updated.remove(customerId);
        state = AsyncValue.data(updated);
      });
      
      // Remove customer tickets
      _customerTickets.remove(customerId);
      
      // Update cache timestamp
      _lastLoaded = DateTime.now();
      
      AppLogger.logInfo('CustomersMaster: Deleted customer $customerId');
    } catch (e, stack) {
      AppLogger.logError('Failed to delete customer', e, stack);
      rethrow;
    }
  }
  
  /// Get customer tickets (from cache)
  List<Ticket> getCustomerTickets(String customerId) {
    return _customerTickets[customerId] ?? [];
  }
  
  /// Load customer tickets (refresh from database)
  Future<List<Ticket>> loadCustomerTickets(String customerId) async {
    try {
      final ticketRepo = ref.read(ticketRepositoryProvider);
      final tickets = await ticketRepo.getTicketsByCustomerId(customerId);
      _customerTickets[customerId] = tickets;
      
      AppLogger.logInfo('CustomersMaster: Loaded ${tickets.length} tickets for customer $customerId');
      return tickets;
    } catch (e, stack) {
      AppLogger.logError('Failed to load customer tickets', e, stack);
      return [];
    }
  }
}

// ========== FILTERING AND SORTING PROVIDER ==========

/// Customer filter and search state provider
@riverpod
class CustomerFilters extends _$CustomerFilters {
  @override
  CustomerFiltersState build() {
    return const CustomerFiltersState();
  }
  
  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    AppLogger.logInfo('CustomerFilters: Search query updated to: "$query"');
  }
  
  /// Set membership filter
  void setMembershipFilter(String? level) {
    state = state.copyWith(membershipFilter: level);
    AppLogger.logInfo('CustomerFilters: Membership filter updated to: ${level ?? "All"}');
  }
  
  /// Set date range filter
  void setDateFilter(DateTimeRange? range) {
    state = state.copyWith(dateFilter: range);
    AppLogger.logInfo('CustomerFilters: Date filter updated');
  }
  
  /// Set name filter (first/last name and letter)
  void setNameFilter(String filterType, String? letter) {
    state = state.copyWith(
      nameFilterType: filterType,
      letterFilter: letter,
    );
    AppLogger.logInfo('CustomerFilters: Name filter updated: $filterType - ${letter ?? "All"}');
  }
  
  /// Set sort configuration
  void setSortBy(String sortType) {
    final currentSort = state.sortBy;
    final isAscending = currentSort == sortType ? !state.sortAscending : (sortType == 'name');
    
    state = state.copyWith(
      sortBy: sortType,
      sortAscending: isAscending,
    );
    
    AppLogger.logInfo('CustomerFilters: Sort updated: $sortType (${isAscending ? "ascending" : "descending"})');
  }
  
  /// Clear all filters
  void clearFilters() {
    state = const CustomerFiltersState();
    AppLogger.logInfo('CustomerFilters: All filters cleared');
  }
}

// ========== FILTERED AND SORTED CUSTOMERS ==========

/// Provider for filtered and sorted customers list
@riverpod
List<Customer> filteredCustomers(Ref ref) {
  final customersAsync = ref.watch(customersMasterProvider);
  final filters = ref.watch(customerFiltersProvider);
  
  return customersAsync.when(
    data: (customersMap) {
      var customers = customersMap.values.toList();
      
      // Apply search filter
      if (filters.searchQuery.isNotEmpty) {
        final query = filters.searchQuery.toLowerCase();
        customers = customers.where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              (customer.phone?.toLowerCase().contains(query) ?? false) ||
              (customer.email?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
      
      // Apply membership filter
      if (filters.membershipFilter != null) {
        customers = customers.where((customer) => 
            customer.membershipLevel == filters.membershipFilter).toList();
      }
      
      // Apply name letter filter
      if (filters.letterFilter != null) {
        customers = customers.where((customer) {
          final nameParts = customer.name.trim().split(' ');
          String nameToFilter;
          
          if (filters.nameFilterType == 'First Name') {
            nameToFilter = nameParts.isNotEmpty ? nameParts.first : '';
          } else {
            // Last Name
            nameToFilter = nameParts.length > 1 ? nameParts.last : nameParts.first;
          }
          
          return nameToFilter.toUpperCase().startsWith(filters.letterFilter!);
        }).toList();
      }
      
      // Apply sorting
      _applySorting(customers, filters, ref);
      
      return customers;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Apply sorting to customers list
void _applySorting(List<Customer> customers, CustomerFiltersState filters, Ref ref) {
  final customersMaster = ref.read(customersMasterProvider.notifier);
  
  switch (filters.sortBy) {
    case 'name':
      if (filters.nameFilterType == 'First Name') {
        customers.sort((a, b) {
          final aFirstName = a.name.trim().split(' ').first;
          final bFirstName = b.name.trim().split(' ').first;
          final comparison = aFirstName.compareTo(bFirstName);
          return filters.sortAscending ? comparison : -comparison;
        });
      } else {
        // Sort by last name
        customers.sort((a, b) {
          final aNameParts = a.name.trim().split(' ');
          final bNameParts = b.name.trim().split(' ');
          final aLastName = aNameParts.length > 1 ? aNameParts.last : aNameParts.first;
          final bLastName = bNameParts.length > 1 ? bNameParts.last : bNameParts.first;
          final comparison = aLastName.compareTo(bLastName);
          return filters.sortAscending ? comparison : -comparison;
        });
      }
      break;
    
    case 'totalSpend':
      customers.sort((a, b) {
        final aTickets = customersMaster.getCustomerTickets(a.id);
        final bTickets = customersMaster.getCustomerTickets(b.id);
        final aTotal = aTickets.fold(0.0, (sum, ticket) => sum + (ticket.totalAmount ?? 0));
        final bTotal = bTickets.fold(0.0, (sum, ticket) => sum + (ticket.totalAmount ?? 0));
        final comparison = aTotal.compareTo(bTotal);
        return filters.sortAscending ? comparison : -comparison;
      });
      break;
    
    case 'totalVisits':
      customers.sort((a, b) {
        final aVisits = customersMaster.getCustomerTickets(a.id).length;
        final bVisits = customersMaster.getCustomerTickets(b.id).length;
        final comparison = aVisits.compareTo(bVisits);
        return filters.sortAscending ? comparison : -comparison;
      });
      break;
    
    case 'lastVisit':
      customers.sort((a, b) {
        final aTickets = customersMaster.getCustomerTickets(a.id);
        final bTickets = customersMaster.getCustomerTickets(b.id);
        
        DateTime? aLastVisit;
        DateTime? bLastVisit;
        
        if (aTickets.isNotEmpty) {
          aLastVisit = aTickets.map((t) => t.checkInTime).reduce((a, b) => a.isAfter(b) ? a : b);
        }
        
        if (bTickets.isNotEmpty) {
          bLastVisit = bTickets.map((t) => t.checkInTime).reduce((a, b) => a.isAfter(b) ? a : b);
        }
        
        // Handle null values (customers with no visits)
        if (aLastVisit == null && bLastVisit == null) return 0;
        if (aLastVisit == null) return filters.sortAscending ? 1 : -1;
        if (bLastVisit == null) return filters.sortAscending ? -1 : 1;
        
        final comparison = aLastVisit.compareTo(bLastVisit);
        return filters.sortAscending ? comparison : -comparison;
      });
      break;
  }
}

// ========== CUSTOMER STATISTICS ==========

/// Provider for comprehensive customer statistics
@riverpod
CustomerStatistics customerStatistics(Ref ref) {
  final customersAsync = ref.watch(customersMasterProvider);
  
  return customersAsync.when(
    data: (customersMap) {
      final customers = customersMap.values.toList();
      final customersMaster = ref.read(customersMasterProvider.notifier);
      
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      
      final totalCount = customers.length;
      final activeCount = customers.where((customer) {
        final tickets = customersMaster.getCustomerTickets(customer.id);
        return tickets.any((ticket) => ticket.checkInTime.isAfter(thirtyDaysAgo));
      }).length;
      
      // Calculate total revenue
      double totalRevenue = 0.0;
      for (final customer in customers) {
        final tickets = customersMaster.getCustomerTickets(customer.id);
        totalRevenue += tickets.fold(0.0, (sum, ticket) => sum + (ticket.totalAmount ?? 0));
      }
      
      // Membership breakdown
      final membershipBreakdown = <String, int>{};
      for (final customer in customers) {
        final level = customer.membershipLevel;
        membershipBreakdown[level] = (membershipBreakdown[level] ?? 0) + 1;
      }
      
      return CustomerStatistics(
        totalCount: totalCount,
        activeCount: activeCount,
        inactiveCount: totalCount - activeCount,
        totalRevenue: totalRevenue,
        membershipBreakdown: membershipBreakdown,
      );
    },
    loading: () => const CustomerStatistics(),
    error: (_, __) => const CustomerStatistics(),
  );
}

// ========== SELECTED CUSTOMER PROVIDER ==========

/// Provider for selected customer state and details
@riverpod
class SelectedCustomer extends _$SelectedCustomer {
  @override
  Customer? build() {
    return null;
  }
  
  /// Select a customer
  void selectCustomer(Customer? customer) {
    state = customer;
    if (customer != null) {
      AppLogger.logInfo('SelectedCustomer: Selected ${customer.name}');
      // Trigger loading customer tickets
      ref.read(customersMasterProvider.notifier).loadCustomerTickets(customer.id);
    }
  }
  
  /// Clear selection
  void clearSelection() {
    state = null;
  }
}

/// Provider for selected customer tickets with date filtering
@riverpod
List<Ticket> selectedCustomerTickets(Ref ref) {
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final filters = ref.watch(customerFiltersProvider);
  
  if (selectedCustomer == null) return [];
  
  final customersMaster = ref.read(customersMasterProvider.notifier);
  final tickets = customersMaster.getCustomerTickets(selectedCustomer.id);
  
  // Apply date filter if set
  if (filters.dateFilter != null) {
    return tickets.where((ticket) {
      return ticket.checkInTime.isAfter(filters.dateFilter!.start) &&
          ticket.checkInTime.isBefore(filters.dateFilter!.end.add(const Duration(days: 1)));
    }).toList();
  }
  
  return tickets;
}

/// Provider for selected customer analytics
@riverpod
SelectedCustomerAnalytics selectedCustomerAnalytics(Ref ref) {
  final tickets = ref.watch(selectedCustomerTicketsProvider);
  
  if (tickets.isEmpty) {
    return const SelectedCustomerAnalytics();
  }
  
  final totalSpent = tickets.fold(0.0, (sum, ticket) => sum + (ticket.totalAmount ?? 0));
  final visitCount = tickets.length;
  final averageSpent = visitCount > 0 ? totalSpent / visitCount : 0.0;
  
  // Find last visit
  final sortedTickets = tickets.toList()
    ..sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
  final lastVisit = sortedTickets.isNotEmpty ? sortedTickets.first.checkInTime : null;
  
  // Service frequency analysis
  final serviceFrequency = <String, int>{};
  for (final ticket in tickets) {
    for (final service in ticket.services) {
      // Use service category name if available, otherwise use service name
      final key = service.categoryId?.toString() ?? service.name;
      serviceFrequency[key] = (serviceFrequency[key] ?? 0) + 1;
    }
  }
  
  return SelectedCustomerAnalytics(
    totalSpent: totalSpent,
    visitCount: visitCount,
    averageSpent: averageSpent,
    lastVisit: lastVisit,
    serviceFrequency: serviceFrequency,
  );
}

/// Provider for a single customer by ID
@riverpod
Customer? customerById(Ref ref, String customerId) {
  final customersAsync = ref.watch(customersMasterProvider);
  
  return customersAsync.when(
    data: (customersMap) => customersMap[customerId],
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for customer count
@riverpod
int customerCount(Ref ref) {
  final customersAsync = ref.watch(customersMasterProvider);
  
  return customersAsync.when(
    data: (customersMap) => customersMap.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Provider for recent customers
@riverpod
List<Customer> recentCustomers(Ref ref, {int limit = 10}) {
  final customersAsync = ref.watch(customersMasterProvider);
  
  return customersAsync.when(
    data: (customersMap) {
      final customers = customersMap.values.toList();
      customers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return customers.take(limit).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// ========== STATE MODELS ==========

@freezed
class CustomerFiltersState with _$CustomerFiltersState {
  const factory CustomerFiltersState({
    @Default('') String searchQuery,
    String? membershipFilter,
    DateTimeRange? dateFilter,
    @Default('Last Name') String nameFilterType, // 'First Name' or 'Last Name'
    String? letterFilter, // A-Z filter
    @Default('name') String sortBy, // 'name', 'totalSpend', 'totalVisits', 'lastVisit'
    @Default(true) bool sortAscending,
  }) = _CustomerFiltersState;
}

@freezed
class CustomerStatistics with _$CustomerStatistics {
  const factory CustomerStatistics({
    @Default(0) int totalCount,
    @Default(0) int activeCount,
    @Default(0) int inactiveCount,
    @Default(0.0) double totalRevenue,
    @Default({}) Map<String, int> membershipBreakdown,
  }) = _CustomerStatistics;
}

@freezed
class SelectedCustomerAnalytics with _$SelectedCustomerAnalytics {
  const factory SelectedCustomerAnalytics({
    @Default(0.0) double totalSpent,
    @Default(0) int visitCount,
    @Default(0.0) double averageSpent,
    DateTime? lastVisit,
    @Default({}) Map<String, int> serviceFrequency,
  }) = _SelectedCustomerAnalytics;
}