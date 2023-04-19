import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/screens/home_screens/activities/components/participants_button.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
        height: CLASS_CARD_HEIGHT,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Image
            SizedBox(
              width: screenWidth * 0.3,
              child: classEvent.classModel?.imageUrl != null
                  ? Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          foregroundDecoration: classEvent.isCancelled == true
                              ? const BoxDecoration(
                                  color: Colors.grey,
                                  backgroundBlendMode: BlendMode.saturation,
                                )
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              width: screenWidth * 0.3,
                              height: CLASS_CARD_HEIGHT,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.black12,
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black12,
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              imageUrl: classEvent.classModel!.imageUrl!,
                            ),
                          ),
                        ),
                        classEvent.isCancelled == true
                            ? const RotationTransition(
                                turns: AlwaysStoppedAnimation(345 / 360),
                                child: Text(
                                  "Canceled",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                              )
                            : Container()
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classEvent.classModel?.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classEvent.startDate != null &&
                                classEvent.endDate != null
                            ? Text(
                                "${DateFormat('H:mm').format(DateTime.parse(classEvent.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(classEvent.endDate!))}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                                        .where((element) => element != null))),
                          )
                        : Container(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classEvent.classModel?.classLevels != null &&
                                classEvent.classModel!.classLevels!.isNotEmpty
                            ? DifficultyWidget(
                                classEvent.classModel!.classLevels!,
                              )
                            : const SizedBox(
                                width: DIFFICULTY_LEVEL_WIDTH,
                                height: DIFFICULTY_LEVEL_HEIGHT,
                              ),
                        Query(
                            options: QueryOptions(
                              fetchPolicy: FetchPolicy.networkOnly,
                              document: Queries.getClassEventParticipants,
                              variables: {
                                'class_event_id': classEvent.id,
                              },
                            ),
                            builder: (QueryResult result,
                                {VoidCallback? refetch, FetchMore? fetchMore}) {
                              UserProvider userProvider =
                                  Provider.of<UserProvider>(context);

                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }

                              if (result.isLoading) {
                                return SizedBox(
                                  height: PARTICIPANT_BUTTON_HEIGHT,
                                  child: IgnorePointer(
                                    child: ParticipantsButton(
                                        classEventId: classEvent.id!,
                                        countParticipants: null,
                                        isParticipate: false,
                                        runRefetch: () {}),
                                  ),
                                );
                              }

                              VoidCallback runRefetch = (() {
                                refetch!();
                              });

                              List<User> participants = List<User>.from(result
                                  .data!["class_events_participants"]
                                  .map((u) => User(
                                      id: u["user"]["id"],
                                      name: u["user"]["name"])));
                              bool isParticipate = false;
                              participants.forEach(((element) {
                                if (element.id == userProvider.activeUser!.id) {
                                  isParticipate = true;
                                }
                              }));

                              return SizedBox(
                                height: PARTICIPANT_BUTTON_HEIGHT,
                                child: ParticipantsButton(
                                    classEventId: classEvent.id!,
                                    countParticipants: participants.length,
                                    isParticipate: isParticipate,
                                    runRefetch: runRefetch),
                              );
                            })
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
