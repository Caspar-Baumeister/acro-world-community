import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_statistics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModernTeacherHeader extends ConsumerWidget {
  const ModernTeacherHeader({
    super.key,
    required this.teacher,
    required this.images,
    required this.currentImageIndex,
    required this.onImageChanged,
    required this.imagePageController,
    required this.isLiked,
    required this.loading,
    required this.onFollowPressed,
    required this.onBackPressed,
  });

  final TeacherModel teacher;
  final List<String> images;
  final int currentImageIndex;
  final ValueChanged<int> onImageChanged;
  final PageController imagePageController;
  final bool isLiked;
  final bool loading;
  final VoidCallback onFollowPressed;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Column(
        children: [
          // Image carousel section - extended to include app bar space
          if (images.isNotEmpty) ...[
            SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + 300,
              child: Stack(
                children: [
                  // Image carousel
                  PageView.builder(
                    controller: imagePageController,
                    onPageChanged: onImageChanged,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return CustomCachedNetworkImage(
                        imageUrl: images[index],
                        width: double.infinity,
                        height: MediaQuery.of(context).padding.top +
                            kToolbarHeight +
                            300,
                      );
                    },
                  ),

                  // Back button overlay
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: onBackPressed,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay for better text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Page indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentImageIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            // Fallback if no images
            Container(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + 200,
              color: colorScheme.surfaceContainerHighest,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // Back button overlay
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: onBackPressed,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Profile info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar and basic info
                Row(
                  children: [
                    // Avatar
                    CustomAvatarCachedNetworkImage(
                      imageUrl: teacher.profilImgUrl ?? "",
                      radius: 50,
                    ),
                    const SizedBox(width: 16),

                    // Name, verification, and follow button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                teacher.name ?? "No name",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Verification badge
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const Spacer(),
                              // Follow button
                              GestureDetector(
                                onTap: onFollowPressed,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isLiked
                                        ? colorScheme.primary.withOpacity(0.1)
                                        : colorScheme.surface,
                                    border: Border.all(
                                      color: isLiked
                                          ? colorScheme.primary.withOpacity(0.3)
                                          : colorScheme.outline
                                              .withOpacity(0.2),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  height: 32,
                                  width: 80,
                                  alignment: Alignment.center,
                                  child: loading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                isLiked
                                                    ? colorScheme.primary
                                                    : colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          isLiked ? "Followed" : "Follow",
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: isLiked
                                                ? colorScheme.primary
                                                : colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${teacher.likes?.toString() ?? "0"} followers",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Statistics row
                Consumer(
                  builder: (context, ref, child) {
                    final statisticsAsync =
                        ref.watch(teacherStatisticsProvider(teacher.id!));

                    return statisticsAsync.when(
                      data: (statistics) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            "Events",
                            statistics.totalEvents.toString(),
                            Icons.event,
                          ),
                          _buildStatItem(
                            context,
                            "Rating",
                            statistics.averageRating > 0
                                ? statistics.averageRating.toStringAsFixed(1)
                                : "N/A",
                            Icons.star,
                          ),
                          _buildStatItem(
                            context,
                            "Reviews",
                            statistics.totalReviews.toString(),
                            Icons.rate_review,
                          ),
                          _buildStatItem(
                            context,
                            "Participated",
                            statistics.eventsParticipated.toString(),
                            Icons.event_available,
                          ),
                          _buildStatItem(
                            context,
                            "Booked",
                            statistics.timesBooked.toString(),
                            Icons.book_online,
                          ),
                        ],
                      ),
                      loading: () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, "Events", "...", Icons.event),
                          _buildStatItem(context, "Rating", "...", Icons.star),
                          _buildStatItem(
                              context, "Reviews", "...", Icons.rate_review),
                          _buildStatItem(context, "Participated", "...",
                              Icons.event_available),
                          _buildStatItem(
                              context, "Booked", "...", Icons.book_online),
                        ],
                      ),
                      error: (error, stack) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, "Events", "0", Icons.event),
                          _buildStatItem(context, "Rating", "N/A", Icons.star),
                          _buildStatItem(
                              context, "Reviews", "0", Icons.rate_review),
                          _buildStatItem(context, "Participated", "0",
                              Icons.event_available),
                          _buildStatItem(
                              context, "Booked", "0", Icons.book_online),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Bio/Description
                if (teacher.description != null &&
                    teacher.description!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          teacher.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
