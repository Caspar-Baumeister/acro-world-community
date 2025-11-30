import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 9: Email consent (mandatory final step)
class Step9Consent extends ConsumerWidget {
  const Step9Consent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    return WizardStepContainer(
      title: 'Almost there!',
      description: 'One last step to complete your teacher profile.',
      currentStep: 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success preview
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                Text(
                  'Your profile is ready!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  'We\'ll use your information to match you with teaching opportunities.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          // Email consent (mandatory)
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(
                color: state.emailOptIn
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CheckboxListTile(
              value: state.emailOptIn,
              onChanged: (value) => notifier.setEmailOptIn(value ?? false),
              title: Text(
                'Email consent (required)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: state.emailOptIn
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.error,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacingSmall),
                child: Text(
                  'I agree that Acroworld / MotionHub may send me emails with matching job offers based on my information.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              secondary: Icon(
                state.emailOptIn ? Icons.email : Icons.email_outlined,
                color: state.emailOptIn
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error.withOpacity(0.5),
                size: 28,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              activeColor: theme.colorScheme.primary,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
          if (!state.emailOptIn) ...[
            const SizedBox(height: AppDimensions.spacingSmall),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSmall),
              child: Text(
                '* You must accept email communications to create your profile',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingLarge),
          // Privacy note
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
                Expanded(
                  child: Text(
                    'Your information will only be used to match you with teaching opportunities. You can unsubscribe at any time.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge),
        ],
      ),
    );
  }
}

