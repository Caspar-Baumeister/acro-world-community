import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/provider/riverpod_provider/navigation_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            ModernButton(
                text: "Back to Home",
                onPressed: () {
                  ref.read(navigationProvider.notifier).setIndex(3);
                  context.goNamed(profileRoute);
                })
          ],
        ),
      ),
    );
  }
}
