import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/home_screens/events/widgets/event_filter_on_card.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventSection extends StatelessWidget {
  const EventSection({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getEventsByTeacherId,
            fetchPolicy: FetchPolicy.noCache,
            variables: {"teacher_id": teacherId}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading || result.data == null) {
            return const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: LoadingWidget(),
              ),
            );
          }

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          });

          List<EventModel> events = [];
          List<EventModel> ownedEvents = [];
          List<EventModel> teachedEvents = [];
          try {
            result.data!["teachers_by_pk"]["events"].forEach((event) =>
                teachedEvents.add(EventModel.fromJson(event["event"])));
            result.data!["teachers_by_pk"]["owned_events"].forEach((event) =>
                ownedEvents.add(EventModel.fromJson(event["event"])));

            events = ownedEvents + teachedEvents;
          } catch (e) {
            print(e.toString());
          }

          return RefreshIndicator(
            onRefresh: () async => runRefetch(),
            child: events.isEmpty
                ? const Center(
                    child: Text("no events"),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: ((context, index) {
                      EventModel event = events[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: EventFilterOnCard(event: event),
                      );
                    })),
          );
        });
  }
}
