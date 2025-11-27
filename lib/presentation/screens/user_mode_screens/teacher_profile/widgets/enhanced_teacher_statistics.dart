import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_statistics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced teacher statistics widget with better error handling and loading states
class EnhancedTeacherStatistics extends ConsumerWidget {
  const EnhancedTeacherStatistics({
    super.key,
    required this.teacherId,
    this.showLabels = true,
    this.compact = false,
  });

  final String teacherId;
  final bool showLabels;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(teacherStatisticsProvider(teacherId));
        final notifier =
            ref.read(teacherStatisticsNotifierProvider(teacherId).notifier);

        // Show loading state
        if (state.isLoading && !state.hasData) {
          return _buildLoadingState(context);
        }

        // Show error state with retry option
        if (state.hasErrors && !state.hasData) {
          return _buildErrorState(context, ref, notifier);
        }

        // Show statistics with partial loading support
        return _buildStatisticsGrid(context, state, notifier);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (index) => _buildStatItemSkeleton(theme)),
    );
  }

  Widget _buildStatItemSkeleton(ThemeData theme) {
    return Column(
      children: [
        ModernSkeleton(
          width: 40,
          height: 40,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 8),
        ModernSkeleton(width: 30, height: 16),
        if (showLabels) ...[
          const SizedBox(height: 4),
          ModernSkeleton(width: 50, height: 12),
        ],
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    TeacherStatisticsNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to load statistics',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => notifier.clearCacheAndReload(),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context,
    TeacherStatisticsState state,
    TeacherStatisticsNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Main statistics row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              'Events',
              state.statistics.totalEvents.toString(),
              Icons.event,
              state.isLoadingStat('events'),
              state.getErrorForStat('events'),
              () => _loadIndividualStat(notifier, 'events'),
            ),
            _buildStatItem(
              context,
              'Rating',
              state.statistics.averageRating > 0
                  ? state.statistics.averageRating.toStringAsFixed(1)
                  : 'N/A',
              Icons.star,
              state.isLoadingStat('comments'),
              state.getErrorForStat('comments'),
              () => _loadIndividualStat(notifier, 'comments'),
            ),
            _buildStatItem(
              context,
              'Reviews',
              state.statistics.totalReviews.toString(),
              Icons.rate_review,
              state.isLoadingStat('comments'),
              state.getErrorForStat('comments'),
              () => _loadIndividualStat(notifier, 'comments'),
            ),
            _buildStatItem(
              context,
              'Participated',
              state.statistics.eventsParticipated.toString(),
              Icons.event_available,
              state.isLoadingStat('participated'),
              state.getErrorForStat('participated'),
              () => _loadIndividualStat(notifier, 'participated'),
            ),
            _buildStatItem(
              context,
              'Booked',
              state.statistics.timesBooked.toString(),
              Icons.book_online,
              state.isLoadingStat('bookings'),
              state.getErrorForStat('bookings'),
              () => _loadIndividualStat(notifier, 'bookings'),
            ),
          ],
        ),

        // Show refresh indicator if data is stale
        if (notifier.shouldRefresh()) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => notifier.refresh(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 12,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Refresh',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Show individual error indicators
        if (state.hasErrors && state.hasData) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.errors.entries
                .where((entry) => entry.key != 'general')
                .map((entry) =>
                    _buildErrorChip(context, entry.key, entry.value, notifier))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isLoading,
    String? error,
    VoidCallback? onRetry,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onRetry,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: error != null
                  ? colorScheme.errorContainer.withOpacity(0.1)
                  : colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: error != null
                  ? Border.all(color: colorScheme.error.withOpacity(0.3))
                  : null,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        error != null ? colorScheme.error : colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    size: 20,
                    color:
                        error != null ? colorScheme.error : colorScheme.primary,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            isLoading ? '...' : value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: error != null ? colorScheme.error : null,
            ),
          ),
          if (showLabels) ...[
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorChip(
    BuildContext context,
    String statName,
    String error,
    TeacherStatisticsNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _loadIndividualStat(notifier, statName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 12,
              color: colorScheme.error,
            ),
            const SizedBox(width: 4),
            Text(
              '$statName error',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadIndividualStat(
      TeacherStatisticsNotifier notifier, String statName) {
    switch (statName) {
      case 'events':
        notifier.loadEventsStats();
        break;
      case 'comments':
        notifier.loadCommentsStats();
        break;
      case 'participated':
        notifier.loadParticipatedStats();
        break;
      case 'bookings':
        notifier.loadBookingsStats();
        break;
    }
  }
}

/// Compact version of the statistics widget
class CompactTeacherStatistics extends StatelessWidget {
  const CompactTeacherStatistics({
    super.key,
    required this.teacherId,
  });

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return EnhancedTeacherStatistics(
      teacherId: teacherId,
      showLabels: false,
      compact: true,
    );
  }
}
