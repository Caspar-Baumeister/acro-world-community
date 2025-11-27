import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/creator_settings_action_modal.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class CreatorSettingsActionIconButton extends StatelessWidget {
  const CreatorSettingsActionIconButton(
      {super.key,
      required this.classModel,
      required this.classEventId,
      required this.classEvent});

  final ClassModel classModel;
  final String? classEventId;
  final ClassEvent? classEvent;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => buildMortal(
          context,
          CreatorSettingsActionModal(
              classModel: classModel,
              classEventId: classEventId,
              classEvent: classEvent)),
      icon: Icon(
        Icons.more_vert_outlined,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
