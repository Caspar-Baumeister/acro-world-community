import 'package:acroworld/presentation/screens/single_class_page/widgets/creator_settings_action_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class CreatorSettingsActionIconButton extends StatelessWidget {
  const CreatorSettingsActionIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => buildMortal(context, const CreatorSettingsActionModal()),
      icon: const Icon(
        Icons.more_vert_outlined,
        color: CustomColors.iconColor,
      ),
    );
  }
}
