import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // Drawer Header with gradient background
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Menu",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Menu Items
            _buildMenuItem(
              context: context,
              icon: Icons.account_circle_outlined,
              text: "Account Settings",
              onTap: () => context.pushNamed(accountSettingsRoute),
            ),

            _buildMenuItem(
              context: context,
              icon: Icons.backpack_rounded,
              text: "Essentials",
              onTap: () => context.pushNamed(essentialsRoute),
            ),

            _buildMenuItem(
              context: context,
              icon: Icons.chat_bubble_outline_rounded,
              text: "Feedback & Bugs",
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => const FeedbackPopUp(
                  subject: 'Feedback from AcroWorld App',
                  title: "Feedback & Bugs",
                ),
              ),
            ),

            // Conditional rendering based on auth status
            userAsync.when(
              data: (user) {
                if (user == null) {
                  return _buildMenuItem(
                    context: context,
                    icon: Icons.login_rounded,
                    text: "Create Account",
                    iconColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => context.pushNamed(
                      authRoute,
                      queryParameters: {
                        'initShowSignIn': 'false',
                        'from': '/profile',
                      },
                    ),
                  );
                } else {
                  return _buildMenuItem(
                    context: context,
                    icon: Icons.logout_rounded,
                    text: "Log out",
                    iconColor: Theme.of(context).colorScheme.error,
                    textColor: Theme.of(context).colorScheme.error,
                    onTap: () async {
                      await ref.read(authProvider.notifier).signOut();
                      ref.invalidate(userRiverpodProvider);
                      ref.invalidate(userNotifierProvider);
                      ref.invalidate(navigationProvider);
                    },
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _buildMenuItem(
                context: context,
                icon: Icons.login_rounded,
                text: "Sign in",
                onTap: () => context.pushNamed(authRoute),
              ),
            ),

            // Version at bottom
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: VersionDisplay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainer,
            width: 1.5,
          ),
        ),
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
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textColor ??
                            Theme.of(context).colorScheme.onSurface,
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
