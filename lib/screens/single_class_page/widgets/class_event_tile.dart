import 'package:acroworld/components/gender_distribution_pie_from_class_event_id.dart';
import 'package:acroworld/components/spaced_column/spaced_column.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_button.dart';
import 'package:acroworld/screens/users_list/user_list_screen.dart';
import 'package:acroworld/utils/helper_functions/datetime_helper.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClassEventTile extends StatefulWidget {
  const ClassEventTile(
      {Key? key,
      required this.classEvent,
      required this.isParticipate,
      required this.participants})
      : super(key: key);

  final ClassEvent classEvent;
  final bool isParticipate;
  final List<User> participants;

  @override
  State<ClassEventTile> createState() => _ClassEventTileState();
}

class _ClassEventTileState extends State<ClassEventTile> {
  late bool isParticipateState;
  late String? classEventId;

  @override
  void initState() {
    super.initState();
    isParticipateState = widget.isParticipate;
    classEventId = widget.classEvent.id;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Mutation(
        options: MutationOptions(
            onCompleted: (data) {
              setState(() {
                isParticipateState = !isParticipateState;
              });
            },
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpacedColumn(
                space: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDateTime(
                          DateTime.parse(widget.classEvent.startDate!))),
                      Text(
                          "${DateFormat('H:mm').format(DateTime.parse(widget.classEvent.startDate!))} - ${DateFormat('Hm').format(DateTime.parse(widget.classEvent.endDate!))}",
                          style: H12W4)
                    ],
                  ),
                  classEventId != null
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QueryUserListScreen(
                                  query: Queries.getClassParticipants,
                                  variables: {
                                    'class_event_id': widget.classEvent.id
                                  },
                                  title: 'Participants',
                                  classEventId: widget.classEvent.id,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            child: GenderDistributionPieFromClassEventId(
                              classEventId: classEventId!,
                              key: UniqueKey(),
                            ),
                          ))
                      : Container(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isParticipateState ? Colors.grey : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          isParticipateState
                              ? runMutation({
                                  'class_event_id': widget.classEvent.id,
                                  'user_id': userProvider.activeUser!.id!
                                })
                              : runMutation({
                                  'class_event_id': widget.classEvent.id,
                                });
                        },
                        child: const Text(
                          "Participate",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      widget.classEvent.classModel
                                      ?.classBookingOptions !=
                                  null &&
                              widget.classEvent.classModel!.classBookingOptions!
                                  .isNotEmpty &&
                              widget.classEvent.classModel?.maxBookingSlots !=
                                  null
                          ? BookNowButton(
                              classEvent: widget.classEvent,
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
