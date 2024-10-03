import 'package:acroworld/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/utils/constants.dart';
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
          : const CircleAvatar(child: Icon(Icons.person)),
      onDeleted: onDelete,
    );
  }
}
