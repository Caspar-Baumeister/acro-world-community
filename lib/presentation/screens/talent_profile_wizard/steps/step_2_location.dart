import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 2: Location input
class Step2Location extends ConsumerStatefulWidget {
  const Step2Location({super.key});

  @override
  ConsumerState<Step2Location> createState() => _Step2LocationState();
}

class _Step2LocationState extends ConsumerState<Step2Location> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(talentProfileWizardProvider);
    _controller = TextEditingController(text: state.locationCities);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    return WizardStepContainer(
      title: 'Where can you teach?',
      description: 'Enter the cities where you\'re based and available to teach.',
      currentStep: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'Your teaching locations',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                InputFieldComponent(
                  controller: _controller,
                  labelText: 'Cities',
                  maxLines: 3,
                  minLines: 2,
                  keyboardType: TextInputType.text,
                  onEditingComplete: () {
                    notifier.setLocationCities(_controller.text);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
                Expanded(
                  child: Text(
                    'Tip: Separate multiple cities with commas.\nExample: Berlin, Potsdam, Hamburg',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Update state when text changes
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifier.setLocationCities(value.text);
              });
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge),
        ],
      ),
    );
  }
}

