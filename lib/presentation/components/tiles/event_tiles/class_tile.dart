import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_location_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_next_occurence_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_teacher_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_title_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

// This is a tile for a class, without specific class event
class ClassTile extends StatelessWidget {
  const ClassTile({super.key, required this.classObject, required this.onTap});
  final ClassModel classObject;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image
            ClassEventTileImage(
              width: MediaQuery.of(context).size.width * 0.3,
              isCancelled: false,
              imgUrl: classObject.imageUrl,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClassTileTitleWidget(classObject: classObject),
                    ClassTileLocationWidget(classObject: classObject),
                    ClassTileTeacherWidget(classObject: classObject),
                    ClassTileNextOccurenceWidget(classObject: classObject),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
