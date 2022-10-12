import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassSection extends StatelessWidget {
  const ClassSection({Key? key, required this.teacher}) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: Queries.getClassesByTeacherId,
            fetchPolicy: FetchPolicy.networkOnly,
            variables: {"teacher_id": teacher.id}),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading || result.data == null) {
            return const Loading();
          }

          VoidCallback runRefetch = (() {
            try {
              refetch!();
            } catch (e) {
              print(e.toString());
            }
          });

          List<ClassModel> classes = [];

          result.data!["classes"]
              .forEach((clas) => classes.add(ClassModel.fromJson(clas)));

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
                              teacherName: teacher.name,
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
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: indexClass.imageUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 85.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 85.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 85.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
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
