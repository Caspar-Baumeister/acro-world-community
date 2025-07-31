import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditCreatorProfileButton extends StatelessWidget {
  final TeacherModel teacher;
  const EditCreatorProfileButton({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: FloatingButton(
        onPressed: () {
          context.pushNamed(
            editCreatorProfileRoute,
            queryParameters: {'isEditing': 'true'},
          );
        },
        insideWidget: Row(
          children: [
            CustomAvatarCachedNetworkImage(imageUrl: teacher.profilImgUrl),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text("Edit profile"),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
