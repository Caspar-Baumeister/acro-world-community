import 'package:acroworld/components/datetime/date_time_service.dart';
import 'package:acroworld/components/tiles/event_tiles/widgets/class_tile_location_widget.dart';
import 'package:acroworld/components/tiles/event_tiles/widgets/class_tile_teacher_widget.dart';
import 'package:acroworld/components/tiles/event_tiles/widgets/class_tile_title_widget.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/utils/colors.dart';
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

class ClassTileNextOccurenceWidget extends StatelessWidget {
  const ClassTileNextOccurenceWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    if (classObject.classEvents == null || classObject.classEvents!.isEmpty) {
      return const SizedBox();
    }
    final ClassEvent nextClassEvent = classObject.classEvents!.first;
    final int amountOfEvents = classObject.classEvents!.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Next: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: CustomColors.primaryTextColor)
                    .copyWith(letterSpacing: -0.5)),
            Text(
              DateTimeService.getDateStringOnlyDate(nextClassEvent.startDate!),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: CustomColors.accentColor)
                  .copyWith(letterSpacing: -0.5),
            ),
          ],
        ),
        if (amountOfEvents > 1)
          Flexible(
            child: Text(
              " +${amountOfEvents - 1} more dates",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: CustomColors.primaryTextColor)
                  .copyWith(letterSpacing: -0.5),
            ),
          ),
      ],
    );
  }
}
