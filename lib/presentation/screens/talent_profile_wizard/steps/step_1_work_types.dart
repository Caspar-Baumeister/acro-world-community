import 'package:acroworld/presentation/screens/talent_profile_wizard/components/removable_chip.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/selectable_option_tile.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 1: Teaching type (work type) selection
class Step1WorkTypes extends ConsumerWidget {
  const Step1WorkTypes({super.key});

  static const List<_WorkTypeOption> _workTypes = [
    _WorkTypeOption(
      label: 'Regular weekly classes',
      subtitle: 'Ongoing classes at a fixed schedule',
      icon: Icons.calendar_today,
    ),
    _WorkTypeOption(
      label: 'Workshops / one-off events',
      subtitle: 'Single sessions or short intensives',
      icon: Icons.event,
    ),
    _WorkTypeOption(
      label: 'Retreats / festivals',
      subtitle: 'Multi-day immersive experiences',
      icon: Icons.nature_people,
    ),
    _WorkTypeOption(
      label: 'Online classes',
      subtitle: 'Virtual teaching via video',
      icon: Icons.videocam,
    ),
    _WorkTypeOption(
      label: 'Permanent position',
      subtitle: 'Full-time or part-time employment',
      icon: Icons.work,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);

    return WizardStepContainer(
      title: 'How do you want to teach?',
      description: 'Select all types of teaching opportunities you\'re interested in.',
      currentStep: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Predefined work types
          ...List.generate(_workTypes.length, (index) {
            final workType = _workTypes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
              child: SelectableOptionTile(
                label: workType.label,
                subtitle: workType.subtitle,
                icon: workType.icon,
                isSelected: state.selectedWorkTypes.contains(workType.label),
                onTap: () => notifier.toggleWorkType(workType.label),
              ),
            );
          }),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Custom work types section
          Text(
            'Custom work types',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          ChipInputSection(
            chips: state.customWorkTypes,
            addButtonLabel: 'Add custom type',
            inputHint: 'Enter work type...',
            onAdd: notifier.addCustomWorkType,
            onRemove: notifier.removeCustomWorkType,
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge),
        ],
      ),
    );
  }
}

class _WorkTypeOption {
  final String label;
  final String subtitle;
  final IconData icon;

  const _WorkTypeOption({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

