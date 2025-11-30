import 'package:acroworld/presentation/screens/talent_profile_wizard/components/removable_chip.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 7: Languages
class Step7Languages extends ConsumerWidget {
  const Step7Languages({super.key});

  static const List<String> _commonLanguages = [
    'English',
    'German',
    'Spanish',
    'French',
    'Portuguese',
    'Italian',
    'Dutch',
    'Russian',
    'Chinese',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    return WizardStepContainer(
      title: 'Teaching Languages',
      description: 'In which languages can you teach?',
      currentStep: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      Icons.language,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'Select languages',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                Wrap(
                  spacing: AppDimensions.spacingSmall,
                  runSpacing: AppDimensions.spacingSmall,
                  children: _commonLanguages.map((language) {
                    final isSelected = state.selectedLanguages.contains(language);
                    return FilterChip(
                      label: Text(language),
                      selected: isSelected,
                      onSelected: (_) => notifier.toggleLanguage(language),
                      backgroundColor: theme.colorScheme.surface,
                      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Custom languages section
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
                Text(
                  'Other languages',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                ChipInputSection(
                  chips: state.customLanguages,
                  addButtonLabel: 'Add another language',
                  inputHint: 'Enter language...',
                  onAdd: notifier.addCustomLanguage,
                  onRemove: notifier.removeCustomLanguage,
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

