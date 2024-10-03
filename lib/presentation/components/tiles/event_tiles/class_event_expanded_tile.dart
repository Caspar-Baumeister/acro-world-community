import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_location_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_teacher_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_title_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class ClassEventExpandedTile extends StatelessWidget {
  const ClassEventExpandedTile(
      {super.key, required this.classEvent, this.showFullDate});
  final ClassEvent classEvent;
  final bool? showFullDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: classEvent.classModel?.urlSlug != null ||
              classEvent.classModel?.id != null ||
              classEvent.id != null
          ? () => Navigator.of(context).push(
                SingleEventIdWrapperPageRoute(
                  urlSlug: classEvent.classModel?.urlSlug,
                  classId: classEvent.classModel?.id,
                  classEventId: classEvent.id,
                ),
              )
          : () => showErrorToast("This class is not available anymore"),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image
            ClassEventTileImage(
              width: MediaQuery.of(context).size.width * 0.3,
              isCancelled: classEvent.isCancelled,
              imgUrl: classEvent.classModel?.imageUrl,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClassTileTitleWidget(classObject: classEvent.classModel!),
                    ClassTileLocationWidget(
                        classObject: classEvent.classModel!),
                    ClassTileTeacherWidget(classObject: classEvent.classModel!),
                    ClassTileDateAndDifficultyWidget(
                        classEvent: classEvent,
                        showFullDate: showFullDate ?? false),
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

class ClassTileDateAndDifficultyWidget extends StatelessWidget {
  const ClassTileDateAndDifficultyWidget(
      {super.key, required this.classEvent, required this.showFullDate});
  final ClassEvent classEvent;
  final bool showFullDate;

  @override
  Widget build(BuildContext context) {
    return showFullDate == true
        ? Padding(
            padding: const EdgeInsets.only(top: AppPaddings.small),
            child: Text(
                DateTimeService.getDateString(
                    classEvent.startDate, classEvent.endDate),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: CustomColors.accentColor)
                    .copyWith(letterSpacing: -0.5)),
          )
        : Padding(
            padding: EdgeInsets.only(top: showFullDate == true ? 0 : 5),
            child: Row(
              children: [
                Text(
                  DateTimeService.getDateString(
                      classEvent.startDate, classEvent.endDate,
                      onlyTime: true),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: CustomColors.accentColor)
                      .copyWith(letterSpacing: -0.5),
                ),
                const Spacer(),
                classEvent.classModel?.classLevels != null &&
                        classEvent.classModel!.classLevels!.isNotEmpty
                    ? DifficultyWidget(
                        classEvent.classModel!.classLevels!,
                      )
                    : const SizedBox(),
              ],
            ),
          );
  }
}
