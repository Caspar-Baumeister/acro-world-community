import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/screens/users_list/user_list_screen.dart';
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
    return GestureDetector(
      onTap: () => classEvent.classModel != null
          ? Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SingleClassPage(
                      teacherClass: classEvent.classModel!,
                      teacherName: "" //classEvent.classModel!.,
                      )),
            )
          : print("isnull"),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: classEvent.classModel?.imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0).copyWith(right: 0),
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 52.0,
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
                    )
                  : Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classEvent.classModel?.name ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${DateFormat('H:mm').format(classEvent.date)} - ${DateFormat('Hm').format(classEvent.endDate)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 16,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.25),
                              child: Text(
                                classEvent.classModel!.locationName,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: const Text(
                              "Participants:",
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                            ))
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        classEvent.classModel != null &&
                                classEvent.classModel!.classLevel.isNotEmpty
                            ? DifficultyWidget(
                                classEvent.classModel!.classLevel,
                              )
                            : const SizedBox(
                                width: 100,
                                height: 15,
                              ),
                        Query(
                            options: QueryOptions(
                              fetchPolicy: FetchPolicy.networkOnly,
                              document: Queries.getClassEventCommunity,
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
                                  height: 48,
                                  child: IgnorePointer(
                                    child: ParticipatentsButton(
                                        classEventId: classEvent.id,
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
                                height: 48,
                                child: ParticipatentsButton(
                                    classEventId: classEvent.id,
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

class ParticipatentsButton extends StatefulWidget {
  const ParticipatentsButton(
      {Key? key,
      this.countParticipants,
      required this.classEventId,
      required this.isParticipate,
      required this.runRefetch})
      : super(key: key);

  final int? countParticipants;
  final String classEventId;
  final bool isParticipate;
  final VoidCallback runRefetch;

  @override
  State<ParticipatentsButton> createState() => _ParticipatentsButtonState();
}

class _ParticipatentsButtonState extends State<ParticipatentsButton> {
  late bool isParticipateState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isParticipateState = widget.isParticipate;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Mutation(
        options: MutationOptions(
            document: isParticipateState
                ? Mutations.leaveParticipateClass
                : Mutations.participateToClass),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result != null && result.hasException) {
            print(result.exception);
          }

          return Stack(
            children: [
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QueryUserListScreen(
                          query: Queries.getClassParticipants,
                          variables: {'class_event_id': widget.classEventId},
                          title: 'Participants',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    widget.countParticipants != null
                        ? "${widget.countParticipants.toString()}       "
                        : "",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: SizedBox(
                  width: 32,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      isParticipateState
                          ? runMutation({
                              'class_event_id': widget.classEventId,
                              'user_id': userProvider.activeUser!.id!
                            })
                          : runMutation({
                              'class_event_id': widget.classEventId,
                            });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        // setState(() {
                        //   isParticipateState = !isParticipateState;
                        // });
                        widget.runRefetch();
                      });
                    },
                    child: Center(
                      child: Icon(
                        isParticipateState ? Icons.remove : Icons.add,
                        size: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

// class DifficultyWidget extends StatelessWidget {
//   const DifficultyWidget({Key? key, required this.classLevel})
//       : super(key: key);

//   final List<String> classLevel;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           "Level:",
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Container(
//           width: 15,
//           height: 15,
//           decoration: BoxDecoration(
//             color: Colors.green[100],
//             border: classLevel.contains("Beginner") ? Border.all() : null,
//           ),
//         ),
//         Container(
//           width: 15,
//           height: 15,
//           decoration: BoxDecoration(
//             color: Colors.yellow[100],
//             border: classLevel.contains("Intermediate") ? Border.all() : null,
//           ),
//         ),
//         Container(
//           width: 15,
//           height: 15,
//           decoration: BoxDecoration(
//             color: Colors.red[100],
//             border: classLevel.contains("Advanced") ? Border.all() : null,
//           ),
//         )
//       ],
//     );
//   }
// }
