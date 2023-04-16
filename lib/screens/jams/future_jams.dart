import 'dart:async';

import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/create_jam_event.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/jams/jams_body.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';

class FutureJams extends StatefulWidget {
  const FutureJams({Key? key, required this.cId}) : super(key: key);

  final String cId;

  @override
  State<FutureJams> createState() => _FutureJamsState();
}

class _FutureJamsState extends State<FutureJams> {
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
        Provider.of<EventBusProvider>(context);
    final EventBus eventBus = eventBusProvider.eventBus;

    return Query(
      options: QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: Queries.jamsByCommunityId,
        variables: {
          'communityId': widget.cId,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const LoadingWidget();
        }

        VoidCallback runRefetch = (() {
          refetch!();
        });

        eventListeners.add(eventBus.on<ParticipateToJamEvent>().listen((event) {
          if (event.jam.communityId == widget.cId) {
            runRefetch();
          }
        }));

        eventListeners.add(eventBus.on<CrudJamEvent>().listen((event) {
          if (event.jam.communityId == widget.cId) {
            runRefetch();
          }
        }));

        return RefreshIndicator(
          onRefresh: (() async => runRefetch()),
          child: JamsBody(
            jams: List<Jam>.from(
                result.data?['jams'].map((e) => Jam.fromJson(e))),
            cId: widget.cId,
          ),
        );
      },
    );
  }
}
