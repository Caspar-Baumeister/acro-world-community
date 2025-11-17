import 'package:acroworld/presentation/components/buttons/floating_mode_switch_button.dart';
import 'package:acroworld/presentation/screens/modals/create_teacher_modal/create_creator_profile_modal.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FloatingCreatorModeButton extends ConsumerWidget {
  const FloatingCreatorModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userRiverpodProvider);

    return userState.when(
      data: (user) {
        final hasTeacherProfile = user?.teacherProfile != null;
        final isEmailVerified = user?.isEmailVerified ?? false;

        String subtitle;
        if (!isEmailVerified) {
          subtitle = "Verify Email to Access";
        } else if (hasTeacherProfile) {
          subtitle = "Switch to Creator Mode";
        } else {
          subtitle = "Register as a Creator";
        }

        return FloatingModeSwitchButton(
          title: "Creator Mode",
          subtitle: subtitle,
          onPressed: () => _switchToCreatorMode(
              context, ref, isEmailVerified, hasTeacherProfile),
          isCreatorMode: true,
          isGradient: true,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Future<void> _switchToCreatorMode(BuildContext context, WidgetRef ref,
      bool isEmailVerified, bool hasTeacherProfile) async {
    if (!isEmailVerified) {
      showInfoToast(
          "You need to verify your email before switching to creator mode",
          context: context);
      if (context.mounted) {
        context.pushNamed(verifyEmailRoute);
      }
    } else if (hasTeacherProfile) {
      GraphQLClientSingleton().updateClient(true);
      ref.read(userRoleProvider.notifier).setIsCreator(true);
      if (context.mounted) {
        context.pushNamed(creatorProfileRoute);
      }
    } else {
      final roles = await TokenSingletonService().getUserRoles();
      if (roles.contains("TeacherUser")) {
        GraphQLClientSingleton().updateClient(true);
        if (context.mounted) {
          context.pushNamed(editCreatorProfileRoute);
        }
      } else {
        if (context.mounted) {
          buildMortal(
            context,
            const CreateCreatorProfileModal(),
          );
        }
      }
    }
  }
}
