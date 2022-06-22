import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/events/jams/participate_to_jam_event.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/calender/calender_body.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class FutureCalenderJams extends StatefulWidget {
  const FutureCalenderJams({Key? key}) : super(key: key);

  @override
  State<FutureCalenderJams> createState() => _FutureCalenderJamsState();
}

class _FutureCalenderJamsState extends State<FutureCalenderJams> {
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
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Loading();
        }

        eventBus.on<ParticipateToJamEvent>().listen((event) {
          refetch!();
        });

        List<Jam> jams = [];

        for (Map<String, dynamic> com in result.data!["me"][0]["communities"]) {
          for (Map<String, dynamic> jam in com["community"]["jams"]) {
            jams.add(Jam.fromJson(jam));
          }
        }

        return RefreshIndicator(
          onRefresh: (() async => refetch!()),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: CalenderBody(
                userJams: jams,
              ),
            ),
          ),
        );
      },
    );
  }
}
