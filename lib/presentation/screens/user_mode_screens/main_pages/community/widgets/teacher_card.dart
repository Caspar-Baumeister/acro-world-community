import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_colors.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: teacher.slug != null
            ? () => context.pushNamed(
                  partnerSlugRoute,
                  pathParameters: {"slug": teacher.slug!},
                )
            : null,
        child: ListTile(
          leading: CustomAvatarCachedNetworkImage(
            imageUrl: teacher.profilImgUrl ?? "",
            radius: 64,
          ),
          title: Text(
            teacher.name ?? "No name",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            "${teacher.likes?.toString() ?? "0"} followers",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: teacherLikes.when(
            data: (likesMap) {
              final isLiked = likesMap[teacher.id] ?? false;
              return _FollowButton(
                teacherId: teacher.id!,
                isLiked: isLiked,
              );
            },
            loading: () => const SizedBox(
              width: 100,
              height: 35,
              child: Center(child: ModernSkeleton(width: 20, height: 20)),
            ),
            error: (_, __) => const SizedBox(width: 100, height: 35),
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
          color: widget.isLiked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 35,
        width: 100,
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: 25,
                width: 25,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ModernSkeleton(
                    width: 15,
                    height: 15,
                    baseColor: widget.isLiked
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,

                  ),
                ),
              )
            : Text(
                widget.isLiked ? "Followed" : "Follow",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: widget.isLiked
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}