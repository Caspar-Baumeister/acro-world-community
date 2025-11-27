import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/cards/modern_teacher_card.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/presentation/components/open_google_maps.dart';
import 'package:acroworld/presentation/components/open_map.dart';
import 'package:acroworld/presentation/screens/single_class_page/widgets/link_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/teacher_profile/widgets/level_difficulty_widget.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SingleClassBody extends StatelessWidget {
  const SingleClassBody({super.key, required this.classe, this.classEvent});

  final ClassModel classe;
  final ClassEvent? classEvent;

  @override
  Widget build(BuildContext context) {
    int amountActiveFlags = classe.amountActiveFlaggs?.toInt() ?? 0;

    List<ClassTeacher> classTeachers = [];

    if (classe.classTeachers != null) {
      classTeachers = classe.classTeachers!
          .where((ClassTeacher classTeacher) =>
              classTeacher.teacher?.type != "Anonymous")
          .toList();
    }
    return SingleChildScrollView(
        child: Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium)
              .copyWith(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classe.name ?? "",
              maxLines: 3, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          if (classEvent != null &&
              classEvent!.startDate != null &&
              classEvent!.endDate != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    DateTimeService.getDateString(
                        classEvent!.startDate!, classEvent!.endDate!),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: -0.5)),
                if (classe.classLevels != null &&
                    classe.classLevels!.isNotEmpty)
                  DifficultyWidget(classe.classLevels),
              ],
            ),
            const CustomDivider()
          ],

          if (amountActiveFlags > 2) ...[
            if (amountActiveFlags < 5)
              // a orange box with a warning, that this class might not happen
              FlagsWarningBox(amountActiveFlags: amountActiveFlags)
            else
              // a red box with a warning, that this class will most likely not happen
              FlagsWarningBox(
                  amountActiveFlags: amountActiveFlags,
                  flagWarningLevel: FlagWarningLevel.hard),
            const SizedBox(height: 10),
          ],
          classe.description != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Html(
                        data: classe.description!,
                        onLinkTap: (url, attributes, element) {
                          if (url != null) {
                            customLaunch(url).catchError((e) =>
                                CustomErrorHandler.captureException(
                                    e.toString()));
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Container(),
          classTeachers.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Teachers",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 16),
                    ModernTeacherList(
                      teachers: List<TeacherModel>.from(
                        classTeachers
                            .where((e) => e.teacher != null)
                            .map((e) => e.teacher!),
                      ),
                      isCompact: false, // Always use full vertical layout
                      maxItems: classTeachers.length, // Show all teachers
                    ),
                    const SizedBox(height: 24),
                    const CustomDivider(),
                  ],
                )
              : const SizedBox.shrink(), // Minimal space when no teachers

          classe.location?.coordinates?[1] != null &&
                  classe.location?.coordinates?[0] != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Location",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        OpenGoogleMaps(
                          latitude: classe.location!.coordinates![1] * 1.0,
                          longitude: classe.location!.coordinates![0] * 1.0,
                        )
                      ],
                    ),
                    // Location name and country/region in a modern chip-like design
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (classe.locationName != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    classe.locationName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          letterSpacing: -0.5,
                                          height: 1.1,
                                        ),
                                  ),
                                ),
                              // Country and region chips
                              if (classe.city != null || classe.country != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      if (classe.city != null)
                                        _buildLocationChip(
                                          context,
                                          classe.city!,
                                          Icons.location_city,
                                        ),
                                      if (classe.country != null)
                                        _buildLocationChip(
                                          context,
                                          classe.country!,
                                          Icons.public,
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: OpenMap(
                        initialZoom: 15,
                        latitude: classe.location!.coordinates![1] * 1.0,
                        longitude: classe.location!.coordinates![0] * 1.0,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Divider(),
                    )
                  ],
                )
              : Container(),

          (classe.websiteUrl != null && classe.websiteUrl != "")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Links",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    classe.websiteUrl != null && classe.websiteUrl != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                top: AppDimensions.spacingMedium),
                            child: SmallStandartButtonWithLink(
                                text: "Website", link: classe.websiteUrl!),
                          )
                        : Container(),
                  ],
                )
              : Container(),
          // ClassEventCalenderQuery(classId: classe.id!),
          const SizedBox(height: AppDimensions.spacingExtraLarge)
        ],
      ),
    ));
  }

  Widget _buildLocationChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

enum FlagWarningLevel { light, hard }

class FlagsWarningBox extends StatelessWidget {
  const FlagsWarningBox({
    super.key,
    required this.amountActiveFlags,
    this.flagWarningLevel = FlagWarningLevel.light,
  });

  final int amountActiveFlags;
  final FlagWarningLevel flagWarningLevel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFlagDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: flagWarningLevel == FlagWarningLevel.light
              ? Theme.of(context).colorScheme.error.withOpacity(0.4)
              : Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.onPrimary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "This class has $amountActiveFlags active flags and ${flagWarningLevel == FlagWarningLevel.light ? "might not happen" : "will most likely not happen"}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.onPrimary, size: 24),
          ],
        ),
      ),
    );
  }

  void _showFlagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flag, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Event Flag",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Flags help the community keep the platform updated. If a class gets 5 or more active flags, it will be removed.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                const Text(
                  "If you believe this class is inactive, you can flag it in the right top corner to notify the organizers.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
