import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/shared/widgets/loading_indicator/loading_indicator.dart';
import 'package:acroworld/shared/widgets/place_map/place_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({Key? key, required this.onPlaceSet}) : super(key: key);

  final Function(Place place) onPlaceSet;

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  String queryInput = "";
  String searchQuery = "";
  bool isLoading = false;
  LatLng? latLng;
  String? placeId;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    FloatingSearchBarController controller = FloatingSearchBarController();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          constraints: const BoxConstraints(maxHeight: 350),
          child: PlaceMap(
            placeId: placeId,
            onLoaded: widget.onPlaceSet,
          ),
        ),
        Container(
            height: 350,
            child: FloatingSearchBar(
              hint: 'Search...',
              controller: controller,
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              width: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              automaticallyImplyBackButton: false,
              automaticallyImplyDrawerHamburger: false,
              onSubmitted: (query) {
                setState(() {
                  isLoading = true;
                  searchQuery = query;
                });
              },
              onQueryChanged: (query) {
                queryInput = query;
              },
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                isLoading
                    ? const LoadingIndicator()
                    : FloatingSearchBarAction(
                        showIfOpened: true,
                        child: CircularButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              searchQuery = queryInput;
                            });
                          },
                        ),
                      ),
              ],
              builder: (context, transition) {
                if (searchQuery == "") {
                  return Container();
                } else {
                  return Query(
                    options: QueryOptions(
                        document: Queries.getPlaces,
                        fetchPolicy: FetchPolicy.networkOnly,
                        variables: {'query': searchQuery}),
                    builder: (QueryResult result,
                        {VoidCallback? refetch, FetchMore? fetchMore}) {
                      if (result.isLoading) {
                        return Container();
                      } else {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.white,
                          elevation: 4.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.from(
                              result.data?['places'].map((place) {
                                return TextButton(
                                  onPressed: () {
                                    controller.clear();
                                    controller.close();
                                    setState(() {
                                      searchQuery = "";
                                      queryInput = "";
                                      placeId = place['id'];
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
              },
            )),
      ],
    );
  }
}
