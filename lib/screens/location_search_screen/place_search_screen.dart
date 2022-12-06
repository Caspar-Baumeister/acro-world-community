import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/components/standard_app_bar/standard_app_bar.dart';
import 'package:flutter/material.dart';

import 'place_search_body.dart';

class PlaceSearchScreen extends StatelessWidget {
  const PlaceSearchScreen({
    Key? key,
    required this.onPlaceSet,
  }) : super(key: key);

  final Function(Place place) onPlaceSet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(
        title: 'Search a location',
      ),
      body: PlaceSearchBody(onPlaceSet: onPlaceSet),
    );
  }
}
