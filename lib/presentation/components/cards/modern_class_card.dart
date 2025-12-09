import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/images/custom_cached_network_image.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModernClassCard extends StatelessWidget {
  const ModernClassCard({
    super.key,
    required this.classModel,
    this.width,
  });

  final ClassModel classModel;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: classModel.urlSlug != null || classModel.id != null
          ? () {
              Map<String, String> pathParameters = {};
              if (classModel.urlSlug != null) {
                pathParameters["urlSlug"] = classModel.urlSlug!;
              }

              context.pushNamed(
                singleEventWrapperRoute,
                pathParameters: pathParameters,
              );
            }
          : () => showErrorToast("This class is not available anymore"),
      child: Container(
        width: width ?? 200,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: _buildImageSection(context, colorScheme),
            ),
            // Content section
            Expanded(
              flex: 2,
              child: _buildContentSection(context, theme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: classModel.imageUrl != null
            ? CustomCachedNetworkImage(
                imageUrl: classModel.imageUrl!,
                width: double.infinity,
                height: double.infinity,
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.event,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class name
          Expanded(
            child: Text(
              classModel.name ?? "Untitled Class",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (classModel.locationName != null) ...[
            const SizedBox(height: 4),
            // Location
            Text(
              classModel.locationName!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
