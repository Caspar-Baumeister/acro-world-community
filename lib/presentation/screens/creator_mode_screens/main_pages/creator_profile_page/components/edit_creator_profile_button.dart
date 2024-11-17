import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/images/custom_avatar_cached_network_image.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class EditCreatorProfileButton extends StatelessWidget {
  final TeacherModel teacher;
  const EditCreatorProfileButton({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
      child: FloatingButton(
        onPressed: () {
          Navigator.of(context).push(EditCreatorProfilePageRoute());
        },
        insideWidget: Row(
          children: [
            CustomAvatarCachedNetworkImage(imageUrl: teacher.profilImgUrl),
            const SizedBox(width: AppPaddings.medium),
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
