import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class SingleClassPage extends StatelessWidget {
  const SingleClassPage({Key? key, required this.teacherClass})
      : super(key: key);

  final ClassModel teacherClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Query(
            options: QueryOptions(
                document: Queries.getClassEventsByClassId,
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {"class_id": teacherClass.id}),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Loading();
              }

              VoidCallback runRefetch = (() {
                try {
                  refetch!();
                } catch (e) {
                  print(e.toString());
                  // print(e);
                }
              });

              List<ClassEvent> classEvents = [];

              result.data!["class_events"].forEach(
                  (cEvent) => classEvents.add(ClassEvent.fromJson(cEvent)));

              // for (Map<String, dynamic> json in result.data!["teachers"]) {
              //   teachers.add(TeacherModel.fromJson(json));
              // }

              return ListView.builder(
                itemCount: classEvents.length,
                itemBuilder: ((context, index) {
                  ClassEvent indexClass = classEvents[index];

                  DateTime startDate =
                      DateTime.parse(indexClass.startDate).toLocal();
                  DateTime endDate =
                      DateTime.parse(indexClass.startDate).toLocal();
                  return ListTile(
                    // leading: const CircleAvatar(
                    //   radius: 3,
                    //   backgroundImage: AssetImage("assets/logo/play_store_512.png"),
                    // ),
                    title: Text(
                        "${DateFormat('EEE, H:mm').format(startDate)} - ${DateFormat('Hm').format(endDate)}"),
                    subtitle: Text(teacherClass.name),
                    //     style: const TextStyle(fontWeight: FontWeight.w300)),
                    trailing: indexClass.isCancelled
                        ? const Text("is cancelled")
                        : null,
                  );
                }),
              );
            }));
  }
}
