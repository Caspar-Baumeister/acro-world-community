import 'package:acroworld/screens/home/communities/user_communities/app_bar.dart';
import 'package:acroworld/screens/home/communities/settings_drawer.dart';
import 'package:acroworld/screens/home/communities/user_communities/future_communities.dart';
import 'package:flutter/material.dart';

class UserCommunities extends StatelessWidget {
  const UserCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of<UserProvider>(context);

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
