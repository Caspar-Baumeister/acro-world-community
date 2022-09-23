import 'package:acroworld/screens/suggest_new_community/widgets/suggest_new_community.dart';
import 'package:acroworld/widgets/standard_app_bar/standard_app_bar.dart';
import 'package:flutter/material.dart';

class SuggestNewCommunityScreen extends StatefulWidget {
  const SuggestNewCommunityScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SuggestNewCommunityScreen> createState() =>
      _SuggestNewCommunityScreenState();
}

class _SuggestNewCommunityScreenState extends State<SuggestNewCommunityScreen> {
  // define state here

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StandardAppBar(
        title: 'Suggest a new community',
      ),
      body: SuggestNewCommunity(),
    );
  }
}
