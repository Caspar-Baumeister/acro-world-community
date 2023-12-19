import 'package:acroworld/components/settings_drawer.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/profile/header_widget.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookmarks/user_bookmarks_query.dart';
import 'package:acroworld/screens/home_screens/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: const SettingsDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text(
            "Your Profile",
            style: H20W5,
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) => HeaderWidget(
                          imgUrl: userProvider.activeUser?.imageUrl ?? "",
                          name: userProvider.activeUser?.name ?? "",
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                Material(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorWeight: 1,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: "Bookmarked events",
                      ),
                      Tab(
                        text: "Favorite activities",
                      ),
                      Tab(
                        text: "Bookings",
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      UserBookmarks(),
                      UserFavoriteClasses(),
                      UserBookings()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
