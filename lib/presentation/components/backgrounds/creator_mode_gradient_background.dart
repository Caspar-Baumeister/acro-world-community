import 'package:flutter/material.dart';

/// A widget that provides a gradient background for creator mode pages.
/// Uses a subtle gradient that complements the creator mode bottom navigation bar.
class CreatorModeGradientBackground extends StatelessWidget {
  const CreatorModeGradientBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.primary.withValues(alpha: 0.05),
            colorScheme.primary.withValues(alpha: 0.1),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}
