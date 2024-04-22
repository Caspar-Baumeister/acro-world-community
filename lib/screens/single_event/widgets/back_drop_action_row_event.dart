import 'dart:ui';

import 'package:acroworld/components/wrapper/bookmark_event_mutation_widget.dart';
import 'package:flutter/material.dart';

class BackDropActionRowEvent extends StatefulWidget {
  const BackDropActionRowEvent({
    required this.isCollapsed,
    required this.eventId,
    required this.initialyBookmarked,
    required this.shareEvents,
    super.key,
  });

  final bool isCollapsed;
  final String eventId;
  final bool? initialyBookmarked;
  final Function shareEvents;

  @override
  State<BackDropActionRowEvent> createState() => _BackDropActionRowEventState();
}

class _BackDropActionRowEventState extends State<BackDropActionRowEvent> {
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
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // twi gesture detector with star and check icon with color and function depending on isCompleted and isMarked
                children: [
                  if (widget.initialyBookmarked != null)
                    BookmarkEventMutationWidget(
                        eventId: widget.eventId,
                        initialBookmarked: widget.initialyBookmarked!,
                        color: Colors.black),
                  IconButton(
                      onPressed: () => widget.shareEvents(),
                      icon: const Icon(Icons.ios_share, color: Colors.black))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
