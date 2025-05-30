import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreatorSwitchToUserModeButton extends StatelessWidget {
  const CreatorSwitchToUserModeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StandartButton(
      text: "User Mode",
      onPressed: () {
        final graphQLSingleton = GraphQLClientSingleton();
        graphQLSingleton.updateClient(false);
        Provider.of<UserRoleProvider>(context, listen: false)
            .setIsCreator(false);

        print("Switch to User Mode");
        // Switch to creator mode
        context.goNamed(profileRoute);
        // dispose all creator providers
        Provider.of<TeacherEventsProvider>(context, listen: false).cleanUp();
      },
      isFilled: true,
    );
  }
}
