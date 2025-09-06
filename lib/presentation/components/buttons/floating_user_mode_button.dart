import 'package:acroworld/presentation/components/buttons/floating_mode_switch_button.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FloatingUserModeButton extends ConsumerWidget {
  const FloatingUserModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingModeSwitchButton(
      title: "User Mode",
      subtitle: "Switch to browse events",
      onPressed: () => _switchToUserMode(context, ref),
      isCreatorMode: false,
    );
  }

  void _switchToUserMode(BuildContext context, WidgetRef ref) {
    final graphQLSingleton = GraphQLClientSingleton();
    graphQLSingleton.updateClient(false);
    ref.read(userRoleProvider.notifier).setIsCreator(false);

    print("Switch to User Mode");
    // Switch to user mode
    context.goNamed(profileRoute);
    // dispose all creator providers
    ref.read(teacherEventsProvider.notifier).cleanUp();
  }
}
