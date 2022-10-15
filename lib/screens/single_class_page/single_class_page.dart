import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_body.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SingleClassPage extends StatelessWidget {
  const SingleClassPage(
      {Key? key, required this.teacherClass, required this.teacherName})
      : super(key: key);

  final ClassModel teacherClass;
  final String teacherName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            title: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: teacherClass.name,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18)),
                ],
              ),
            )),
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
                }
              });

              List<ClassEvent> classEvents = [];

              result.data!["class_events"].forEach(
                  (cEvent) => classEvents.add(ClassEvent.fromJson(cEvent)));

              return SingleClassBody(
                classe: teacherClass,
                classEvents: classEvents,
              );
            }));
  }
}
