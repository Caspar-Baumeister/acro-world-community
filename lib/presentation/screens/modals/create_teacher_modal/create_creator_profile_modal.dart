import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateCreatorProfileModal extends StatefulWidget {
  const CreateCreatorProfileModal({super.key});

  @override
  State<CreateCreatorProfileModal> createState() =>
      _CreateCreatorProfileModalState();
}

class _CreateCreatorProfileModalState extends State<CreateCreatorProfileModal> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Icon + Title + Subtitle ───────────────────
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Ready to Create?',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock a world of possibilities and share your passion with others.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),

            // ─── Feature List ──────────────────────────────
            _FeatureItem(
              icon: Icons.group_add,
              title: 'Grow Your Audience',
              description: 'Connect with followers and build your community.',
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.event,
              title: 'Host Unique Events',
              description:
                  'Easily set up and manage bookings for your activities.',
            ),
            const SizedBox(height: 16),
            _FeatureItem(
              icon: Icons.star,
              title: 'Get Featured',
              description:
                  'Be discovered and featured for your amazing content.',
            ),
            const SizedBox(height: 24),

            // ─── Footnote ───────────────────────────────────
            Text(
              'Setting up your creator profile is quick, easy, and completely free. It only takes a few minutes to get started!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: CustomColors.subtitleText),
            ),
            const SizedBox(height: 24),

            // ─── Primary Action ─────────────────────────────
            StandartButton(
              text: "Let's Go!",
              onPressed: isLoading ? () {} : _onContinue,
              buttonFillColor: Theme.of(context).colorScheme.primary,
              loading: isLoading,
              disabled: isLoading,
              isFilled: true,
            ),

            // ─── Secondary Action ───────────────────────────
            const SizedBox(height: 12),
            StandartButton(
              text: "Maybe Later",
              onPressed: isLoading ? () {} : () => Navigator.of(context).pop(),
              buttonFillColor: Theme.of(context).colorScheme.secondary,
              disabled: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    setState(() => isLoading = true);

    final client = GraphQLClientSingleton().client;
    const mutation = '''
      mutation signUpAsTeacher {
        signup_as_teacher {
          success
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(document: gql(mutation)),
    );

    setState(() => isLoading = false);

    if (result.hasException) {
      _onError(result.exception);
    } else {
      _onSuccess(result.data);
    }
  }

  void _onSuccess(Map<String, dynamic>? data) async {
    if (data?['signup_as_teacher']?['success'] == true) {
      // refresh token to pick up creator role
      await TokenSingletonService().refreshToken();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        GraphQLClientSingleton().updateClient(true);
        context.pushNamed(editCreatorProfileRoute);
      });
    } else {
      CustomErrorHandler.captureException(
        data.toString(),
        stackTrace: StackTrace.current,
      );
      showErrorToast(
        'An error occurred. Please try again later or contact support.',
      );
    }
  }

  void _onError(OperationException? error) {
    CustomErrorHandler.captureException(
      error?.graphqlErrors.toString(),
      stackTrace: StackTrace.current,
    );
    showErrorToast(
      'An error occurred. Please try again later or contact support.',
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
