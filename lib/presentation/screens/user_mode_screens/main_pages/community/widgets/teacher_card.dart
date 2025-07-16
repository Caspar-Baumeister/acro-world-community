import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
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
              child: Center(child: CircularProgressIndicator()),
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
          color: widget.isLiked ? CustomColors.primaryColor : Colors.white,
          border: Border.all(color: CustomColors.primaryColor),
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
                  child: CircularProgressIndicator(
                    color: widget.isLiked
                        ? Colors.white
                        : CustomColors.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                widget.isLiked ? "Followed" : "Follow",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: widget.isLiked
                          ? Colors.white
                          : CustomColors.primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
