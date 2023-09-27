import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_button.dart';
import 'package:acroworld/screens/home_screens/activities/components/class_event_tile_image.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassEventExpandedTile extends StatelessWidget {
  const ClassEventExpandedTile({Key? key, required this.classEvent})
      : super(key: key);
  final ClassEvent classEvent;

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
                        style: CARD_TITLE_TEXT),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          classEvent.startDate != null &&
                                  classEvent.endDate != null
                              ? Text(
                                  "${DateFormat('H:mm').format(DateTime.parse(classEvent.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(classEvent.endDate!))}",
                                  style: CARD_DESCRIPTION_TEXT)
                              : const Text("time not given"),
                          const Spacer(),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.35),
                            child: Text(
                                classEvent.classModel?.locationName ??
                                    "no location name",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: CARD_DESCRIPTION_TEXT),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    classTeachers.isNotEmpty
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
                                classEvent.classModel!.classBookingOptions!
                                    .isNotEmpty &&
                                classEvent.classModel?.maxBookingSlots != null
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text("discount with AcroWorld",
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: CARD_DESCRIPTION_TEXT),
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
