import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 6: Teaching experience
class Step6Experience extends ConsumerStatefulWidget {
  const Step6Experience({super.key});

  @override
  ConsumerState<Step6Experience> createState() => _Step6ExperienceState();
}

class _Step6ExperienceState extends ConsumerState<Step6Experience> {
  late TextEditingController _lengthController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(talentProfileWizardProvider);
    _lengthController = TextEditingController(text: state.experienceLength);
    _descriptionController =
        TextEditingController(text: state.experienceDescription);
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    return WizardStepContainer(
      title: 'Teaching Experience',
      description: 'Tell us about your teaching background and experience.',
      currentStep: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Experience length
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'How long have you been teaching?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                TextField(
                  controller: _lengthController,
                  decoration: InputDecoration(
                    hintText: 'E.g., 3 years, since 2019, 5+ years',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMedium,
                      vertical: AppDimensions.spacingSmall,
                    ),
                  ),
                  onChanged: notifier.setExperienceLength,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Experience description
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'Additional context',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  'Share details about your teaching experience (optional)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'E.g., I\'ve taught at several festivals including XYZ, regular classes of 10-20 students, private sessions, beginners to advanced...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    contentPadding:
                        const EdgeInsets.all(AppDimensions.spacingMedium),
                  ),
                  onChanged: notifier.setExperienceDescription,
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

