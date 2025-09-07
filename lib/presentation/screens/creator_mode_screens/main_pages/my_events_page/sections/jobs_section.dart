import 'package:acroworld/presentation/components/dialogs/jobs_feature_request_dialog.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/presentation/components/sections/jobs_search_and_filter.dart';
import 'package:acroworld/provider/riverpod_provider/jobs_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsSection extends ConsumerStatefulWidget {
  const JobsSection({super.key});

  @override
  ConsumerState<JobsSection> createState() => _JobsSectionState();
}

class _JobsSectionState extends ConsumerState<JobsSection> {
  bool _showFeatureRequestOverlay = true;

  @override
  void initState() {
    super.initState();
    // Fetch initial jobs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobsProvider.notifier).fetchJobs(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsProvider);

    return Stack(
      children: [
        Column(
          children: [
            // Search and filter
            JobsSearchAndFilter(
              searchQuery: jobsState.searchQuery,
              selectedFilter: jobsState.selectedFilter,
              onSearchChanged: (query) {
                ref.read(jobsProvider.notifier).updateSearchQuery(query);
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    ref.read(jobsProvider.notifier).fetchJobs(
                      searchQuery: query,
                      filter: jobsState.selectedFilter,
                      isRefresh: true,
                    );
                  }
                });
              },
              onFilterChanged: (filter) {
                ref.read(jobsProvider.notifier).updateFilter(filter);
                ref.read(jobsProvider.notifier).fetchJobs(
                  searchQuery: jobsState.searchQuery,
                  filter: filter,
                  isRefresh: true,
                );
              },
              onSearchSubmitted: (query) {
                ref.read(jobsProvider.notifier).fetchJobs(
                  searchQuery: query,
                  filter: jobsState.selectedFilter,
                  isRefresh: true,
                );
              },
            ),
            // Jobs list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(jobsProvider.notifier).fetchJobs(
                  searchQuery: jobsState.searchQuery,
                  filter: jobsState.selectedFilter,
                  isRefresh: true,
                ),
                child: _buildJobsList(jobsState),
              ),
            ),
          ],
        ),
        // Feature request overlay
        if (_showFeatureRequestOverlay) _buildFeatureRequestOverlay(context),
      ],
    );
  }

  Widget _buildFeatureRequestOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.work_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                "Jobs Dashboard Coming Soon!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You will soon be able to post open job offers for performers, teachers, medics, or other community members for your events or studios.\n\nIf you are interested in this feature, let us know below. We will only build this feature if it is wished for by the community.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showFeatureRequestOverlay = false;
                        });
                      },
                      child: const Text('Not Interested'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showFeatureRequestOverlay = false;
                        });
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => const JobsFeatureRequestDialog(),
                        );
                      },
                      child: const Text('I Want This Feature'),
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

  Widget _buildJobsList(JobsState state) {
    if (state.loading) {
      return _buildLoadingState();
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.jobs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.jobs.length + (state.canFetchMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.jobs.length) {
          // Load more button
          return _buildLoadMoreButton();
        }
        
        final job = state.jobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerSkeleton(width: 200, height: 20),
                  const SizedBox(height: 8),
                  ShimmerSkeleton(width: 150, height: 16),
                  const SizedBox(height: 12),
                  ShimmerSkeleton(width: double.infinity, height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading jobs',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(jobsProvider.notifier).fetchJobs(isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to job details
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: job.status == 'active' 
                          ? colorScheme.primary.withOpacity(0.1)
                          : colorScheme.onSurface.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: job.status == 'active' 
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Location and date
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(job.startDate)} - ${_formatDate(job.endDate)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                job.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Footer with pay rate and teacher
              Row(
                children: [
                  Text(
                    '${job.payRate.toStringAsFixed(0)} ${job.currency}/hour',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: job.teacherImageUrl.isNotEmpty
                        ? NetworkImage(job.teacherImageUrl)
                        : null,
                    child: job.teacherImageUrl.isEmpty
                        ? Text(job.teacherName[0])
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    job.teacherName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildLoadMoreButton() {
    final state = ref.watch(jobsProvider);
    
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: TextButton(
          onPressed: () => ref.read(jobsProvider.notifier).fetchMore(),
          child: const Text('Load More'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
