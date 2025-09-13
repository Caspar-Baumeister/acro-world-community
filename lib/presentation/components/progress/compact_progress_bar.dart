import 'package:flutter/material.dart';

/// A compact progress bar that shows progress through multiple steps
class CompactProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? currentStepTitle;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;

  const CompactProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.currentStepTitle,
    this.onBackPressed,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final progress = (currentStep + 1) / totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with back/close buttons and step info
          Row(
            children: [
              // Back button (only show if not on first step)
              if (currentStep > 0 && onBackPressed != null)
                IconButton(
                  onPressed: onBackPressed,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                )
              else
                const SizedBox(width: 32),

              // Step title and progress info
              Expanded(
                child: Column(
                  children: [
                    if (currentStepTitle != null)
                      Text(
                        currentStepTitle!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Step ${currentStep + 1} of $totalSteps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              if (onClosePressed != null)
                IconButton(
                  onPressed: onClosePressed,
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                )
              else
                const SizedBox(width: 32),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
