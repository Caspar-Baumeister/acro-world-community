import 'package:acroworld/screens/home/communities/app_bar_communities.dart';
import 'package:acroworld/screens/home/communities/communities_stream.dart';
import 'package:flutter/material.dart';

class Communities extends StatelessWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCommunities(),
        body: const CommunitiesStream());
  }
}
