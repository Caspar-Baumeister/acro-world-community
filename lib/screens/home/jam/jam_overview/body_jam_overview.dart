import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/errors/graphql_error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/jam/jam_overview/participant_modal.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;
    final UserModel user = Provider.of<UserProvider>(context).activeUser!;

    isUserParticipating = widget.jam.participants
        .any((participant) => participant.uid == user.uid);

    // String timeString = timeago.format(widget.jam.date);
    String dateString =
        DateFormat('EEEE – kk:mm – dd-MM-yyyy').format(widget.jam.date);

    eventBus.on<CrudJamEvent>().listen((CrudJamEvent crudJamEvent) {
      Jam crudJam = crudJamEvent.jam;
      if (crudJam.jid == widget.jam.jid) {
        setState(() {
          widget.jam = crudJam;
        });
      }
    });

    return SingleChildScrollView(
      child: Mutation(
        options: MutationOptions(
          document: isUserParticipating
              ? Mutations.removeJamParticipation
              : Mutations.particapteToJam,
          onCompleted: (dynamic resultData) {
            isLoading = false;
            setState(() {
              isUserParticipating = !isUserParticipating;
            });
            eventBus.fire(ParticipateToJamEvent(widget.jam));
            dynamic returnObject = resultData['insert_jam_participants'] ??
                resultData['delete_jam_participants'];
            widget.jam = Jam.fromJson(returnObject['returning'][0]['jam']);
          },
          onError: GraphQLErrorHandler().handleError,
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0)
                        .copyWith(top: 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.jam.name,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 0.0, 0.0),
                    child: Text("Date",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik")),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dateString,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 0.0, 8.0),
                    child: Text("Information",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik")),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.jam.info,
                      maxLines: 60,
                      style: const TextStyle(fontSize: 16.0),
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
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
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: MapWidget(
                      zoom: 15.0,
                      center: widget.jam.latLng,
                      markerLocation: widget.jam.latLng,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
