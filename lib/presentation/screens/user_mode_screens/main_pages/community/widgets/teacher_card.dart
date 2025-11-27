import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeacherCard extends ConsumerWidget {
  const TeacherCard({
    super.key,
    required this.teacher,
  });

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read current user once; .value may be null if not authenticated
    final teacherLikes = ref.watch(teacherLikesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: teacher.slug != null
              ? () => context.pushNamed(
                    partnerSlugRoute,
                    pathParameters: {"slug": teacher.slug!},
                  )
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile image
                CustomAvatarCachedNetworkImage(
                  imageUrl: teacher.profilImgUrl ?? "",
                  radius: 60,
                ),
                const SizedBox(width: 12),
                // Name and followers
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name ?? "No name",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${teacher.likes?.toString() ?? "0"} followers",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Follow button
                teacherLikes.when(
                  data: (likesMap) {
                    final isLiked = likesMap[teacher.id] ?? false;
                    return _FollowButton(
                      teacherId: teacher.id!,
                      isLiked: isLiked,
                    );
                  },
                  loading: () => const SizedBox(
                    width: 80,
                    height: 32,
                    child: Center(child: ModernSkeleton(width: 20, height: 20)),
                  ),
                  error: (_, __) => const SizedBox(width: 80, height: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extract button to separate widget for cleaner code
class _FollowButton extends ConsumerStatefulWidget {
  const _FollowButton({
    required this.teacherId,
    required this.isLiked,
  });

  final String teacherId;
  final bool isLiked;

  @override
  ConsumerState<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<_FollowButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        final currentUser = ref.read(userRiverpodProvider).value;
        if (currentUser == null) {
          showAuthRequiredDialog(
            context,
            subtitle:
                'Log in or sign up to follow your favorite partners and stay updated with their events.',
          );
          return;
        }

        setState(() => loading = true);

        ref
            .read(teacherLikesProvider.notifier)
            .toggleTeacherLike(widget.teacherId);

        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() => loading = false);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isLiked
              ? colorScheme.primary
                  .withOpacity(0.1) // Light background for active state
              : colorScheme.surface,
          border: Border.all(
            color: widget.isLiked
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
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
                  child: ModernSkeleton(
                    width: 12,
                    height: 12,
                    baseColor: widget.isLiked
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : Text(
                widget.isLiked ? "Followed" : "Follow",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: widget.isLiked
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
