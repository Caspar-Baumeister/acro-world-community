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
import 'package:acroworld/shared/widgets/open_google_maps.dart';
import 'package:acroworld/widgets/spaced_column/spaced_column.dart';
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
    final User user = Provider.of<UserProvider>(context).activeUser!;

    isUserParticipating =
        widget.jam.participants.any((participant) => participant.id == user.id);

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
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                space: 20,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Creator",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik"),
                      ),
                      Text(
                        widget.jam.createdBy.name ?? "Unknown",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik"),
                      ),
                      Text(
                        dateString,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Information",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik"),
                      ),
                      Text(
                        widget.jam.info,
                        maxLines: 60,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Participants",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: "rubik"),
                      ),
                      GestureDetector(
                        onTap: () => buildMortal(
                          context,
                          ParticipantModal(
                            participants: widget.jam.participants,
                          ),
                        ),
                        child: Text(
                            widget.jam.participants
                                .map((e) => "${e.name}")
                                .toList()
                                .join(", "),
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16.0,
                                color: Colors.black)),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OpenGoogleMaps(
                          latitude: widget.jam.latLng.latitude,
                          longitude: widget.jam.latLng.longitude),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isUserParticipating ? Colors.grey : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          isLoading = true;
                          runMutation({'jamId': widget.jam.jid});
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
