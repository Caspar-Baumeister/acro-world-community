import 'package:acroworld/components/datetime/date_time_service.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
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
    List<ClassTeachers> classTeachers = [];

    if (classEvent.classModel?.classTeachers != null) {
      classTeachers = classEvent.classModel!.classTeachers!
          .where((ClassTeachers classTeacher) =>
              classTeacher.teacher?.type != "Anonymous")
          .toList();
    }

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
                    Text(
                      classEvent.classModel?.name ?? "Unknown",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                letterSpacing: -0.5,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    classEvent.classModel?.locationName != null
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppPaddings.tiny),
                            child: Text(
                              classEvent.classModel!.locationName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.1,
                                  ),
                            ),
                          )
                        : Container(),
                    classTeachers.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ClassTeacherChips(
                              classTeacherList: List<TeacherModel>.from(
                                classTeachers
                                    .map((e) => e.teacher)
                                    .where((element) => element != null),
                              ),
                            ),
                          )
                        : Container(),
                    // if showFullDate is true, show "Today, Tomorrow, 03. March, 04. March, etc"
                    showFullDate == true
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppPaddings.small),
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
                            padding: EdgeInsets.only(
                                top: showFullDate == true ? 0 : 5),
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
                                        classEvent
                                            .classModel!.classLevels!.isNotEmpty
                                    ? DifficultyWidget(
                                        classEvent.classModel!.classLevels!,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
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
