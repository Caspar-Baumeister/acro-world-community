import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/location_search_screen/place_search_screen.dart';
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
  late QueryOptions queryOptions;
  late String selector;

  @override
  Widget build(BuildContext context) {
    if (place == null) {
      queryOptions = QueryOptions(
        document: Queries.getClasses,
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'classes';
    } else {
      queryOptions = QueryOptions(
        document: Queries.getClassesByLocation,
        variables: {
          'latitude': place!.latLng.latitude,
          'longitude': place!.latLng.longitude
        },
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'classes_by_location';
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlaceSearchScreen(
                          onPlaceSet: (Place place) {
                            Future.delayed(
                              Duration.zero,
                              () => setState(
                                () {
                                  this.place = place;
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        )),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.location_city),
                Text(
                  place?.description ?? 'No location set',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Query(
            options: queryOptions,
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

              result.data![selector]
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
                        subtitle: Text(indexClass.locationName +
                            (indexClass.distance != null
                                ? " (${indexClass.distance!.toStringAsFixed(2)} km from city centre)"
                                : "")),
                      ),
                    );
                  }));
            }),
      ],
    );
  }
}
