import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invitation_details_modal.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class ModernEmailInvitationCard extends StatelessWidget {
  final InvitationModel invitation;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChanged;

  const ModernEmailInvitationCard({
    super.key,
    required this.invitation,
    this.onTap,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final classModel = invitation.classModel;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (invitation.confirmationStatus.toLowerCase() == "pending") {
          _showInvitationModal(context);
        }
      },
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
              // Class image with confirmation status badge
              _buildImageSection(context, colorScheme, classModel),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: _buildContentSection(
                    context, theme, colorScheme, classModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
      BuildContext context, ColorScheme colorScheme, ClassModel? classModel) {
    return Stack(
      children: [
        // Class image or placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 80,
            height: 80,
            color: colorScheme.surfaceContainerHighest,
            child: (classModel?.imageUrl != null)
                ? CustomCachedNetworkImage(
                    imageUrl: classModel!.imageUrl!,
                    width: 80,
                    height: 80,
                  )
                : _buildClassPlaceholder(colorScheme),
          ),
        ),
        // Confirmation status badge
        Positioned(
          top: 4,
          right: 4,
          child: _buildConfirmationBadge(context, colorScheme),
        ),
      ],
    );
  }

  Widget _buildClassPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.class_outlined,
        color: colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
  }

  Widget _buildConfirmationBadge(
      BuildContext context, ColorScheme colorScheme) {
    final status = invitation.confirmationStatus;
    final isConfirmed = status.toLowerCase() == "confirmed";
    final isPending = status.toLowerCase() == "pending";

    Color badgeColor;
    String badgeText;

    if (isConfirmed) {
      badgeColor = Colors.green;
      badgeText = "Confirmed";
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

  Widget _buildContentSection(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, ClassModel? classModel) {
    // Handle case where class is null
    if (classModel == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No Class Information",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "Class details not available",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    final className = classModel.name ?? "Untitled Class";
    final location =
        classModel.locationName ?? classModel.city ?? "Location TBD";
    final teachers = classModel.teachers;
    final nextEvent = classModel.classEvents?.isNotEmpty == true
        ? classModel.classEvents!.first
        : null;
    final invitedBy = invitation.createdBy?.name ?? "Unknown";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Class name
        Text(
          className,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Location
        Text(
          location,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Teachers
        if (teachers.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  teachers.map((t) => t.name ?? "Unknown").join(", "),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        // Next event date or invited by
        if (nextEvent?.startDate != null) ...[
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  DateTimeService.getDateString(
                      nextEvent!.startDate, nextEvent.endDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        // Invited by
        Text(
          "Invited by: $invitedBy",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _showInvitationModal(BuildContext context) {
    buildMortal(
      context,
      InvitationDetailsModal(
        invitation: invitation,
        onStatusChanged: onStatusChanged,
      ),
    );
  }
}
