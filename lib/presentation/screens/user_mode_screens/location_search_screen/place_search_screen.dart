import 'package:acroworld/presentation/components/appbar/standard_app_bar/standard_app_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:flutter/material.dart';

import 'place_search_body.dart';

class PlaceSearchScreen extends StatelessWidget {
  const PlaceSearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      appBar: StandardAppBar(
        title: 'Search a location',
      ),
      child: PlaceSearchBody(),
    );
  }
}
