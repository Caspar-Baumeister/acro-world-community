import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/preferences/place_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/all_communities_list.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/widgets/place_button/place_button.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class AllCommunitiesBody extends StatefulWidget {
  const AllCommunitiesBody({Key? key}) : super(key: key);

  @override
  State<AllCommunitiesBody> createState() => _AllCommunitiesBodyState();
}

class _AllCommunitiesBodyState extends State<AllCommunitiesBody> {
  Place? place;
  late QueryOptions queryOptions;
  late String selector;

  String query = "";
  @override
  Widget build(BuildContext context) {
    String userId =
        Provider.of<UserProvider>(context, listen: false).activeUser!.id!;

    place = PlacePreferences.getSavedPlace();
    if (place == null) {
      queryOptions = QueryOptions(
        document: Queries.getOtherCommunities,
        variables: {'query': "%$query%", 'user_id': userId},
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'communities';
    } else {
      queryOptions = QueryOptions(
        document: Queries.getOtherCommunitiesByLocation,
        variables: {
          'latitude': place!.latLng.latitude,
          'longitude': place!.latLng.longitude,
          'query': "%$query%",
          'user_id': userId
        },
        fetchPolicy: FetchPolicy.networkOnly,
      );
      selector = 'communities_by_location_v1';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Searchbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SearchBarWidget(onChanged: (newQuery) {
              setState(() {
                query = newQuery;
              });
            }),
          ),
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

              List<Community> communities = [];

              if (result.data!.keys.contains(selector)) {
                result.data![selector]
                    .forEach((com) => communities.add(Community.fromJson(com)));

                return Expanded(
                  child: AllCommunitiesList(
                    communities: communities,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
