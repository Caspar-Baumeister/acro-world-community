import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:flutter/material.dart';

class EventInvitationCard extends StatelessWidget {
  final ClassModel invitation;
  final String status; // 'approved', 'pending', 'rejected'
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const EventInvitationCard({
    super.key,
    required this.invitation,
    required this.status,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _showInvitationDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image with status badge
              _buildImageSection(context, colorScheme),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: _buildContentSection(context, theme, colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        // Event image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,
            height: 80,
            color: colorScheme.surfaceContainerHighest,
            child: invitation.imageUrl != null
                ? CustomCachedNetworkImage(
                    imageUrl: invitation.imageUrl!,
                    width: 80,
                    height: 80,
                  )
                : _buildImagePlaceholder(colorScheme),
          ),
        ),
        // Status badge
        Positioned(
          top: 4,
          right: 4,
          child: _buildStatusBadge(context, colorScheme),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.event,
        color: colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(colorScheme),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentSection(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final eventName = invitation.name ?? "Unknown Event";
    final location =
        invitation.locationName ?? invitation.city ?? "Unknown Location";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event name
        Text(
          eventName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Location
        Text(
          location,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Event type or description
        if (invitation.description != null)
          Text(
            invitation.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  void _showInvitationDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Event Invitation',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: colorScheme.surfaceContainerHighest,
                      child: invitation.imageUrl != null
                          ? CustomCachedNetworkImage(
                              imageUrl: invitation.imageUrl!,
                              width: 60,
                              height: 60,
                            )
                          : Icon(
                              Icons.event,
                              color: colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invitation.name ?? "Unknown Event",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invitation.locationName ??
                              invitation.city ??
                              "Unknown Location",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Status info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(colorScheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(colorScheme).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(colorScheme),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${status.toUpperCase()}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getStatusColor(colorScheme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Notification text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will be shown as a teacher in this event and your followers will be notified.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: status == 'pending'
              ? [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onReject?.call();
                    },
                    child: Text(
                      'Reject',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onAccept?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: const Text('Accept'),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
        );
      },
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
