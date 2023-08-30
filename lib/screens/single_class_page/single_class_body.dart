import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/show_more_text.dart';
import 'package:acroworld/components/map.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:intl/intl.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody({Key? key, required this.classe, this.classEvent})
      : super(key: key);

  final ClassModel classe;
  final ClassEvent? classEvent;

  @override
  Widget build(BuildContext context) {
    List<ClassTeachers> classTeachers = [];

    if (classe.classTeachers != null) {
      classTeachers = classe.classTeachers!
          .where((ClassTeachers classTeacher) =>
              classTeacher.teacher?.type != "Anonymous")
          .toList();
    }
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classe.name ?? "", maxLines: 3, style: H20W5),
          const SizedBox(height: 20),
          classEvent != null &&
                  classEvent!.startDate != null &&
                  classEvent!.endDate != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDateTime(
                            DateTime.parse(classEvent!.startDate!))),
                        Text(
                            "${DateFormat('H:mm').format(DateTime.parse(classEvent!.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(classEvent!.endDate!))}",
                            style: SMALL_TEXT_STYLE)
                      ],
                    ),
                    const CustomDivider()
                  ],
                )
              : Container(),
          classe.description != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DescriptionTextWidget(text: classe.description ?? ""),
                    const CustomDivider()
                  ],
                )
              : Container(),
          classTeachers.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Teacher:",
                      style: H20W3,
                    ),
                    const SizedBox(height: 2),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            ClassTeacherChips(
                                classTeacherList: List<TeacherModel>.from(
                                    classTeachers.map((e) => e.teacher))),
                          ],
                        ),
                      ),
                    ),
                    const CustomDivider()
                  ],
                )
              : Container(),
          classe.requirements != null && classe.requirements != ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Requirements",
                      textAlign: TextAlign.start,
                      style: H20W3,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      classe.requirements!,
                      textAlign: TextAlign.start,
                    ),
                    const CustomDivider()
                  ],
                )
              : Container(),
          classe.pricing != null && classe.pricing != ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prices",
                      textAlign: TextAlign.start,
                      style: H20W3,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      classe.pricing!,
                      textAlign: TextAlign.start,
                    ),
                    const CustomDivider()
                  ],
                )
              : Container(),

          classe.location?.coordinates?[1] != null &&
                  classe.location?.coordinates?[0] != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Location",
                          style: H20W3,
                        ),
                        OpenGoogleMaps(
                          latitude: classe.location!.coordinates![1] * 1.0,
                          longitude: classe.location!.coordinates![0] * 1.0,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: MapWidget(
                        zoom: 15.0,
                        center: LatLng(classe.location!.coordinates![1] * 1.0,
                            classe.location!.coordinates![0] * 1.0),
                        markerLocation: LatLng(
                            classe.location!.coordinates![1] * 1.0,
                            classe.location!.coordinates![0] * 1.0),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Divider(),
                    )
                  ],
                )
              : Container(),
          (classe.uscUrl != null && classe.uscUrl != "") ||
                  (classe.classPassUrl != null && classe.classPassUrl != "") ||
                  (classe.websiteUrl != null && classe.websiteUrl != "")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Links",
                        style: H20W3,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            classe.uscUrl != null && classe.uscUrl != ""
                                ? LinkButton(
                                    text: "Urban Sport", link: classe.uscUrl!)
                                : Container(),
                            classe.classPassUrl != null &&
                                    classe.classPassUrl != ""
                                ? LinkButton(
                                    text: "Class Pass",
                                    link: classe.classPassUrl!)
                                : Container(),
                            classe.websiteUrl != null && classe.websiteUrl != ""
                                ? LinkButton(
                                    text: "Website", link: classe.websiteUrl!)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    const CustomDivider()
                  ],
                )
              : Container(),
          // ClassEventCalenderQuery(classId: classe.id!),
          const SizedBox(height: 100)
        ],
      ),
    ));
  }
}
