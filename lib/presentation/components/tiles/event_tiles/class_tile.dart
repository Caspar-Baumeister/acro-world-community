import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_location_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_next_occurence_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_teacher_widget.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/widgets/class_tile_title_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_event_tile_image.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

// This is a tile for a class, without specific class event
class ClassTile extends StatelessWidget {
  const ClassTile({super.key, required this.classObject, required this.onTap});
  final ClassModel classObject;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ClassEventTileImage(
                  width: MediaQuery.of(context).size.width * 0.25,
                  isCancelled: false,
                  imgUrl: classObject.imageUrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClassTileTitleWidget(classObject: classObject),
                    const SizedBox(height: 4),
                    ClassTileLocationWidget(classObject: classObject),
                    const SizedBox(height: 8),
                    ClassTileTeacherWidget(classObject: classObject),
                    const SizedBox(height: 8),
                    ClassTileNextOccurenceWidget(classObject: classObject),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
