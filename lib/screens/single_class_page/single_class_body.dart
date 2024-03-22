import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/datetime/date_time_service.dart';
import 'package:acroworld/components/open_google_maps.dart';
import 'package:acroworld/components/open_map.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/main_pages/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody({super.key, required this.classe, this.classEvent});

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
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium)
          .copyWith(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classe.name ?? "",
              maxLines: 3, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          classEvent != null &&
                  classEvent!.startDate != null &&
                  classEvent!.endDate != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        DateTimeService.getDateString(
                            classEvent!.startDate!, classEvent!.endDate!),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: CustomColors.accentColor)
                            .copyWith(letterSpacing: -0.5)),
                    const CustomDivider()
                  ],
                )
              : Container(),
          classe.description != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Html(
                        data: classe.description!,
                        onLinkTap: (url, attributes, element) {
                          if (url != null) {
                            customLaunch(url).catchError((e) =>
                                CustomErrorHandler.captureException(
                                    e.toString()));
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Container(),
          classTeachers.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Teacher:",
                      style: Theme.of(context).textTheme.headlineMedium,
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

          classe.location?.coordinates?[1] != null &&
                  classe.location?.coordinates?[0] != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        OpenGoogleMaps(
                          latitude: classe.location!.coordinates![1] * 1.0,
                          longitude: classe.location!.coordinates![0] * 1.0,
                        )
                      ],
                    ),
                    classe.locationName != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              classe.locationName!,
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
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: OpenMap(
                        initialZoom: 15,
                        latitude: classe.location!.coordinates![1] * 1.0,
                        longitude: classe.location!.coordinates![0] * 1.0,
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
                      child: Text(
                        "Links",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    classe.websiteUrl != null && classe.websiteUrl != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.only(top: AppPaddings.medium),
                            child: LinkButton(
                                text: "Website", link: classe.websiteUrl!),
                          )
                        : Container(),
                  ],
                )
              : Container(),
          // ClassEventCalenderQuery(classId: classe.id!),
          const SizedBox(height: AppPaddings.extraLarge)
        ],
      ),
    ));
  }
}
