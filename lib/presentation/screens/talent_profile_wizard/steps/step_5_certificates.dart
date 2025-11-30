import 'package:acroworld/presentation/screens/talent_profile_wizard/components/removable_chip.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 5: Certificates and education
class Step5Certificates extends ConsumerStatefulWidget {
  const Step5Certificates({super.key});

  @override
  ConsumerState<Step5Certificates> createState() => _Step5CertificatesState();
}

class _Step5CertificatesState extends ConsumerState<Step5Certificates> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(talentProfileWizardProvider);
    _controller = TextEditingController(text: state.certificationsText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);
    final theme = Theme.of(context);

    return WizardStepContainer(
      title: 'Certificates & Training',
      description:
          'What certifications or training programs have you completed? (Optional)',
      currentStep: 5,
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
                      Icons.school,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'Your qualifications',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'E.g., 200hr Yoga Teacher Training (2020), AcroYoga International Level 1 & 2, Thai Massage certification...',
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
                  onChanged: notifier.setCertificationsText,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Certificate cards section
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
                  'Quick add certificates',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  'Add certificates as quick tags (optional)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                ChipInputSection(
                  chips: state.certificateCards,
                  addButtonLabel: 'Add certificate',
                  inputHint: 'Certificate name...',
                  onAdd: notifier.addCertificateCard,
                  onRemove: notifier.removeCertificateCard,
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
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
                Expanded(
                  child: Text(
                    'No formal certificates? That\'s fine! Many great teachers are self-taught or learned through apprenticeship.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
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

