import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/shared/widgets/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
        print('placeId $placeId');
        if (placeResult.hasException || !placeResult.isConcrete) {
          return Container();
        } else if (placeResult.isLoading) {
          return const LoadingIndicator();
        } else {
          Place place = Place.fromJson(placeResult.data!['place']);
          onPlaceSet(place);
          return Container();
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
          return const LoadingIndicator();
        }
        if (result.hasException) {
          return const Text('Exception occured');
        }
        if (result.data != null) {
          Map<String, dynamic> data = result.data!;
          if (data.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.from(
                result.data?['places'].map((place) {
                  return TextButton(
                    onPressed: () {
                      onPlaceIdSet(place['id']);
                    },
                    child: Text(place['description']),
                  );
                }),
              ),
            );
          } else {
            return const Text('No data found');
          }
        }
        return Container();
      },
    );
  }
}

class PlaceSearchBody extends StatefulWidget {
  const PlaceSearchBody({Key? key, required this.onPlaceSet}) : super(key: key);

  final Function(Place place) onPlaceSet;

  @override
  State<PlaceSearchBody> createState() => _PlaceSearchBodyState();
}

class _PlaceSearchBodyState extends State<PlaceSearchBody> {
  String query = '';
  String placeId = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SearchBarWidget(
            onChanged: (String value) {
              setState(() {
                query = value;
              });
            },
          ),
          SingleChildScrollView(
            child: query.isNotEmpty
                ? placeId.isNotEmpty
                    ? PlaceQuery(
                        placeId: placeId,
                        onPlaceSet: (Place place) {
                          print('onPlaceSet');
                          widget.onPlaceSet(place);
                        },
                      )
                    : PlacesQuery(
                        query: query,
                        onPlaceIdSet: (String placeId) {
                          setState(() {
                            print(placeId);
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
