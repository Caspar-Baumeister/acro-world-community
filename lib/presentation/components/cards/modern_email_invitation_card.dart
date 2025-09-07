import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/material.dart';

class ModernEmailInvitationCard extends StatelessWidget {
  final InvitationModel invitation;
  final VoidCallback? onTap;

  const ModernEmailInvitationCard({
    super.key,
    required this.invitation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      onTap: onTap,
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
              // Teacher image with status badge
              _buildImageSection(context, colorScheme),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: _buildContentSection(context, theme, colorScheme),
              ),
              // Status section
              _buildStatusSection(context, theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    final isConfirmed = invitation.confirmationStatus.toLowerCase() == "accepted";
    final teacherImageUrl = invitation.invitedUser?.imageUrl;
    
    return Stack(
      children: [
        // Teacher image or anonymous placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,
            height: 80,
            color: colorScheme.surfaceContainerHighest,
            child: isConfirmed && teacherImageUrl != null
                ? CustomCachedNetworkImage(
                    imageUrl: teacherImageUrl,
                    width: 80,
                    height: 80,
                  )
                : _buildAnonymousPlaceholder(colorScheme),
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

  Widget _buildAnonymousPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person_outline,
        color: colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ColorScheme colorScheme) {
    final status = invitation.confirmationStatus;
    final isAccepted = status.toLowerCase() == "accepted";
    final isPending = status.toLowerCase() == "pending";
    
    Color badgeColor;
    String badgeText;
    
    if (isAccepted) {
      badgeColor = Colors.green;
      badgeText = "Accepted";
    } else if (isPending) {
      badgeColor = Colors.orange;
      badgeText = "Pending";
    } else {
      badgeColor = Colors.red;
      badgeText = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final teacherName = invitation.invitedUser?.name ?? invitation.email ?? "Unknown";
    final eventName = invitation.classModel?.name ?? "Unknown Event";
    final invitedAt = getDatedMMHHmm(DateTime.parse(invitation.createdAt));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teacher name
        Text(
          teacherName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Event name
        Text(
          eventName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Invited at
        Text(
          "Invited: $invitedAt",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final status = invitation.confirmationStatus;
    final isAccepted = status.toLowerCase() == "accepted";
    final isPending = status.toLowerCase() == "pending";
    
    Color statusColor;
    IconData statusIcon;
    
    if (isAccepted) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isPending) {
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          statusIcon,
          color: statusColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: theme.textTheme.bodySmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
