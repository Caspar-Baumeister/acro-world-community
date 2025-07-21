import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as Provider;

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: ErrorScreenWidget(
        error: error,
      ),
    );
  }
}

class ErrorScreenWidget extends ConsumerWidget {
  const ErrorScreenWidget({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRoleProvider userRoleProvider =
        Provider.Provider.of<UserRoleProvider>(context, listen: false);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            StandartButton(
                text: "Back to Home",
                onPressed: () {
                  // Set navigation index to 3 (Profile tab)
                  if (userRoleProvider.isCreator) {
                    ref.read(creatorNavigationProvider.notifier).setIndex(3);
                    context.goNamed(creatorProfileRoute);
                  } else {
                    ref.read(navigationProvider.notifier).setIndex(3);
                    context.goNamed(profileRoute);
                  }
                })
          ],
        ),
      ),
    );
  }
}
