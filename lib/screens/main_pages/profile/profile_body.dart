import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/screens/main_pages/profile/header_widget.dart';
import 'package:acroworld/screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/screens/modals/base_modal.dart';
import 'package:acroworld/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context);
    final hasTeacherProfile = provider.activeUser?.teacherProfile != null;
    final isEmailVerified = provider.activeUser?.isEmailVerified ?? false;
    return RefreshIndicator(
      onRefresh: () async {
        await provider.setUserFromToken();
      },
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    hasTeacherProfile
                        ? Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(left: 20),
                            child: HeaderWidget(
                              imgUrl: provider.activeUser?.teacherProfile
                                      ?.profilImgUrl ??
                                  provider.activeUser?.imageUrl ??
                                  "",
                              name: provider.activeUser?.teacherProfile?.name ??
                                  provider.activeUser?.name ??
                                  "",
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppPaddings.small,
                          horizontal: AppPaddings.medium),
                      child:
                          // !isEmailVerified
                          //     ? CustomButton(
                          //         "Verify Email",
                          //         () {
                          //           Navigator.of(context)
                          //               .push(ConfirmEmailPageRoute());
                          //         },
                          //       )
                          //     :
                          hasTeacherProfile
                              ? CustomButton('Switch to Creator Mode',
                                  () async {
                                  // Switch to
                                  // TODO: Implement switch to creator mode
                                  print("Switch to Creator Mode");
                                  // buildMortal(context, const CreateTeacherModal());
                                  // final token =
                                  //     await TokenSingletonService().getToken();
                                  // final refreshToken = LocalStorageService.get(
                                  //     Preferences.refreshToken);
                                  // customLaunch(
                                  //     "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken&redirectTo=/app");
                                })
                              : CustomButton(
                                  "Create Events",
                                  () async {
                                    List<String> roles =
                                        await TokenSingletonService()
                                            .getUserRoles();
                                    if (roles.contains("TeacherUser")) {
                                      print("TeacherUser exists");

                                      Navigator.of(context).push(
                                          CreateCreatorProfilePageRoute());
                                    } else {
                                      print("TeacherUser does not exist");

                                      buildMortal(context,
                                          const CreateCreatorProfileModal());
                                    }

                                    // show the user the input form for creating an account

                                    // on submit, if the user has no teacher role, signup as teacher first

                                    // create teacher profile

                                    // final token =
                                    //     await TokenSingletonService().getToken();
                                    // final refreshToken = LocalStorageService.get(
                                    //     Preferences.refreshToken);

                                    // if (refreshToken != null) {
                                    //   customLaunch(
                                    //       "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken");
                                    // } else {
                                    //   customLaunch(AppEnvironment.dashboardUrl);
                                    // }
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
                      text: "Favorites",
                    ),
                    Tab(
                      text: "Bookings",
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [UserFavoriteClasses(), UserBookings()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
