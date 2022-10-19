import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/users/user_list_screen.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpacedColumn(
                space: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat('EEE, H:mm').format(widget.classEvent.date)} - ${DateFormat('Hm').format(widget.classEvent.endDate)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QueryUserListScreen(
                            query: Queries.getClassParticipants,
                            variables: {'class_event_id': widget.classEvent.id},
                            title: 'Participants',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Participants: ${isParticipateState ? "You" : ""}${isParticipateState && widget.participants.isNotEmpty ? ", " : ""}${widget.participants.map((e) => "${e.name}").toList().join(", ")}",
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {
                              isParticipateState = !isParticipateState;
                            });
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
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
