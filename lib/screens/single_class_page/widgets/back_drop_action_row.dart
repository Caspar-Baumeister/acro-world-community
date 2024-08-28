import 'dart:ui';

import 'package:acroworld/components/mutation_wrapper/report_button_mutation_wrapper.dart';
import 'package:acroworld/components/wrapper/favorite_class_mutation_widget.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/screens/modals/base_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class BackDropActionRow extends StatefulWidget {
  const BackDropActionRow({
    required this.isCollapsed,
    required this.classId,
    required this.initialFavorized,
    required this.shareEvents,
    required this.isCreator,
    required this.classEvent,
    required this.initialReported,
    super.key,
  });

  final bool isCollapsed;
  final String classId;
  final bool? initialFavorized;
  final Function shareEvents;
  final ClassEvent? classEvent;
  final bool initialReported;
  final bool isCreator;

  @override
  State<BackDropActionRow> createState() => _BackDropActionRowState();
}

class _BackDropActionRowState extends State<BackDropActionRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double blurFactor = widget.isCollapsed ? 0 : 4;
    List<Widget> actions = [
      IconButton(
        onPressed: () => widget.shareEvents(),
        icon: const Icon(
          Icons.ios_share,
          color: Colors.black,
        ),
      ),
    ];
    if (widget.isCreator) {
      actions.add(const CreatorSettingsActionIconButton());
    } else {
      if (widget.initialFavorized != null) {
        actions.add(
          FavoriteClassMutationWidget(
            classId: widget.classId,
            initialFavorized: widget.initialFavorized == true,
          ),
        );
      }

      actions.add(
        ReportButtonMutationWrapper(
          classId: widget.classId,
          initialReported: widget.initialReported,
        ),
      );
    }
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // Subdued color
          // round oval
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: blurFactor,
              sigmaY: blurFactor), // Adjust blur values as needed
          child: SizedBox(
            height: 65,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.small),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // twi gesture detector with star and check icon with color and function depending on isCompleted and isMarked
                    children: actions)),
          ),
        ),
      ),
    );
  }
}

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

class CreatorSettingsActionModal extends StatelessWidget {
  const CreatorSettingsActionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Container(
        color: CustomColors.backgroundColor,
        child: Column(
          children: [
            ListTile(
              title: const Text("Edit"),
              leading: const Icon(Icons.edit),
              onTap: () => Navigator.of(context).pushNamed("/edit"),
            ),
            ListTile(
              title: const Text("Delete"),
              leading: const Icon(Icons.delete),
              onTap: () => Navigator.of(context).pushNamed("/delete"),
            ),
          ],
        ),
      ),
    );
  }
}
