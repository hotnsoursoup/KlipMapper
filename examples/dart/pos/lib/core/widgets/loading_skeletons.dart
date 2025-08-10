// lib/core/widgets/loading_skeletons.dart
// Collection of animated skeleton loading widgets providing visual placeholders during data fetching. Includes specialized skeletons for tickets, appointments, data grids, and generic cards with shimmer animations.
// Usage: ACTIVE - Used throughout the app for improved loading UX in lists, tables, and card layouts while data is being fetched
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Collection of loading skeleton widgets for instant UI feedback
/// These provide visual placeholders while data is loading in the background
class LoadingSkeletons {
  LoadingSkeletons._();

  /// Skeleton for ticket list items
  static Widget ticketListSkeleton({int itemCount = 8}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => _TicketItemSkeleton(),
    );
  }

  /// Skeleton for appointment list items
  static Widget appointmentListSkeleton({int itemCount = 6}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => _AppointmentItemSkeleton(),
    );
  }

  /// Skeleton for data grid/table
  static Widget dataGridSkeleton({
    int rowCount = 10,
    int columnCount = 4,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header row
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: _ShimmerBox(
                      height: 16,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Data rows
          ...List.generate(
            rowCount,
            (rowIndex) => Container(
              height: 56,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: List.generate(
                  columnCount,
                  (colIndex) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: _ShimmerBox(
                        height: 16,
                        width: colIndex == 0 ? 80 : double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generic card skeleton
  static Widget cardSkeleton({
    double height = 120,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) {
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(height: 16, width: 120),
            const SizedBox(height: 8),
            _ShimmerBox(height: 14, width: 200),
            const SizedBox(height: 8),
            _ShimmerBox(height: 14, width: 160),
            const Spacer(),
            Row(
              children: [
                _ShimmerBox(height: 12, width: 80),
                const Spacer(),
                _ShimmerBox(height: 12, width: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for individual ticket list items
class _TicketItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ShimmerBox(height: 16, width: 80), // Ticket number
                const Spacer(),
                _ShimmerBox(height: 20, width: 60), // Status badge
              ],
            ),
            const SizedBox(height: 12),
            _ShimmerBox(height: 18, width: 160), // Customer name
            const SizedBox(height: 8),
            Row(
              children: [
                _ShimmerBox(height: 14, width: 100), // Service info
                const Spacer(),
                _ShimmerBox(height: 14, width: 80), // Time/amount
              ],
            ),
            const SizedBox(height: 8),
            _ShimmerBox(height: 12, width: 120), // Additional info
          ],
        ),
      ),
    );
  }
}

/// Skeleton for individual appointment list items
class _AppointmentItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Time section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(height: 16, width: 60), // Start time
                const SizedBox(height: 4),
                _ShimmerBox(height: 14, width: 40), // Duration
              ],
            ),
            const SizedBox(width: 16),
            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(height: 16, width: 140), // Customer name
                  const SizedBox(height: 8),
                  _ShimmerBox(height: 14, width: 100), // Service
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ShimmerBox(height: 12, width: 80), // Technician
                      const Spacer(),
                      _ShimmerBox(height: 20, width: 70), // Status
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated shimmer box that represents loading content
class _ShimmerBox extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const _ShimmerBox({
    required this.height,
    required this.width,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ),);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
        color: AppColors.surfaceLight,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [
                  AppColors.surfaceLight,
                  Colors.white.withValues(alpha: 0.8),
                  AppColors.surfaceLight,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(_animation.value - 1, 0),
                end: Alignment(_animation.value, 0),
              ),
            ),
          );
        },
      ),
    );
  }
}