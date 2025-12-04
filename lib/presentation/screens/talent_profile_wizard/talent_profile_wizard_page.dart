import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_1_work_types.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_2_location.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_3_disciplines.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_4_discipline_details.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_5_certificates.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_6_experience.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_7_languages.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_8_payment.dart';
import 'package:acroworld/presentation/screens/talent_profile_wizard/steps/step_9_consent.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Main wizard page for creating a talent profile
class TalentProfileWizardPage extends ConsumerStatefulWidget {
  const TalentProfileWizardPage({super.key});

  @override
  ConsumerState<TalentProfileWizardPage> createState() =>
      _TalentProfileWizardPageState();
}

class _TalentProfileWizardPageState
    extends ConsumerState<TalentProfileWizardPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    final state = ref.read(talentProfileWizardProvider);
    if (state.canGoBack) {
      ref.read(talentProfileWizardProvider.notifier).previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showExitConfirmation();
    }
  }

  void _onNextPressed() async {
    final state = ref.read(talentProfileWizardProvider);
    final notifier = ref.read(talentProfileWizardProvider.notifier);

    if (state.isLastStep) {
      // Submit the profile
      final success = await notifier.submit();
      if (success && mounted) {
        showSuccessToast('Profile created successfully!', context: context);
        context.pop();
      } else if (mounted && state.errorMessage != null) {
        showErrorToast(state.errorMessage!, context: context);
      }
    } else {
      notifier.nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave wizard?'),
        content: const Text(
          'Your progress will be lost. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(talentProfileWizardProvider.notifier).reset();
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return const Step1WorkTypes();
      case 2:
        return const Step2Location();
      case 3:
        return const Step3Disciplines();
      case 4:
        return const Step4DisciplineDetails();
      case 5:
        return const Step5Certificates();
      case 6:
        return const Step6Experience();
      case 7:
        return const Step7Languages();
      case 8:
        return const Step8Payment();
      case 9:
        return const Step9Consent();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(talentProfileWizardProvider);
    final theme = Theme.of(context);

    // Listen to step changes and sync PageController
    ref.listen<TalentProfileWizardState>(
      talentProfileWizardProvider,
      (previous, next) {
        if (previous?.currentStep != next.currentStep) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              next.currentStep - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
          title: const Text('Talent Profile'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Main content with PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalWizardSteps,
                itemBuilder: (context, index) => _buildStepContent(index + 1),
              ),
            ),
            // Bottom navigation buttons
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Back button (only show if not on first step)
                    if (state.canGoBack)
                      Expanded(
                        child: ModernButton(
                          text: 'Back',
                          onPressed: state.isSubmitting ? null : _onBackPressed,
                          isFilled: false,
                          isOutlined: true,
                        ),
                      )
                    else
                      const Spacer(),
                    const SizedBox(width: AppDimensions.spacingMedium),
                    // Next/Submit button
                    Expanded(
                      flex: 2,
                      child: ModernButton(
                        text: state.isLastStep ? 'Submit' : 'Next',
                        onPressed: (state.canProceed && !state.isSubmitting)
                            ? _onNextPressed
                            : null,
                        isLoading: state.isSubmitting,
                        isFilled: true,
                        icon: state.isLastStep
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

