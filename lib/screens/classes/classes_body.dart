import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassesBody extends StatefulWidget {
  const ClassesBody({Key? key}) : super(key: key);

  @override
  State<ClassesBody> createState() => _ClassesBodyState();
}

class _ClassesBodyState extends State<ClassesBody> {
  Place? place;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Query(
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
                                  teacherName: "",
                                )),
                      ),
                      child: ListTile(
                        leading: indexClass.imageUrl != null
                            ? SizedBox(
                                height: 85.0,
                                width: 120.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 52.0,
                                    placeholder: (context, url) => Container(
                                      color: Colors.black12,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.black12,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    imageUrl: indexClass.imageUrl!,
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
            }),
      ],
    );
  }
}
