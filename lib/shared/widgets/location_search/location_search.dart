import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/home/map/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PlaceWidget extends StatefulWidget {
  PlaceWidget(
      {Key? key, required this.placesResult, required this.onResultCallback})
      : super(key: key);

  QueryResult placesResult;
  void Function(QueryResult result) onResultCallback;

  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  String id = "";

  Object? placesResult;
  @override
  Widget build(BuildContext context) {
    print(placesResult);
    return Query(
      options: QueryOptions(
          document: Queries.getPlace,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'id': id}),
      builder: (QueryResult placeResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (!placeResult.hasException) {
          print(placeResult);
          widget.onResultCallback(placeResult);
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.from(
                widget.placesResult.data?['places'].map((place) {
                  return TextButton(
                    onPressed: () {
                      setState(() {
                        id = place['id'];
                      });
                    },
                    child: Text(place['description']),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key}) : super(key: key);

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  String searchQuery = "";
  LatLng? latLng;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          constraints: const BoxConstraints(maxHeight: 350),
          child: MapWidget(center: latLng),
        ),
        Container(
            height: 350,
            child: FloatingSearchBar(
              hint: 'Search...',
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              width: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                print(query);
                // Call your model, bloc, controller here.
                setState(() {
                  searchQuery = query;
                });
              },
              // Specify a custom transition to be used for
              // animating between opened and closed stated.
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(Icons.place),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                return Query(
                  options: QueryOptions(
                      document: Queries.getPlaces,
                      fetchPolicy: FetchPolicy.networkOnly,
                      variables: {'query': searchQuery}),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    return PlaceWidget(
                        placesResult: result,
                        onResultCallback: (result) {
                          print('onResultCallback');
                          setState(() {
                            latLng = LatLng(result.data?['place']['latitude'],
                                result.data?['place']['longitude']);
                          });
                        });
                  },
                );
              },
            )),
      ],
    );
  }
}
