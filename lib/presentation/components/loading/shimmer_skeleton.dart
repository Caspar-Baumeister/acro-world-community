import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Helper to get shimmer colors with proper contrast
class _SkeletonColors {
  /// Gets shimmer effect colors based on brightness
  /// Uses fixed colors that provide good contrast for visible shimmer animation
  static ShimmerEffect getShimmerEffect(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return const ShimmerEffect(
        baseColor: Color(0xFF2A2A2A),
        highlightColor: Color(0xFF3D3D3D),
        duration: Duration(milliseconds: 1500),
      );
    } else {
      return const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1500),
      );
    }
  }

  /// Gets the base skeleton color
  static Color getBaseColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);
  }
}

/// Modern skeleton loading component using skeletonizer package
class ShimmerSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor ?? _SkeletonColors.getBaseColor(context),
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      ),
    );
  }
}

/// Predefined skeleton components for common use cases
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = _SkeletonColors.getBaseColor(context);
    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingSmall,
          horizontal: AppDimensions.spacingMedium,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: skeletonColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Container(
                    width: 200,
                    height: 12,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
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

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Image skeleton using Bone.square
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Bone.square(
                  size: MediaQuery.of(context).size.width * 0.25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton with flag badge
                    Row(
                      children: [
                        Expanded(
                          child: Bone.text(
                            words: 2,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Flag badge skeleton
                        Bone(
                          width: 20,
                          height: 16,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        const SizedBox(width: 4),
                        Bone.icon(size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Location skeleton
                    Bone.text(
                      words: 1,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    // Teacher chips skeleton
                    Row(
                      children: [
                        Bone(
                          width: 60,
                          height: 32,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        const SizedBox(width: 5),
                        Bone(
                          width: 80,
                          height: 32,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Next occurrence skeleton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Bone.text(
                              words: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Bone.text(
                              words: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Bone.text(
                          words: 1,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonColor = _SkeletonColors.getBaseColor(context);
    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMedium),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: skeletonColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for event discovery cards with landscape aspect ratio
class EventDiscoveryCardSkeleton extends StatelessWidget {
  final double? width;

  const EventDiscoveryCardSkeleton({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final skeletonColor = _SkeletonColors.getBaseColor(context);
    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Container(
        width: width ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusExtraLarge),
          color: skeletonColor,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusExtraLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section skeleton
              Expanded(
                flex: 3,
                child: Bone(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusExtraLarge),
                  ),
                ),
              ),
              // Content section skeleton
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton
                      const Bone(height: 16),
                      const SizedBox(height: AppDimensions.spacingSmall),
                      Bone(width: 120, height: 12),
                      const SizedBox(height: AppDimensions.spacingSmall),
                      Bone(width: 80, height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for event row (horizontal scroll of event cards)
class EventRowSkeleton extends StatelessWidget {
  final int cardCount;
  final String? title;

  const EventRowSkeleton({
    super.key,
    this.cardCount = 3,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final skeletonColor = _SkeletonColors.getBaseColor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        if (title != null)
          Skeletonizer(
            enabled: true,
            effect: _SkeletonColors.getShimmerEffect(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMedium,
                vertical: AppDimensions.spacingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Cards skeleton
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              cardCount,
              (index) => Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.spacingMedium,
                  right: AppDimensions.spacingSmall,
                ),
                child: EventDiscoveryCardSkeleton(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton for responsive event card with landscape aspect ratio
class ResponsiveEventCardSkeleton extends StatelessWidget {
  final double? width;
  final bool isGridMode;

  const ResponsiveEventCardSkeleton({
    super.key,
    this.width,
    this.isGridMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final skeletonColor = _SkeletonColors.getBaseColor(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ?? (isGridMode ? (screenWidth - 48) / 2.0 : 160.0);
    final cardHeight = isGridMode ? 240.0 : 200.0;

    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(
          right: isGridMode ? 0 : AppDimensions.spacingMedium,
          bottom: isGridMode ? AppDimensions.spacingMedium : 0,
        ),
        decoration: BoxDecoration(
          color: skeletonColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            Expanded(
              flex: 3,
              child: Bone(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
            ),
            // Content skeleton
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    const Bone(height: 16),
                    const SizedBox(height: AppDimensions.spacingExtraSmall),
                    Bone(width: 120, height: 12),
                    const SizedBox(height: AppDimensions.spacingExtraSmall),
                    Bone(width: 80, height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for responsive event list (both horizontal and grid)
class ResponsiveEventListSkeleton extends StatelessWidget {
  final bool isGridMode;
  final int itemCount;

  const ResponsiveEventListSkeleton({
    super.key,
    this.isGridMode = false,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridMode) {
      return _buildGridSkeleton(context);
    } else {
      return _buildHorizontalSkeleton(context);
    }
  }

  Widget _buildHorizontalSkeleton(BuildContext context) {
    return SizedBox(
      height: 260.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const ResponsiveEventCardSkeleton(isGridMode: false);
        },
      ),
    );
  }

  Widget _buildGridSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const ResponsiveEventCardSkeleton(isGridMode: true);
        },
      ),
    );
  }
}

/// Skeleton for teacher cards in community page
class TeacherCardSkeleton extends StatelessWidget {
  const TeacherCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Skeletonizer(
      enabled: true,
      effect: _SkeletonColors.getShimmerEffect(context),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingExtraSmall,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusExtraLarge),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMedium),
          child: Row(
            children: [
              // Profile image skeleton
              Bone(
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(30),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              // Name and followers skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(
                      words: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingExtraSmall),
                    Bone.text(
                      words: 1,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Follow button skeleton
              Bone(
                width: 80,
                height: 32,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusExtraLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
