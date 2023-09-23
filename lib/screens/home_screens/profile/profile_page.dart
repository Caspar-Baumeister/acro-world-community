import 'package:acroworld/components/settings_drawer.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/profile/header_widget.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookmarks/user_bookmarks_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        endDrawer: const SettingsDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 238, 238, 238),
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Profile",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              centerTitle: false,
              elevation: 0,
              actions: const [],
            ),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      HeaderWidget(
                        imgUrl: userProvider.activeUser?.imageUrl ?? "",
                        name: userProvider.activeUser?.name ?? "",
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
                        // icon: Icon(
                        //   Icons.book,
                        //   color: Colors.black,
                        // ),
                        text: "Safed events",
                      ),
                      Tab(
                        // icon: Icon(
                        //   Icons.star,
                        //   color: Colors.black,
                        // ),
                        text: "Favorites",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [const UserBookmarks(), Container()],
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
