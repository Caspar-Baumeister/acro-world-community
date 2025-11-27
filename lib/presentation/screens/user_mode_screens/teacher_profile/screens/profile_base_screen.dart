import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/screens/modern_teacher_profile.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileBaseScreen extends ConsumerStatefulWidget {
  const ProfileBaseScreen({
    super.key,
    required this.teacher,
  });

  final TeacherModel teacher;

  @override
  ConsumerState<ProfileBaseScreen> createState() => _ProfileBaseScreenState();
}

class _ProfileBaseScreenState extends ConsumerState<ProfileBaseScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ModernSkeleton(width: 200, height: 20),
                  SizedBox(height: 16),
                  ModernSkeleton(width: 300, height: 100),
                ],
              ),
            ),
          ),
          error: (e, st) => Scaffold(
            body: Center(child: Text('Error loading user')),
          ),
          data: (currentUser) {
            final teacherLikes = ref.watch(teacherLikesProvider);

            return teacherLikes.when(
              loading: () => const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ModernSkeleton(width: 200, height: 20),
                      SizedBox(height: 16),
                      ModernSkeleton(width: 300, height: 100),
                    ],
                  ),
                ),
              ),
              error: (_, __) => Scaffold(
                body: Center(child: Text('Error loading teacher likes')),
              ),
              data: (likesMap) {
                final isLikedState = likesMap[widget.teacher.id] ?? false;

                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: ModernTeacherProfile(
                    teacher: widget.teacher,
                    isLiked: isLikedState,
                    loading: loading,
                    onFollowPressed: () {
                      if (currentUser == null) {
                        showAuthRequiredDialog(
                          context,
                          subtitle:
                              'Log in or sign up to follow ${widget.teacher.name ?? "this partner"} and stay updated with their activities.',
                        );
                        return;
                      }
                      setState(() => loading = true);

                      ref
                          .read(teacherLikesProvider.notifier)
                          .toggleTeacherLike(widget.teacher.id!);

                      Future.delayed(const Duration(milliseconds: 200), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    onBackPressed: () {
                      if (!GoRouter.of(context).canPop()) {
                        context.go('/community');
                      } else {
                        GoRouter.of(context).pop();
                      }
                    },
                  ),
                );
              },
            );
          },
        );
  }
}
