// lib/core/widgets/pagination_controls.dart
// Reusable pagination controls widget with items per page selector, page navigation, and status display. Provides consistent pagination UI across data tables and lists.
// Usage: ACTIVE - Used in appointment lists, customer tables, employee management, and all paginated data views throughout the application
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A reusable pagination controls widget.
/// 
/// This widget is inherently dynamic (receives changing pagination data),
/// so UI Bible const optimization don't apply here. Keeping it simple.
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final String paginationInfo;
  final bool canGoToPreviousPage;
  final bool canGoToNextPage;
  final VoidCallback? onFirstPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onLastPage;
  final Function(int)? onItemsPerPageChanged;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.paginationInfo,
    required this.canGoToPreviousPage,
    required this.canGoToNextPage,
    this.onFirstPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onLastPage,
    this.onItemsPerPageChanged,
    this.itemsPerPage = 25,
    this.itemsPerPageOptions = const [10, 25, 50, 100],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Items per page selector
          Row(
            children: [
              Text(
                'Items per page:',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(

                value: itemsPerPage,
                underline: const SizedBox(),
                items: itemsPerPageOptions.map((items) {
                  return DropdownMenuItem<int>(
                    value: items,
                    child: Text(
                      items.toString(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: onItemsPerPageChanged != null
                    ? (value) => onItemsPerPageChanged!(value!)
                    : null,
              ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Pagination info
          Text(
            paginationInfo,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const Spacer(),
          
          // Navigation controls
          Row(
            children: [
              // First page
              IconButton(
                onPressed: canGoToPreviousPage ? onFirstPage : null,
                icon: Icon(
                  Icons.first_page,
                  color: canGoToPreviousPage ? AppColors.primaryBlue : AppColors.textLight,
                ),
                tooltip: 'First page',
              ),
              
              // Previous page
              IconButton(
                onPressed: canGoToPreviousPage ? onPreviousPage : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: canGoToPreviousPage ? AppColors.primaryBlue : AppColors.textLight,
                ),
                tooltip: 'Previous page',
              ),
              
              // Page indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.surface,
                ),
                child: Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Next page
              IconButton(
                onPressed: canGoToNextPage ? onNextPage : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: canGoToNextPage ? AppColors.primaryBlue : AppColors.textLight,
                ),
                tooltip: 'Next page',
              ),
              
              // Last page
              IconButton(
                onPressed: canGoToNextPage ? onLastPage : null,
                icon: Icon(
                  Icons.last_page,
                  color: canGoToNextPage ? AppColors.primaryBlue : AppColors.textLight,
                ),
                tooltip: 'Last page',
              ),
            ],
          ),
        ],
      ),
    );
  }
}