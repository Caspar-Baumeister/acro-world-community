import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/components/search_bar_widget.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/user_mode_screens/location_search_screen/set_to_user_location_widget.dart';
import 'package:acroworld/services/location_singleton.dart';
import 'package:acroworld/utils/colors.dart';
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
      {super.key,
      required this.query,
      required this.onPlaceIdSet,
      this.queryOptions,
      this.selector = 'places'});

  final String query;
  final Function(String placeId, {String? description}) onPlaceIdSet;
  final QueryOptions? queryOptions;
  final String? selector;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: queryOptions ??
          QueryOptions(
              document: Queries.getPlacesIdsCity,
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
          CustomErrorHandler.captureException(
              Exception("Error while transforming places to objects"),
              stackTrace: StackTrace.current);
          return ErrorWidget(result.exception.toString());
        }
        if (result.data != null) {
          Map<String, dynamic> data = result.data!;
          if (data.isEmpty ||
              data[selector] == null ||
              data[selector].isEmpty) {
            return const Center(
              child: Text("No places found"),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppPaddings.medium, vertical: AppPaddings.medium),
            margin: const EdgeInsets.symmetric(vertical: AppPaddings.small),
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              borderRadius: AppBorders.smallRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: result.data?[selector].length,
              separatorBuilder: (BuildContext context, int index) =>
                  const CustomDivider(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    onPlaceIdSet(result.data?[selector][index]['id'],
                        description: result.data?[selector][index]
                            ['description']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppPaddings.medium),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: CustomColors.primaryColor,
                        ),
                        const SizedBox(width: AppPaddings.small),
                        Flexible(
                          child: Text(
                            result.data?[selector]?[index]['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
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
          Row(
            children: [
              Flexible(
                child: SearchBarWidget(
                  onChanged: (String value) {
                    setState(() {
                      query = value;
                    });
                  },
                ),
              ),
              const SetToUserLocationWidget(),
            ],
          ),
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
                        onPlaceIdSet: (String placeId, {String? description}) {
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
