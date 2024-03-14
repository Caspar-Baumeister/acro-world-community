import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/main_pages/activities/components/class_event_tile_image.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassEventExpandedTile extends StatelessWidget {
  const ClassEventExpandedTile(
      {super.key, required this.classEvent, this.showFullDate});
  final ClassEvent classEvent;
  final bool? showFullDate;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<ClassTeachers> classTeachers = [];

    if (classEvent.classModel?.classTeachers != null) {
      classTeachers = classEvent.classModel!.classTeachers!
          .where((ClassTeachers classTeacher) =>
              classTeacher.teacher?.type != "Anonymous")
          .toList();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => classEvent.classModel != null
          ? Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SingleEventQueryWrapper(
                  classId: classEvent.classModel!.id!,
                  classEventId: classEvent.id,
                ),
              ),
            )
          : null,
      child: SizedBox(
        height: CLASS_CARD_HEIGHT + 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
            ClassEventTileImage(
              width: screenWidth * 0.3,
              isCancelled: classEvent.isCancelled,
              imgUrl: classEvent.classModel?.imageUrl,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classEvent.classModel?.name ?? "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge),
                    // if showFullDate is true, show "Today, Tomorrow, 03. March, 04. March, etc"
                    if (showFullDate == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          DateFormat('d. MMMM')
                              .format(DateTime.parse(classEvent.startDate!)),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: classEvent.startDate != null &&
                                    classEvent.endDate != null
                                ? Text(
                                    "${DateFormat('H:mm').format(DateTime.parse(classEvent.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(classEvent.endDate!))}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!)
                                : const Text(""),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(classEvent.classModel?.locationName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!),
                              const Icon(
                                Icons.location_on,
                                color: Colors.black,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    classTeachers.isNotEmpty && showFullDate != true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ClassTeacherChips(
                              classTeacherList: List<TeacherModel>.from(
                                classTeachers
                                    .map((e) => e.teacher)
                                    .where((element) => element != null),
                              ),
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        classEvent.classModel?.classBookingOptions != null &&
                                classEvent
                                    .classModel!.classBookingOptions!.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.local_offer,
                                      color: CustomColors.successTextColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text("direct booking",
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!),
                                  ],
                                ))
                            : Container(),
                        const Spacer(),
                        classEvent.classModel?.classLevels != null &&
                                classEvent.classModel!.classLevels!.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: DifficultyWidget(
                                  classEvent.classModel!.classLevels!,
                                ),
                              )
                            : const SizedBox(),
                      ],
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
