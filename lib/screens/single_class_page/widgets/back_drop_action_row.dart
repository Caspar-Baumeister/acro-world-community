import 'dart:ui';

import 'package:acroworld/components/mutation_wrapper/report_button_mutation_wrapper.dart';
import 'package:acroworld/components/wrapper/favorite_class_mutation_widget.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class BackDropActionRow extends StatefulWidget {
  const BackDropActionRow({
    required this.isCollapsed,
    required this.classId,
    required this.initialFavorized,
    required this.shareEvents,
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
                children: [
                  if (widget.initialFavorized != null)
                    FavoriteClassMutationWidget(
                      classId: widget.classId,
                      initialFavorized: widget.initialFavorized == true,
                    ),
                  IconButton(
                    onPressed: () => widget.shareEvents(),
                    icon: const Icon(
                      Icons.ios_share,
                      color: Colors.black,
                    ),
                  ),
                  ReportButtonMutationWrapper(
                    classId: widget.classId,
                    initialReported: widget.initialReported,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
