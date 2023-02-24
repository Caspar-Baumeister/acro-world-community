import 'package:acroworld/components/standard_app_bar/standard_app_bar.dart';
import 'package:flutter/material.dart';

import 'place_search_body.dart';

class PlaceSearchScreen extends StatelessWidget {
  const PlaceSearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StandardAppBar(
        title: 'Search a location',
      ),
      body: PlaceSearchBody(),
    );
  }
}
