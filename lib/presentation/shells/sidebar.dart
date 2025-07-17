import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/presentation/shells/creator_side_navigation.dart';
import 'package:acroworld/presentation/shells/user_side_navigation.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/auth_helpers.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class ShellSideBar extends StatelessWidget {
  const ShellSideBar({super.key, required this.isCreator});

  final bool isCreator;

  @override
  Widget build(BuildContext context) {
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
                  .copyWith(color: CustomColors.accentColor),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
                child: isCreator
                    ? const CreatorDestopSideNavigationBar()
                    : const UserDestopSideNavigationBar()),
          ),
          isCreator
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Consumer(builder: (context, ref, child) {
                          final userAsync = ref.watch(userRiverpodProvider);
                          return userAsync.when(
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (e, st) {
                              // Optionally log
                              return Center(
                                  child: Text('Error loading profile'));
                            },
                            data: (user) {
                              final hasTeacherProfile =
                                  user?.teacherProfile != null;
                              final isEmailVerified =
                                  user?.isEmailVerified ?? false;
                              return StandartButton(
                                width: null,
                                text: "Create Events",
                                onPressed: () async {
                                  if (user == null) {
                                    showAuthRequiredDialog(
                                      subtitle:
                                          'Create a partner account to upload your events as a creator, teacher, studio or anonymously.',
                                      context,
                                      redirectPath: '/',
                                    );
                                    return;
                                  }
                                  if (!isEmailVerified) {
                                    showInfoToast(
                                        "You need to verify your email before switching to creator mode");
                                    context.pushNamed(verifyEmailRoute);
                                  } else if (hasTeacherProfile) {
                                    GraphQLClientSingleton().updateClient(true);
                                    provider.Provider.of<UserRoleProvider>(
                                            context,
                                            listen: false)
                                        .setIsCreator(true);
                                    context.goNamed(myEventsRoute);
                                  } else {
                                    final roles = await TokenSingletonService()
                                        .getUserRoles();
                                    if (roles.contains("TeacherUser")) {
                                      GraphQLClientSingleton()
                                          .updateClient(true);
                                      context.goNamed(editCreatorProfileRoute);
                                    } else {
                                      buildMortal(
                                        context,
                                        const CreateCreatorProfileModal(),
                                      );
                                    }
                                  }
                                },
                                isFilled: true,
                              );
                            },
                          );
                        })
                      ]),
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
                  final divider = const Divider(
                    color: CustomColors.accentColor,
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
                              color: CustomColors.accentColor),
                          title: Text(
                            "Create Account",
                            style: TextStyle(color: CustomColors.accentColor),
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
