import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/single_jam_overview/participant_modal.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../graphql/mutations.dart';

class JamParticipantsButton extends StatefulWidget {
  const JamParticipantsButton({
    Key? key,
    required this.jamId,
    required this.participants,
    required this.uid,
  }) : super(key: key);

  final List<Participants> participants;
  final String uid;
  final String jamId;

  @override
  State<JamParticipantsButton> createState() => _JamParticipantsButtonState();
}

class _JamParticipantsButtonState extends State<JamParticipantsButton> {
  late bool isParticipateState;
  late List<User> realParticipants;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isParticipateState = widget.participants
        .map((paicipant) => paicipant.user!.id)
        .toList()
        .contains(widget.uid);
    realParticipants = widget.participants.map((e) => e.user!).toList();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Mutation(
        options: MutationOptions(
          document: isParticipateState
              ? Mutations.removeJamParticipation
              : Mutations.particapteToJam,
          onCompleted: (dynamic resultData) {
            loading = false;
            if (!isParticipateState) {
              realParticipants.add(userProvider.activeUser!);
            }
            if (isParticipateState) {
              realParticipants.remove(userProvider.activeUser!);
            }
            setState(() {
              isParticipateState = !isParticipateState;
            });
          },
          onError: GraphQLErrorHandler().handleError,
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
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
                    buildMortal(
                      context,
                      ParticipantModal(
                        participants: realParticipants,
                        jamId: widget.jamId,
                      ),
                    );
                    // Show user list
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => QueryUserListScreen(
                    //       query: Queries.getClassParticipants,
                    //       variables: {'jamId': widget.jamId},
                    //       title: 'Participants',
                    //       jamId: widget.jamId,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Text(
                    realParticipants.length.toString(),
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
                              'jamId': widget.jamId,
                            })
                          : runMutation({
                              'jamId': widget.jamId,
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
