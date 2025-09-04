import 'package:acroworld/presentation/components/guest_profile_content.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/header_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
          child: CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: HeaderWidget(
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
              ),

              // Main Action Buttons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Creator Mode Button (Prominent)
                      _buildProminentButton(
                        context: context,
                        icon: Icons.star_rounded,
                        title: "Creator Mode",
                        subtitle: !isEmailVerified
                            ? "Verify Email to Access"
                            : hasTeacherProfile
                                ? "Switch to Creator Mode"
                                : "Register as a Creator",
                        onTap: () async {
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
                        isProminent: true,
                      ),

                      const SizedBox(height: 16),

                      // Tickets and Favorites Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              icon: Icons.confirmation_number_rounded,
                              title: "Tickets",
                              subtitle: "View your bookings",
                              onTap: () {
                                // TODO: Navigate to tickets page
                                showInfoToast("Tickets feature coming soon!");
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              icon: Icons.favorite_rounded,
                              title: "Favorites",
                              subtitle: "Saved classes",
                              onTap: () {
                                // TODO: Navigate to favorites page
                                showInfoToast("Favorites feature coming soon!");
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Settings Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildSettingsItem(
                        context: context,
                        icon: Icons.account_circle_outlined,
                        title: "Account Settings",
                        onTap: () => context.pushNamed(accountSettingsRoute),
                      ),
                      
                      _buildSettingsItem(
                        context: context,
                        icon: Icons.backpack_rounded,
                        title: "Essentials",
                        onTap: () => context.pushNamed(essentialsRoute),
                      ),
                      
                      _buildSettingsItem(
                        context: context,
                        icon: Icons.chat_bubble_outline_rounded,
                        title: "Feedback & Bugs",
                        onTap: () => showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => const FeedbackPopUp(
                            subject: 'Feedback from AcroWorld App',
                            title: "Feedback & Bugs",
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Favorites and Bookings Tabs
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: TabBar(
                          labelColor: Theme.of(context).colorScheme.onSurface,
                          unselectedLabelColor: Theme.of(context).colorScheme.outline,
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          tabs: const [
                            Tab(text: "Favorites"),
                            Tab(text: "Bookings"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 400, // Fixed height for tab content
                        child: const TabBarView(
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

              // Logout and Delete Account
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDangerButton(
                        context: context,
                        icon: Icons.logout_rounded,
                        title: "Log out",
                        onTap: () async {
                          await ref.read(authProvider.notifier).signOut();
                          ref.invalidate(userRiverpodProvider);
                          ref.invalidate(userNotifierProvider);
                          ref.invalidate(navigationProvider);
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDangerButton(
                        context: context,
                        icon: Icons.delete_forever_rounded,
                        title: "Delete Account",
                        onTap: () {
                          _showDeleteAccountDialog(context, ref);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Version
                      const VersionDisplay(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProminentButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isProminent = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isProminent
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isProminent ? null : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isProminent
                        ? Colors.white.withOpacity(0.2)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isProminent
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isProminent
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isProminent
                              ? Colors.white.withOpacity(0.8)
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isProminent
                      ? Colors.white.withOpacity(0.8)
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement account deletion
                showInfoToast("Account deletion feature coming soon!");
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({super.key});

  Future<String> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading version...');
        } else if (snapshot.hasError) {
          return const Text('Version unavailable');
        } else {
          return Text(
            'Version ${snapshot.data}',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          );
        }
      },
    );
  }
}
