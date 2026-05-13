import 'package:acroworld/presentation/shells/user_side_navigation.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellSideBar extends ConsumerWidget {
  const ShellSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Center(
            child: Image(
              image: AssetImage("assets/muscleup_drawing.png"),
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Text(
              "ACROWORLD".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
                child: const UserDestopSideNavigationBar()),
          ),
          // Authentication section - Sign Up or Logout
          Consumer(
            builder: (context, ref, child) {
              final userAsync = ref.watch(userRiverpodProvider);

              return userAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (user) {
                  // Common divider for both cases
                  final divider = Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  );

                  if (user == null) {
                    // Show Sign Up button for unauthenticated users
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        divider,
                        ListTile(
                          leading: Icon(Icons.login_rounded,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          onTap: () => context.pushNamed(
                            authRoute,
                            queryParameters: {
                              'initShowSignIn': 'false',
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  // Show logout button for authenticated users
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      divider,
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        onTap: () async {
                          await ref.read(authProvider.notifier).signOut();
                          ref.invalidate(userRiverpodProvider);
                          ref.invalidate(userNotifierProvider);
                          // we don't need to route since the router listens to authentication changes
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
