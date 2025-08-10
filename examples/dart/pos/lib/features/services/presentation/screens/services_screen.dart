// lib/features/services/presentation/screens/services_screen.dart
// Service catalog management screen with category organization, service CRUD operations, and pricing management. Features privileged operations for service configuration and category color customization.
// Usage: ACTIVE - Core screen for service catalog management and pricing configuration

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart' as db;
import '../../../shared/data/models/service_model.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../widgets/dynamic_service_form_dialog.dart';
import '../widgets/service_category_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/privileged_operations.dart';
import '../../providers/services_provider.dart'; // Riverpod providers

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to the search query provider to update the text controller
    // This ensures the controller stays in sync if the state is changed from elsewhere
    final initialQuery = ref.read(serviceSearchQueryProvider);
    _searchController.text = initialQuery;

    _searchController.addListener(() {
      ref
          .read(serviceSearchQueryProvider.notifier)
          .setQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppHeader.withNavigation(
        title: 'Services',
        navigationLabel: 'Add Category',
        navigationIcon: Icons.category,
        onNavigate: () => _showCategoryDialog(),
        addButtonLabel: 'Add Service',
        onAdd: () => _showServiceDialog(null),
        showSearch: true,
        onSearchChanged: (query) {
          // The listener in initState already updates the provider
        },
        onSearchClear: () {
          _searchController.clear();
        },
        searchHint: 'Search services...',
        searchValue: _searchController.text,
      ),
      body: Column(
        children: [
          _buildCategoryPills(),
          Expanded(child: _buildServicesList()),
        ],
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categoriesAsync = ref.watch(serviceCategoriesMasterProvider);
    final groupedServices = ref.watch(servicesGroupedByCategoryProvider);
    final selectedCategoryId = ref.watch(serviceCategoryFilterProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryPill(
                    category: null, // Represents "All"
                    isSelected: selectedCategoryId == null,
                    onTap: () => ref
                        .read(serviceCategoryFilterProvider.notifier)
                        .setCategory(null),
                    serviceCount: ref.watch(activeServicesProvider).length,
                  ),
                  ...categories.map((category) {
                    final categoryId = category.id;
                    return _buildCategoryPill(
                      category: category,
                      isSelected: selectedCategoryId == categoryId,
                      onTap: () => ref
                          .read(serviceCategoryFilterProvider.notifier)
                          .setCategory(categoryId),
                      serviceCount:
                          groupedServices.asData?.value[categoryId]?.length ??
                              0,
                    );
                  }),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: LinearProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading categories: $e')),
      ),
    );
  }

  Widget _buildServicesList() {
    final searchQuery = ref.watch(serviceSearchQueryProvider);
    final selectedCategoryId = ref.watch(serviceCategoryFilterProvider);

    // If searching, show a flat, filtered list
    if (searchQuery.isNotEmpty) {
      return _buildFilteredList(searchQuery);
    }

    // If a category is selected, show services for that category
    if (selectedCategoryId != null) {
      final services =
          ref.watch(servicesByCategoryProvider(selectedCategoryId));
      final categoryAsync = ref.watch(serviceCategoriesMasterProvider);
      return categoryAsync.when(
        data: (cats) {
          final category = cats.firstWhere(
              (c) => c.id == selectedCategoryId,
              orElse: () => db.ServiceCategory(id: 0, name: 'Unknown'));
          return _buildSingleCategoryList(services, category);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      );
    }

    // Otherwise, show all services grouped by category
    return _buildGroupedList();
  }

  Widget _buildFilteredList(String query) {
    final filter = ServiceFilter(search: query);
    final services = ref.watch(servicesByFilterProvider(filter));

    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No services found for "$query"',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return _buildDualColumnServiceList(services, 'Search Results');
  }

  Widget _buildGroupedList() {
    final categoriesAsync = ref.watch(serviceCategoriesMasterProvider);
    final groupedServicesAsync = ref.watch(servicesGroupedByCategoryProvider);

    // Combine the async values to handle loading/error states together
    if (categoriesAsync.isLoading || groupedServicesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (categoriesAsync.hasError || groupedServicesAsync.hasError) {
      return const Center(child: Text('Error loading services.'));
    }

    final categories = categoriesAsync.value!;
    final servicesByCategory = groupedServicesAsync.value!;

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No service categories found',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showCategoryDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add First Category'),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            final categoryId = category.id;
            final services = servicesByCategory[categoryId] ?? [];
            if (services.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildModernCategoryCard(category, services),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSingleCategoryList(
      List<Service> services, db.ServiceCategory category) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: _buildModernCategoryCard(category, services),
      ),
    );
  }

  Widget _buildModernCategoryCard(
      db.ServiceCategory category, List<Service> services) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: category.color != null && category.color!.startsWith('#')
                        ? Color(int.parse(category.color!.substring(1), radix: 16) | 0xFF000000)
                        : (category.color != null
                            ? Color(int.tryParse(category.color!) ?? 0xFF9E9E9E)
                            : const Color(0xFF9E9E9E)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: AppTextStyles.headline3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${services.length} services',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => _showServiceDialogForCategory(category),
                  icon: Icon(Icons.add, color: AppColors.primaryBlue),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                    minimumSize: const Size(36, 36),
                  ),
                  tooltip: 'Add Service',
                ),
              ],
            ),
          ),
          // Services Grid
          if (services.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.design_services_outlined,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No services in this category',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildServicesGrid(services),
            ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(List<Service> services) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800
            ? 3
            : (constraints.maxWidth > 500 ? 2 : 1);
        final childAspectRatio = constraints.maxWidth > 800 ? 3.5 : 3.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildModernServiceCard(services[index]);
          },
        );
      },
    );
  }

  Widget _buildModernServiceCard(Service service) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => _showServiceDialog(service),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showServiceDialog(service);
                      } else if (value == 'delete') {
                        _deleteService(service);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red))),
                    ],
                    child: Icon(Icons.more_vert,
                        size: 18, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '\$${service.price.toStringAsFixed(0)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${service.durationMinutes}m',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildDualColumnServiceList(List<Service> services, String title) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '$title (${services.length})',
                style: AppTextStyles.headline3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildServicesGrid(services),
          ],
        ),
      ),
    );
  }

  void _showServiceDialog(Service? service) async {
    final categories = await ref.read(serviceCategoriesMasterProvider.future);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => DynamicServiceFormDialog(
        service: service,
        categories: categories,
        onSave: (name, categoryId, price, duration) {
          final newOrUpdatedService = Service(
            id: service?.id.toString() ?? '',
            name: name,
            description: service?.description ?? '',
            basePrice: price,
            durationMinutes: duration,
            categoryId: categoryId,
            isActive: true,
            createdAt: service?.createdAt ?? DateTime.now(),
            isActive: service?.isActive ?? true,
            createdAt: service?.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
          );

          if (service == null) {
            ref
                .read(servicesMasterProvider.notifier)
                .addService(newOrUpdatedService);
          } else {
            ref
                .read(servicesMasterProvider.notifier)
                .updateService(newOrUpdatedService);
          }
        },
      ),
    );
  }

  void _showServiceDialogForCategory(db.ServiceCategory category) async {
    final categories = await ref.read(serviceCategoriesMasterProvider.future);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => DynamicServiceFormDialog(
        categories: categories,
        preselectedCategoryId: category.id,
        onSave: (name, categoryId, price, duration) {
          final newService = Service(
            id: '',
            name: name,
            description: '',
            basePrice: price,
            durationMinutes: duration,
            isActive: true,
            createdAt: DateTime.now(),
            categoryId: categoryId,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          ref.read(servicesMasterProvider.notifier).addService(newService);
        },
      ),
    );
  }

  void _deleteService(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(servicesMasterProvider.notifier)
                  .deleteService(service.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog() async {
    showDialog(
      context: context,
      builder: (context) => ServiceCategoryDialog(
        onSave: (name, color, icon) {
          // Assuming your provider's addCategory takes these params
          // You might need to adjust this based on the actual signature
          ref
              .read(serviceCategoriesMasterProvider.notifier)
              .addCategory(name, color.value.toRadixString(16));
        },
      ),
    );
  }

  Widget _buildCategoryPill({
    required db.ServiceCategory? category,
    required bool isSelected,
    required VoidCallback onTap,
    required int serviceCount,
  }) {
    final bool isAllCategory = category == null;
    final String name = isAllCategory ? 'All' : category.name;
    final Color pillColor = isAllCategory
        ? AppColors.primaryBlue
        : (category.color != null && category.color!.startsWith('#')
            ? Color(int.parse(category.color!.substring(1), radix: 16) | 0xFF000000)
            : (category.color != null
                ? Color(int.tryParse(category.color!) ?? AppColors.primaryBlue.value)
                : AppColors.primaryBlue));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? pillColor : pillColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: pillColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : pillColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                serviceCount.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? Colors.white : pillColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
