import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/suggest_new_community/widgets/suggest_new_community.dart';
import 'package:acroworld/screens/home/jam/create_jam/create_jam.dart';
import 'package:acroworld/screens/home/jam/jams/app_bar_jams.dart';
import 'package:acroworld/screens/home/jam/jams/future_jams.dart';
import 'package:acroworld/widgets/aw_community_app_bar/aw_community_app_bar.dart';
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
      appBar: AWCommunityAppBar(
        title: 'Suggest a new community',
      ),
      body: SuggestNewCommunity(),
    );
  }
}
