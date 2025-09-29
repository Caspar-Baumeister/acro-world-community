import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class InsertEventExplanationModal extends ConsumerWidget {
  const InsertEventExplanationModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userAsync = ref.watch(userRiverpodProvider);

    return BaseModal(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Content - Scrollable (includes header, content, and button)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(context, colorScheme),

                    const SizedBox(height: AppDimensions.spacingSmall),

                    // Content
                    userAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) =>
                          _buildUnauthenticatedContent(context, colorScheme),
                      data: (user) {
                        if (user == null) {
                          return _buildUnauthenticatedContent(
                              context, colorScheme);
                        } else {
                          return _buildUserContent(context, colorScheme, user);
                        }
                      },
                    ),

                    const SizedBox(height: AppDimensions.spacingSmall),

                    // Action Button
                    _buildActionButton(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon and title row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                Icons.event_available,
                color: colorScheme.tertiary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get Exposure to Your Events',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    'Share your classes and workshops with the community',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnauthenticatedContent(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to share your events? Here\'s how to get started:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '1',
          'Create Account',
          'Provide your email (used for booking confirmations) and validate it to confirm you exist.',
          Icons.person_add,
          colorScheme.primary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '2',
          'Switch to Creator Mode',
          'In your profile, switch to creator mode and create a creator account with your business information.',
          Icons.business,
          colorScheme.secondary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '3',
          'Start Creating Events',
          'Navigate to "My Events" and create your first event. You can always switch between user and creator modes.',
          Icons.event,
          colorScheme.tertiary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'All of this takes less than 10 minutes and is completely free!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Connect your bank account and sell tickets with low commissions and common payment methods',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Text(
          'If you want to learn more about it, you have questions or you need help setting it up, ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        GestureDetector(
          onTap: () async {
            // Open email client
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'info@acroworld.de',
              query: 'subject=Help with Creator Setup',
            );
            try {
              await launchUrl(emailUri);
            } catch (e) {
              // Show a snackbar if email client can't be opened
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open email client'),
                  ),
                );
              }
            }
          },
          child: Text(
            'get in touch',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserContent(
      BuildContext context, ColorScheme colorScheme, User user) {
    final isEmailVerified = user.isEmailVerified == true;
    final hasTeacherId = user.teacherId != null;

    // If user has teacherId, show teacher-specific content
    if (hasTeacherId) {
      return _buildTeacherContent(context, colorScheme);
    }

    // If user is authenticated but no teacherId
    if (isEmailVerified) {
      return _buildAuthenticatedContent(context, colorScheme);
    } else {
      return _buildUnverifiedEmailContent(context, colorScheme);
    }
  }

  Widget _buildTeacherContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You\'re already a creator! Here\'s what you can do:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '1',
          'Create Events',
          'Navigate to "My Events" and start creating your classes and workshops.',
          Icons.event,
          colorScheme.tertiary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'You\'re all set up! You can start creating and managing events.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Connect your bank account and sell tickets with low commissions and common payment methods',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Text(
          'If you want to learn more about it, you have questions or you need help setting it up, ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        GestureDetector(
          onTap: () async {
            // Open email client
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'info@acroworld.de',
              query: 'subject=Help with Creator Setup',
            );
            try {
              await launchUrl(emailUri);
            } catch (e) {
              // Show a snackbar if email client can't be opened
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open email client'),
                  ),
                );
              }
            }
          },
          child: Text(
            'get in touch',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnverifiedEmailContent(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You\'re signed in but need to verify your email first:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '1',
          'Verify Email',
          'Check your email and click the verification link to confirm your account.',
          Icons.email,
          colorScheme.primary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '2',
          'Switch to Creator Mode',
          'In your profile, switch to creator mode and create a creator account with your business information.',
          Icons.business,
          colorScheme.secondary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        _buildStep(
          context,
          '3',
          'Create Events',
          'Navigate to "My Events" and create your first event. You can always switch between user and creator modes.',
          Icons.event,
          colorScheme.tertiary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Setting up creator mode takes less than 5 minutes!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Connect your bank account and sell tickets with low commissions and common payment methods',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Text(
          'If you want to learn more about it, you have questions or you need help setting it up, ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        GestureDetector(
          onTap: () async {
            // Open email client
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'info@acroworld.de',
              query: 'subject=Help with Creator Setup',
            );
            try {
              await launchUrl(emailUri);
            } catch (e) {
              // Show a snackbar if email client can't be opened
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open email client'),
                  ),
                );
              }
            }
          },
          child: Text(
            'get in touch',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedContent(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You\'re already signed in! Here\'s what you need to do:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        _buildStep(
          context,
          '1',
          'Switch to Creator Mode',
          'In your profile, switch to creator mode and create a creator account with your business information.',
          Icons.business,
          colorScheme.secondary,
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        _buildStep(
          context,
          '2',
          'Start Creating Events',
          'Navigate to "My Events" and create your first event. You can always switch between user and creator modes.',
          Icons.event,
          colorScheme.tertiary,
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Setting up creator mode takes less than 5 minutes!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: Text(
                  'Connect your bank account and sell tickets with low commissions and common payment methods',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Text(
          'If you want to learn more about it, you have questions or you need help setting it up, ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        GestureDetector(
          onTap: () async {
            // Open email client
            final Uri emailUri = Uri(
              scheme: 'mailto',
              path: 'info@acroworld.de',
              query: 'subject=Help with Creator Setup',
            );
            try {
              await launchUrl(emailUri);
            } catch (e) {
              // Show a snackbar if email client can't be opened
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open email client'),
                  ),
                );
              }
            }
          },
          child: Text(
            'get in touch',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number and icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: AppDimensions.spacingMedium),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ModernButton(
        text: 'Upload now',
        onPressed: () {
          Navigator.of(context).pop();
          context.goNamed(profileRoute);
        },
        icon: Icons.person,
      ),
    );
  }
}
