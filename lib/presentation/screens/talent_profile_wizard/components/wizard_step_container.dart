import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Container widget for wizard steps with consistent styling
class WizardStepContainer extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final int currentStep;

  const WizardStepContainer({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step $currentStep of $totalWizardSteps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentStep / totalWizardSteps,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        // Title and description
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSmall),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLarge),
        // Step content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMedium,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

