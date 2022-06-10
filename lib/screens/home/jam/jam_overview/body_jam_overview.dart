import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/jam/jam_overview/participant_modal.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class JamOverviewBody extends StatelessWidget {
  const JamOverviewBody({required this.jam, required this.cid, Key? key})
      : super(key: key);
  final Jam jam;
  final String cid;

  @override
  Widget build(BuildContext context) {
    String timeString = timeago.format(jam.date);
    String dateString =
        DateFormat('EEEE – kk:mm – dd-MM-yyyy').format(jam.date);
    return SingleChildScrollView(
      child: Mutation(
        options: MutationOptions(
          document: gql(Mutations
              .particapteToJam), // this is the mutation string you just created
          onCompleted: (dynamic resultData) {
            print(resultData);
          },
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                  child: Text("Date",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: "rubik")),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dateString,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.fromLTRB(14.0, 0, 0.0, 8.0),
                  child: Text("Information",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: "rubik")),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    jam.info ?? "",
                    maxLines: 10,
                    style: const TextStyle(
                        color: Color(0xFFA4A4A4), fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        onPressed: () => buildMortal(context,
                            ParticipantModal(participants: jam.participants)),
                        child: Text(
                          "${jam.participants.length.toString()} participants",
                          maxLines: 10,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black54),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        onPressed: () => runMutation({'jamId': jam.jid}),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              "Participate",
                              maxLines: 10,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
