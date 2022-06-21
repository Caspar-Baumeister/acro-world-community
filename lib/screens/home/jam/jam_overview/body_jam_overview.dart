import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/model/user/user.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/participant_modal.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:event_bus/event_bus.dart';

class JamOverviewBody extends StatefulWidget {
  JamOverviewBody({required this.jam, required this.cid, Key? key})
      : super(key: key);
  Jam jam;
  final String cid;

  @override
  State<JamOverviewBody> createState() => _JamOverviewBodyState();
}

class _JamOverviewBodyState extends State<JamOverviewBody> {
  bool isLoading = false;
  bool isUserParticipating = false;

  void onError(OperationException? errorData) {
    String errorMessage = "";
    if (errorData != null) {
      if (errorData.graphqlErrors.isNotEmpty) {
        errorMessage = errorData.graphqlErrors[0].message;
      }
    }
    if (errorMessage == "") {
      errorMessage = "An unknown error occured";
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;
    final UserModel user = Provider.of<UserProvider>(context).activeUser!;

    isUserParticipating = widget.jam.participants
        .any((participant) => participant.uid == user.uid);

    String timeString = timeago.format(widget.jam.date);
    String dateString =
        DateFormat('EEEE – kk:mm – dd-MM-yyyy').format(widget.jam.date);

    return SingleChildScrollView(
      child: Mutation(
        options: MutationOptions(
          document: isUserParticipating
              ? Mutations.removeJamParticipation
              : Mutations.particapteToJam,
          onCompleted: (dynamic resultData) {
            isLoading = false;
            isUserParticipating = !isUserParticipating;
            eventBus.fire(ParticipateToJamEvent(widget.jam.jid));
            print(resultData);
            dynamic returnObject = resultData['insert_jam_participants'] ??
                resultData['delete_jam_participants'];
            widget.jam = Jam.fromJson(returnObject['returning'][0]['jam']);
          },
          onError: onError,
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
                    widget.jam.info ?? "",
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
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          onPressed: () => buildMortal(
                              context,
                              ParticipantModal(
                                  participants: widget.jam.participants
                                      .map((e) => e.userName)
                                      .toList())),
                          child: Text(
                            "${widget.jam.participants.length.toString()} participant/s",
                            maxLines: 10,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: IgnorePointer(
                          ignoring: isLoading,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                textStyle: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              isLoading = true;
                              runMutation({'jamId': widget.jam.jid});
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: isLoading
                                  ? [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    ]
                                  : [
                                      isUserParticipating
                                          ? const Icon(Icons.remove,
                                              color: Colors.black54)
                                          : const Icon(Icons.add,
                                              color: Colors.black54),
                                      const SizedBox(width: 8),
                                      Text(
                                        isUserParticipating
                                            ? "Leave"
                                            : "Participate",
                                        maxLines: 10,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54),
                                      ),
                                    ],
                            ),
                          ),
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
