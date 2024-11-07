import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/header_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/creator_profile_page_route.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
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
                              ? StandardButton(
                                  text: 'Creator Mode',
                                  isFilled: true,
                                  onPressed: () async {
                                    final graphQLSingleton =
                                        GraphQLClientSingleton();
                                    graphQLSingleton.updateClient(true);
                                    Provider.of<UserRoleProvider>(context,
                                            listen: false)
                                        .setIsCreator(true);
                                    // Switch to
                                    print("Switch to Creator Mode");
                                    // Switch to creator mode
                                    Navigator.of(context)
                                        .push(CreatorProfilePageRoute());
                                  })
                              : StandardButton(
                                  text: "Creater Mode",
                                  isFilled: true,
                                  onPressed: () async {
                                    List<String> roles =
                                        await TokenSingletonService()
                                            .getUserRoles();
                                    if (roles.contains("TeacherUser")) {
                                      final graphQLSingleton =
                                          GraphQLClientSingleton();
                                      graphQLSingleton.updateClient(true);
                                      Navigator.of(context).push(
                                          CreateCreatorProfilePageRoute());
                                    } else {
                                      buildMortal(context,
                                          const CreateCreatorProfileModal());
                                    }
                                  },
                                ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: AppPaddings.small,
                    //       horizontal: AppPaddings.medium),
                    //   child: hasTeacherProfile
                    //       ? CustomButton('WEB', () async {
                    //           final token =
                    //               await TokenSingletonService().getToken();
                    //           final refreshToken = LocalStorageService.get(
                    //               Preferences.refreshToken);
                    //           customLaunch(
                    //               "${AppEnvironment.dashboardUrl}/token-callback?jwtToken=$token&refreshToken=$refreshToken&redirectTo=/app");
                    //         })
                    //       : CustomButton(
                    //           "No TEACHER",
                    //           () async {
                    //             List<String> roles =
                    //                 await TokenSingletonService()
                    //                     .getUserRoles();
                    //             if (roles.contains("TeacherUser")) {
                    //               Navigator.of(context)
                    //                   .push(CreateCreatorProfilePageRoute());
                    //             } else {
                    //               buildMortal(context,
                    //                   const CreateCreatorProfileModal());
                    //             }
                    //           },
                    //         ),
                    // ),
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
