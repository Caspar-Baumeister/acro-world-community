import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/components/search_bar_widget.dart';
import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/screens/location_search_screen/set_to_user_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class PlaceQuery extends StatelessWidget {
  const PlaceQuery({Key? key, required this.placeId, required this.onPlaceSet})
      : super(key: key);

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
  const PlacesQuery({Key? key, required this.query, required this.onPlaceIdSet})
      : super(key: key);

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
  const PlaceSearchBody({Key? key}) : super(key: key);

  @override
  State<PlaceSearchBody> createState() => _PlaceSearchBodyState();
}

class _PlaceSearchBodyState extends State<PlaceSearchBody> {
  String query = '';
  String placeId = '';
  bool isNavigatedBack = false;

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = Provider.of<PlaceProvider>(context);
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
          const SizedBox(height: 20),
          const SetToUserLocationWidget(),
          const SizedBox(height: 20),
          SingleChildScrollView(
            child: query.isNotEmpty
                ? placeId.isNotEmpty
                    ? PlaceQuery(
                        placeId: placeId,
                        onPlaceSet: (Place place) {
                          placeProvider.updatePlace(place);
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
