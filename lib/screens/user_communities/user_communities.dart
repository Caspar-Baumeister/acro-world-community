import 'package:acroworld/screens/home/chatroom/fetch_community_chatroom.dart';
import 'package:acroworld/screens/home/communities/settings_drawer.dart';
import 'package:acroworld/screens/user_communities/user_communities_body.dart';
import 'package:acroworld/screens/user_communities/widgets/app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserCommunities extends StatelessWidget {
  const UserCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Listening to messages');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      String type = message.data['type'];
      if (type == 'CommunityMessage') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FetchCommunityChatroom(
                    communityId: message.data['id'],
                  )),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarUserCommunities(),
      body: const UserCommunitiesBody(),
      endDrawer: const SettingsDrawer(),
    );
  }
}
