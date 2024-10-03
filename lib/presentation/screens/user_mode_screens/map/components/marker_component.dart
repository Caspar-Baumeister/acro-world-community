import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/provider/map_events_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkerComponent extends StatelessWidget {
  final ClassEvent classEvent;
  const MarkerComponent({super.key, required this.classEvent});

  @override
  Widget build(BuildContext context) {
    // define the classEventProvider with listen true
    MapEventsProvider classEventProvider =
        Provider.of<MapEventsProvider>(context, listen: true);
    return InkWell(
      onTap: () {
        // set the selected classEvent
        classEventProvider.setSelectedClassEvent(classEvent);
      },
      child: Icon(Icons.location_on,
          color: classEventProvider.selectedClassEvent?.id == classEvent.id
              ? CustomColors.accentColor
              : CustomColors.iconColor,
          size: AppDimensions.iconSizeLarge),
    );
  }
}
