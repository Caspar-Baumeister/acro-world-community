import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class TeacherOption extends StatelessWidget {
  final TeacherModel teacher;
  final VoidCallback? onDelete;

  const TeacherOption({
    super.key,
    required this.teacher,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(teacher.name ?? "unknown"),
      avatar: teacher.profilImgUrl != null
          ? CustomAvatarCachedNetworkImage(
              imageUrl: teacher.profilImgUrl,
              radius: AppDimensions.avatarSizeMedium,
            )
          : Icon(Icons.person, color: Theme.of(context).iconTheme.color),
      onDeleted: onDelete,
    );
  }
}
