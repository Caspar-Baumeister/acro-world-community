import 'dart:ui';

import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/mutation_wrapper/report_button_mutation_wrapper.dart';
import 'package:acroworld/presentation/components/wrapper/favorite_class_mutation_widget.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/creator_settings_action_icon_button.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackDropActionRow extends StatefulWidget {
  const BackDropActionRow({
    required this.isCollapsed,
    required this.classId,
    required this.initialFavorized,
    required this.shareEvents,
    required this.isCreator,
    required this.classObject,
    required this.initialReported,
    required this.classEventId,
    super.key,
    this.classEvent,
  });

  final bool isCollapsed;
  final String classId;
  final bool? initialFavorized;
  final Function shareEvents;
  final ClassModel classObject;
  final bool initialReported;
  final bool isCreator;
  final String? classEventId;
  final ClassEvent? classEvent;

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
    UserRoleProvider userRoleProvider = Provider.of<UserRoleProvider>(context);
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
    if (userRoleProvider.isCreator) {
      try {
        actions.add(CreatorSettingsActionIconButton(
            classModel: widget.classObject,
            classEventId: widget.classEventId,
            classEvent: widget.classEvent));
      } catch (e, s) {
        CustomErrorHandler.captureException(e, stackTrace: s);
      }
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
