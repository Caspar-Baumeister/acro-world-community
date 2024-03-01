import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/participants_button.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ParticipatesQuery extends StatelessWidget {
  const ParticipatesQuery({super.key, required this.classEventId});

  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: Queries.getClassEventParticipants,
          variables: {'class_event_id': classEventId},
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return SizedBox(
              height: PARTICIPANT_BUTTON_HEIGHT,
              child: IgnorePointer(
                child: ParticipantsButton(
                    classEventId: classEventId,
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
              .map((u) => User(id: u["user"]["id"], name: u["user"]["name"])));
          bool isParticipate = false;
          participants.forEach(((element) {
            if (element.id ==
                Provider.of<UserProvider>(context, listen: false)
                    .activeUser
                    ?.id) {
              isParticipate = true;
            }
          }));

          return SizedBox(
            height: PARTICIPANT_BUTTON_HEIGHT,
            child: ParticipantsButton(
                classEventId: classEventId,
                countParticipants: participants.length,
                isParticipate: isParticipate,
                runRefetch: runRefetch),
          );
        });
  }
}
