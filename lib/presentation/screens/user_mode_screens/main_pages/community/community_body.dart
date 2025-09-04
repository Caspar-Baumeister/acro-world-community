import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/cards/modern_user_card.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:acroworld/theme/app_dimensions.dart';
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
        return ModernUserCard(
          name: teacher.name ?? "No name",
          followerCount: (teacher.likes ?? 0).toInt(),
          profileImageUrl: teacher.profilImgUrl ?? "",
          isFollowed: false, // This will be handled by the follow button logic
          onFollowTap: () {
            // Handle follow logic here
            // This should be moved to the TeacherCard logic
          },
          onCardTap: () {
            if (teacher.slug != null) {
              context.pushNamed(
                'partnerSlugRoute', // You'll need to define this route
                pathParameters: {"slug": teacher.slug!},
              );
            }
          },
          description: teacher.description,
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
