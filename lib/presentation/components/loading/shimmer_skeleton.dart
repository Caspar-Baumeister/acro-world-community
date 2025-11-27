import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor ?? Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(4),
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
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
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
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1500),
      ),
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
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
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
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1500),
      ),
      child: Container(
        width: width ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[300],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section skeleton
              Expanded(
                flex: 3,
                child: Bone(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
              // Content section skeleton
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton
                      const Bone(height: 16),
                      const SizedBox(height: 8),
                      Bone(width: 120, height: 12),
                      const SizedBox(height: 8),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
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
                  left: 16,
                  right: 8,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ?? (isGridMode ? (screenWidth - 48) / 2.0 : 160.0);
    final cardHeight = isGridMode ? 240.0 : 200.0;

    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1500),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(
          right: isGridMode ? 0 : 12,
          bottom: isGridMode ? 12 : 0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            Expanded(
              flex: 3,
              child: Bone(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            // Content skeleton
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    const Bone(height: 16),
                    const SizedBox(height: 4),
                    Bone(width: 120, height: 12),
                    const SizedBox(height: 4),
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
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        duration: Duration(milliseconds: 1500),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Profile image skeleton
              Bone(
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(30),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 4),
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
                borderRadius: BorderRadius.circular(16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
