import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/components/search_bar_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/location_search_screen/set_to_user_location_widget.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class PlaceQuery extends StatelessWidget {
  const PlaceQuery(
      {super.key, required this.placeId, required this.onPlaceSet});

  final String placeId;
  final Function(Place place) onPlaceSet;

  @override
  Widget build(BuildContext context) {
    // TODO create a location service that sets the place and fetches the right place from the place id
    // and fetches all possible places
    return Query(
      options: QueryOptions(
          document: Queries.getPlace,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'id': placeId}),
      builder: (QueryResult placeResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (placeResult.data != null) {
          Place place = Place.fromJson(placeResult.data!['place']);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onPlaceSet(place);
          });

          return const LoadingWidget();
        } else if (placeResult.hasException || !placeResult.isConcrete) {
          return Container();
        } else {
          return const LoadingWidget();
        }
      },
    );
  }
}

class PlacesQuery extends StatelessWidget {
  const PlacesQuery(
      {super.key, required this.query, required this.onPlaceIdSet});

  final String query;
  final Function(String placeId) onPlaceIdSet;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: Queries.getPlaces,
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {'query': query}),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: const LoadingIndicator());
        }
        if (result.hasException) {
          return ErrorWidget(result.exception.toString());
        }
        if (result.data != null) {
          Map<String, dynamic> data = result.data!;
          if (data.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.from(
                result.data?['places'].map((place) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0)
                        .copyWith(bottom: 8),
                    child: StandardIconButton(
                      withBorder: false,
                      text: place['description'],
                      icon: Icons.location_on,
                      onPressed: () {
                        onPlaceIdSet(place['id']);
                      },
                    ),
                  );
                }),
              ),
            );
          } else {
            return ErrorWidget(
                "Something unexpected went wrong, restart or update your app");
          }
        }
        return Container();
      },
    );
  }
}

class PlaceSearchBody extends StatefulWidget {
  const PlaceSearchBody({super.key});

  @override
  State<PlaceSearchBody> createState() => _PlaceSearchBodyState();
}

class _PlaceSearchBodyState extends State<PlaceSearchBody> {
  String query = '';
  String placeId = '';
  bool isNavigatedBack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SearchBarWidget(
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
            autofocus: true,
          ),
          const SizedBox(height: AppPaddings.medium),
          const SetToUserLocationWidget(),
          const SizedBox(height: AppPaddings.medium),
          SingleChildScrollView(
            child: query.isNotEmpty
                ? placeId.isNotEmpty
                    ? PlaceQuery(
                        placeId: placeId,
                        onPlaceSet: (Place place) {
                          LocationSingleton().setPlace(place);
                          Provider.of<PlaceProvider>(context, listen: false)
                              .updatePlace(place);
                          Provider.of<CalendarProvider>(context, listen: false)
                              .fetchClasseEvents();
                          // updateCurrentCameraPosition MapEventsProvider
                          Provider.of<MapEventsProvider>(context, listen: false)
                              .setPlaceFromPlace(place);

                          Provider.of<MapEventsProvider>(context, listen: false)
                              .fetchClasseEvents();
                          if (!isNavigatedBack) {
                            Navigator.of(context).pop();
                            setState(() {
                              isNavigatedBack = true;
                            });
                          }
                        },
                      )
                    : PlacesQuery(
                        query: query,
                        onPlaceIdSet: (String placeId) {
                          setState(() {
                            this.placeId = placeId;
                          });
                        },
                      )
                : Container(),
          )
        ],
      ),
    );
  }
}
