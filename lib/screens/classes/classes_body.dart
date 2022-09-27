import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/teacher/single_class_page.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassesBody extends StatelessWidget {
  const ClassesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.getClasses,
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

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
              // print(e);
            }
          });

          List<ClassModel> classes = [];

          result.data!["classes"]
              .forEach((clas) => classes.add(ClassModel.fromJson(clas)));

          // for (Map<String, dynamic> json in result.data!["teachers"]) {
          //   teachers.add(TeacherModel.fromJson(json));
          // }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: classes.length,
              itemBuilder: ((context, index) {
                ClassModel indexClass = classes[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SingleClassPage(
                              teacherClass: indexClass,
                              teacherName: "",
                            )),
                  ),
                  child: ListTile(
                    // leading: const CircleAvatar(
                    //   radius: 3,
                    //   backgroundImage: AssetImage("assets/logo/play_store_512.png"),
                    // ),
                    leading: indexClass.imageUrl != null
                        ? SizedBox(
                            height: 85.0,
                            width: 120.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    indexClass.imageUrl!,
                                  )),
                            ),
                          )
                        : null,
                    title: Text(indexClass.name),
                    subtitle: Text(indexClass.locationName),
                    //     style: const TextStyle(fontWeight: FontWeight.w300)),
                  ),
                );
              }));
        });
  }
}
