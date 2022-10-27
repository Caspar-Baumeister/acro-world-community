import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/screens/classes/widgets/classes_calendar.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/place_button/place_button.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassesBody extends StatefulWidget {
  const ClassesBody({Key? key}) : super(key: key);

  @override
  State<ClassesBody> createState() => _ClassesBodyState();
}

class _ClassesBodyState extends State<ClassesBody> {
  late Place? place;
  late QueryOptions queryOptions;
  late String selector;
  DateTime selctedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    place = PlacePreferences.getSavedPlace();
  }

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
      selector = 'classes_by_location_v1';
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: PlaceButton(
              initialPlace: place,
              onPlaceSet: (Place _place) async {
                PlacePreferences.setSavedPlace(_place);
                setState(
                  () {
                    place = _place;
                  },
                );
              },
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
                List<ClassEvent> classEvents = [];

                if (result.data!.keys.contains(selector) &&
                    result.data![selector] != null) {
                  result.data![selector].forEach((clas) {
                    classes.add(ClassModel.fromJson(clas));
                    if (clas["class_events"] != null &&
                        clas["class_events"].isNotEmpty) {
                      clas["class_events"].forEach((element) {
                        classEvents.add(ClassEvent.fromJson(element,
                            classModel: ClassModel.fromJson(clas)));
                      });
                    }
                  });
                }
                return ClassesEventCalendar(
                    kEvents: classEventToHash(classEvents));
              }),
        ],
      ),
    );
  }
}
