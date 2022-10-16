import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/place_button/place_button.dart';
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
    place = PlacePreferences.getSavedPlace();

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
      selector = 'classes_by_location_v1';
    }
    return Column(
      children: [
        PlaceButton(
          initialPlace: place,
          onPlaceSet: (Place place) {
            Future.delayed(
              Duration.zero,
              () => setState(
                () {
                  this.place = place;
                  PlacePreferences.setSavedPlace(place);
                },
              ),
            );
          },
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

              if (result.data!.keys.contains(selector) &&
                  result.data![selector] != null) {
                result.data![selector]
                    .forEach((clas) => classes.add(ClassModel.fromJson(clas)));
              }
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
                          ),
                        ),
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
                        subtitle: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: indexClass.locationName,
                                  style: const TextStyle(color: Colors.black)),
                              TextSpan(
                                text: indexClass.distance != null
                                    ? " (${indexClass.distance!.toStringAsFixed(2)} km from city centre)"
                                    : "",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }));
            }),
      ],
    );
  }
}
