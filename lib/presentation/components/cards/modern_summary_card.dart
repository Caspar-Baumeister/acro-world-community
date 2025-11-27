import 'package:flutter/material.dart';

/// Modern summary card component for displaying statistics
class ModernSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const ModernSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bgColor = backgroundColor ?? colorScheme.surface;
    final fgColor = textColor ?? colorScheme.onSurface;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  bgColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: fgColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: fgColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: fgColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: fgColor.withOpacity(0.6),
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

/// Modern stats card for displaying multiple statistics
class ModernStatsCard extends StatelessWidget {
  final List<StatItem> stats;
  final String? title;

  const ModernStatsCard({
    super.key,
    required this.stats,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: stats.map((stat) => Expanded(
                  child: _buildStatItem(theme, colorScheme, stat),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, ColorScheme colorScheme, StatItem stat) {
    return Column(
      children: [
        if (stat.icon != null) ...[
          Icon(
            stat.icon,
            color: stat.color ?? colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          stat.value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: stat.color ?? colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Data class for stat items
class StatItem {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const StatItem({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });
}
