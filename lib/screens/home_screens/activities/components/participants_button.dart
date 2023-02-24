import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/users_list/user_list_screen.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../graphql/mutations.dart';

class ParticipantsButton extends StatefulWidget {
  const ParticipantsButton(
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
  State<ParticipantsButton> createState() => _ParticipantsButtonState();
}

class _ParticipantsButtonState extends State<ParticipantsButton> {
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

          return Stack(
            children: [
              SizedBox(
                width: PARTICIPANT_BUTTON_WIDTH,
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
                          classEventId: widget.classEventId,
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
                  height: PARTICIPANT_BUTTON_HEIGHT,
                  width: PARTICIPANT_BUTTON_HEIGHT,
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
