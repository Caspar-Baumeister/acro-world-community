import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 4: Discipline details (dynamic per discipline)
class Step4DisciplineDetails extends ConsumerStatefulWidget {
  const Step4DisciplineDetails({super.key});

  @override
  ConsumerState<Step4DisciplineDetails> createState() =>
      _Step4DisciplineDetailsState();
}

class _Step4DisciplineDetailsState
    extends ConsumerState<Step4DisciplineDetails> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final state = ref.read(talentProfileWizardProvider);
    for (final discipline in state.allDisciplines) {
      _controllers[discipline] = TextEditingController(
        text: state.disciplineDetails[discipline] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _getHintForDiscipline(String discipline) {
    if (discipline.toLowerCase().contains('acroyoga') ||
        discipline.toLowerCase().contains('acro')) {
      return 'E.g., L-basing, standing acro, washing machines, beginner-friendly, festival workshops...';
    } else if (discipline.toLowerCase().contains('yoga')) {
      return 'E.g., Vinyasa, Yin, Hatha, beginner to advanced, small groups...';
    } else if (discipline.toLowerCase().contains('handstand')) {
      return 'E.g., Press to handstand, one-arm progressions, beginners welcome...';
    } else if (discipline.toLowerCase().contains('movement') ||
        discipline.toLowerCase().contains('floor')) {
      return 'E.g., Animal flow, locomotion, contemporary, mixed levels...';
    } else if (discipline.toLowerCase().contains('strength')) {
      return 'E.g., Calisthenics, functional fitness, small group training...';
    } else if (discipline.toLowerCase().contains('dance')) {
      return 'E.g., Contact improvisation, contemporary, partner dance...';
    }
    return 'Describe your style, level, and typical settings...';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    final disciplines = state.allDisciplines;

    // Ensure controllers exist for all disciplines
    for (final discipline in disciplines) {
      if (!_controllers.containsKey(discipline)) {
        _controllers[discipline] = TextEditingController(
          text: state.disciplineDetails[discipline] ?? '',
        );
      }
    }

    return WizardStepContainer(
      title: 'Tell us about your teaching',
      description:
          'For each discipline, share details about your style, typical level, and settings.',
      currentStep: 4,
      child: disciplines.isEmpty
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingLarge),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppDimensions.spacingMedium),
                    Text(
                      'No disciplines selected',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      'Go back to Step 3 to select your disciplines.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...disciplines.map((discipline) {
                  final controller = _controllers[discipline]!;
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
                    padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLarge),
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
                          discipline,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSmall),
                        Text(
                          'Tell us about your $discipline teaching:',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingSmall),
                        TextField(
                          controller: controller,
                          maxLines: 4,
                          minLines: 3,
                          decoration: InputDecoration(
                            hintText: _getHintForDiscipline(discipline),
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium),
                            ),
                            contentPadding: const EdgeInsets.all(
                                AppDimensions.spacingMedium),
                          ),
                          onChanged: (value) {
                            notifier.setDisciplineDetail(discipline, value);
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppDimensions.spacingExtraLarge),
              ],
            ),
    );
  }
}

