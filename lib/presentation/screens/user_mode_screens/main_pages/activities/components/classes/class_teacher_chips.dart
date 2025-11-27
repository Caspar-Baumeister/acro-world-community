import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassTeacherChips extends StatelessWidget {
  const ClassTeacherChips({super.key, required this.classTeacherList});

  final List<TeacherModel> classTeacherList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (classTeacherList.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...classTeacherList.map((teacher) => teacher.id != null &&
                  teacher.name != null &&
                  teacher.profilImgUrl != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _TeacherChip(
                    teacher: teacher,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                )
              : const SizedBox.shrink())
        ],
      ),
    );
  }
}

class _TeacherChip extends StatelessWidget {
  const _TeacherChip({
    required this.teacher,
    required this.theme,
    required this.colorScheme,
  });

  final TeacherModel teacher;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: teacher.slug != null
          ? () => context.pushNamed(
                partnerSlugRoute,
                pathParameters: {
                  "slug": teacher.slug!,
                },
              )
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Teacher avatar
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: teacher.profilImgUrl ?? "",
                  placeholder: (context, url) => Container(
                    color: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.person,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.person,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Teacher name
            Text(
              teacher.name ?? "",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
