import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Modern skeleton loading component using shimmer package
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
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const ShimmerSkeleton(
            width: 50,
            height: 50,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerSkeleton(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: 8),
                const ShimmerSkeleton(
                  width: 200,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerSkeleton(
              width: double.infinity,
              height: 120,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const SizedBox(height: 12),
            const ShimmerSkeleton(
              width: double.infinity,
              height: 20,
            ),
            const SizedBox(height: 8),
            const ShimmerSkeleton(
              width: 150,
              height: 16,
            ),
            const SizedBox(height: 8),
            const ShimmerSkeleton(
              width: 100,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ShimmerSkeleton(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          const SizedBox(height: 16),
          const ShimmerSkeleton(
            width: 200,
            height: 20,
          ),
          const SizedBox(height: 8),
          const ShimmerSkeleton(
            width: 150,
            height: 16,
          ),
          const SizedBox(height: 16),
          const ShimmerSkeleton(
            width: double.infinity,
            height: 100,
          ),
        ],
      ),
    );
  }
}
