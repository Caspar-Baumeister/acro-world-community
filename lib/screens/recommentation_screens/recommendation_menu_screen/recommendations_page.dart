import 'package:acroworld/screens/recommentation_screens/recommendation_menu_screen/recommendations_app_bar.dart';
import 'package:acroworld/screens/recommentation_screens/recommendation_menu_screen/recommendations_body.dart';
import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarRecommendations(),
      body: RecommendationsBody(),
    );
  }
}
