import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/error_page.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/screens/jam/jams/jam_tile.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class JamsViewQuery extends StatefulWidget {
  const JamsViewQuery({Key? key, this.place, required this.day})
      : super(key: key);
  final Place? place;
  final DateTime day;

  @override
  State<JamsViewQuery> createState() => _JamsViewQueryState();
}

class _JamsViewQueryState extends State<JamsViewQuery> {
  List<StreamSubscription> eventListeners = [];

  @override
  void dispose() {
    super.dispose();
    for (final eventListener in eventListeners) {
      eventListener.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventBusProvider eventBusProvider =
        Provider.of<EventBusProvider>(context, listen: false);
    final EventBus eventBus = eventBusProvider.eventBus;

    return Query(
      options: QueryOptions(
        document: Queries.getAllJamsFromMyCommunities,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return ErrorPage(error: result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(child: LoadingWidget());
        }

        Future<void> runRefetch() async {
          try {
            refetch!();
          } catch (e) {
            print(e.toString());
          }
        }

        eventListeners.add(eventBus.on<ParticipateToJamEvent>().listen((event) {
          runRefetch();
        }));

        eventListeners.add(eventBus.on<CrudJamEvent>().listen((event) {
          runRefetch();
        }));

        List<Jam> jams = [];

        // TODO We want only the jams that are close to <place>

        if (result.data?["me"]?[0]?["communities"] != null) {
          for (Map<String, dynamic> com in result.data!["me"][0]
              ["communities"]) {
            if (com["community"]?["jams"] != null) {
              for (Map<String, dynamic> jamObject in com["community"]["jams"]) {
                Jam jam = Jam.fromJson(jamObject);
                if (isSameDate(jam.date!, widget.day)) {
                  jams.add(jam);
                }
              }
            }
          }
        }

        jams.sort((a, b) => b.date!.isBefore(a.date!) ? 1 : 0);

        return RefreshIndicator(
          onRefresh: () => runRefetch(),
          child: ListView.builder(
            itemCount: jams.length,
            itemBuilder: (context, index) {
              print(jams[index].participants);
              return JamTile(
                jam: jams[index],
                cid: jams[index].cid!,
                communityName: jams[index].community?.name,
              );
            },
          ),
        );
      },
    );
  }
}
