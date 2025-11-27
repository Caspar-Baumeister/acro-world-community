import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModernTeacherCard extends StatelessWidget {
  const ModernTeacherCard({
    super.key,
    required this.teacher,
    this.isCompact = false,
  });

  final TeacherModel teacher;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: teacher.slug != null
          ? () => context.pushNamed(
                partnerSlugRoute,
                pathParameters: {"slug": teacher.slug!},
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: isCompact
            ? _buildCompactLayout(context, theme, colorScheme)
            : _buildFullLayout(context, theme, colorScheme),
      ),
    );
  }

  Widget _buildCompactLayout(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildAvatar(colorScheme),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teacher.name ?? "Unknown Teacher",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (teacher.likes != null && teacher.likes! > 0) ...[
                const SizedBox(height: 2),
                Text(
                  "${teacher.likes} followers",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildFullLayout(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(colorScheme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name ?? "Unknown Teacher",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (teacher.likes != null && teacher.likes! > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      "${teacher.likes} followers",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (teacher.description != null && teacher.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            teacher.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    return Container(
      width: isCompact ? 40 : 48,
      height: isCompact ? 40 : 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: teacher.profilImgUrl != null && teacher.profilImgUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: teacher.profilImgUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurfaceVariant,
                    size: isCompact ? 20 : 24,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurfaceVariant,
                    size: isCompact ? 20 : 24,
                  ),
                ),
              )
            : Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.person,
                  color: colorScheme.onSurfaceVariant,
                  size: isCompact ? 20 : 24,
                ),
              ),
      ),
    );
  }
}

class ModernTeacherList extends StatelessWidget {
  const ModernTeacherList({
    super.key,
    required this.teachers,
    this.isCompact = false,
    this.maxItems = 3,
  });

  final List<TeacherModel> teachers;
  final bool isCompact;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    if (teachers.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayTeachers = teachers.take(maxItems).toList();
    final hasMoreTeachers = teachers.length > maxItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teachers grid
        if (isCompact)
          // Horizontal layout for compact mode
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayTeachers.length + (hasMoreTeachers ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == displayTeachers.length && hasMoreTeachers) {
                  return _buildMoreTeachersCard(
                      context, teachers.length - maxItems);
                }
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < displayTeachers.length - 1 ? 12 : 0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ModernTeacherCard(
                      teacher: displayTeachers[index],
                      isCompact: true,
                    ),
                  ),
                );
              },
            ),
          )
        else
          // Vertical layout for full mode
          Column(
            children: [
              ...displayTeachers.map(
                (teacher) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ModernTeacherCard(
                    teacher: teacher,
                    isCompact: false,
                  ),
                ),
              ),
              if (hasMoreTeachers)
                _buildMoreTeachersCard(context, teachers.length - maxItems),
            ],
          ),
      ],
    );
  }

  Widget _buildMoreTeachersCard(BuildContext context, int additionalCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_add,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "+$additionalCount more",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
