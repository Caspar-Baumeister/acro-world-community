import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvitationDetailsModal extends ConsumerStatefulWidget {
  final InvitationModel invitation;
  final VoidCallback? onStatusChanged;

  const InvitationDetailsModal({
    super.key,
    required this.invitation,
    this.onStatusChanged,
  });

  @override
  ConsumerState<InvitationDetailsModal> createState() =>
      _InvitationDetailsModalState();
}

class _InvitationDetailsModalState
    extends ConsumerState<InvitationDetailsModal> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final classModel = widget.invitation.classModel;

    // Calculate available height considering keyboard and safe areas
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double availableHeight =
        MediaQuery.of(context).size.height * 0.5 - keyboardHeight;

    return BaseModal(
      title: "Class Invitation",
      child: Container(
        constraints: BoxConstraints(
          maxHeight: availableHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Explanation text
              _buildExplanationSection(theme, colorScheme),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Class details section
              _buildClassDetailsSection(theme, colorScheme, classModel),

              const SizedBox(height: AppDimensions.spacingLarge),

              // Action buttons
              _buildActionButtons(theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationSection(ThemeData theme, ColorScheme colorScheme) {
    final inviterName = widget.invitation.createdBy?.name ?? "Someone";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "You've been invited!",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "$inviterName has invited you to join as a teacher for this event. When you accept:",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoPoint(theme, colorScheme,
              "You will be displayed as a teacher at this event"),
          _buildInfoPoint(
              theme, colorScheme, "Your followers will receive a notification"),
          _buildInfoPoint(theme, colorScheme,
              "The event will show up on your profile and statistics"),
          const SizedBox(height: 8),
          Text(
            "⚠️ Once accepted, you cannot undo this action.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(
      ThemeData theme, ColorScheme colorScheme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetailsSection(
      ThemeData theme, ColorScheme colorScheme, ClassModel? classModel) {
    if (classModel == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.class_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              "Class information not available",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final className = classModel.name ?? "Untitled Class";
    final location =
        classModel.locationName ?? classModel.city ?? "Location TBD";
    final teachers = classModel.teachers;
    final nextEvent = classModel.classEvents?.isNotEmpty == true
        ? classModel.classEvents!.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Class image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: colorScheme.surfaceContainerHighest,
              child: classModel.imageUrl != null
                  ? CustomCachedNetworkImage(
                      imageUrl: classModel.imageUrl!,
                    )
                  : Icon(
                      Icons.class_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          // Class details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class name
                Text(
                  className,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Teachers
                if (teachers.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teachers.map((t) => t.name ?? "Unknown").join(", "),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                // Next event date
                if (nextEvent?.startDate != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          DateTimeService.getDateString(
                              nextEvent!.startDate, nextEvent.endDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    final isPending =
        widget.invitation.confirmationStatus.toLowerCase() == "pending";

    if (!isPending) {
      // Show current status if not pending
      final status = widget.invitation.confirmationStatus;
      final isConfirmed = status.toLowerCase() == "confirmed";

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isConfirmed
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isConfirmed ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isConfirmed ? Icons.check_circle : Icons.cancel,
              color: isConfirmed ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              isConfirmed ? "Invitation Accepted" : "Invitation Rejected",
              style: theme.textTheme.titleMedium?.copyWith(
                color: isConfirmed ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ModernButton(
            text: "Reject",
            isOutlined: true,
            backgroundColor: colorScheme.error,
            onPressed: _isLoading ? null : _rejectInvitation,
            isLoading: _isLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ModernButton(
            text: "Accept",
            isFilled: true,
            onPressed: _isLoading ? null : _acceptInvitation,
            isLoading: _isLoading,
          ),
        ),
      ],
    );
  }

  Future<void> _acceptInvitation() async {
    setState(() => _isLoading = true);

    try {
      final client = GraphQLClientSingleton().client;

      // First, try to accept the invitation
      final acceptResult = await client.mutate(MutationOptions(
        document: Mutations.acceptInviteMutation,
        variables: {'invite_id': widget.invitation.id},
      ));

      if (acceptResult.hasException) {
        // Handle GraphQL errors specifically
        final error = acceptResult.exception!;
        final errorMessage = error.graphqlErrors.isNotEmpty
            ? error.graphqlErrors.first.message
            : "Failed to accept invitation";

        if (mounted) {
          showErrorToast(errorMessage);
        }
        return;
      }

      final success = acceptResult.data?['accept_invite']?['success'] as bool?;

      if (success != true) {
        if (mounted) {
          showErrorToast("Failed to accept invitation. Please try again.");
        }
        return;
      }

      // Only if accept_invite succeeded, update the invitation status to confirmed
      final updateResult = await client.mutate(MutationOptions(
        document: Mutations.updateInviteStatusMutation,
        variables: {
          'id': widget.invitation.id,
          'confirmation_status': 'Confirmed',
        },
      ));

      if (updateResult.hasException) {
        // If accept succeeded but update failed, still show success but log the error
        CustomErrorHandler.captureException(
          "Accept invite succeeded but status update failed: ${updateResult.exception}",
          stackTrace: StackTrace.current,
        );

        if (mounted) {
          Navigator.of(context).pop();
          showSuccessToast("Invitation accepted successfully!");
          widget.onStatusChanged?.call();
        }
        return;
      }

      // Both operations succeeded
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessToast("Invitation accepted successfully!");
        widget.onStatusChanged?.call();
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      if (mounted) {
        showErrorToast("Failed to accept invitation. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rejectInvitation() async {
    setState(() => _isLoading = true);

    try {
      final client = GraphQLClientSingleton().client;

      // Update the invitation status to rejected
      final result = await client.mutate(MutationOptions(
        document: Mutations.updateInviteStatusMutation,
        variables: {
          'id': widget.invitation.id,
          'confirmation_status': 'Rejected',
        },
      ));

      if (result.hasException) {
        // Handle GraphQL errors specifically
        final error = result.exception!;
        final errorMessage = error.graphqlErrors.isNotEmpty
            ? error.graphqlErrors.first.message
            : "Failed to reject invitation";

        if (mounted) {
          showErrorToast(errorMessage);
        }
        return;
      }

      // Success
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessToast("Invitation rejected");
        widget.onStatusChanged?.call();
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      if (mounted) {
        showErrorToast("Failed to reject invitation. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
