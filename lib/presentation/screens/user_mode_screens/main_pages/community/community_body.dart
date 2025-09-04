import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/cards/simple_user_card.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_likes_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityBody extends ConsumerWidget {
  const CommunityBody({
    super.key,
    required this.teachers,
  });

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTeachers = teachers.where((t) => t.type != "Anonymous").toList();

    if (filteredTeachers.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredTeachers.length,
      itemBuilder: (context, index) {
        final teacher = filteredTeachers[index];
        return _SimpleTeacherCardWrapper(
          teacher: teacher,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No community members found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// A wrapper that integrates the simple user card with the teacher likes provider
class _SimpleTeacherCardWrapper extends ConsumerWidget {
  const _SimpleTeacherCardWrapper({
    required this.teacher,
  });

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherLikes = ref.watch(teacherLikesProvider);

    return teacherLikes.when(
      data: (likesMap) {
        final isFollowed = likesMap[teacher.id] ?? false;
        return SimpleUserCard(
          name: teacher.name ?? "No name",
          followerCount: (teacher.likes ?? 0).toInt(),
          profileImageUrl: teacher.profilImgUrl ?? "",
          isFollowed: isFollowed,
          onFollowTap: () => _handleFollowTap(context, ref),
          onCardTap: () => _handleCardTap(context),
          description: teacher.description,
        );
      },
      loading: () => SimpleUserCard(
        name: teacher.name ?? "No name",
        followerCount: (teacher.likes ?? 0).toInt(),
        profileImageUrl: teacher.profilImgUrl ?? "",
        isFollowed: false,
        isLoading: true,
        onFollowTap: () {},
        onCardTap: () => _handleCardTap(context),
        description: teacher.description,
      ),
      error: (_, __) => SimpleUserCard(
        name: teacher.name ?? "No name",
        followerCount: (teacher.likes ?? 0).toInt(),
        profileImageUrl: teacher.profilImgUrl ?? "",
        isFollowed: false,
        onFollowTap: () => _handleFollowTap(context, ref),
        onCardTap: () => _handleCardTap(context),
        description: teacher.description,
      ),
    );
  }

  void _handleFollowTap(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(userRiverpodProvider).value;
    if (currentUser == null) {
      showAuthRequiredDialog(
        context,
        subtitle:
            'Log in or sign up to follow your favorite partners and stay updated with their events.',
      );
      return;
    }

    ref.read(teacherLikesProvider.notifier).toggleTeacherLike(teacher.id!);
  }

  void _handleCardTap(BuildContext context) {
    if (teacher.slug != null) {
      context.pushNamed(
        'partnerSlugRoute', // This should match your route name
        pathParameters: {"slug": teacher.slug!},
      );
    }
  }
}
