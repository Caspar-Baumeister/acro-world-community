import 'package:acroworld/presentation/components/guest_profile_content.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/header_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModernSkeleton(width: 200, height: 20),
            SizedBox(height: 16),
            ModernSkeleton(width: 300, height: 100),
            SizedBox(height: 16),
            ModernSkeleton(width: 250, height: 80),
          ],
        ),
      ),
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
                    // Always show user profile header
                    HeaderWidget(
                      imgUrl: user.imageUrl ?? '',
                      name: user.name ?? 'User',
                      subtitle: hasTeacherProfile 
                          ? 'Creator & User' 
                          : 'User',
                      showEditButton: true,
                      onEditPressed: () {
                        context.pushNamed(editUserDataRoute);
                      },
                    ),
                    
                    // Creator Mode Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingSmall,
                        horizontal: AppDimensions.spacingMedium,
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
                            ref
                                .read(userRoleProvider.notifier)
                                .setIsCreator(true);
                            context.pushNamed(creatorProfileRoute);
                          } else {
                            final roles =
                                await TokenSingletonService().getUserRoles();
                            if (roles.contains("TeacherUser")) {
                              GraphQLClientSingleton().updateClient(true);
                              context.pushNamed(editCreatorProfileRoute);
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
                    color: Theme.of(context).colorScheme.surface,
                    child: TabBar(
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.outline,
                      indicatorWeight: 1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Theme.of(context).colorScheme.onSurface,
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
