import 'package:acroworld/presentation/screens/talent_profile_wizard/components/wizard_step_container.dart';
import 'package:acroworld/provider/riverpod_provider/talent_profile_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step 8: Payment expectations (optional)
class Step8Payment extends ConsumerStatefulWidget {
  const Step8Payment({super.key});

  @override
  ConsumerState<Step8Payment> createState() => _Step8PaymentState();
}

class _Step8PaymentState extends ConsumerState<Step8Payment> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(talentProfileWizardProvider);
    _controller = TextEditingController(text: state.paymentExpectations);
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
      title: 'Payment Expectations',
      description:
          'Do you have a preferred payment range? This helps us match you with suitable opportunities. (Optional)',
      currentStep: 8,
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
                      Icons.euro,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Text(
                      'Your rate',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText:
                        'E.g., 30-50 €/h, 60-80 € per 90-minute class, negotiable',
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
                  onChanged: notifier.setPaymentExpectations,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Ticket compensation checkbox
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
            child: CheckboxListTile(
              value: state.acceptsTicketCompensation,
              onChanged: (value) =>
                  notifier.setAcceptsTicketCompensation(value ?? false),
              title: Text(
                'Open to teaching for event tickets',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'I\'m also open to teaching in exchange for a free event ticket',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              secondary: Icon(
                Icons.confirmation_number,
                color: state.acceptsTicketCompensation
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              activeColor: theme.colorScheme.primary,
              controlAffinity: ListTileControlAffinity.trailing,
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
                    'This information helps organizers understand your expectations. Final rates are always negotiable.',
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

