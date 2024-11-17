import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
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
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context);
    print("provider active user: ${provider.activeUser?.isEmailVerified}");
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
                      child: CustomSettingComponent(
                        title: "Creator Mode",
                        content: isEmailVerified
                            ? hasTeacherProfile
                                ? "Switch to Creator Mode"
                                : "Register as a Creator"
                            : "Verify Email",
                        onPressed: () async {
                          // If the user is not verified, show a button to verify the email
                          if (!isEmailVerified) {
                            showInfoToast(
                                "You need to verify your email, before you can switch to creator mode");
                            Navigator.of(context).push(ConfirmEmailPageRoute());
                          }
                          // If the users email is verified, show a button to switch to creator mode
                          // if the user has a teacher profile, show a button to switch to creator mode
                          else if (hasTeacherProfile) {
                            final graphQLSingleton = GraphQLClientSingleton();
                            graphQLSingleton.updateClient(true);
                            Provider.of<UserRoleProvider>(context,
                                    listen: false)
                                .setIsCreator(true);
                            // Switch to
                            print("Switch to Creator Mode");
                            // Switch to creator mode
                            Navigator.of(context)
                                .push(CreatorProfilePageRoute());
                          }

                          // If the user does not have a teacher profile, show a button to create a teacher profile
                          else {
                            // get the user roles, if sign_up_as_teacher was called bevore, the user has the role TeacherUser
                            List<String> roles =
                                await TokenSingletonService().getUserRoles();
                            // If the user has the role TeacherUser, show the create teacher profile page
                            // for this, the gql client needs to be updated to send the teacher role
                            if (roles.contains("TeacherUser")) {
                              final graphQLSingleton = GraphQLClientSingleton();
                              graphQLSingleton.updateClient(true);
                              Navigator.of(context)
                                  .push(CreateCreatorProfilePageRoute());
                              // If the user does not have the role TeacherUser, show the create teacher profile modal
                              // there the user can sign up as a teacher
                            } else {
                              buildMortal(
                                  context, const CreateCreatorProfileModal());
                            }
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
