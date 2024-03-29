// import 'package:acroworld/components/loading_indicator/loading_indicator.dart';
// import 'package:acroworld/graphql/queries.dart';
// import 'package:acroworld/models/places/place.dart';
// import 'package:acroworld/open_map.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class PlaceMap extends StatefulWidget {
//   const PlaceMap({Key? key, required this.placeId, required this.onLoaded})
//       : super(key: key);
//   final String? placeId;
//   final Function(Place place)? onLoaded;

//   @override
//   State<PlaceMap> createState() => _PlaceMapState();
// }

// class _PlaceMapState extends State<PlaceMap> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.placeId == null) {
//       return Container();
//     } else {
//       return Query(
//         options: QueryOptions(
//             document: Queries.getPlace,
//             fetchPolicy: FetchPolicy.networkOnly,
//             variables: {'id': widget.placeId}),
//         builder: (QueryResult placeResult,
//             {VoidCallback? refetch, FetchMore? fetchMore}) {
//           if (placeResult.hasException || !placeResult.isConcrete) {
//             return Container();
//           } else if (placeResult.isLoading) {
//             return const LoadingIndicator();
//           } else {
//             Place place = Place.fromJson(placeResult.data!['place']);
//             if (widget.onLoaded != null) {
//               widget.onLoaded!(place);
//             }
//             return OpenMap(
//               latitude: place.latLng.latitude,
//               longitude: place.latLng.longitude,
//             );
//           }
//         },
//       );
//     }
//   }
// }
