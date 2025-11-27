import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:flutter/material.dart';

class TeacherOption extends StatelessWidget {
  final TeacherModel? teacher;
  final String? email;
  final VoidCallback? onDelete;
  final bool isEmailInvite;

  const TeacherOption({
    super.key,
    required this.teacher,
    this.onDelete,
  })  : email = null,
        isEmailInvite = false;

  const TeacherOption.email({
    super.key,
    required this.email,
    this.onDelete,
  })  : teacher = null,
        isEmailInvite = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
          onTap: null, // Disabled tap since it's a selected teacher
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile image or email icon
                if (isEmailInvite)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  )
                else
                  CustomAvatarCachedNetworkImage(
                    imageUrl: teacher?.profilImgUrl ?? "",
                    radius: 40,
                  ),
                const SizedBox(width: 12),
                // Name/Email and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEmailInvite
                            ? email!
                            : (teacher?.name ?? "Unknown Teacher"),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEmailInvite
                            ? "Pending email invitation"
                            : "${teacher?.likes?.toString() ?? "0"} followers",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Remove button
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
