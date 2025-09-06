import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:flutter/material.dart';

class EventInvitationCard extends StatelessWidget {
  final ClassModel invitation;
  final String status; // 'approved', 'pending', 'rejected'
  final VoidCallback? onTap;

  const EventInvitationCard({
    super.key,
    required this.invitation,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // Base class tile
        ClassTile(
          classObject: invitation,
          onTap: onTap ?? () {},
        ),
        // Status overlay
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(colorScheme).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(),
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'approved':
        return colorScheme.primary;
      case 'pending':
        return colorScheme.secondary;
      case 'rejected':
        return colorScheme.error;
      default:
        return colorScheme.onSurface.withOpacity(0.7);
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
