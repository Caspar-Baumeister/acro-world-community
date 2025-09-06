import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingModeSwitchButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCreatorMode;

  const FloatingModeSwitchButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.isCreatorMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      bottom: 100, // Position above the bottom navigation bar
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCreatorMode
                    ? [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ]
                    : [
                        colorScheme.secondary,
                        colorScheme.secondary.withOpacity(0.8),
                      ],
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingModeSwitchButtonConsumer extends ConsumerWidget {
  final bool isCreatorMode;

  const FloatingModeSwitchButtonConsumer({
    super.key,
    required this.isCreatorMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCreatorMode) {
      return const FloatingModeSwitchButton(
        title: "User Mode",
        subtitle: "Switch to browse events",
        icon: Icons.person,
        onPressed: _switchToUserMode,
        isCreatorMode: false,
      );
    } else {
      return const FloatingModeSwitchButton(
        title: "Creator Mode",
        subtitle: "Switch to create events",
        icon: Icons.star,
        onPressed: _switchToCreatorMode,
        isCreatorMode: true,
      );
    }
  }

  static void _switchToUserMode() {
    // This will be handled by the parent widget
  }

  static void _switchToCreatorMode() {
    // This will be handled by the parent widget
  }
}
