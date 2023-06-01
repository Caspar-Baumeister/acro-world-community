import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_button.dart';
import 'package:acroworld/screens/home_screens/activities/components/class_event_tile_image.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => classEvent.classModel != null
          ? Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SingleClassPage(
                  clas: classEvent.classModel!,
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
                    Text(classEvent.classModel?.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MEDIUM_BOLD_TEXT_STYLE),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classEvent.startDate != null &&
                                classEvent.endDate != null
                            ? Text(
                                "${DateFormat('H:mm').format(DateTime.parse(classEvent.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(classEvent.endDate!))}",
                                style: SMALL_TEXT_STYLE)
                            : const Text("time not given"),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.35),
                              child: Text(
                                  classEvent.classModel?.locationName ??
                                      "no location name",
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: SMALL_TEXT_STYLE),
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    classEvent.classModel?.classTeachers != null &&
                            classEvent.classModel!.classTeachers!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: ClassTeacherChips(
                              classTeacherList: List<TeacherModel>.from(
                                classEvent.classModel!.classTeachers!
                                    .map((e) => e.teacher)
                                    .where((element) => element != null),
                              ),
                            ),
                          )
                        : Container(
                            height: 10,
                          ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classEvent.classModel?.classLevels != null &&
                                classEvent.classModel!.classLevels!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12),
                                child: DifficultyWidget(
                                  classEvent.classModel!.classLevels!,
                                ),
                              )
                            : const SizedBox(
                                width: DIFFICULTY_LEVEL_WIDTH,
                                height: DIFFICULTY_LEVEL_HEIGHT,
                              ),
                        classEvent.classModel?.classBookingOptions != null &&
                                classEvent.classModel!.classBookingOptions!
                                    .isNotEmpty &&
                                classEvent.classModel?.maxBookingSlots != null
                            ? BookNowButton(
                                classEvent: classEvent,
                              )
                            : Container()
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
