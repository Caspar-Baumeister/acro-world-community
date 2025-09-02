import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart';
import 'package:acroworld/provider/riverpod_provider/calendar_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassesView extends ConsumerWidget {
  const ClassesView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    if (calendarState.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ModernSkeleton(width: 200, height: 20),
            SizedBox(height: 16),
            ModernSkeleton(width: 150, height: 20),
            SizedBox(height: 24),
            ModernSkeleton(
                width: 300,
                height: 100,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            SizedBox(height: 16),
            ModernSkeleton(
                width: 300,
                height: 100,
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ],
        ),
      );
    }

    if (calendarState.weekClassEvents.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text("There are no activities close to you."),
                const SizedBox(height: AppDimensions.spacingLarge),
                ModernButton(
                  text: "increase search radius",
                  onPressed: () {
                    // TODO: Implement increaseRadius method in CalendarNotifier
                  },
                ),
              ],
            ),
          )
        ],
      );
    }

    List<ClassEvent> classEvents = calendarState.weekClassEvents;

    if (classEvents.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("There are no activities on this day."),
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: classEvents.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4, bottom: AppDimensions.spacingSmall),
            child: ClassEventExpandedTile(
              classEvent: classEvents[index],
            ),
          );
        },
      ),
    );
  }
}
