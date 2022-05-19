import 'package:acroworld/data.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/user_communities/app_bar.dart';
import 'package:acroworld/screens/home/communities/settings_drawer.dart';
import 'package:acroworld/screens/home/communities/user_communities/body.dart';
import 'package:acroworld/screens/home/communities/user_communities/future_communities.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCommunities extends StatelessWidget {
  const UserCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarUserCommunities(),
      body: const FutureCommunity(),
      // UserCommunitiesBody(
      //   userCommunities: List<Community>.from(
      //     DataClass().communities.where(
      //           (element) => userProvider.userCommunities.contains(element.id),
      //         ),
      //   ),
      // ),
      endDrawer: const SettingsDrawer(),
    );
  }
}
