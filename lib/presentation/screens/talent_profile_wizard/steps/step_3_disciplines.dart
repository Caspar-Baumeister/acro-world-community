import 'package:acroworld/presentation/screens/talent_profile_wizard/components/removable_chip.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/selectable_option_tile.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 3: Disciplines selection
class Step3Disciplines extends ConsumerWidget {
  const Step3Disciplines({super.key});

  static const List<_DisciplineOption> _disciplines = [
    _DisciplineOption(
      label: 'Acroyoga & partner acrobatics',
      icon: Icons.people,
    ),
    _DisciplineOption(
      label: 'Yoga',
      icon: Icons.self_improvement,
    ),
    _DisciplineOption(
      label: 'Handstands',
      icon: Icons.accessibility_new,
    ),
    _DisciplineOption(
      label: 'Movement / floorwork',
      icon: Icons.directions_walk,
    ),
    _DisciplineOption(
      label: 'Strength & conditioning',
      icon: Icons.fitness_center,
    ),
    _DisciplineOption(
      label: 'Dance / flow arts',
      icon: Icons.music_note,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);

    return WizardStepContainer(
      title: 'What do you teach?',
      description: 'Select all disciplines you can teach. You\'ll describe each in more detail later.',
      currentStep: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Predefined disciplines
          ...List.generate(_disciplines.length, (index) {
            final discipline = _disciplines[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
              child: SelectableOptionTile(
                label: discipline.label,
                icon: discipline.icon,
                isSelected: state.selectedDisciplines.contains(discipline.label),
                onTap: () => notifier.toggleDiscipline(discipline.label),
              ),
            );
          }),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Custom disciplines section
          Text(
            'Other disciplines',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          ChipInputSection(
            chips: state.customDisciplines,
            addButtonLabel: 'Add another discipline',
            inputHint: 'Enter discipline...',
            onAdd: notifier.addCustomDiscipline,
            onRemove: notifier.removeCustomDiscipline,
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge),
        ],
      ),
    );
  }
}

class _DisciplineOption {
  final String label;
  final IconData icon;

  const _DisciplineOption({
    required this.label,
    required this.icon,
  });
}

