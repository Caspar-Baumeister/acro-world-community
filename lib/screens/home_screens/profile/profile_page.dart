import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/components/settings_drawer.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home_screens/profile/header_widget.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/screens/home_screens/profile/user_bookmarks/user_bookmarks_query.dart';
import 'package:acroworld/screens/home_screens/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/services/local_storage_service.dart';
import 'package:acroworld/types_and_extensions/preferences_extension.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  UserProvider? userProvider;
  bool listenToResume = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && listenToResume) {
      print(
          '_ProfilePageState:didChangeAppLifecycleState ${identityHashCode(userProvider)}');
      userProvider?.setUserFromToken();
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        print('_ProfilePageState:build ${identityHashCode(provider)}');

        // Your UI components that depend on the provider's state
        userProvider ??= provider;
        bool hasTeacherProfile = provider.activeUser?.teacherProfile != null;
        print(
          '_ProfilePageState name ${provider.activeUser?.teacherProfile?.name}',
        );
        return SafeArea(
          child: Scaffold(
            endDrawer: const SettingsDrawer(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Text(
                "Your Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              centerTitle: false,
              elevation: 0,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await provider.setUserFromToken();
              },
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            hasTeacherProfile
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0)
                                        .copyWith(left: 20),
                                    child: HeaderWidget(
                                      imgUrl: provider.activeUser
                                              ?.teacherProfile?.profilImgUrl ??
                                          provider.activeUser?.imageUrl ??
                                          "",
                                      name: provider.activeUser?.teacherProfile
                                              ?.name ??
                                          provider.activeUser?.name ??
                                          "",
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: hasTeacherProfile
                                  ? CustomButton('Edit your profile', () async {
                                      // get token and refresh token

                                      final token =
                                          await TokenSingletonService()
                                              .getToken();
                                      final refreshToken =
                                          LocalStorageService.get(
                                              Preferences.refreshToken);

                                      String? teacherId = provider
                                          .activeUser?.teacherProfile?.id;
                                      listenToResume = true;
                                      customLaunch(
                                          "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken&redirectTo=/app/teachers/$teacherId");
                                    })
                                  : CustomButton(
                                      "Become a Partner",
                                      () async {
                                        final token =
                                            await TokenSingletonService()
                                                .getToken();
                                        final refreshToken =
                                            LocalStorageService.get(
                                                Preferences.refreshToken);

                                        if (refreshToken != null) {
                                          customLaunch(
                                              "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken");
                                        } else {
                                          customLaunch(
                                              AppEnvironment.dashboardUrl);
                                        }
                                      },
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
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.black,
                          tabs: const [
                            Tab(
                              text: "Events",
                            ),
                            Tab(
                              text: "Activities",
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
          ),
        );
      },
    );
  }
}
