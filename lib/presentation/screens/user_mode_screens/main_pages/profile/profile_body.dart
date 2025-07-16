import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/header_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        // Optionally log
        return Center(child: Text('Error loading profile'));
      },
      data: (user) {
        if (user == null) {
          return GuestProfileContent();
        }

        final hasTeacherProfile = user.teacherProfile != null;
        final isEmailVerified = user.isEmailVerified ?? false;

        return RefreshIndicator(
          onRefresh: () => ref.refresh(userRiverpodProvider.future),
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (ctx, _) => [
                SliverList(
                  delegate: SliverChildListDelegate([
                    if (hasTeacherProfile)
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(left: 20),
                        child: HeaderWidget(
                          imgUrl: user.teacherProfile?.profilImgUrl ??
                              user.imageUrl ??
                              '',
                          name: user.teacherProfile?.name ?? user.name ?? '',
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPaddings.small,
                        horizontal: AppPaddings.medium,
                      ),
                      child: CustomSettingComponent(
                        title: "Creator Mode",
                        content: !isEmailVerified
                            ? "Verify Email"
                            : hasTeacherProfile
                                ? "Switch to Creator Mode"
                                : "Register as a Creator",
                        onPressed: () async {
                          if (!isEmailVerified) {
                            showInfoToast(
                                "You need to verify your email before switching to creator mode");
                            context.pushNamed(verifyEmailRoute);
                          } else if (hasTeacherProfile) {
                            GraphQLClientSingleton().updateClient(true);
                            provider.Provider.of<UserRoleProvider>(context,
                                    listen: false)
                                .setIsCreator(true);
                            context.goNamed(creatorProfileRoute);
                          } else {
                            final roles =
                                await TokenSingletonService().getUserRoles();
                            if (roles.contains("TeacherUser")) {
                              GraphQLClientSingleton().updateClient(true);
                              context.goNamed(editCreatorProfileRoute);
                            } else {
                              buildMortal(
                                context,
                                const CreateCreatorProfileModal(),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ],
              body: Column(
                children: [
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[400],
                      indicatorWeight: 1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.black,
                      tabs: const [
                        Tab(text: "Favorites"),
                        Tab(text: "Bookings"),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        UserFavoriteClasses(),
                        UserBookings(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GuestProfileContent extends StatelessWidget {
  const GuestProfileContent({
    super.key,
    this.subtitle =
        'Log in or sign up to view your saved events, tickets, and more.',
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileContent(context),
      desktop: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _buildMobileContent(context),
        ),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      color: CustomColors.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decorative circle with image
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CustomColors.primaryColor.withOpacity(0.6),
                width: 2.5,
              ),
            ),
            padding:
                const EdgeInsets.all(12), // Padding between border and image
            child: CircleAvatar(
              radius: Responsive.isMobile(context)
                  ? 64 - 12
                  : 80 - 12, // Adjusted for padding
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage(
                'assets/muscleup_drawing.png',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // title
          Text(
            'Create an account or log in',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.primaryTextColor,
              fontSize: Responsive.isMobile(context) ? 22 : 26,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          // subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.subtitleText,
              fontSize: Responsive.isMobile(context) ? 16 : 18,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: Responsive.isMobile(context) ? 32 : 40),

          // Log In button
          SizedBox(
            width: double.infinity,
            height: Responsive.isMobile(context) ? 48 : 56,
            child: ElevatedButton(
              onPressed: () => context.pushNamed(
                authRoute,
                queryParameters: {
                  'initShowSignIn': 'true',
                  'from': '/profile',
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.whiteTextColor,
                ),
              ),
            ),
          ),

          SizedBox(height: Responsive.isMobile(context) ? 12 : 16),

          // Sign Up button
          SizedBox(
            width: double.infinity,
            height: Responsive.isMobile(context) ? 48 : 56,
            child: OutlinedButton(
              onPressed: () => context.pushNamed(
                authRoute,
                queryParameters: {
                  'initShowSignIn': 'false',
                  'from': '/profile',
                },
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: CustomColors.buttonPrimaryLight,
                shape: const StadiumBorder(),
                side: BorderSide.none,
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.primaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
