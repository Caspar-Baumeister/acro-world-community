import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/datetime/date_time_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class ClassTileNextOccurenceWidget extends StatelessWidget {
  const ClassTileNextOccurenceWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    print("classObject.classEvents: ${classObject.classEvents}");
    print(
        "classObject.amountUpcomingEvents: ${classObject.amountUpcomingEvents}");
    if (classObject.classEvents == null ||
        classObject.amountUpcomingEvents == null ||
        classObject.classEvents?.isEmpty == true) {
      return const Text("No upcoming events");
    }
    ClassEvent nextClassEvent = classObject.classEvents!.first;
    int? amountOfEvents = classObject.amountUpcomingEvents;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Next: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: CustomColors.primaryTextColor)
                    .copyWith(letterSpacing: -0.5)),
            Text(
              DateTimeService.getDateStringOnlyDate(nextClassEvent.startDate),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: CustomColors.accentColor)
                  .copyWith(letterSpacing: -0.5),
            ),
          ],
        ),
        if (amountOfEvents != null && amountOfEvents > 1)
          Flexible(
            child: Text(
              " +${amountOfEvents - 1} more dates",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: CustomColors.primaryTextColor)
                  .copyWith(letterSpacing: -0.5),
            ),
          ),
      ],
    );
  }
}
