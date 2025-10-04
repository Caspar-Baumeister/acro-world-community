import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityBody extends ConsumerWidget {
  const CommunityBody({
    super.key,
    required this.teachers,
    this.canFetchMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  final List<TeacherModel> teachers;
  final bool canFetchMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTeachers =
        teachers.where((t) => t.type != "Anonymous").toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.spacingSmall),
        ...filteredTeachers.map((teacher) {
          return TeacherCard(
            teacher: teacher,
          );
        }),
        if (canFetchMore) ...[
          const SizedBox(height: AppDimensions.spacingMedium),
          Center(
            child: GestureDetector(
              onTap: isLoadingMore ? null : onLoadMore,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSmall,
                  vertical: AppDimensions.spacingExtraSmall,
                ),
                child: isLoadingMore
                    ? const CircularProgressIndicator()
                    : Text(
                        "Load more",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.spacingMedium),
      ],
    );
  }
}
